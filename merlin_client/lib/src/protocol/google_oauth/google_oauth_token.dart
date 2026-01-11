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

abstract class GoogleOAuthToken implements _i1.SerializableModel {
  GoogleOAuthToken._({
    this.id,
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    this.createdAt,
    this.updatedAt,
  });

  factory GoogleOAuthToken({
    int? id,
    required int userId,
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _GoogleOAuthTokenImpl;

  factory GoogleOAuthToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return GoogleOAuthToken(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      accessToken: jsonSerialization['accessToken'] as String,
      refreshToken: jsonSerialization['refreshToken'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
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

  /// The user ID this token belongs to
  int userId;

  /// Encrypted access token
  String accessToken;

  /// Encrypted refresh token
  String refreshToken;

  /// When the access token expires
  DateTime expiresAt;

  /// When this record was created
  DateTime? createdAt;

  /// When this record was last updated
  DateTime? updatedAt;

  /// Returns a shallow copy of this [GoogleOAuthToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GoogleOAuthToken copyWith({
    int? id,
    int? userId,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GoogleOAuthToken',
      if (id != null) 'id': id,
      'userId': userId,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toJson(),
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

class _GoogleOAuthTokenImpl extends GoogleOAuthToken {
  _GoogleOAuthTokenImpl({
    int? id,
    required int userId,
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         accessToken: accessToken,
         refreshToken: refreshToken,
         expiresAt: expiresAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [GoogleOAuthToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GoogleOAuthToken copyWith({
    Object? id = _Undefined,
    int? userId,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    Object? createdAt = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return GoogleOAuthToken(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
