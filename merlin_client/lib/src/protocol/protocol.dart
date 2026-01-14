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
import 'chat/chat_message.dart' as _i8;
import 'chat/chat_request.dart' as _i9;
import 'chat/chat_response.dart' as _i10;
import 'email/email.dart' as _i11;
import 'email/email_attachment.dart' as _i12;
import 'email/email_list_response.dart' as _i13;
import 'email/email_search_request.dart' as _i14;
import 'email/forward_email_request.dart' as _i15;
import 'email/reply_email_request.dart' as _i16;
import 'email/send_email_request.dart' as _i17;
import 'google_oauth/google_oauth_token.dart' as _i18;
import 'greetings/greeting.dart' as _i19;
import 'user_profile/user_profile.dart' as _i20;
import 'package:merlin_client/src/protocol/chat/chat_message.dart' as _i21;
import 'package:merlin_client/src/protocol/calendar/calendar.dart' as _i22;
import 'package:merlin_client/src/protocol/calendar/calendar_event.dart'
    as _i23;
import 'package:merlin_client/src/protocol/email/email.dart' as _i24;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i25;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i26;
export 'calendar/calendar.dart';
export 'calendar/calendar_event.dart';
export 'calendar/create_event_request.dart';
export 'calendar/find_slots_request.dart';
export 'calendar/time_slot.dart';
export 'calendar/update_event_request.dart';
export 'chat/chat_message.dart';
export 'chat/chat_request.dart';
export 'chat/chat_response.dart';
export 'email/email.dart';
export 'email/email_attachment.dart';
export 'email/email_list_response.dart';
export 'email/email_search_request.dart';
export 'email/forward_email_request.dart';
export 'email/reply_email_request.dart';
export 'email/send_email_request.dart';
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
    if (t == _i8.ChatMessage) {
      return _i8.ChatMessage.fromJson(data) as T;
    }
    if (t == _i9.ChatRequest) {
      return _i9.ChatRequest.fromJson(data) as T;
    }
    if (t == _i10.ChatResponse) {
      return _i10.ChatResponse.fromJson(data) as T;
    }
    if (t == _i11.Email) {
      return _i11.Email.fromJson(data) as T;
    }
    if (t == _i12.EmailAttachment) {
      return _i12.EmailAttachment.fromJson(data) as T;
    }
    if (t == _i13.EmailListResponse) {
      return _i13.EmailListResponse.fromJson(data) as T;
    }
    if (t == _i14.EmailSearchRequest) {
      return _i14.EmailSearchRequest.fromJson(data) as T;
    }
    if (t == _i15.ForwardEmailRequest) {
      return _i15.ForwardEmailRequest.fromJson(data) as T;
    }
    if (t == _i16.ReplyEmailRequest) {
      return _i16.ReplyEmailRequest.fromJson(data) as T;
    }
    if (t == _i17.SendEmailRequest) {
      return _i17.SendEmailRequest.fromJson(data) as T;
    }
    if (t == _i18.GoogleOAuthToken) {
      return _i18.GoogleOAuthToken.fromJson(data) as T;
    }
    if (t == _i19.Greeting) {
      return _i19.Greeting.fromJson(data) as T;
    }
    if (t == _i20.UserProfile) {
      return _i20.UserProfile.fromJson(data) as T;
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
    if (t == _i1.getType<_i8.ChatMessage?>()) {
      return (data != null ? _i8.ChatMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.ChatRequest?>()) {
      return (data != null ? _i9.ChatRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.ChatResponse?>()) {
      return (data != null ? _i10.ChatResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.Email?>()) {
      return (data != null ? _i11.Email.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.EmailAttachment?>()) {
      return (data != null ? _i12.EmailAttachment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.EmailListResponse?>()) {
      return (data != null ? _i13.EmailListResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.EmailSearchRequest?>()) {
      return (data != null ? _i14.EmailSearchRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.ForwardEmailRequest?>()) {
      return (data != null ? _i15.ForwardEmailRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i16.ReplyEmailRequest?>()) {
      return (data != null ? _i16.ReplyEmailRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.SendEmailRequest?>()) {
      return (data != null ? _i17.SendEmailRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.GoogleOAuthToken?>()) {
      return (data != null ? _i18.GoogleOAuthToken.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.Greeting?>()) {
      return (data != null ? _i19.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.UserProfile?>()) {
      return (data != null ? _i20.UserProfile.fromJson(data) : null) as T;
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
    if (t == List<_i8.ChatMessage>) {
      return (data as List).map((e) => deserialize<_i8.ChatMessage>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i8.ChatMessage>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i8.ChatMessage>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i11.Email>) {
      return (data as List).map((e) => deserialize<_i11.Email>(e)).toList()
          as T;
    }
    if (t == List<_i21.ChatMessage>) {
      return (data as List)
              .map((e) => deserialize<_i21.ChatMessage>(e))
              .toList()
          as T;
    }
    if (t == List<_i22.Calendar>) {
      return (data as List).map((e) => deserialize<_i22.Calendar>(e)).toList()
          as T;
    }
    if (t == List<_i23.CalendarEvent>) {
      return (data as List)
              .map((e) => deserialize<_i23.CalendarEvent>(e))
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
    if (t == List<_i24.Email>) {
      return (data as List).map((e) => deserialize<_i24.Email>(e)).toList()
          as T;
    }
    try {
      return _i25.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i26.Protocol().deserialize<T>(data, t);
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
      _i8.ChatMessage => 'ChatMessage',
      _i9.ChatRequest => 'ChatRequest',
      _i10.ChatResponse => 'ChatResponse',
      _i11.Email => 'Email',
      _i12.EmailAttachment => 'EmailAttachment',
      _i13.EmailListResponse => 'EmailListResponse',
      _i14.EmailSearchRequest => 'EmailSearchRequest',
      _i15.ForwardEmailRequest => 'ForwardEmailRequest',
      _i16.ReplyEmailRequest => 'ReplyEmailRequest',
      _i17.SendEmailRequest => 'SendEmailRequest',
      _i18.GoogleOAuthToken => 'GoogleOAuthToken',
      _i19.Greeting => 'Greeting',
      _i20.UserProfile => 'UserProfile',
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
      case _i8.ChatMessage():
        return 'ChatMessage';
      case _i9.ChatRequest():
        return 'ChatRequest';
      case _i10.ChatResponse():
        return 'ChatResponse';
      case _i11.Email():
        return 'Email';
      case _i12.EmailAttachment():
        return 'EmailAttachment';
      case _i13.EmailListResponse():
        return 'EmailListResponse';
      case _i14.EmailSearchRequest():
        return 'EmailSearchRequest';
      case _i15.ForwardEmailRequest():
        return 'ForwardEmailRequest';
      case _i16.ReplyEmailRequest():
        return 'ReplyEmailRequest';
      case _i17.SendEmailRequest():
        return 'SendEmailRequest';
      case _i18.GoogleOAuthToken():
        return 'GoogleOAuthToken';
      case _i19.Greeting():
        return 'Greeting';
      case _i20.UserProfile():
        return 'UserProfile';
    }
    className = _i25.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i26.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'ChatMessage') {
      return deserialize<_i8.ChatMessage>(data['data']);
    }
    if (dataClassName == 'ChatRequest') {
      return deserialize<_i9.ChatRequest>(data['data']);
    }
    if (dataClassName == 'ChatResponse') {
      return deserialize<_i10.ChatResponse>(data['data']);
    }
    if (dataClassName == 'Email') {
      return deserialize<_i11.Email>(data['data']);
    }
    if (dataClassName == 'EmailAttachment') {
      return deserialize<_i12.EmailAttachment>(data['data']);
    }
    if (dataClassName == 'EmailListResponse') {
      return deserialize<_i13.EmailListResponse>(data['data']);
    }
    if (dataClassName == 'EmailSearchRequest') {
      return deserialize<_i14.EmailSearchRequest>(data['data']);
    }
    if (dataClassName == 'ForwardEmailRequest') {
      return deserialize<_i15.ForwardEmailRequest>(data['data']);
    }
    if (dataClassName == 'ReplyEmailRequest') {
      return deserialize<_i16.ReplyEmailRequest>(data['data']);
    }
    if (dataClassName == 'SendEmailRequest') {
      return deserialize<_i17.SendEmailRequest>(data['data']);
    }
    if (dataClassName == 'GoogleOAuthToken') {
      return deserialize<_i18.GoogleOAuthToken>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i19.Greeting>(data['data']);
    }
    if (dataClassName == 'UserProfile') {
      return deserialize<_i20.UserProfile>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i25.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i26.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
