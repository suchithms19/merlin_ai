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

abstract class ChatMessage implements _i1.SerializableModel {
  ChatMessage._({
    this.id,
    required this.userProfileId,
    required this.role,
    required this.content,
    this.functionName,
    this.functionArgs,
    this.functionResult,
    this.createdAt,
  });

  factory ChatMessage({
    int? id,
    required int userProfileId,
    required String role,
    required String content,
    String? functionName,
    String? functionArgs,
    String? functionResult,
    DateTime? createdAt,
  }) = _ChatMessageImpl;

  factory ChatMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatMessage(
      id: jsonSerialization['id'] as int?,
      userProfileId: jsonSerialization['userProfileId'] as int,
      role: jsonSerialization['role'] as String,
      content: jsonSerialization['content'] as String,
      functionName: jsonSerialization['functionName'] as String?,
      functionArgs: jsonSerialization['functionArgs'] as String?,
      functionResult: jsonSerialization['functionResult'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userProfileId;

  String role;

  String content;

  String? functionName;

  String? functionArgs;

  String? functionResult;

  DateTime? createdAt;

  /// Returns a shallow copy of this [ChatMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatMessage copyWith({
    int? id,
    int? userProfileId,
    String? role,
    String? content,
    String? functionName,
    String? functionArgs,
    String? functionResult,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChatMessage',
      if (id != null) 'id': id,
      'userProfileId': userProfileId,
      'role': role,
      'content': content,
      if (functionName != null) 'functionName': functionName,
      if (functionArgs != null) 'functionArgs': functionArgs,
      if (functionResult != null) 'functionResult': functionResult,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChatMessageImpl extends ChatMessage {
  _ChatMessageImpl({
    int? id,
    required int userProfileId,
    required String role,
    required String content,
    String? functionName,
    String? functionArgs,
    String? functionResult,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userProfileId: userProfileId,
         role: role,
         content: content,
         functionName: functionName,
         functionArgs: functionArgs,
         functionResult: functionResult,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ChatMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatMessage copyWith({
    Object? id = _Undefined,
    int? userProfileId,
    String? role,
    String? content,
    Object? functionName = _Undefined,
    Object? functionArgs = _Undefined,
    Object? functionResult = _Undefined,
    Object? createdAt = _Undefined,
  }) {
    return ChatMessage(
      id: id is int? ? id : this.id,
      userProfileId: userProfileId ?? this.userProfileId,
      role: role ?? this.role,
      content: content ?? this.content,
      functionName: functionName is String? ? functionName : this.functionName,
      functionArgs: functionArgs is String? ? functionArgs : this.functionArgs,
      functionResult: functionResult is String?
          ? functionResult
          : this.functionResult,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
    );
  }
}
