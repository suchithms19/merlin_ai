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
import 'package:merlin_client/src/protocol/protocol.dart' as _i2;

abstract class ChatResponse implements _i1.SerializableModel {
  ChatResponse._({
    required this.message,
    this.functionsCalled,
    this.calendarEventsAffected,
    this.emailsAffected,
    this.error,
  });

  factory ChatResponse({
    required String message,
    List<String>? functionsCalled,
    List<String>? calendarEventsAffected,
    List<String>? emailsAffected,
    String? error,
  }) = _ChatResponseImpl;

  factory ChatResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatResponse(
      message: jsonSerialization['message'] as String,
      functionsCalled: jsonSerialization['functionsCalled'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['functionsCalled'],
            ),
      calendarEventsAffected:
          jsonSerialization['calendarEventsAffected'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['calendarEventsAffected'],
            ),
      emailsAffected: jsonSerialization['emailsAffected'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['emailsAffected'],
            ),
      error: jsonSerialization['error'] as String?,
    );
  }

  String message;

  List<String>? functionsCalled;

  List<String>? calendarEventsAffected;

  List<String>? emailsAffected;

  String? error;

  /// Returns a shallow copy of this [ChatResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatResponse copyWith({
    String? message,
    List<String>? functionsCalled,
    List<String>? calendarEventsAffected,
    List<String>? emailsAffected,
    String? error,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChatResponse',
      'message': message,
      if (functionsCalled != null) 'functionsCalled': functionsCalled?.toJson(),
      if (calendarEventsAffected != null)
        'calendarEventsAffected': calendarEventsAffected?.toJson(),
      if (emailsAffected != null) 'emailsAffected': emailsAffected?.toJson(),
      if (error != null) 'error': error,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChatResponseImpl extends ChatResponse {
  _ChatResponseImpl({
    required String message,
    List<String>? functionsCalled,
    List<String>? calendarEventsAffected,
    List<String>? emailsAffected,
    String? error,
  }) : super._(
         message: message,
         functionsCalled: functionsCalled,
         calendarEventsAffected: calendarEventsAffected,
         emailsAffected: emailsAffected,
         error: error,
       );

  /// Returns a shallow copy of this [ChatResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatResponse copyWith({
    String? message,
    Object? functionsCalled = _Undefined,
    Object? calendarEventsAffected = _Undefined,
    Object? emailsAffected = _Undefined,
    Object? error = _Undefined,
  }) {
    return ChatResponse(
      message: message ?? this.message,
      functionsCalled: functionsCalled is List<String>?
          ? functionsCalled
          : this.functionsCalled?.map((e0) => e0).toList(),
      calendarEventsAffected: calendarEventsAffected is List<String>?
          ? calendarEventsAffected
          : this.calendarEventsAffected?.map((e0) => e0).toList(),
      emailsAffected: emailsAffected is List<String>?
          ? emailsAffected
          : this.emailsAffected?.map((e0) => e0).toList(),
      error: error is String? ? error : this.error,
    );
  }
}
