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

abstract class Email implements _i1.SerializableModel {
  Email._({
    this.id,
    required this.userProfileId,
    required this.googleMessageId,
    required this.googleThreadId,
    this.subject,
    required this.fromEmail,
    this.fromName,
    required this.toEmails,
    this.ccEmails,
    this.bccEmails,
    this.snippet,
    this.bodyPlainText,
    this.bodyHtml,
    bool? isRead,
    bool? isStarred,
    bool? hasAttachments,
    required this.labels,
    required this.receivedAt,
    this.createdAt,
    this.updatedAt,
  }) : isRead = isRead ?? false,
       isStarred = isStarred ?? false,
       hasAttachments = hasAttachments ?? false;

  factory Email({
    int? id,
    required int userProfileId,
    required String googleMessageId,
    required String googleThreadId,
    String? subject,
    required String fromEmail,
    String? fromName,
    required List<String> toEmails,
    List<String>? ccEmails,
    List<String>? bccEmails,
    String? snippet,
    String? bodyPlainText,
    String? bodyHtml,
    bool? isRead,
    bool? isStarred,
    bool? hasAttachments,
    required List<String> labels,
    required DateTime receivedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _EmailImpl;

  factory Email.fromJson(Map<String, dynamic> jsonSerialization) {
    return Email(
      id: jsonSerialization['id'] as int?,
      userProfileId: jsonSerialization['userProfileId'] as int,
      googleMessageId: jsonSerialization['googleMessageId'] as String,
      googleThreadId: jsonSerialization['googleThreadId'] as String,
      subject: jsonSerialization['subject'] as String?,
      fromEmail: jsonSerialization['fromEmail'] as String,
      fromName: jsonSerialization['fromName'] as String?,
      toEmails: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['toEmails'],
      ),
      ccEmails: jsonSerialization['ccEmails'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['ccEmails'],
            ),
      bccEmails: jsonSerialization['bccEmails'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['bccEmails'],
            ),
      snippet: jsonSerialization['snippet'] as String?,
      bodyPlainText: jsonSerialization['bodyPlainText'] as String?,
      bodyHtml: jsonSerialization['bodyHtml'] as String?,
      isRead: jsonSerialization['isRead'] as bool,
      isStarred: jsonSerialization['isStarred'] as bool,
      hasAttachments: jsonSerialization['hasAttachments'] as bool,
      labels: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['labels'],
      ),
      receivedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['receivedAt'],
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

  int userProfileId;

  String googleMessageId;

  String googleThreadId;

  String? subject;

  String fromEmail;

  String? fromName;

  List<String> toEmails;

  List<String>? ccEmails;

  List<String>? bccEmails;

  String? snippet;

  String? bodyPlainText;

  String? bodyHtml;

  bool isRead;

  bool isStarred;

  bool hasAttachments;

  List<String> labels;

  DateTime receivedAt;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [Email]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Email copyWith({
    int? id,
    int? userProfileId,
    String? googleMessageId,
    String? googleThreadId,
    String? subject,
    String? fromEmail,
    String? fromName,
    List<String>? toEmails,
    List<String>? ccEmails,
    List<String>? bccEmails,
    String? snippet,
    String? bodyPlainText,
    String? bodyHtml,
    bool? isRead,
    bool? isStarred,
    bool? hasAttachments,
    List<String>? labels,
    DateTime? receivedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Email',
      if (id != null) 'id': id,
      'userProfileId': userProfileId,
      'googleMessageId': googleMessageId,
      'googleThreadId': googleThreadId,
      if (subject != null) 'subject': subject,
      'fromEmail': fromEmail,
      if (fromName != null) 'fromName': fromName,
      'toEmails': toEmails.toJson(),
      if (ccEmails != null) 'ccEmails': ccEmails?.toJson(),
      if (bccEmails != null) 'bccEmails': bccEmails?.toJson(),
      if (snippet != null) 'snippet': snippet,
      if (bodyPlainText != null) 'bodyPlainText': bodyPlainText,
      if (bodyHtml != null) 'bodyHtml': bodyHtml,
      'isRead': isRead,
      'isStarred': isStarred,
      'hasAttachments': hasAttachments,
      'labels': labels.toJson(),
      'receivedAt': receivedAt.toJson(),
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

class _EmailImpl extends Email {
  _EmailImpl({
    int? id,
    required int userProfileId,
    required String googleMessageId,
    required String googleThreadId,
    String? subject,
    required String fromEmail,
    String? fromName,
    required List<String> toEmails,
    List<String>? ccEmails,
    List<String>? bccEmails,
    String? snippet,
    String? bodyPlainText,
    String? bodyHtml,
    bool? isRead,
    bool? isStarred,
    bool? hasAttachments,
    required List<String> labels,
    required DateTime receivedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userProfileId: userProfileId,
         googleMessageId: googleMessageId,
         googleThreadId: googleThreadId,
         subject: subject,
         fromEmail: fromEmail,
         fromName: fromName,
         toEmails: toEmails,
         ccEmails: ccEmails,
         bccEmails: bccEmails,
         snippet: snippet,
         bodyPlainText: bodyPlainText,
         bodyHtml: bodyHtml,
         isRead: isRead,
         isStarred: isStarred,
         hasAttachments: hasAttachments,
         labels: labels,
         receivedAt: receivedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Email]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Email copyWith({
    Object? id = _Undefined,
    int? userProfileId,
    String? googleMessageId,
    String? googleThreadId,
    Object? subject = _Undefined,
    String? fromEmail,
    Object? fromName = _Undefined,
    List<String>? toEmails,
    Object? ccEmails = _Undefined,
    Object? bccEmails = _Undefined,
    Object? snippet = _Undefined,
    Object? bodyPlainText = _Undefined,
    Object? bodyHtml = _Undefined,
    bool? isRead,
    bool? isStarred,
    bool? hasAttachments,
    List<String>? labels,
    DateTime? receivedAt,
    Object? createdAt = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return Email(
      id: id is int? ? id : this.id,
      userProfileId: userProfileId ?? this.userProfileId,
      googleMessageId: googleMessageId ?? this.googleMessageId,
      googleThreadId: googleThreadId ?? this.googleThreadId,
      subject: subject is String? ? subject : this.subject,
      fromEmail: fromEmail ?? this.fromEmail,
      fromName: fromName is String? ? fromName : this.fromName,
      toEmails: toEmails ?? this.toEmails.map((e0) => e0).toList(),
      ccEmails: ccEmails is List<String>?
          ? ccEmails
          : this.ccEmails?.map((e0) => e0).toList(),
      bccEmails: bccEmails is List<String>?
          ? bccEmails
          : this.bccEmails?.map((e0) => e0).toList(),
      snippet: snippet is String? ? snippet : this.snippet,
      bodyPlainText: bodyPlainText is String?
          ? bodyPlainText
          : this.bodyPlainText,
      bodyHtml: bodyHtml is String? ? bodyHtml : this.bodyHtml,
      isRead: isRead ?? this.isRead,
      isStarred: isStarred ?? this.isStarred,
      hasAttachments: hasAttachments ?? this.hasAttachments,
      labels: labels ?? this.labels.map((e0) => e0).toList(),
      receivedAt: receivedAt ?? this.receivedAt,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
