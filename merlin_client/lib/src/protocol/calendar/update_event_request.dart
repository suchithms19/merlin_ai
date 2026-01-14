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

abstract class UpdateEventRequest implements _i1.SerializableModel {
  UpdateEventRequest._({
    required this.calendarId,
    required this.googleEventId,
    this.title,
    this.description,
    this.startTime,
    this.endTime,
    this.location,
    this.attendees,
    this.recurrenceRule,
    bool? sendNotifications,
  }) : sendNotifications = sendNotifications ?? true;

  factory UpdateEventRequest({
    required String calendarId,
    required String googleEventId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    List<String>? attendees,
    String? recurrenceRule,
    bool? sendNotifications,
  }) = _UpdateEventRequestImpl;

  factory UpdateEventRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return UpdateEventRequest(
      calendarId: jsonSerialization['calendarId'] as String,
      googleEventId: jsonSerialization['googleEventId'] as String,
      title: jsonSerialization['title'] as String?,
      description: jsonSerialization['description'] as String?,
      startTime: jsonSerialization['startTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startTime']),
      endTime: jsonSerialization['endTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endTime']),
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

  String googleEventId;

  String? title;

  String? description;

  DateTime? startTime;

  DateTime? endTime;

  String? location;

  List<String>? attendees;

  String? recurrenceRule;

  bool sendNotifications;

  /// Returns a shallow copy of this [UpdateEventRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UpdateEventRequest copyWith({
    String? calendarId,
    String? googleEventId,
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
      '__className__': 'UpdateEventRequest',
      'calendarId': calendarId,
      'googleEventId': googleEventId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (startTime != null) 'startTime': startTime?.toJson(),
      if (endTime != null) 'endTime': endTime?.toJson(),
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

class _UpdateEventRequestImpl extends UpdateEventRequest {
  _UpdateEventRequestImpl({
    required String calendarId,
    required String googleEventId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    List<String>? attendees,
    String? recurrenceRule,
    bool? sendNotifications,
  }) : super._(
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

  /// Returns a shallow copy of this [UpdateEventRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UpdateEventRequest copyWith({
    String? calendarId,
    String? googleEventId,
    Object? title = _Undefined,
    Object? description = _Undefined,
    Object? startTime = _Undefined,
    Object? endTime = _Undefined,
    Object? location = _Undefined,
    Object? attendees = _Undefined,
    Object? recurrenceRule = _Undefined,
    bool? sendNotifications,
  }) {
    return UpdateEventRequest(
      calendarId: calendarId ?? this.calendarId,
      googleEventId: googleEventId ?? this.googleEventId,
      title: title is String? ? title : this.title,
      description: description is String? ? description : this.description,
      startTime: startTime is DateTime? ? startTime : this.startTime,
      endTime: endTime is DateTime? ? endTime : this.endTime,
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
