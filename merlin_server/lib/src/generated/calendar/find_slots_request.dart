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
import 'package:merlin_server/src/generated/protocol.dart' as _i2;

abstract class FindSlotsRequest
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  FindSlotsRequest._({
    required this.calendarId,
    required this.durationMinutes,
    required this.searchStartTime,
    required this.searchEndTime,
    this.workingHoursStart,
    this.workingHoursEnd,
    this.preferredDays,
    int? maxResults,
  }) : maxResults = maxResults ?? 10;

  factory FindSlotsRequest({
    required String calendarId,
    required int durationMinutes,
    required DateTime searchStartTime,
    required DateTime searchEndTime,
    int? workingHoursStart,
    int? workingHoursEnd,
    List<int>? preferredDays,
    int? maxResults,
  }) = _FindSlotsRequestImpl;

  factory FindSlotsRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return FindSlotsRequest(
      calendarId: jsonSerialization['calendarId'] as String,
      durationMinutes: jsonSerialization['durationMinutes'] as int,
      searchStartTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['searchStartTime'],
      ),
      searchEndTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['searchEndTime'],
      ),
      workingHoursStart: jsonSerialization['workingHoursStart'] as int?,
      workingHoursEnd: jsonSerialization['workingHoursEnd'] as int?,
      preferredDays: jsonSerialization['preferredDays'] == null
          ? null
          : _i2.Protocol().deserialize<List<int>>(
              jsonSerialization['preferredDays'],
            ),
      maxResults: jsonSerialization['maxResults'] as int,
    );
  }

  String calendarId;

  int durationMinutes;

  DateTime searchStartTime;

  DateTime searchEndTime;

  int? workingHoursStart;

  int? workingHoursEnd;

  List<int>? preferredDays;

  int maxResults;

  /// Returns a shallow copy of this [FindSlotsRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FindSlotsRequest copyWith({
    String? calendarId,
    int? durationMinutes,
    DateTime? searchStartTime,
    DateTime? searchEndTime,
    int? workingHoursStart,
    int? workingHoursEnd,
    List<int>? preferredDays,
    int? maxResults,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FindSlotsRequest',
      'calendarId': calendarId,
      'durationMinutes': durationMinutes,
      'searchStartTime': searchStartTime.toJson(),
      'searchEndTime': searchEndTime.toJson(),
      if (workingHoursStart != null) 'workingHoursStart': workingHoursStart,
      if (workingHoursEnd != null) 'workingHoursEnd': workingHoursEnd,
      if (preferredDays != null) 'preferredDays': preferredDays?.toJson(),
      'maxResults': maxResults,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FindSlotsRequest',
      'calendarId': calendarId,
      'durationMinutes': durationMinutes,
      'searchStartTime': searchStartTime.toJson(),
      'searchEndTime': searchEndTime.toJson(),
      if (workingHoursStart != null) 'workingHoursStart': workingHoursStart,
      if (workingHoursEnd != null) 'workingHoursEnd': workingHoursEnd,
      if (preferredDays != null) 'preferredDays': preferredDays?.toJson(),
      'maxResults': maxResults,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FindSlotsRequestImpl extends FindSlotsRequest {
  _FindSlotsRequestImpl({
    required String calendarId,
    required int durationMinutes,
    required DateTime searchStartTime,
    required DateTime searchEndTime,
    int? workingHoursStart,
    int? workingHoursEnd,
    List<int>? preferredDays,
    int? maxResults,
  }) : super._(
         calendarId: calendarId,
         durationMinutes: durationMinutes,
         searchStartTime: searchStartTime,
         searchEndTime: searchEndTime,
         workingHoursStart: workingHoursStart,
         workingHoursEnd: workingHoursEnd,
         preferredDays: preferredDays,
         maxResults: maxResults,
       );

  /// Returns a shallow copy of this [FindSlotsRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FindSlotsRequest copyWith({
    String? calendarId,
    int? durationMinutes,
    DateTime? searchStartTime,
    DateTime? searchEndTime,
    Object? workingHoursStart = _Undefined,
    Object? workingHoursEnd = _Undefined,
    Object? preferredDays = _Undefined,
    int? maxResults,
  }) {
    return FindSlotsRequest(
      calendarId: calendarId ?? this.calendarId,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      searchStartTime: searchStartTime ?? this.searchStartTime,
      searchEndTime: searchEndTime ?? this.searchEndTime,
      workingHoursStart: workingHoursStart is int?
          ? workingHoursStart
          : this.workingHoursStart,
      workingHoursEnd: workingHoursEnd is int?
          ? workingHoursEnd
          : this.workingHoursEnd,
      preferredDays: preferredDays is List<int>?
          ? preferredDays
          : this.preferredDays?.map((e0) => e0).toList(),
      maxResults: maxResults ?? this.maxResults,
    );
  }
}
