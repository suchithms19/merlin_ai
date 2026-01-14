import 'dart:async';
import 'dart:convert';

import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../generated/email/email.dart';
import '../generated/email/email_attachment.dart';
import '../services/google_oauth_service.dart';

/// Lightweight HTTP client that injects the OAuth access token for Google APIs.
class _GoogleAuthClient extends http.BaseClient {
  final String accessToken;
  final http.Client _inner = http.Client();

  _GoogleAuthClient(this.accessToken);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $accessToken';
    return _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}

class GoogleGmailService {
  GoogleGmailService(this.session);

  final Session session;

  Future<gmail.GmailApi> _getGmailApi(int userProfileId) async {
    final oauthService = GoogleOAuthService(session);
    final accessToken = await oauthService.getValidAccessToken(userProfileId);
    final authClient = _GoogleAuthClient(accessToken);
    return gmail.GmailApi(authClient);
  }

  /// Fetches emails from Gmail with optional pagination
  Future<({List<Email> emails, String? nextPageToken, int? totalEstimate})>
      getEmails({
    required int userProfileId,
    int maxResults = 20,
    String? pageToken,
    List<String>? labelIds,
    String? query,
  }) async {
    try {
      final api = await _getGmailApi(userProfileId);
      final response = await api.users.messages.list(
        'me',
        maxResults: maxResults,
        pageToken: pageToken,
        labelIds: labelIds,
        q: query,
      );

      final emails = <Email>[];
      for (final message in response.messages ?? []) {
        if (message.id != null) {
          final email = await getEmail(
            userProfileId: userProfileId,
            messageId: message.id!,
          );
          if (email != null) {
            emails.add(email);
          }
        }
      }

      return (
        emails: emails,
        nextPageToken: response.nextPageToken,
        totalEstimate: response.resultSizeEstimate,
      );
    } catch (error, stackTrace) {
      session.log(
        'Failed to fetch emails: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      final cached = await _getCachedEmails(
        userProfileId: userProfileId,
        maxResults: maxResults,
      );
      return (emails: cached, nextPageToken: null, totalEstimate: null);
    }
  }

  /// Fetches a single email by message ID
  Future<Email?> getEmail({
    required int userProfileId,
    required String messageId,
  }) async {
    try {
      final api = await _getGmailApi(userProfileId);
      final message = await api.users.messages.get(
        'me',
        messageId,
        format: 'full',
      );

      if (message.id == null) return null;

      final email = _mapMessage(
        userProfileId: userProfileId,
        message: message,
      );

      await _cacheEmail(email);

      // Extract and cache attachments
      await _cacheAttachments(email, message);

      return email;
    } catch (error, stackTrace) {
      session.log(
        'Failed to fetch email $messageId: $error',
        level: LogLevel.warning,
        stackTrace: stackTrace,
      );
      return Email.db.findFirstRow(
        session,
        where: (t) =>
            t.userProfileId.equals(userProfileId) &
            t.googleMessageId.equals(messageId),
      );
    }
  }

  /// Fetches an email thread by thread ID
  Future<List<Email>> getEmailThread({
    required int userProfileId,
    required String threadId,
  }) async {
    try {
      final api = await _getGmailApi(userProfileId);
      final thread = await api.users.threads.get(
        'me',
        threadId,
        format: 'full',
      );

      final emails = <Email>[];
      for (final message in thread.messages ?? []) {
        if (message.id != null) {
          final email = _mapMessage(
            userProfileId: userProfileId,
            message: message,
          );
          await _cacheEmail(email);
          emails.add(email);
        }
      }

      return emails;
    } catch (error, stackTrace) {
      session.log(
        'Failed to fetch thread $threadId: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      return Email.db.find(
        session,
        where: (t) =>
            t.userProfileId.equals(userProfileId) &
            t.googleThreadId.equals(threadId),
        orderBy: (t) => t.receivedAt,
      );
    }
  }

