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

abstract class EmailAttachment implements _i1.SerializableModel {
  EmailAttachment._({
    this.id,
    required this.emailId,
    required this.attachmentId,
    required this.filename,
    required this.mimeType,
    required this.size,
    this.createdAt,
  });

  factory EmailAttachment({
    int? id,
    required int emailId,
    required String attachmentId,
    required String filename,
    required String mimeType,
    required int size,
    DateTime? createdAt,
  }) = _EmailAttachmentImpl;

  factory EmailAttachment.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailAttachment(
      id: jsonSerialization['id'] as int?,
      emailId: jsonSerialization['emailId'] as int,
      attachmentId: jsonSerialization['attachmentId'] as String,
      filename: jsonSerialization['filename'] as String,
      mimeType: jsonSerialization['mimeType'] as String,
      size: jsonSerialization['size'] as int,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int emailId;

  String attachmentId;

  String filename;

  String mimeType;

  int size;

  DateTime? createdAt;

  /// Returns a shallow copy of this [EmailAttachment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAttachment copyWith({
    int? id,
    int? emailId,
    String? attachmentId,
    String? filename,
    String? mimeType,
    int? size,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EmailAttachment',
      if (id != null) 'id': id,
      'emailId': emailId,
      'attachmentId': attachmentId,
      'filename': filename,
      'mimeType': mimeType,
      'size': size,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailAttachmentImpl extends EmailAttachment {
  _EmailAttachmentImpl({
    int? id,
    required int emailId,
    required String attachmentId,
    required String filename,
    required String mimeType,
    required int size,
    DateTime? createdAt,
  }) : super._(
         id: id,
         emailId: emailId,
         attachmentId: attachmentId,
         filename: filename,
         mimeType: mimeType,
         size: size,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [EmailAttachment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAttachment copyWith({
    Object? id = _Undefined,
    int? emailId,
    String? attachmentId,
    String? filename,
    String? mimeType,
    int? size,
    Object? createdAt = _Undefined,
  }) {
    return EmailAttachment(
      id: id is int? ? id : this.id,
      emailId: emailId ?? this.emailId,
      attachmentId: attachmentId ?? this.attachmentId,
      filename: filename ?? this.filename,
      mimeType: mimeType ?? this.mimeType,
      size: size ?? this.size,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
    );
  }
}
