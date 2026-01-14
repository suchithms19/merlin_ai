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

  /// Creates a new calendar event
  /// Used by AI to create events based on user requests
  Future<CalendarEvent> createEvent({
    required int userProfileId,
    required String calendarId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    String? description,
    String? location,
    List<String>? attendees,
    String? recurrenceRule,
    bool sendNotifications = true,
  }) async {
    try {
      final api = await _getCalendarApi(userProfileId);
      
      // Build the event
      final event = gcal.Event()
        ..summary = title
        ..description = description
        ..location = location
        ..start = gcal.EventDateTime(dateTime: startTime.toUtc())
        ..end = gcal.EventDateTime(dateTime: endTime.toUtc());
      
      if (attendees != null && attendees.isNotEmpty) {
        event.attendees = attendees
            .map((email) => gcal.EventAttendee()..email = email)
            .toList();
      }
      
      if (recurrenceRule != null && recurrenceRule.isNotEmpty) {
        event.recurrence = [recurrenceRule];
      }
      
      final createdEvent = await api.events.insert(
        event,
        calendarId,
        sendNotifications: sendNotifications,
      );
      
      if (createdEvent.id == null) {
        throw Exception('Failed to create event: no event ID returned');
      }
      
      final mappedEvent = _mapEvent(
        userProfileId: userProfileId,
        calendarId: calendarId,
        event: createdEvent,
      );
      
      await _cacheEvents([mappedEvent]);
      
      session.log(
        'Created event "$title" in calendar $calendarId',
        level: LogLevel.info,
      );
      
      return mappedEvent;
    } catch (error, stackTrace) {
      session.log(
        'Failed to create calendar event: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Updates an existing calendar event
  /// Used by AI to modify events based on user requests
  Future<CalendarEvent> updateEvent({
    required int userProfileId,
    required String calendarId,
    required String googleEventId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    List<String>? attendees,
    String? recurrenceRule,
    bool sendNotifications = true,
  }) async {
    try {
      final api = await _getCalendarApi(userProfileId);
      
      final existingEvent = await api.events.get(calendarId, googleEventId);
      
      if (title != null) existingEvent.summary = title;
      if (description != null) existingEvent.description = description;
      if (location != null) existingEvent.location = location;
      
      if (startTime != null) {
        existingEvent.start = gcal.EventDateTime(dateTime: startTime.toUtc());
      }
      
      if (endTime != null) {
        existingEvent.end = gcal.EventDateTime(dateTime: endTime.toUtc());
      }
      
      if (attendees != null) {
        existingEvent.attendees = attendees
            .map((email) => gcal.EventAttendee()..email = email)
            .toList();
      }
      
      if (recurrenceRule != null) {
        existingEvent.recurrence = 
            recurrenceRule.isNotEmpty ? [recurrenceRule] : null;
      }
      
      final updatedEvent = await api.events.update(
        existingEvent,
        calendarId,
        googleEventId,
        sendNotifications: sendNotifications,
      );
      
      final mappedEvent = _mapEvent(
        userProfileId: userProfileId,
        calendarId: calendarId,
        event: updatedEvent,
      );
      
      await _cacheEvents([mappedEvent]);
      
      session.log(
        'Updated event $googleEventId in calendar $calendarId',
        level: LogLevel.info,
      );
      
      return mappedEvent;
    } catch (error, stackTrace) {
      session.log(
        'Failed to update calendar event: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Deletes a calendar event
  /// Used by AI to remove events based on user requests
  Future<void> deleteEvent({
    required int userProfileId,
    required String calendarId,
    required String googleEventId,
    bool sendNotifications = true,
  }) async {
    try {
      final api = await _getCalendarApi(userProfileId);
      
      await api.events.delete(
        calendarId,
        googleEventId,
        sendNotifications: sendNotifications,
      );
      
      await CalendarEvent.db.deleteWhere(
        session,
        where: (t) =>
            t.userProfileId.equals(userProfileId) &
            t.googleEventId.equals(googleEventId),
      );
      
      session.log(
        'Deleted event $googleEventId from calendar $calendarId',
        level: LogLevel.info,
      );
    } catch (error, stackTrace) {
      session.log(
        'Failed to delete calendar event: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Finds available time slots in the calendar
  /// Used by AI to suggest meeting times
  Future<List<Map<String, dynamic>>> findAvailableTimeSlots({
    required int userProfileId,
    required String calendarId,
    required int durationMinutes,
    required DateTime searchStartTime,
    required DateTime searchEndTime,
    int? workingHoursStart,
    int? workingHoursEnd,
    List<int>? preferredDays,
    int maxResults = 10,
  }) async {
    try {
      final events = await getCalendarEvents(
        userProfileId: userProfileId,
        calendarId: calendarId,
        startTime: searchStartTime,
        endTime: searchEndTime,
      );
      
      events.sort((a, b) => a.startTime.compareTo(b.startTime));
      
      final availableSlots = <Map<String, dynamic>>[];
      final duration = Duration(minutes: durationMinutes);
      
      final workStart = workingHoursStart ?? 9;
      final workEnd = workingHoursEnd ?? 17;
      var currentDay = DateTime(
        searchStartTime.year,
        searchStartTime.month,
        searchStartTime.day,
        workStart,
      );
      
      while (currentDay.isBefore(searchEndTime) && 
             availableSlots.length < maxResults) {
        final dayOfWeek = currentDay.weekday;
        if (preferredDays != null && 
            preferredDays.isNotEmpty && 
            !preferredDays.contains(dayOfWeek)) {
          currentDay = currentDay.add(const Duration(days: 1));
          currentDay = DateTime(
            currentDay.year,
            currentDay.month,
            currentDay.day,
            workStart,
          );
          continue;
        }
        
        final dayStart = DateTime(
          currentDay.year,
          currentDay.month,
          currentDay.day,
          workStart,
        );
        final dayEnd = DateTime(
          currentDay.year,
          currentDay.month,
          currentDay.day,
          workEnd,
        );
        
        final dayEvents = events
            .where((e) =>
                e.startTime.year == currentDay.year &&
                e.startTime.month == currentDay.month &&
                e.startTime.day == currentDay.day)
            .toList();
        
        var slotStart = dayStart;
        
        for (final event in dayEvents) {
          final eventStart = event.startTime;
          final eventEnd = event.endTime;
          
          if (slotStart.add(duration).isBefore(eventStart) ||
              slotStart.add(duration).isAtSameMomentAs(eventStart)) {
            final slotEnd = slotStart.add(duration);
            
            if (slotEnd.isBefore(eventStart) || 
                slotEnd.isAtSameMomentAs(eventStart)) {
              availableSlots.add({
                'start_time': slotStart,
                'end_time': slotEnd,
                'duration_minutes': durationMinutes,
                'day_of_week': dayOfWeek,
              });
              
              if (availableSlots.length >= maxResults) break;
            }
          }
          
          slotStart = eventEnd.isAfter(slotStart) ? eventEnd : slotStart;
        }
        
        if (availableSlots.length < maxResults &&
            slotStart.add(duration).isBefore(dayEnd)) {
          availableSlots.add({
            'start_time': slotStart,
            'end_time': slotStart.add(duration),
            'duration_minutes': durationMinutes,
            'day_of_week': dayOfWeek,
          });
        }
        
        currentDay = currentDay.add(const Duration(days: 1));
        currentDay = DateTime(
          currentDay.year,
          currentDay.month,
          currentDay.day,
          workStart,
        );
      }
      
      session.log(
        'Found ${availableSlots.length} available time slots',
        level: LogLevel.info,
      );
      
      return availableSlots;
    } catch (error, stackTrace) {
      session.log(
        'Failed to find available time slots: $error',
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
