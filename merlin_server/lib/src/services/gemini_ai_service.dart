import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/calendar/calendar_event.dart';
import '../generated/chat/chat_message.dart';
import '../generated/chat/chat_response.dart';
import 'dart:io';
import '../generated/email/email.dart';
import '../generated/user_context/user_context.dart';
import '../services/google_calendar_service.dart';
import '../services/google_gmail_service.dart';
import '../services/google_oauth_service.dart';

class GeminiAIService {
  GeminiAIService(this.session);

  final Session session;
  GenerativeModel? _model;

  static const String _systemPrompt = '''
You are Merlin, an intelligent AI personal assistant that helps users manage their calendar and emails.
You have access to the user's Google Calendar and Gmail.

Your responsibilities:

1. Calendar Management:
- View calendar events for any date range
- Create new calendar events (title, date, time, location, attendees)
- Update existing events
- Delete events
- Find available time slots for scheduling

2. Email Management:
- Read and search emails
- Send new emails
- Reply to emails
- Forward emails
- Archive, delete, or star emails

Behavior rules:
- Be conversational, clear, and helpful.
- Be proactive: mention scheduling conflicts, overlapping events, or important emails when relevant.
- If required details are missing (time, date, recipient, etc.), ask follow-up questions before acting.
- Never assume or invent event details, email content, recipients, or attendees.

Action safety:
- Before sending emails or modifying calendar events, clearly summarize the intended action and ask for explicit user confirmation.
- Only execute actions after the user confirms.

System context:
- Today's date and time will be provided in the context.
- Use this to correctly interpret relative dates such as "today", "tomorrow", or "next week".

When an action is approved, use the appropriate function call.
''';

