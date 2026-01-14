import 'package:serverpod/serverpod.dart';

import '../generated/email/email.dart';
import '../generated/email/email_list_response.dart';
import '../services/google_gmail_service.dart';
import '../services/user_profile_service.dart';

class EmailEndpoint extends Endpoint {
  /// Fetches emails with optional pagination
  /// Used by AI to read user emails
  Future<EmailListResponse> getEmails(
    Session session, {
    int maxResults = 20,
    String? pageToken,
    List<String>? labelIds,
    String? query,
  }) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleGmailService(session);
    final result = await service.getEmails(
      userProfileId: userProfileId,
      maxResults: maxResults,
      pageToken: pageToken,
      labelIds: labelIds,
      query: query,
    );
    return EmailListResponse(
      emails: result.emails,
      nextPageToken: result.nextPageToken,
      totalEstimate: result.totalEstimate,
    );
  }

  /// Fetches a single email by message ID
  /// Used by AI to read full email content
  Future<Email?> getEmail(
    Session session,
    String messageId,
  ) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleGmailService(session);
    return service.getEmail(
      userProfileId: userProfileId,
      messageId: messageId,
    );
  }

  /// Fetches an email thread by thread ID
  /// Used by AI to read email conversations
  Future<List<Email>> getEmailThread(
    Session session,
    String threadId,
  ) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleGmailService(session);
    return service.getEmailThread(
      userProfileId: userProfileId,
      threadId: threadId,
    );
  }

  /// Searches emails with Gmail search syntax
  /// Used by AI to find specific emails
  Future<EmailListResponse> searchEmails(
    Session session,
    String query, {
    int maxResults = 20,
    String? pageToken,
  }) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleGmailService(session);
    final result = await service.searchEmails(
      userProfileId: userProfileId,
      query: query,
      maxResults: maxResults,
      pageToken: pageToken,
    );
    return EmailListResponse(
      emails: result.emails,
      nextPageToken: result.nextPageToken,
    );
  }

  /// Syncs emails from Gmail to local cache
  Future<void> syncEmails(
    Session session, {
    int maxResults = 100,
    List<String>? labelIds,
  }) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleGmailService(session);
    await service.syncEmails(
      userProfileId: userProfileId,
      maxResults: maxResults,
      labelIds: labelIds,
    );
  }

  /// Sends a new email
  /// Called by AI when user asks to send an email
  Future<Email?> sendEmail(
    Session session,
    List<String> to,
    String subject, {
    List<String>? cc,
    List<String>? bcc,
    String? bodyPlainText,
    String? bodyHtml,
  }) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleGmailService(session);
    return service.sendEmail(
      userProfileId: userProfileId,
      to: to,
      cc: cc,
      bcc: bcc,
      subject: subject,
      bodyPlainText: bodyPlainText,
      bodyHtml: bodyHtml,
    );
  }

  /// Replies to an existing email
  /// Called by AI when user asks to reply to an email
  Future<Email?> replyToEmail(
    Session session,
    String originalMessageId, {
    String? bodyPlainText,
    String? bodyHtml,
    bool replyAll = false,
  }) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleGmailService(session);
    return service.replyToEmail(
      userProfileId: userProfileId,
      originalMessageId: originalMessageId,
      bodyPlainText: bodyPlainText,
      bodyHtml: bodyHtml,
      replyAll: replyAll,
    );
  }

  /// Forwards an email to new recipients
  /// Called by AI when user asks to forward an email
  Future<Email?> forwardEmail(
    Session session,
    String originalMessageId,
    List<String> to, {
    List<String>? cc,
    List<String>? bcc,
    String? additionalMessage,
  }) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleGmailService(session);
    return service.forwardEmail(
      userProfileId: userProfileId,
      originalMessageId: originalMessageId,
      to: to,
      cc: cc,
      bcc: bcc,
      additionalMessage: additionalMessage,
    );
  }

  /// Marks an email as read or unread
  /// Called by AI when user asks to mark email as read/unread
  Future<void> markAsRead(
    Session session,
    String messageId,
    bool isRead,
  ) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleGmailService(session);
    await service.markAsRead(
      userProfileId: userProfileId,
      messageId: messageId,
      isRead: isRead,
    );
  }

  /// Archives an email
  /// Called by AI when user asks to archive an email
  Future<void> archiveEmail(
    Session session,
    String messageId,
  ) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleGmailService(session);
    await service.archiveEmail(
      userProfileId: userProfileId,
      messageId: messageId,
    );
  }

  /// Deletes an email (moves to Trash)
  /// Called by AI when user asks to delete an email
  Future<void> deleteEmail(
    Session session,
    String messageId,
  ) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleGmailService(session);
    await service.deleteEmail(
      userProfileId: userProfileId,
      messageId: messageId,
    );
  }

  /// Stars or unstars an email
  /// Called by AI when user asks to star/unstar an email
  Future<void> starEmail(
    Session session,
    String messageId,
    bool isStarred,
  ) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleGmailService(session);
    await service.starEmail(
      userProfileId: userProfileId,
      messageId: messageId,
      isStarred: isStarred,
    );
  }

  Future<int> _requireUserProfileId(Session session) async {
    final profileService = UserProfileService(session);
    final userProfileId = await profileService.getCurrentUserProfileId();
    if (userProfileId == null) {
      throw Exception('User not authenticated');
    }
    return userProfileId;
  }
}
