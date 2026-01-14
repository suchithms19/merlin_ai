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

abstract class TimeSlot implements _i1.SerializableModel {
  TimeSlot._({
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.dayOfWeek,
  });

  factory TimeSlot({
    required DateTime startTime,
    required DateTime endTime,
    required int durationMinutes,
    required int dayOfWeek,
  }) = _TimeSlotImpl;

  factory TimeSlot.fromJson(Map<String, dynamic> jsonSerialization) {
    return TimeSlot(
      startTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startTime'],
      ),
      endTime: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endTime']),
      durationMinutes: jsonSerialization['durationMinutes'] as int,
      dayOfWeek: jsonSerialization['dayOfWeek'] as int,
    );
  }

  DateTime startTime;

  DateTime endTime;

  int durationMinutes;

  int dayOfWeek;

  /// Returns a shallow copy of this [TimeSlot]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TimeSlot copyWith({
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    int? dayOfWeek,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TimeSlot',
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      'durationMinutes': durationMinutes,
      'dayOfWeek': dayOfWeek,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _TimeSlotImpl extends TimeSlot {
  _TimeSlotImpl({
    required DateTime startTime,
    required DateTime endTime,
    required int durationMinutes,
    required int dayOfWeek,
  }) : super._(
         startTime: startTime,
         endTime: endTime,
         durationMinutes: durationMinutes,
         dayOfWeek: dayOfWeek,
       );

  /// Returns a shallow copy of this [TimeSlot]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TimeSlot copyWith({
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    int? dayOfWeek,
  }) {
    return TimeSlot(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    );
  }
}
