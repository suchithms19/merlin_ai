import 'dart:async';

import 'package:googleapis/calendar/v3.dart' as gcal;
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../generated/calendar/calendar.dart';
import '../generated/calendar/calendar_event.dart';
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

class GoogleCalendarService {
  GoogleCalendarService(this.session);

  final Session session;

  Future<gcal.CalendarApi> _getCalendarApi(int userProfileId) async {
    final oauthService = GoogleOAuthService(session);
    final accessToken = await oauthService.getValidAccessToken(userProfileId);
    final authClient = _GoogleAuthClient(accessToken);
    return gcal.CalendarApi(authClient);
  }

  Future<List<Calendar>> getCalendars(int userProfileId) async {
    try {
      final api = await _getCalendarApi(userProfileId);
      final response = await api.calendarList.list();

      final calendars = (response.items ?? [])
          .where((c) => c.id != null)
          .map(
            (c) => Calendar(
              userProfileId: userProfileId,
              googleCalendarId: c.id!,
              name: c.summary ?? 'Calendar',
              description: c.description,
              backgroundColor: c.backgroundColor,
              isPrimary: c.primary ?? false,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          )
          .toList();

      await _cacheCalendars(calendars);
      return calendars;
    } catch (error, stackTrace) {
      session.log(
        'Failed to fetch calendars: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      return _getCachedCalendars(userProfileId);
    }
  }

  Future<List<CalendarEvent>> getCalendarEvents({
    required int userProfileId,
    required String calendarId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      final api = await _getCalendarApi(userProfileId);
      final response = await api.events.list(
        calendarId,
        timeMin: startTime.toUtc(),
        timeMax: endTime.toUtc(),
        singleEvents: true,
        orderBy: 'startTime',
      );

      final events = (response.items ?? [])
          .where((event) => event.id != null)
          .map(
            (event) => _mapEvent(
              userProfileId: userProfileId,
              calendarId: calendarId,
              event: event,
            ),
          )
          .toList();

      await _cacheEvents(events);
      return events;
    } catch (error, stackTrace) {
      session.log(
        'Failed to fetch calendar events: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      return _getCachedEvents(
        userProfileId: userProfileId,
        calendarId: calendarId,
        startTime: startTime,
        endTime: endTime,
      );
    }
  }

  Future<CalendarEvent?> getCalendarEvent({
    required int userProfileId,
    required String calendarId,
    required String googleEventId,
  }) async {
    try {
      final api = await _getCalendarApi(userProfileId);
      final event = await api.events.get(calendarId, googleEventId);
      if (event.id == null) return null;

      final mapped = _mapEvent(
        userProfileId: userProfileId,
        calendarId: calendarId,
        event: event,
      );
      await _cacheEvents([mapped]);
      return mapped;
    } catch (error, stackTrace) {
      session.log(
        'Failed to fetch calendar event $googleEventId: $error',
        level: LogLevel.warning,
        stackTrace: stackTrace,
      );
      return CalendarEvent.db.findFirstRow(
        session,
        where: (t) =>
            t.userProfileId.equals(userProfileId) &
            t.calendarId.equals(calendarId) &
            t.googleEventId.equals(googleEventId),
      );
    }
  }

  Future<void> syncCalendar({
    required int userProfileId,
    String? calendarId,
    DateTime? timeMin,
    DateTime? timeMax,
  }) async {
    final calendars = await getCalendars(userProfileId);
    final targetCalendars = calendarId == null
        ? calendars
        : calendars.where((c) => c.googleCalendarId == calendarId);

    final start = timeMin ?? DateTime.now().subtract(const Duration(days: 1));
    final end = timeMax ?? DateTime.now().add(const Duration(days: 30));

    for (final cal in targetCalendars) {
      await getCalendarEvents(
        userProfileId: userProfileId,
        calendarId: cal.googleCalendarId,
        startTime: start,
        endTime: end,
      );
    }
  }

  CalendarEvent _mapEvent({
    required int userProfileId,
    required String calendarId,
    required gcal.Event event,
  }) {
    final startDateTime =
        event.start?.dateTime ?? event.start?.date?.toUtc() ?? DateTime.now();
    final endDateTime =
        event.end?.dateTime ?? event.end?.date?.toUtc() ?? startDateTime;

    final attendees = (event.attendees ?? [])
        .map((a) => a.email)
        .whereType<String>()
        .toList();

    final recurrenceRule =
        event.recurrence != null && event.recurrence!.isNotEmpty
        ? event.recurrence!.join('\n')
        : null;

    return CalendarEvent(
      userProfileId: userProfileId,
      calendarId: calendarId,
      googleEventId: event.id ?? '',
      title: event.summary ?? 'Untitled event',
      description: event.description,
      startTime: startDateTime,
      endTime: endDateTime,
      location: event.location,
      attendees: attendees,
      organizerEmail: event.organizer?.email,
      recurrenceRule: recurrenceRule,
      status: event.status ?? 'confirmed',
      createdAt: event.created ?? DateTime.now(),
      updatedAt: event.updated ?? DateTime.now(),
    );
  }

  Future<void> _cacheCalendars(List<Calendar> calendars) async {
    for (final calendar in calendars) {
      final existing = await Calendar.db.findFirstRow(
        session,
        where: (t) =>
            t.userProfileId.equals(calendar.userProfileId) &
            t.googleCalendarId.equals(calendar.googleCalendarId),
      );

      if (existing != null) {
        existing
          ..name = calendar.name
          ..description = calendar.description
          ..backgroundColor = calendar.backgroundColor
          ..isPrimary = calendar.isPrimary
          ..updatedAt = DateTime.now();
        await Calendar.db.updateRow(session, existing);
      } else {
        await Calendar.db.insertRow(session, calendar);
      }
    }
  }

  Future<List<Calendar>> _getCachedCalendars(int userProfileId) async {
    return Calendar.db.find(
      session,
      where: (t) => t.userProfileId.equals(userProfileId),
      orderBy: (t) => t.isPrimary,
      orderDescending: true,
    );
  }

  Future<void> _cacheEvents(List<CalendarEvent> events) async {
    for (final event in events) {
      final existing = await CalendarEvent.db.findFirstRow(
        session,
        where: (t) =>
            t.userProfileId.equals(event.userProfileId) &
            t.googleEventId.equals(event.googleEventId),
      );

      if (existing != null) {
        existing
          ..calendarId = event.calendarId
          ..title = event.title
          ..description = event.description
          ..startTime = event.startTime
          ..endTime = event.endTime
          ..location = event.location
          ..attendees = event.attendees
          ..organizerEmail = event.organizerEmail
          ..recurrenceRule = event.recurrenceRule
          ..status = event.status
          ..updatedAt = DateTime.now();
        await CalendarEvent.db.updateRow(session, existing);
      } else {
        await CalendarEvent.db.insertRow(session, event);
      }
    }
  }

  Future<List<CalendarEvent>> _getCachedEvents({
    required int userProfileId,
    required String calendarId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    return CalendarEvent.db.find(
      session,
      where: (t) =>
          t.userProfileId.equals(userProfileId) &
          t.calendarId.equals(calendarId) &
          t.startTime.between(startTime, endTime),
      orderBy: (t) => t.startTime,
    );
  }
}
