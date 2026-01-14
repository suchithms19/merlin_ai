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

abstract class CreateEventRequest implements _i1.SerializableModel {
  CreateEventRequest._({
    required this.calendarId,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    this.attendees,
    this.recurrenceRule,
    bool? sendNotifications,
  }) : sendNotifications = sendNotifications ?? true;

  factory CreateEventRequest({
    required String calendarId,
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    String? location,
    List<String>? attendees,
    String? recurrenceRule,
    bool? sendNotifications,
  }) = _CreateEventRequestImpl;

  factory CreateEventRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return CreateEventRequest(
      calendarId: jsonSerialization['calendarId'] as String,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      startTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startTime'],
      ),
      endTime: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endTime']),
      location: jsonSerialization['location'] as String?,
      attendees: jsonSerialization['attendees'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['attendees'],
            ),
      recurrenceRule: jsonSerialization['recurrenceRule'] as String?,
      sendNotifications: jsonSerialization['sendNotifications'] as bool,
    );
  }

  String calendarId;

  String title;

  String? description;

  DateTime startTime;

  DateTime endTime;

  String? location;

  List<String>? attendees;

  String? recurrenceRule;

  bool sendNotifications;

  /// Returns a shallow copy of this [CreateEventRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CreateEventRequest copyWith({
    String? calendarId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    List<String>? attendees,
    String? recurrenceRule,
    bool? sendNotifications,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CreateEventRequest',
      'calendarId': calendarId,
      'title': title,
      if (description != null) 'description': description,
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      if (location != null) 'location': location,
      if (attendees != null) 'attendees': attendees?.toJson(),
      if (recurrenceRule != null) 'recurrenceRule': recurrenceRule,
      'sendNotifications': sendNotifications,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CreateEventRequestImpl extends CreateEventRequest {
  _CreateEventRequestImpl({
    required String calendarId,
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    String? location,
    List<String>? attendees,
    String? recurrenceRule,
    bool? sendNotifications,
  }) : super._(
         calendarId: calendarId,
         title: title,
         description: description,
         startTime: startTime,
         endTime: endTime,
         location: location,
         attendees: attendees,
         recurrenceRule: recurrenceRule,
         sendNotifications: sendNotifications,
       );

  /// Returns a shallow copy of this [CreateEventRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CreateEventRequest copyWith({
    String? calendarId,
    String? title,
    Object? description = _Undefined,
    DateTime? startTime,
    DateTime? endTime,
    Object? location = _Undefined,
    Object? attendees = _Undefined,
    Object? recurrenceRule = _Undefined,
    bool? sendNotifications,
  }) {
    return CreateEventRequest(
      calendarId: calendarId ?? this.calendarId,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location is String? ? location : this.location,
      attendees: attendees is List<String>?
          ? attendees
          : this.attendees?.map((e0) => e0).toList(),
      recurrenceRule: recurrenceRule is String?
          ? recurrenceRule
          : this.recurrenceRule,
      sendNotifications: sendNotifications ?? this.sendNotifications,
    );
  }
}
