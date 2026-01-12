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

abstract class Calendar implements _i1.SerializableModel {
  Calendar._({
    this.id,
    required this.userProfileId,
    required this.googleCalendarId,
    required this.name,
    this.description,
    this.backgroundColor,
    required this.isPrimary,
    this.createdAt,
    this.updatedAt,
  });

  factory Calendar({
    int? id,
    required int userProfileId,
    required String googleCalendarId,
    required String name,
    String? description,
    String? backgroundColor,
    required bool isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CalendarImpl;

  factory Calendar.fromJson(Map<String, dynamic> jsonSerialization) {
    return Calendar(
      id: jsonSerialization['id'] as int?,
      userProfileId: jsonSerialization['userProfileId'] as int,
      googleCalendarId: jsonSerialization['googleCalendarId'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      backgroundColor: jsonSerialization['backgroundColor'] as String?,
      isPrimary: jsonSerialization['isPrimary'] as bool,
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

  String googleCalendarId;

  String name;

  String? description;

  String? backgroundColor;

  bool isPrimary;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [Calendar]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Calendar copyWith({
    int? id,
    int? userProfileId,
    String? googleCalendarId,
    String? name,
    String? description,
    String? backgroundColor,
    bool? isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Calendar',
      if (id != null) 'id': id,
      'userProfileId': userProfileId,
      'googleCalendarId': googleCalendarId,
      'name': name,
      if (description != null) 'description': description,
      if (backgroundColor != null) 'backgroundColor': backgroundColor,
      'isPrimary': isPrimary,
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

class _CalendarImpl extends Calendar {
  _CalendarImpl({
    int? id,
    required int userProfileId,
    required String googleCalendarId,
    required String name,
    String? description,
    String? backgroundColor,
    required bool isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userProfileId: userProfileId,
         googleCalendarId: googleCalendarId,
         name: name,
         description: description,
         backgroundColor: backgroundColor,
         isPrimary: isPrimary,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Calendar]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Calendar copyWith({
    Object? id = _Undefined,
    int? userProfileId,
    String? googleCalendarId,
    String? name,
    Object? description = _Undefined,
    Object? backgroundColor = _Undefined,
    bool? isPrimary,
    Object? createdAt = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return Calendar(
      id: id is int? ? id : this.id,
      userProfileId: userProfileId ?? this.userProfileId,
      googleCalendarId: googleCalendarId ?? this.googleCalendarId,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      backgroundColor: backgroundColor is String?
          ? backgroundColor
          : this.backgroundColor,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
