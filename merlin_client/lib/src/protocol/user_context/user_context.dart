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

abstract class UserContext implements _i1.SerializableModel {
  UserContext._({
    this.id,
    required this.userProfileId,
    required this.title,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory UserContext({
    int? id,
    required int userProfileId,
    required String title,
    required String content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserContextImpl;

  factory UserContext.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserContext(
      id: jsonSerialization['id'] as int?,
      userProfileId: jsonSerialization['userProfileId'] as int,
      title: jsonSerialization['title'] as String,
      content: jsonSerialization['content'] as String,
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

  String title;

  String content;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [UserContext]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserContext copyWith({
    int? id,
    int? userProfileId,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserContext',
      if (id != null) 'id': id,
      'userProfileId': userProfileId,
      'title': title,
      'content': content,
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

class _UserContextImpl extends UserContext {
  _UserContextImpl({
    int? id,
    required int userProfileId,
    required String title,
    required String content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userProfileId: userProfileId,
         title: title,
         content: content,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserContext]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserContext copyWith({
    Object? id = _Undefined,
    int? userProfileId,
    String? title,
    String? content,
    Object? createdAt = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return UserContext(
      id: id is int? ? id : this.id,
      userProfileId: userProfileId ?? this.userProfileId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
