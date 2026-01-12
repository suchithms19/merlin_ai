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

abstract class CalendarEvent implements _i1.SerializableModel {
  CalendarEvent._({
    this.id,
    required this.userProfileId,
    required this.calendarId,
    required this.googleEventId,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    required this.attendees,
    this.organizerEmail,
    this.recurrenceRule,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory CalendarEvent({
    int? id,
    required int userProfileId,
    required String calendarId,
    required String googleEventId,
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    String? location,
    required List<String> attendees,
    String? organizerEmail,
    String? recurrenceRule,
    required String status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CalendarEventImpl;

  factory CalendarEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return CalendarEvent(
      id: jsonSerialization['id'] as int?,
      userProfileId: jsonSerialization['userProfileId'] as int,
      calendarId: jsonSerialization['calendarId'] as String,
      googleEventId: jsonSerialization['googleEventId'] as String,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      startTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startTime'],
      ),
      endTime: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endTime']),
      location: jsonSerialization['location'] as String?,
      attendees: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['attendees'],
      ),
      organizerEmail: jsonSerialization['organizerEmail'] as String?,
      recurrenceRule: jsonSerialization['recurrenceRule'] as String?,
      status: jsonSerialization['status'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userProfileId;

  String calendarId;

  String googleEventId;

  String title;

  String? description;

  DateTime startTime;

  DateTime endTime;

  String? location;

  List<String> attendees;

  String? organizerEmail;

  String? recurrenceRule;

  String status;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [CalendarEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CalendarEvent copyWith({
    int? id,
    int? userProfileId,
    String? calendarId,
    String? googleEventId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    List<String>? attendees,
    String? organizerEmail,
    String? recurrenceRule,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarEvent',
      if (id != null) 'id': id,
      'userProfileId': userProfileId,
      'calendarId': calendarId,
      'googleEventId': googleEventId,
      'title': title,
      if (description != null) 'description': description,
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      if (location != null) 'location': location,
      'attendees': attendees.toJson(),
      if (organizerEmail != null) 'organizerEmail': organizerEmail,
      if (recurrenceRule != null) 'recurrenceRule': recurrenceRule,
      'status': status,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CalendarEventImpl extends CalendarEvent {
  _CalendarEventImpl({
    int? id,
    required int userProfileId,
    required String calendarId,
    required String googleEventId,
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    String? location,
    required List<String> attendees,
    String? organizerEmail,
    String? recurrenceRule,
    required String status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userProfileId: userProfileId,
         calendarId: calendarId,
         googleEventId: googleEventId,
         title: title,
         description: description,
         startTime: startTime,
         endTime: endTime,
         location: location,
         attendees: attendees,
         organizerEmail: organizerEmail,
         recurrenceRule: recurrenceRule,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CalendarEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CalendarEvent copyWith({
    Object? id = _Undefined,
    int? userProfileId,
    String? calendarId,
    String? googleEventId,
    String? title,
    Object? description = _Undefined,
    DateTime? startTime,
    DateTime? endTime,
    Object? location = _Undefined,
    List<String>? attendees,
    Object? organizerEmail = _Undefined,
    Object? recurrenceRule = _Undefined,
    String? status,
    Object? createdAt = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return CalendarEvent(
      id: id is int? ? id : this.id,
      userProfileId: userProfileId ?? this.userProfileId,
      calendarId: calendarId ?? this.calendarId,
      googleEventId: googleEventId ?? this.googleEventId,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location is String? ? location : this.location,
      attendees: attendees ?? this.attendees.map((e0) => e0).toList(),
      organizerEmail: organizerEmail is String?
          ? organizerEmail
          : this.organizerEmail,
      recurrenceRule: recurrenceRule is String?
          ? recurrenceRule
          : this.recurrenceRule,
      status: status ?? this.status,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
