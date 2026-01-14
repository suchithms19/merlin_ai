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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'calendar/calendar.dart' as _i2;
import 'calendar/calendar_event.dart' as _i3;
import 'calendar/create_event_request.dart' as _i4;
import 'calendar/find_slots_request.dart' as _i5;
import 'calendar/time_slot.dart' as _i6;
import 'calendar/update_event_request.dart' as _i7;
import 'google_oauth/google_oauth_token.dart' as _i8;
import 'greetings/greeting.dart' as _i9;
import 'user_profile/user_profile.dart' as _i10;
import 'package:merlin_client/src/protocol/calendar/calendar.dart' as _i11;
import 'package:merlin_client/src/protocol/calendar/calendar_event.dart'
    as _i12;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i13;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i14;
export 'calendar/calendar.dart';
export 'calendar/calendar_event.dart';
export 'calendar/create_event_request.dart';
export 'calendar/find_slots_request.dart';
export 'calendar/time_slot.dart';
export 'calendar/update_event_request.dart';
export 'google_oauth/google_oauth_token.dart';
export 'greetings/greeting.dart';
export 'user_profile/user_profile.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.Calendar) {
      return _i2.Calendar.fromJson(data) as T;
    }
    if (t == _i3.CalendarEvent) {
      return _i3.CalendarEvent.fromJson(data) as T;
    }
    if (t == _i4.CreateEventRequest) {
      return _i4.CreateEventRequest.fromJson(data) as T;
    }
    if (t == _i5.FindSlotsRequest) {
      return _i5.FindSlotsRequest.fromJson(data) as T;
    }
    if (t == _i6.TimeSlot) {
      return _i6.TimeSlot.fromJson(data) as T;
    }
    if (t == _i7.UpdateEventRequest) {
      return _i7.UpdateEventRequest.fromJson(data) as T;
    }
    if (t == _i8.GoogleOAuthToken) {
      return _i8.GoogleOAuthToken.fromJson(data) as T;
    }
    if (t == _i9.Greeting) {
      return _i9.Greeting.fromJson(data) as T;
    }
    if (t == _i10.UserProfile) {
      return _i10.UserProfile.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Calendar?>()) {
      return (data != null ? _i2.Calendar.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.CalendarEvent?>()) {
      return (data != null ? _i3.CalendarEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.CreateEventRequest?>()) {
      return (data != null ? _i4.CreateEventRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.FindSlotsRequest?>()) {
      return (data != null ? _i5.FindSlotsRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.TimeSlot?>()) {
      return (data != null ? _i6.TimeSlot.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.UpdateEventRequest?>()) {
      return (data != null ? _i7.UpdateEventRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.GoogleOAuthToken?>()) {
      return (data != null ? _i8.GoogleOAuthToken.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Greeting?>()) {
      return (data != null ? _i9.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.UserProfile?>()) {
      return (data != null ? _i10.UserProfile.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i11.Calendar>) {
      return (data as List).map((e) => deserialize<_i11.Calendar>(e)).toList()
          as T;
    }
    if (t == List<_i12.CalendarEvent>) {
      return (data as List)
              .map((e) => deserialize<_i12.CalendarEvent>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<Map<String, dynamic>>) {
      return (data as List)
              .map((e) => deserialize<Map<String, dynamic>>(e))
              .toList()
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    try {
      return _i13.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i14.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Calendar => 'Calendar',
      _i3.CalendarEvent => 'CalendarEvent',
      _i4.CreateEventRequest => 'CreateEventRequest',
      _i5.FindSlotsRequest => 'FindSlotsRequest',
      _i6.TimeSlot => 'TimeSlot',
      _i7.UpdateEventRequest => 'UpdateEventRequest',
      _i8.GoogleOAuthToken => 'GoogleOAuthToken',
      _i9.Greeting => 'Greeting',
      _i10.UserProfile => 'UserProfile',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('merlin.', '');
    }

    switch (data) {
      case _i2.Calendar():
        return 'Calendar';
      case _i3.CalendarEvent():
        return 'CalendarEvent';
      case _i4.CreateEventRequest():
        return 'CreateEventRequest';
      case _i5.FindSlotsRequest():
        return 'FindSlotsRequest';
      case _i6.TimeSlot():
        return 'TimeSlot';
      case _i7.UpdateEventRequest():
        return 'UpdateEventRequest';
      case _i8.GoogleOAuthToken():
        return 'GoogleOAuthToken';
      case _i9.Greeting():
        return 'Greeting';
      case _i10.UserProfile():
        return 'UserProfile';
    }
    className = _i13.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i14.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Calendar') {
      return deserialize<_i2.Calendar>(data['data']);
    }
    if (dataClassName == 'CalendarEvent') {
      return deserialize<_i3.CalendarEvent>(data['data']);
    }
    if (dataClassName == 'CreateEventRequest') {
      return deserialize<_i4.CreateEventRequest>(data['data']);
    }
    if (dataClassName == 'FindSlotsRequest') {
      return deserialize<_i5.FindSlotsRequest>(data['data']);
    }
    if (dataClassName == 'TimeSlot') {
      return deserialize<_i6.TimeSlot>(data['data']);
    }
    if (dataClassName == 'UpdateEventRequest') {
      return deserialize<_i7.UpdateEventRequest>(data['data']);
    }
    if (dataClassName == 'GoogleOAuthToken') {
      return deserialize<_i8.GoogleOAuthToken>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i9.Greeting>(data['data']);
    }
    if (dataClassName == 'UserProfile') {
      return deserialize<_i10.UserProfile>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i13.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i14.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
