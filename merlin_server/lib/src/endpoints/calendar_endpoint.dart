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

  Future<CalendarEvent> createCalendarEvent(
    Session session,
    String calendarId,
    String title,
    DateTime startTime,
    DateTime endTime, {
    String? description,
    String? location,
    List<String>? attendees,
    String? recurrenceRule,
    bool sendNotifications = true,
  }) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleCalendarService(session);
    return service.createEvent(
      userProfileId: userProfileId,
      calendarId: calendarId,
      title: title,
      startTime: startTime,
      endTime: endTime,
      description: description,
      location: location,
      attendees: attendees,
      recurrenceRule: recurrenceRule,
      sendNotifications: sendNotifications,
    );
  }

  Future<CalendarEvent> updateCalendarEvent(
    Session session,
    String calendarId,
    String googleEventId, {
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    List<String>? attendees,
    String? recurrenceRule,
    bool sendNotifications = true,
  }) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleCalendarService(session);
    return service.updateEvent(
      userProfileId: userProfileId,
      calendarId: calendarId,
      googleEventId: googleEventId,
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      location: location,
      attendees: attendees,
      recurrenceRule: recurrenceRule,
      sendNotifications: sendNotifications,
    );
  }

  Future<void> deleteCalendarEvent(
    Session session,
    String calendarId,
    String googleEventId, {
    bool sendNotifications = true,
  }) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleCalendarService(session);
    await service.deleteEvent(
      userProfileId: userProfileId,
      calendarId: calendarId,
      googleEventId: googleEventId,
      sendNotifications: sendNotifications,
    );
  }

  Future<List<Map<String, dynamic>>> findAvailableTimeSlots(
    Session session,
    String calendarId,
    int durationMinutes,
    DateTime searchStartTime,
    DateTime searchEndTime, {
    int? workingHoursStart,
    int? workingHoursEnd,
    List<int>? preferredDays,
    int maxResults = 10,
  }) async {
    final userProfileId = await _requireUserProfileId(session);
    final service = GoogleCalendarService(session);
    return service.findAvailableTimeSlots(
      userProfileId: userProfileId,
      calendarId: calendarId,
      durationMinutes: durationMinutes,
      searchStartTime: searchStartTime,
      searchEndTime: searchEndTime,
      workingHoursStart: workingHoursStart,
      workingHoursEnd: workingHoursEnd,
      preferredDays: preferredDays,
      maxResults: maxResults,
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
