import 'package:serverpod/serverpod.dart';

import '../generated/calendar/calendar.dart';
import '../generated/calendar/calendar_event.dart';
import '../services/google_calendar_service.dart';
import '../services/user_profile_service.dart';

class CalendarEndpoint extends Endpoint {
  Future<List<Calendar>> getCalendars(Session session) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleCalendarService(session);
    return service.getCalendars(userProfileId);
  }

  Future<List<CalendarEvent>> getCalendarEvents(
    Session session,
    String calendarId,
    DateTime startTime,
    DateTime endTime,
  ) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleCalendarService(session);
    return service.getCalendarEvents(
      userProfileId: userProfileId,
      calendarId: calendarId,
      startTime: startTime,
      endTime: endTime,
    );
  }

  Future<CalendarEvent?> getCalendarEvent(
    Session session,
    String calendarId,
    String googleEventId,
  ) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleCalendarService(session);
    return service.getCalendarEvent(
      userProfileId: userProfileId,
      calendarId: calendarId,
      googleEventId: googleEventId,
    );
  }

  Future<void> syncCalendar(
    Session session, {
    String? calendarId,
    DateTime? timeMin,
    DateTime? timeMax,
  }) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleCalendarService(session);
    await service.syncCalendar(
      userProfileId: userProfileId,
      calendarId: calendarId,
      timeMin: timeMin,
      timeMax: timeMax,
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