  /// Searches emails with a query string (Gmail search syntax)
  Future<({List<Email> emails, String? nextPageToken})> searchEmails({
    required int userProfileId,
    required String query,
    int maxResults = 20,
    String? pageToken,
  }) async {
    return getEmails(
      userProfileId: userProfileId,
      maxResults: maxResults,
      pageToken: pageToken,
      query: query,
    ).then((r) => (emails: r.emails, nextPageToken: r.nextPageToken));
  }

  /// Syncs emails from Gmail to local cache
  Future<void> syncEmails({
    required int userProfileId,
    int maxResults = 100,
    List<String>? labelIds,
  }) async {
    try {
      await getEmails(
        userProfileId: userProfileId,
        maxResults: maxResults,
        labelIds: labelIds ?? ['INBOX'],
      );
      session.log(
        'Synced $maxResults emails for user $userProfileId',
        level: LogLevel.info,
      );
    } catch (error, stackTrace) {
      session.log(
        'Failed to sync emails: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Sends a new email
  Future<Email?> sendEmail({
    required int userProfileId,
    required List<String> to,
    List<String>? cc,
    List<String>? bcc,
    required String subject,
    String? bodyPlainText,
    String? bodyHtml,
  }) async {
    try {
      final api = await _getGmailApi(userProfileId);

      final rawMessage = _buildRawMessage(
        to: to,
        cc: cc,
        bcc: bcc,
        subject: subject,
        bodyPlainText: bodyPlainText,
        bodyHtml: bodyHtml,
      );

      final message = gmail.Message(raw: rawMessage);
      final sentMessage = await api.users.messages.send(message, 'me');

      if (sentMessage.id == null) {
        throw Exception('Failed to send email: no message ID returned');
      }

      session.log(
        'Sent email to ${to.join(", ")} with subject "$subject"',
        level: LogLevel.info,
      );

      // Fetch the sent email to cache it
      return getEmail(
        userProfileId: userProfileId,
        messageId: sentMessage.id!,
      );
    } catch (error, stackTrace) {
      session.log(
        'Failed to send email: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Replies to an existing email
  Future<Email?> replyToEmail({
    required int userProfileId,
    required String originalMessageId,
    String? bodyPlainText,
    String? bodyHtml,
    bool replyAll = false,
  }) async {
    try {
      final api = await _getGmailApi(userProfileId);

      // Fetch the original message to get headers
      final originalMessage = await api.users.messages.get(
        'me',
        originalMessageId,
        format: 'full',
      );

      final headers = originalMessage.payload?.headers ?? [];
      final originalSubject = _getHeader(headers, 'Subject') ?? '';
      final originalFrom = _getHeader(headers, 'From') ?? '';
      final originalTo = _getHeader(headers, 'To') ?? '';
      final originalCc = _getHeader(headers, 'Cc');
      final messageId = _getHeader(headers, 'Message-ID');

      // Determine recipients
      final to = [originalFrom];
      List<String>? cc;
      if (replyAll) {
        final allRecipients = <String>{};
        if (originalTo.isNotEmpty) {
          allRecipients.addAll(_parseEmailList(originalTo));
        }
        if (originalCc != null && originalCc.isNotEmpty) {
          allRecipients.addAll(_parseEmailList(originalCc));
        }
        // Remove the original sender and current user
        allRecipients.remove(originalFrom);
        if (allRecipients.isNotEmpty) {
          cc = allRecipients.toList();
        }
      }

      // Build reply subject
      final subject = originalSubject.startsWith('Re:')
          ? originalSubject
          : 'Re: $originalSubject';

      final rawMessage = _buildRawMessage(
        to: to,
        cc: cc,
        subject: subject,
        bodyPlainText: bodyPlainText,
        bodyHtml: bodyHtml,
        inReplyTo: messageId,
        references: messageId,
        threadId: originalMessage.threadId,
      );

      final message = gmail.Message(
        raw: rawMessage,
        threadId: originalMessage.threadId,
      );
      final sentMessage = await api.users.messages.send(message, 'me');

      if (sentMessage.id == null) {
        throw Exception('Failed to send reply: no message ID returned');
      }

      session.log(
        'Replied to email $originalMessageId',
        level: LogLevel.info,
      );

      return getEmail(
        userProfileId: userProfileId,
        messageId: sentMessage.id!,
      );
    } catch (error, stackTrace) {
      session.log(
        'Failed to reply to email: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Forwards an email to new recipients
  Future<Email?> forwardEmail({
    required int userProfileId,
    required String originalMessageId,
    required List<String> to,
    List<String>? cc,
    List<String>? bcc,
    String? additionalMessage,
  }) async {
    try {
      final api = await _getGmailApi(userProfileId);

      // Fetch the original message
      final originalMessage = await api.users.messages.get(
        'me',
        originalMessageId,
        format: 'full',
      );

      final headers = originalMessage.payload?.headers ?? [];
      final originalSubject = _getHeader(headers, 'Subject') ?? '';
      final originalFrom = _getHeader(headers, 'From') ?? '';
      final originalDate = _getHeader(headers, 'Date') ?? '';

      // Get original body
      final originalBody = _extractBody(originalMessage);

      // Build forward subject
      final subject = originalSubject.startsWith('Fwd:')
          ? originalSubject
          : 'Fwd: $originalSubject';

      // Build forward body with original message
      final forwardHeader = '''
---------- Forwarded message ---------
From: $originalFrom
Date: $originalDate
Subject: $originalSubject

''';

      final bodyPlainText = additionalMessage != null
          ? '$additionalMessage\n\n$forwardHeader${originalBody.plainText ?? ""}'
          : '$forwardHeader${originalBody.plainText ?? ""}';

      final bodyHtml = additionalMessage != null
          ? '<p>$additionalMessage</p><br><hr>$forwardHeader<br>${originalBody.html ?? ""}'
          : '<hr>$forwardHeader<br>${originalBody.html ?? ""}';

      final rawMessage = _buildRawMessage(
        to: to,
        cc: cc,
        bcc: bcc,
        subject: subject,
        bodyPlainText: bodyPlainText,
        bodyHtml: bodyHtml,
      );

      final message = gmail.Message(raw: rawMessage);
      final sentMessage = await api.users.messages.send(message, 'me');

      if (sentMessage.id == null) {
        throw Exception('Failed to forward email: no message ID returned');
      }

      session.log(
        'Forwarded email $originalMessageId to ${to.join(", ")}',
        level: LogLevel.info,
      );

      return getEmail(
        userProfileId: userProfileId,
        messageId: sentMessage.id!,
      );
    } catch (error, stackTrace) {
      session.log(
        'Failed to forward email: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Marks an email as read or unread
  Future<void> markAsRead({
    required int userProfileId,
    required String messageId,
    required bool isRead,
  }) async {
    try {
      final api = await _getGmailApi(userProfileId);

      final modifyRequest = gmail.ModifyMessageRequest(
        addLabelIds: isRead ? null : ['UNREAD'],
        removeLabelIds: isRead ? ['UNREAD'] : null,
      );

      await api.users.messages.modify(modifyRequest, 'me', messageId);

      // Update cache
      final cached = await Email.db.findFirstRow(
        session,
        where: (t) =>
            t.userProfileId.equals(userProfileId) &
            t.googleMessageId.equals(messageId),
      );

      if (cached != null) {
        cached.isRead = isRead;
        cached.updatedAt = DateTime.now();
        await Email.db.updateRow(session, cached);
      }

      session.log(
        'Marked email $messageId as ${isRead ? "read" : "unread"}',
        level: LogLevel.info,
      );
    } catch (error, stackTrace) {
      session.log(
        'Failed to mark email as read: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Archives an email (removes from INBOX)
  Future<void> archiveEmail({
    required int userProfileId,
    required String messageId,
  }) async {
    try {
      final api = await _getGmailApi(userProfileId);

      final modifyRequest = gmail.ModifyMessageRequest(
        removeLabelIds: ['INBOX'],
      );

      await api.users.messages.modify(modifyRequest, 'me', messageId);

      // Update cache
      final cached = await Email.db.findFirstRow(
        session,
        where: (t) =>
            t.userProfileId.equals(userProfileId) &
            t.googleMessageId.equals(messageId),
      );

      if (cached != null) {
        final labels = List<String>.from(cached.labels);
        labels.remove('INBOX');
        cached.labels = labels;
        cached.updatedAt = DateTime.now();
        await Email.db.updateRow(session, cached);
      }

      session.log(
        'Archived email $messageId',
        level: LogLevel.info,
      );
    } catch (error, stackTrace) {
      session.log(
        'Failed to archive email: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Deletes an email (moves to Trash)
  Future<void> deleteEmail({
    required int userProfileId,
    required String messageId,
  }) async {
    try {
      final api = await _getGmailApi(userProfileId);

      await api.users.messages.trash('me', messageId);

      // Remove from cache
      await Email.db.deleteWhere(
        session,
        where: (t) =>
            t.userProfileId.equals(userProfileId) &
            t.googleMessageId.equals(messageId),
      );

      session.log(
        'Deleted email $messageId',
        level: LogLevel.info,
      );
    } catch (error, stackTrace) {
      session.log(
        'Failed to delete email: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Stars or unstars an email
  Future<void> starEmail({
    required int userProfileId,
    required String messageId,
    required bool isStarred,
  }) async {
    try {
      final api = await _getGmailApi(userProfileId);

      final modifyRequest = gmail.ModifyMessageRequest(
        addLabelIds: isStarred ? ['STARRED'] : null,
        removeLabelIds: isStarred ? null : ['STARRED'],
      );

      await api.users.messages.modify(modifyRequest, 'me', messageId);

      // Update cache
      final cached = await Email.db.findFirstRow(
        session,
        where: (t) =>
            t.userProfileId.equals(userProfileId) &
            t.googleMessageId.equals(messageId),
      );

      if (cached != null) {
        cached.isStarred = isStarred;
        cached.updatedAt = DateTime.now();
        await Email.db.updateRow(session, cached);
      }

      session.log(
        '${isStarred ? "Starred" : "Unstarred"} email $messageId',
        level: LogLevel.info,
      );
    } catch (error, stackTrace) {
      session.log(
        'Failed to star email: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // Helper methods

  Email _mapMessage({
    required int userProfileId,
    required gmail.Message message,
  }) {
    final headers = message.payload?.headers ?? [];
    final subject = _getHeader(headers, 'Subject');
    final from = _getHeader(headers, 'From') ?? '';
    final to = _getHeader(headers, 'To') ?? '';
    final cc = _getHeader(headers, 'Cc');
    final bcc = _getHeader(headers, 'Bcc');
    final dateStr = _getHeader(headers, 'Date');

    final fromParsed = _parseEmailAddress(from);
    final body = _extractBody(message);

    final labels = message.labelIds ?? [];
    final isRead = !labels.contains('UNREAD');
    final isStarred = labels.contains('STARRED');
    final hasAttachments = _hasAttachments(message);

    DateTime receivedAt;
    if (message.internalDate != null) {
      receivedAt = DateTime.fromMillisecondsSinceEpoch(
        int.parse(message.internalDate!),
      );
    } else if (dateStr != null) {
      receivedAt = _parseDate(dateStr) ?? DateTime.now();
    } else {
      receivedAt = DateTime.now();
    }

    return Email(
      userProfileId: userProfileId,
      googleMessageId: message.id ?? '',
      googleThreadId: message.threadId ?? '',
      subject: subject,
      fromEmail: fromParsed.email,
      fromName: fromParsed.name,
      toEmails: _parseEmailList(to),
      ccEmails: cc != null ? _parseEmailList(cc) : null,
      bccEmails: bcc != null ? _parseEmailList(bcc) : null,
      snippet: message.snippet,
      bodyPlainText: body.plainText,
      bodyHtml: body.html,
      isRead: isRead,
      isStarred: isStarred,
      hasAttachments: hasAttachments,
      labels: labels,
      receivedAt: receivedAt,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  String? _getHeader(List<gmail.MessagePartHeader> headers, String name) {
    for (final header in headers) {
      if (header.name?.toLowerCase() == name.toLowerCase()) {
        return header.value;
      }
    }
    return null;
  }

  ({String email, String? name}) _parseEmailAddress(String address) {
    final regex = RegExp(r'^(?:"?([^"]*)"?\s*)?<([^>]+)>$|^([^\s<]+)$');
    final match = regex.firstMatch(address.trim());
    if (match != null) {
      if (match.group(3) != null) {
        return (email: match.group(3)!, name: null);
      }
      return (email: match.group(2) ?? address, name: match.group(1));
    }
    return (email: address, name: null);
  }

  List<String> _parseEmailList(String addresses) {
    return addresses
        .split(',')
        .map((a) => _parseEmailAddress(a.trim()).email)
        .where((e) => e.isNotEmpty)
        .toList();
  }

  ({String? plainText, String? html}) _extractBody(gmail.Message message) {
    String? plainText;
    String? html;

    void extractParts(gmail.MessagePart? part) {
      if (part == null) return;

      if (part.mimeType == 'text/plain' && part.body?.data != null) {
        plainText = _decodeBase64Url(part.body!.data!);
      } else if (part.mimeType == 'text/html' && part.body?.data != null) {
        html = _decodeBase64Url(part.body!.data!);
      }

      for (final subPart in part.parts ?? []) {
        extractParts(subPart);
      }
    }

    extractParts(message.payload);

    // If body is directly in payload
    if (plainText == null &&
        html == null &&
        message.payload?.body?.data != null) {
      final data = _decodeBase64Url(message.payload!.body!.data!);
      if (message.payload?.mimeType == 'text/html') {
        html = data;
      } else {
        plainText = data;
      }
    }

    return (plainText: plainText, html: html);
  }

  bool _hasAttachments(gmail.Message message) {
    bool checkParts(gmail.MessagePart? part) {
      if (part == null) return false;

      if (part.filename != null && part.filename!.isNotEmpty) {
        return true;
      }

      for (final subPart in part.parts ?? []) {
        if (checkParts(subPart)) return true;
      }

      return false;
    }

    return checkParts(message.payload);
  }

  String _decodeBase64Url(String encoded) {
    try {
      // Convert Base64URL to standard Base64
      var output = encoded.replaceAll('-', '+').replaceAll('_', '/');
      // Add padding if needed
      switch (output.length % 4) {
        case 2:
          output += '==';
          break;
        case 3:
          output += '=';
          break;
      }
      return utf8.decode(base64.decode(output));
    } catch (e) {
      return encoded;
    }
  }

  DateTime? _parseDate(String dateStr) {
    try {
      // Try various date formats
      return DateTime.tryParse(dateStr);
    } catch (e) {
      return null;
    }
  }

  String _buildRawMessage({
    required List<String> to,
    List<String>? cc,
    List<String>? bcc,
    required String subject,
    String? bodyPlainText,
    String? bodyHtml,
    String? inReplyTo,
    String? references,
    String? threadId,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('To: ${to.join(", ")}');
    if (cc != null && cc.isNotEmpty) {
      buffer.writeln('Cc: ${cc.join(", ")}');
    }
    if (bcc != null && bcc.isNotEmpty) {
      buffer.writeln('Bcc: ${bcc.join(", ")}');
    }
    buffer.writeln('Subject: $subject');
    buffer.writeln('MIME-Version: 1.0');

    if (inReplyTo != null) {
      buffer.writeln('In-Reply-To: $inReplyTo');
    }
    if (references != null) {
      buffer.writeln('References: $references');
    }

    if (bodyHtml != null && bodyPlainText != null) {
      // Multipart message
      const boundary = 'boundary_string_merlin';
      buffer.writeln('Content-Type: multipart/alternative; boundary=$boundary');
      buffer.writeln();
      buffer.writeln('--$boundary');
      buffer.writeln('Content-Type: text/plain; charset=UTF-8');
      buffer.writeln();
      buffer.writeln(bodyPlainText);
      buffer.writeln('--$boundary');
      buffer.writeln('Content-Type: text/html; charset=UTF-8');
      buffer.writeln();
      buffer.writeln(bodyHtml);
      buffer.writeln('--$boundary--');
    } else if (bodyHtml != null) {
      buffer.writeln('Content-Type: text/html; charset=UTF-8');
      buffer.writeln();
      buffer.writeln(bodyHtml);
    } else {
      buffer.writeln('Content-Type: text/plain; charset=UTF-8');
      buffer.writeln();
      buffer.writeln(bodyPlainText ?? '');
    }

    // Encode to Base64URL
    final rawBytes = utf8.encode(buffer.toString());
    return base64Url.encode(rawBytes).replaceAll('=', '');
  }

  Future<void> _cacheEmail(Email email) async {
    final existing = await Email.db.findFirstRow(
      session,
      where: (t) =>
          t.userProfileId.equals(email.userProfileId) &
          t.googleMessageId.equals(email.googleMessageId),
    );

    if (existing != null) {
      existing
        ..googleThreadId = email.googleThreadId
        ..subject = email.subject
        ..fromEmail = email.fromEmail
        ..fromName = email.fromName
        ..toEmails = email.toEmails
        ..ccEmails = email.ccEmails
        ..bccEmails = email.bccEmails
        ..snippet = email.snippet
        ..bodyPlainText = email.bodyPlainText
        ..bodyHtml = email.bodyHtml
        ..isRead = email.isRead
        ..isStarred = email.isStarred
        ..hasAttachments = email.hasAttachments
        ..labels = email.labels
        ..receivedAt = email.receivedAt
        ..updatedAt = DateTime.now();
      await Email.db.updateRow(session, existing);
    } else {
      await Email.db.insertRow(session, email);
    }
  }

  Future<void> _cacheAttachments(Email email, gmail.Message message) async {
    if (email.id == null || !email.hasAttachments) return;

    void extractAttachments(gmail.MessagePart? part) async {
      if (part == null) return;

      if (part.filename != null &&
          part.filename!.isNotEmpty &&
          part.body?.attachmentId != null) {
        final attachment = EmailAttachment(
          emailId: email.id!,
          attachmentId: part.body!.attachmentId!,
          filename: part.filename!,
          mimeType: part.mimeType ?? 'application/octet-stream',
          size: part.body?.size ?? 0,
          createdAt: DateTime.now(),
        );

        final existing = await EmailAttachment.db.findFirstRow(
          session,
          where: (t) =>
              t.emailId.equals(email.id!) &
              t.attachmentId.equals(part.body!.attachmentId!),
        );

        if (existing == null) {
          await EmailAttachment.db.insertRow(session, attachment);
        }
      }

      for (final subPart in part.parts ?? []) {
        extractAttachments(subPart);
      }
    }

    extractAttachments(message.payload);
  }

  Future<List<Email>> _getCachedEmails({
    required int userProfileId,
    int maxResults = 20,
  }) async {
    return Email.db.find(
      session,
      where: (t) => t.userProfileId.equals(userProfileId),
      orderBy: (t) => t.receivedAt,
      orderDescending: true,
      limit: maxResults,
    );
  }
}
