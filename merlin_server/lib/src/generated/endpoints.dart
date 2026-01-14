/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../auth/email_idp_endpoint.dart' as _i2;
import '../auth/jwt_refresh_endpoint.dart' as _i3;
import '../endpoints/calendar_endpoint.dart' as _i4;
import '../endpoints/google_oauth_endpoint.dart' as _i5;
import '../greetings/greeting_endpoint.dart' as _i6;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i7;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i8;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIdp': _i2.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i3.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'calendar': _i4.CalendarEndpoint()
        ..initialize(
          server,
          'calendar',
          null,
        ),
      'googleOAuth': _i5.GoogleOAuthEndpoint()
        ..initialize(
          server,
          'googleOAuth',
          null,
        ),
      'greeting': _i6.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i3.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['calendar'] = _i1.EndpointConnector(
      name: 'calendar',
      endpoint: endpoints['calendar']!,
      methodConnectors: {
        'getCalendars': _i1.MethodConnector(
          name: 'getCalendars',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['calendar'] as _i4.CalendarEndpoint)
                  .getCalendars(session),
        ),
        'getCalendarEvents': _i1.MethodConnector(
          name: 'getCalendarEvents',
          params: {
            'calendarId': _i1.ParameterDescription(
              name: 'calendarId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'startTime': _i1.ParameterDescription(
              name: 'startTime',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'endTime': _i1.ParameterDescription(
              name: 'endTime',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['calendar'] as _i4.CalendarEndpoint)
                  .getCalendarEvents(
                    session,
                    params['calendarId'],
                    params['startTime'],
                    params['endTime'],
                  ),
        ),
        'getCalendarEvent': _i1.MethodConnector(
          name: 'getCalendarEvent',
          params: {
            'calendarId': _i1.ParameterDescription(
              name: 'calendarId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'googleEventId': _i1.ParameterDescription(
              name: 'googleEventId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['calendar'] as _i4.CalendarEndpoint)
                  .getCalendarEvent(
                    session,
                    params['calendarId'],
                    params['googleEventId'],
                  ),
        ),
        'syncCalendar': _i1.MethodConnector(
          name: 'syncCalendar',
          params: {
            'calendarId': _i1.ParameterDescription(
              name: 'calendarId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'timeMin': _i1.ParameterDescription(
              name: 'timeMin',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'timeMax': _i1.ParameterDescription(
              name: 'timeMax',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['calendar'] as _i4.CalendarEndpoint).syncCalendar(
                    session,
                    calendarId: params['calendarId'],
                    timeMin: params['timeMin'],
                    timeMax: params['timeMax'],
                  ),
        ),
        'createCalendarEvent': _i1.MethodConnector(
          name: 'createCalendarEvent',
          params: {
            'calendarId': _i1.ParameterDescription(
              name: 'calendarId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'startTime': _i1.ParameterDescription(
              name: 'startTime',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'endTime': _i1.ParameterDescription(
              name: 'endTime',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'location': _i1.ParameterDescription(
              name: 'location',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'attendees': _i1.ParameterDescription(
              name: 'attendees',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
            'recurrenceRule': _i1.ParameterDescription(
              name: 'recurrenceRule',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'sendNotifications': _i1.ParameterDescription(
              name: 'sendNotifications',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['calendar'] as _i4.CalendarEndpoint)
                  .createCalendarEvent(
                    session,
                    params['calendarId'],
                    params['title'],
                    params['startTime'],
                    params['endTime'],
                    description: params['description'],
                    location: params['location'],
                    attendees: params['attendees'],
                    recurrenceRule: params['recurrenceRule'],
                    sendNotifications: params['sendNotifications'],
                  ),
        ),
        'updateCalendarEvent': _i1.MethodConnector(
          name: 'updateCalendarEvent',
          params: {
            'calendarId': _i1.ParameterDescription(
              name: 'calendarId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'googleEventId': _i1.ParameterDescription(
              name: 'googleEventId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'startTime': _i1.ParameterDescription(
              name: 'startTime',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'endTime': _i1.ParameterDescription(
              name: 'endTime',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'location': _i1.ParameterDescription(
              name: 'location',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'attendees': _i1.ParameterDescription(
              name: 'attendees',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
            'recurrenceRule': _i1.ParameterDescription(
              name: 'recurrenceRule',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'sendNotifications': _i1.ParameterDescription(
              name: 'sendNotifications',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['calendar'] as _i4.CalendarEndpoint)
                  .updateCalendarEvent(
                    session,
                    params['calendarId'],
                    params['googleEventId'],
                    title: params['title'],
                    description: params['description'],
                    startTime: params['startTime'],
                    endTime: params['endTime'],
                    location: params['location'],
                    attendees: params['attendees'],
                    recurrenceRule: params['recurrenceRule'],
                    sendNotifications: params['sendNotifications'],
                  ),
        ),
        'deleteCalendarEvent': _i1.MethodConnector(
          name: 'deleteCalendarEvent',
          params: {
            'calendarId': _i1.ParameterDescription(
              name: 'calendarId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'googleEventId': _i1.ParameterDescription(
              name: 'googleEventId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'sendNotifications': _i1.ParameterDescription(
              name: 'sendNotifications',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['calendar'] as _i4.CalendarEndpoint)
                  .deleteCalendarEvent(
                    session,
                    params['calendarId'],
                    params['googleEventId'],
                    sendNotifications: params['sendNotifications'],
                  ),
        ),
        'findAvailableTimeSlots': _i1.MethodConnector(
          name: 'findAvailableTimeSlots',
          params: {
            'calendarId': _i1.ParameterDescription(
              name: 'calendarId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'durationMinutes': _i1.ParameterDescription(
              name: 'durationMinutes',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'searchStartTime': _i1.ParameterDescription(
              name: 'searchStartTime',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'searchEndTime': _i1.ParameterDescription(
              name: 'searchEndTime',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'workingHoursStart': _i1.ParameterDescription(
              name: 'workingHoursStart',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'workingHoursEnd': _i1.ParameterDescription(
              name: 'workingHoursEnd',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'preferredDays': _i1.ParameterDescription(
              name: 'preferredDays',
              type: _i1.getType<List<int>?>(),
              nullable: true,
            ),
            'maxResults': _i1.ParameterDescription(
              name: 'maxResults',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['calendar'] as _i4.CalendarEndpoint)
                  .findAvailableTimeSlots(
                    session,
                    params['calendarId'],
                    params['durationMinutes'],
                    params['searchStartTime'],
                    params['searchEndTime'],
                    workingHoursStart: params['workingHoursStart'],
                    workingHoursEnd: params['workingHoursEnd'],
                    preferredDays: params['preferredDays'],
                    maxResults: params['maxResults'],
                  ),
        ),
      },
    );
    connectors['googleOAuth'] = _i1.EndpointConnector(
      name: 'googleOAuth',
      endpoint: endpoints['googleOAuth']!,
      methodConnectors: {
        'initiateGoogleOAuth': _i1.MethodConnector(
          name: 'initiateGoogleOAuth',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['googleOAuth'] as _i5.GoogleOAuthEndpoint)
                  .initiateGoogleOAuth(session),
        ),
        'handleGoogleOAuthCallback': _i1.MethodConnector(
          name: 'handleGoogleOAuthCallback',
          params: {
            'code': _i1.ParameterDescription(
              name: 'code',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['googleOAuth'] as _i5.GoogleOAuthEndpoint)
                  .handleGoogleOAuthCallback(
                    session,
                    params['code'],
                  ),
        ),
        'refreshGoogleTokens': _i1.MethodConnector(
          name: 'refreshGoogleTokens',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['googleOAuth'] as _i5.GoogleOAuthEndpoint)
                  .refreshGoogleTokens(session),
        ),
        'getGoogleConnectionStatus': _i1.MethodConnector(
          name: 'getGoogleConnectionStatus',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['googleOAuth'] as _i5.GoogleOAuthEndpoint)
                  .getGoogleConnectionStatus(session),
        ),
        'disconnectGoogle': _i1.MethodConnector(
          name: 'disconnectGoogle',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['googleOAuth'] as _i5.GoogleOAuthEndpoint)
                  .disconnectGoogle(session),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i6.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i7.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i8.Endpoints()
      ..initializeEndpoints(server);
  }
}