  Future<GenerativeModel> _getModel() async {
    if (_model != null) return _model!;

    final apiKey =
        Platform.environment['geminiApiKey'] ??
        session.passwords['geminiApiKey'] ??
        '';
    if (apiKey.isEmpty || apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      throw Exception(
        'Gemini API key not configured. Please set geminiApiKey in passwords.yaml',
      );
    }

    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 4096,
      ),
      tools: [
        Tool(functionDeclarations: _getFunctionDeclarations()),
      ],
      systemInstruction: Content.system(_systemPrompt),
    );

    return _model!;
  }

  List<FunctionDeclaration> _getFunctionDeclarations() {
    return [
      FunctionDeclaration(
        'getCalendarEvents',
        'Get calendar events for a specific date range',
        Schema.object(
          properties: {
            'startDate': Schema.string(
              description: 'Start date in ISO 8601 format (YYYY-MM-DD)',
            ),
            'endDate': Schema.string(
              description: 'End date in ISO 8601 format (YYYY-MM-DD)',
            ),
          },
          requiredProperties: ['startDate', 'endDate'],
        ),
      ),
      FunctionDeclaration(
        'createCalendarEvent',
        'Create a new calendar event',
        Schema.object(
          properties: {
            'title': Schema.string(description: 'Event title'),
            'startTime': Schema.string(
              description: 'Start time in ISO 8601 format',
            ),
            'endTime': Schema.string(
              description: 'End time in ISO 8601 format',
            ),
            'description': Schema.string(description: 'Event description'),
            'location': Schema.string(description: 'Event location'),
            'attendees': Schema.array(
              items: Schema.string(),
              description: 'List of attendee email addresses',
            ),
          },
          requiredProperties: ['title', 'startTime', 'endTime'],
        ),
      ),
      FunctionDeclaration(
        'updateCalendarEvent',
        'Update an existing calendar event',
        Schema.object(
          properties: {
            'eventId': Schema.string(
              description: 'The Google event ID to update',
            ),
            'title': Schema.string(description: 'New event title'),
            'startTime': Schema.string(
              description: 'New start time in ISO 8601 format',
            ),
            'endTime': Schema.string(
              description: 'New end time in ISO 8601 format',
            ),
            'description': Schema.string(description: 'New event description'),
            'location': Schema.string(description: 'New event location'),
          },
          requiredProperties: ['eventId'],
        ),
      ),
      FunctionDeclaration(
        'deleteCalendarEvent',
        'Delete a calendar event',
        Schema.object(
          properties: {
            'eventId': Schema.string(
              description: 'The Google event ID to delete',
            ),
          },
          requiredProperties: ['eventId'],
        ),
      ),
      FunctionDeclaration(
        'findAvailableTimeSlots',
        'Find available time slots for scheduling a meeting',
        Schema.object(
          properties: {
            'durationMinutes': Schema.integer(
              description: 'Duration of the meeting in minutes',
            ),
            'startDate': Schema.string(
              description: 'Start date to search from (ISO 8601)',
            ),
            'endDate': Schema.string(
              description: 'End date to search until (ISO 8601)',
            ),
            'workingHoursStart': Schema.integer(
              description: 'Working hours start (0-23), default 9',
            ),
            'workingHoursEnd': Schema.integer(
              description: 'Working hours end (0-23), default 17',
            ),
          },
          requiredProperties: ['durationMinutes', 'startDate', 'endDate'],
        ),
      ),

      FunctionDeclaration(
        'getEmails',
        'Get recent emails from inbox',
        Schema.object(
          properties: {
            'maxResults': Schema.integer(
              description: 'Maximum number of emails to return',
            ),
            'query': Schema.string(
              description:
                  'Gmail search query (e.g., "from:john@example.com", "is:unread")',
            ),
          },
        ),
      ),
      FunctionDeclaration(
        'searchEmails',
        'Search for emails using Gmail search syntax',
        Schema.object(
          properties: {
            'query': Schema.string(
              description: 'Search query using Gmail syntax',
            ),
            'maxResults': Schema.integer(
              description: 'Maximum results to return',
            ),
          },
          requiredProperties: ['query'],
        ),
      ),
      FunctionDeclaration(
        'sendEmail',
        'Send a new email. If the user explicitly requests to save as draft (e.g., "save as draft", "put in draft", "draft it"), set saveAsDraft to true.',
        Schema.object(
          properties: {
            'to': Schema.array(
              items: Schema.string(),
              description: 'Recipient email addresses',
            ),
            'subject': Schema.string(description: 'Email subject'),
            'body': Schema.string(description: 'Email body content'),
            'cc': Schema.array(
              items: Schema.string(),
              description: 'CC recipients',
            ),
            'saveAsDraft': Schema.boolean(
              description:
                  'Set to true if user explicitly requests to save email as draft instead of sending. Look for phrases like "save as draft", "put in draft", "draft", "save draft", "draft it", etc.',
            ),
          },
          requiredProperties: ['to', 'subject', 'body'],
        ),
      ),
      FunctionDeclaration(
        'replyToEmail',
        'Reply to an existing email',
        Schema.object(
          properties: {
            'messageId': Schema.string(
              description: 'The Gmail message ID to reply to',
            ),
            'body': Schema.string(description: 'Reply body content'),
            'replyAll': Schema.boolean(
              description: 'Whether to reply to all recipients',
            ),
          },
          requiredProperties: ['messageId', 'body'],
        ),
      ),
      FunctionDeclaration(
        'forwardEmail',
        'Forward an email to new recipients',
        Schema.object(
          properties: {
            'messageId': Schema.string(
              description: 'The Gmail message ID to forward',
            ),
            'to': Schema.array(
              items: Schema.string(),
              description: 'Recipients to forward to',
            ),
            'additionalMessage': Schema.string(
              description: 'Additional message to include',
            ),
          },
          requiredProperties: ['messageId', 'to'],
        ),
      ),
      FunctionDeclaration(
        'archiveEmail',
        'Archive an email (remove from inbox)',
        Schema.object(
          properties: {
            'messageId': Schema.string(
              description: 'The Gmail message ID to archive',
            ),
          },
          requiredProperties: ['messageId'],
        ),
      ),
      FunctionDeclaration(
        'deleteEmail',
        'Delete an email (move to trash)',
        Schema.object(
          properties: {
            'messageId': Schema.string(
              description: 'The Gmail message ID to delete',
            ),
          },
          requiredProperties: ['messageId'],
        ),
      ),
      FunctionDeclaration(
        'markEmailAsRead',
        'Mark an email as read or unread',
        Schema.object(
          properties: {
            'messageId': Schema.string(description: 'The Gmail message ID'),
            'isRead': Schema.boolean(
              description: 'true to mark as read, false for unread',
            ),
          },
          requiredProperties: ['messageId', 'isRead'],
        ),
      ),
    ];
  }

  bool _isCalendarOrEmailRelated(String message) {
    final lowerMessage = message.toLowerCase();
    final calendarKeywords = [
      'calendar',
      'event',
      'meeting',
      'appointment',
      'schedule',
      'reminder',
      'agenda',
      'book',
      'reserve',
      'cancel event',
      'create event',
      'delete event',
      'update event',
      'what\'s on',
      'what is on',
      'when is',
      'when are',
    ];
    final emailKeywords = [
      'email',
      'mail',
      'gmail',
      'inbox',
      'send email',
      'reply',
      'forward',
      'archive',
      'delete email',
      'unread',
      'read email',
      'check email',
      'compose',
      'draft',
    ];

    return calendarKeywords.any((keyword) => lowerMessage.contains(keyword)) ||
        emailKeywords.any((keyword) => lowerMessage.contains(keyword));
  }

  Future<ChatResponse> chat({
    required int userProfileId,
    required String message,
    List<ChatMessage>? conversationHistory,
    bool includeCalendarContext = true,
    bool includeEmailContext = true,
  }) async {
    try {
      if (_isCalendarOrEmailRelated(message)) {
        final oauthService = GoogleOAuthService(session);
        final isConnected = await oauthService.isConnected(userProfileId);

        if (!isConnected) {
          await _saveMessage(userProfileId, 'user', message);
          final responseMessage =
              'I\'d be happy to help you with your calendar and email! However, '
              'you need to connect your Google account first to access these features. ';
          await _saveMessage(userProfileId, 'model', responseMessage);

          return ChatResponse(
            message: responseMessage,
          );
        }
      }

      final model = await _getModel();

      final contextParts = <String>[];
      contextParts.add(
        'Current date and time: ${DateTime.now().toIso8601String()}',
      );

      final userContextInfo = await _getUserContext(userProfileId);
      if (userContextInfo.isNotEmpty) {
        contextParts.add(
          'User preferences and important information:\n$userContextInfo',
        );
      }

      if (includeCalendarContext) {
        final calendarContext = await _getCalendarContext(userProfileId);
        if (calendarContext.isNotEmpty) {
          contextParts.add('Today\'s calendar events:\n$calendarContext');
        }
      }

      if (includeEmailContext) {
        final emailContext = await _getEmailContext(userProfileId);
        if (emailContext.isNotEmpty) {
          contextParts.add('Recent unread emails:\n$emailContext');
        }
      }

      final contents = <Content>[];

      if (contextParts.isNotEmpty) {
        contents.add(Content.text('[Context]\n${contextParts.join("\n\n")}'));
        contents.add(
          Content('model', [
            TextPart('I understand the context. How can I help you today?'),
          ]),
        );
      }

      if (conversationHistory != null && conversationHistory.isNotEmpty) {
        final validMessages = conversationHistory
            .where(
              (msg) =>
                  msg.content.trim().isNotEmpty &&
                  (msg.role == 'user' || msg.role == 'model'),
            )
            .toList();

        for (final msg in validMessages) {
          if (msg.role == 'user') {
            contents.add(Content.text(msg.content));
          } else {
            contents.add(Content('model', [TextPart(msg.content)]));
          }
        }
      }

      contents.add(Content.text(message));

      final chat = model.startChat(
        history: contents.take(contents.length - 1).toList(),
      );

      var response = await chat.sendMessage(Content.text(message));

      final functionsCalled = <String>[];
      final calendarEventsAffected = <String>[];
      final emailsAffected = <String>[];

      while (response.functionCalls.isNotEmpty) {
        final functionResponses = <FunctionResponse>[];

        for (final call in response.functionCalls) {
          session.log(
            'AI calling function: ${call.name} with args: ${call.args}',
            level: LogLevel.info,
          );

          functionsCalled.add(call.name);

          final result = await _executeFunction(
            userProfileId: userProfileId,
            functionName: call.name,
            args: call.args,
            calendarEventsAffected: calendarEventsAffected,
            emailsAffected: emailsAffected,
          );

          functionResponses.add(FunctionResponse(call.name, result));
        }

        response = await chat.sendMessage(
          Content.functionResponses(functionResponses),
        );
      }

      final responseText =
          response.text ?? 'I apologize, but I couldn\'t generate a response.';

      await _saveMessage(userProfileId, 'user', message);
      await _saveMessage(userProfileId, 'model', responseText);

      return ChatResponse(
        message: responseText,
        functionsCalled: functionsCalled.isNotEmpty ? functionsCalled : null,
        calendarEventsAffected: calendarEventsAffected.isNotEmpty
            ? calendarEventsAffected
            : null,
        emailsAffected: emailsAffected.isNotEmpty ? emailsAffected : null,
      );
    } catch (e, stackTrace) {
      session.log(
        'Error in AI chat: $e',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );

      return ChatResponse(
        message:
            'I apologize, but I encountered an error processing your request. Please try again.',
        error: e.toString(),
      );
    }
  }

  Future<String> _getUserContext(int userProfileId) async {
    try {
      final contexts = await UserContext.db.find(
        session,
        where: (t) => t.userProfileId.equals(userProfileId),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );

      if (contexts.isEmpty) return '';

      return contexts.map((c) => '- ${c.title}: ${c.content}').join('\n');
    } catch (e) {
      return '';
    }
  }

  Future<String> _getCalendarContext(int userProfileId) async {
    try {
      final calendarService = GoogleCalendarService(session);
      final calendars = await calendarService.getCalendars(userProfileId);

      if (calendars.isEmpty) return '';

      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final events = await calendarService.getCalendarEvents(
        userProfileId: userProfileId,
        calendarId: calendars.first.googleCalendarId,
        startTime: startOfDay,
        endTime: endOfDay,
      );

      if (events.isEmpty) return 'No events scheduled for today.';

      return events
          .map(
            (e) =>
                '- ${e.title} at ${_formatTime(e.startTime)} - ${_formatTime(e.endTime)}${e.location != null ? " (${e.location})" : ""}',
          )
          .join('\n');
    } catch (e) {
      return '';
    }
  }

  Future<String> _getEmailContext(int userProfileId) async {
    try {
      final emailService = GoogleGmailService(session);
      final result = await emailService.getEmails(
        userProfileId: userProfileId,
        maxResults: 5,
        query: 'is:unread',
      );

      if (result.emails.isEmpty) return 'No unread emails.';

      return result.emails
          .map(
            (e) =>
                '- From: ${e.fromName ?? e.fromEmail} | Subject: ${e.subject ?? "(no subject)"} | ${_formatRelativeTime(e.receivedAt)}',
          )
          .join('\n');
    } catch (e) {
      return '';
    }
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatRelativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Future<Map<String, Object?>> _executeFunction({
    required int userProfileId,
    required String functionName,
    required Map<String, Object?> args,
    required List<String> calendarEventsAffected,
    required List<String> emailsAffected,
  }) async {
    try {
      final calendarFunctions = [
        'getCalendarEvents',
        'createCalendarEvent',
        'updateCalendarEvent',
        'deleteCalendarEvent',
        'findAvailableTimeSlots',
      ];
      final emailFunctions = [
        'getEmails',
        'searchEmails',
        'sendEmail',
        'replyToEmail',
        'forwardEmail',
        'archiveEmail',
        'deleteEmail',
        'markEmailAsRead',
      ];

      if (calendarFunctions.contains(functionName) ||
          emailFunctions.contains(functionName)) {
        final oauthService = GoogleOAuthService(session);
        final isConnected = await oauthService.isConnected(userProfileId);

        if (!isConnected) {
          return {
            'error':
                'Google account is not connected. Please connect your Google account to use this feature.',
          };
        }
      }

      switch (functionName) {
        case 'getCalendarEvents':
          return await _handleGetCalendarEvents(userProfileId, args);

        case 'createCalendarEvent':
          final result = await _handleCreateCalendarEvent(userProfileId, args);
          if (result['eventId'] != null) {
            calendarEventsAffected.add(result['eventId'] as String);
          }
          return result;

        case 'updateCalendarEvent':
          final result = await _handleUpdateCalendarEvent(userProfileId, args);
          if (args['eventId'] != null) {
            calendarEventsAffected.add(args['eventId'] as String);
          }
          return result;

        case 'deleteCalendarEvent':
          await _handleDeleteCalendarEvent(userProfileId, args);
          if (args['eventId'] != null) {
            calendarEventsAffected.add(args['eventId'] as String);
          }
          return {'success': true};

        case 'findAvailableTimeSlots':
          return await _handleFindAvailableSlots(userProfileId, args);

        case 'getEmails':
          return await _handleGetEmails(userProfileId, args);

        case 'searchEmails':
          return await _handleSearchEmails(userProfileId, args);

        case 'sendEmail':
          final result = await _handleSendEmail(userProfileId, args);
          if (result['messageId'] != null) {
            emailsAffected.add(result['messageId'] as String);
          }
          return result;

        case 'replyToEmail':
          final result = await _handleReplyToEmail(userProfileId, args);
          if (result['messageId'] != null) {
            emailsAffected.add(result['messageId'] as String);
          }
          return result;

        case 'forwardEmail':
          final result = await _handleForwardEmail(userProfileId, args);
          if (result['messageId'] != null) {
            emailsAffected.add(result['messageId'] as String);
          }
          return result;

        case 'archiveEmail':
          await _handleArchiveEmail(userProfileId, args);
          if (args['messageId'] != null) {
            emailsAffected.add(args['messageId'] as String);
          }
          return {'success': true};

        case 'deleteEmail':
          await _handleDeleteEmail(userProfileId, args);
          if (args['messageId'] != null) {
            emailsAffected.add(args['messageId'] as String);
          }
          return {'success': true};

        case 'markEmailAsRead':
          await _handleMarkEmailAsRead(userProfileId, args);
          if (args['messageId'] != null) {
            emailsAffected.add(args['messageId'] as String);
          }
          return {'success': true};

        default:
          return {'error': 'Unknown function: $functionName'};
      }
    } catch (e) {
      session.log(
        'Error executing function $functionName: $e',
        level: LogLevel.error,
      );
      return {'error': e.toString()};
    }
  }

  Future<Map<String, Object?>> _handleGetCalendarEvents(
    int userProfileId,
    Map<String, Object?> args,
  ) async {
    final startDate = DateTime.parse(args['startDate'] as String);
    var endDate = DateTime.parse(args['endDate'] as String);

    if (endDate.hour == 0 && endDate.minute == 0 && endDate.second == 0) {
      endDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
    }

    final calendarService = GoogleCalendarService(session);
    final calendars = await calendarService.getCalendars(userProfileId);

    if (calendars.isEmpty) {
      return {'events': [], 'message': 'No calendars found'};
    }

    final primaryCalendar = calendars.firstWhere(
      (cal) => cal.isPrimary,
      orElse: () => calendars.first,
    );

    final events = await calendarService.getCalendarEvents(
      userProfileId: userProfileId,
      calendarId: primaryCalendar.googleCalendarId,
      startTime: startDate,
      endTime: endDate,
    );

    session.log(
      'Retrieved ${events.length} events from ${startDate.toIso8601String()} to ${endDate.toIso8601String()}',
      level: LogLevel.info,
    );

    return {
      'events': events.map((e) => _eventToMap(e)).toList(),
      'count': events.length,
    };
  }

  Future<Map<String, Object?>> _handleCreateCalendarEvent(
    int userProfileId,
    Map<String, Object?> args,
  ) async {
    try {
      final calendarService = GoogleCalendarService(session);
      final calendars = await calendarService.getCalendars(userProfileId);

      if (calendars.isEmpty) {
        return {
          'error':
              'No calendars found. Please connect your Google Calendar first.',
        };
      }

      final primaryCalendar = calendars.firstWhere(
        (cal) => cal.isPrimary,
        orElse: () => calendars.first,
      );

      final attendees = args['attendees'] != null
          ? (args['attendees'] as List).cast<String>()
          : null;

      final event = await calendarService.createEvent(
        userProfileId: userProfileId,
        calendarId: primaryCalendar.googleCalendarId,
        title: args['title'] as String,
        startTime: DateTime.parse(args['startTime'] as String),
        endTime: DateTime.parse(args['endTime'] as String),
        description: args['description'] as String?,
        location: args['location'] as String?,
        attendees: attendees,
      );

      return {
        'success': true,
        'eventId': event.googleEventId,
        'event': _eventToMap(event),
      };
    } catch (e) {
      if (e.toString().contains('403') ||
          e.toString().contains('writer access')) {
        return {
          'error':
              'Insufficient calendar permissions. Please disconnect and reconnect your Google account to grant calendar write access.',
          'needsReauth': true,
        };
      }
      rethrow;
    }
  }

  Future<Map<String, Object?>> _handleUpdateCalendarEvent(
    int userProfileId,
    Map<String, Object?> args,
  ) async {
    try {
      final calendarService = GoogleCalendarService(session);
      final calendars = await calendarService.getCalendars(userProfileId);

      if (calendars.isEmpty) {
        return {
          'error':
              'No calendars found. Please connect your Google Calendar first.',
        };
      }

      final primaryCalendar = calendars.firstWhere(
        (cal) => cal.isPrimary,
        orElse: () => calendars.first,
      );

      final event = await calendarService.updateEvent(
        userProfileId: userProfileId,
        calendarId: primaryCalendar.googleCalendarId,
        googleEventId: args['eventId'] as String,
        title: args['title'] as String?,
        startTime: args['startTime'] != null
            ? DateTime.parse(args['startTime'] as String)
            : null,
        endTime: args['endTime'] != null
            ? DateTime.parse(args['endTime'] as String)
            : null,
        description: args['description'] as String?,
        location: args['location'] as String?,
      );

      return {
        'success': true,
        'event': _eventToMap(event),
      };
    } catch (e) {
      if (e.toString().contains('403') ||
          e.toString().contains('writer access')) {
        return {
          'error':
              'Insufficient calendar permissions. Please disconnect and reconnect your Google account to grant calendar write access.',
          'needsReauth': true,
        };
      }
      rethrow;
    }
  }

  Future<void> _handleDeleteCalendarEvent(
    int userProfileId,
    Map<String, Object?> args,
  ) async {
    try {
      final calendarService = GoogleCalendarService(session);
      final calendars = await calendarService.getCalendars(userProfileId);

      if (calendars.isEmpty) {
        throw Exception(
          'No calendars found. Please connect your Google Calendar first.',
        );
      }

      final primaryCalendar = calendars.firstWhere(
        (cal) => cal.isPrimary,
        orElse: () => calendars.first,
      );

      await calendarService.deleteEvent(
        userProfileId: userProfileId,
        calendarId: primaryCalendar.googleCalendarId,
        googleEventId: args['eventId'] as String,
      );
    } catch (e) {
      if (e.toString().contains('403') ||
          e.toString().contains('writer access')) {
        throw Exception(
          'Insufficient calendar permissions. Please disconnect and reconnect your Google account to grant calendar write access.',
        );
      }
      rethrow;
    }
  }

  Future<Map<String, Object?>> _handleFindAvailableSlots(
    int userProfileId,
    Map<String, Object?> args,
  ) async {
    final calendarService = GoogleCalendarService(session);
    final calendars = await calendarService.getCalendars(userProfileId);

    if (calendars.isEmpty) {
      return {'slots': [], 'message': 'No calendars found'};
    }

    final slots = await calendarService.findAvailableTimeSlots(
      userProfileId: userProfileId,
      calendarId: calendars.first.googleCalendarId,
      durationMinutes: args['durationMinutes'] as int,
      searchStartTime: DateTime.parse(args['startDate'] as String),
      searchEndTime: DateTime.parse(args['endDate'] as String),
      workingHoursStart: args['workingHoursStart'] as int?,
      workingHoursEnd: args['workingHoursEnd'] as int?,
    );

    return {
      'slots': slots
          .map(
            (s) => {
              'startTime': (s['start_time'] as DateTime).toIso8601String(),
              'endTime': (s['end_time'] as DateTime).toIso8601String(),
              'durationMinutes': s['duration_minutes'],
            },
          )
          .toList(),
      'count': slots.length,
    };
  }

  Future<Map<String, Object?>> _handleGetEmails(
    int userProfileId,
    Map<String, Object?> args,
  ) async {
    final emailService = GoogleGmailService(session);
    final result = await emailService.getEmails(
      userProfileId: userProfileId,
      maxResults: args['maxResults'] as int? ?? 10,
      query: args['query'] as String?,
    );

    return {
      'emails': result.emails.map((e) => _emailToMap(e)).toList(),
      'count': result.emails.length,
    };
  }

  Future<Map<String, Object?>> _handleSearchEmails(
    int userProfileId,
    Map<String, Object?> args,
  ) async {
    final emailService = GoogleGmailService(session);
    final result = await emailService.searchEmails(
      userProfileId: userProfileId,
      query: args['query'] as String,
      maxResults: args['maxResults'] as int? ?? 10,
    );

    return {
      'emails': result.emails.map((e) => _emailToMap(e)).toList(),
      'count': result.emails.length,
    };
  }

  Future<Map<String, Object?>> _handleSendEmail(
    int userProfileId,
    Map<String, Object?> args,
  ) async {
    final emailService = GoogleGmailService(session);

    final to = (args['to'] as List).cast<String>();
    final cc = args['cc'] != null ? (args['cc'] as List).cast<String>() : null;
    final saveAsDraft = args['saveAsDraft'] as bool? ?? false;

    final email = await emailService.sendEmail(
      userProfileId: userProfileId,
      to: to,
      cc: cc,
      subject: args['subject'] as String,
      bodyPlainText: args['body'] as String,
      saveAsDraft: saveAsDraft,
    );

    return {
      'success': true,
      'messageId': email?.googleMessageId,
      'savedAsDraft': saveAsDraft,
    };
  }

  Future<Map<String, Object?>> _handleReplyToEmail(
    int userProfileId,
    Map<String, Object?> args,
  ) async {
    final emailService = GoogleGmailService(session);

    final email = await emailService.replyToEmail(
      userProfileId: userProfileId,
      originalMessageId: args['messageId'] as String,
      bodyPlainText: args['body'] as String,
      replyAll: args['replyAll'] as bool? ?? false,
    );

    return {
      'success': true,
      'messageId': email?.googleMessageId,
    };
  }

  Future<Map<String, Object?>> _handleForwardEmail(
    int userProfileId,
    Map<String, Object?> args,
  ) async {
    final emailService = GoogleGmailService(session);

    final to = (args['to'] as List).cast<String>();

    final email = await emailService.forwardEmail(
      userProfileId: userProfileId,
      originalMessageId: args['messageId'] as String,
      to: to,
      additionalMessage: args['additionalMessage'] as String?,
    );

    return {
      'success': true,
      'messageId': email?.googleMessageId,
    };
  }

  Future<void> _handleArchiveEmail(
    int userProfileId,
    Map<String, Object?> args,
  ) async {
    final emailService = GoogleGmailService(session);
    await emailService.archiveEmail(
      userProfileId: userProfileId,
      messageId: args['messageId'] as String,
    );
  }

  Future<void> _handleDeleteEmail(
    int userProfileId,
    Map<String, Object?> args,
  ) async {
    final emailService = GoogleGmailService(session);
    await emailService.deleteEmail(
      userProfileId: userProfileId,
      messageId: args['messageId'] as String,
    );
  }

  Future<void> _handleMarkEmailAsRead(
    int userProfileId,
    Map<String, Object?> args,
  ) async {
    final emailService = GoogleGmailService(session);
    await emailService.markAsRead(
      userProfileId: userProfileId,
      messageId: args['messageId'] as String,
      isRead: args['isRead'] as bool,
    );
  }

  Map<String, Object?> _eventToMap(CalendarEvent event) {
    return {
      'eventId': event.googleEventId,
      'title': event.title,
      'startTime': event.startTime.toIso8601String(),
      'endTime': event.endTime.toIso8601String(),
      'description': event.description,
      'location': event.location,
      'attendees': event.attendees,
      'status': event.status,
    };
  }

  Map<String, Object?> _emailToMap(Email email) {
    return {
      'messageId': email.googleMessageId,
      'threadId': email.googleThreadId,
      'subject': email.subject,
      'from': email.fromName != null
          ? '${email.fromName} <${email.fromEmail}>'
          : email.fromEmail,
      'to': email.toEmails,
      'snippet': email.snippet,
      'isRead': email.isRead,
      'isStarred': email.isStarred,
      'receivedAt': email.receivedAt.toIso8601String(),
    };
  }

  Future<void> _saveMessage(
    int userProfileId,
    String role,
    String content,
  ) async {
    if (content.trim().isEmpty) return;
    try {
      final message = ChatMessage(
        userProfileId: userProfileId,
        role: role,
        content: content,
        createdAt: DateTime.now(),
      );
      await ChatMessage.db.insertRow(session, message);
    } catch (e) {
      session.log('Error saving chat message: $e', level: LogLevel.warning);
    }
  }

  Future<List<ChatMessage>> getConversationHistory(
    int userProfileId, {
    int limit = 20,
  }) async {
    return ChatMessage.db
        .find(
          session,
          where: (t) => t.userProfileId.equals(userProfileId),
          orderBy: (t) => t.createdAt,
          orderDescending: true,
          limit: limit,
        )
        .then((list) => list.reversed.toList());
  }

  Future<void> clearConversationHistory(int userProfileId) async {
    await ChatMessage.db.deleteWhere(
      session,
      where: (t) => t.userProfileId.equals(userProfileId),
    );
  }
}
