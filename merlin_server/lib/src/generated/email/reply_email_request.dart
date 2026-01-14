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

abstract class ReplyEmailRequest
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ReplyEmailRequest._({
    required this.originalMessageId,
    this.bodyPlainText,
    this.bodyHtml,
    bool? replyAll,
  }) : replyAll = replyAll ?? false;

  factory ReplyEmailRequest({
    required String originalMessageId,
    String? bodyPlainText,
    String? bodyHtml,
    bool? replyAll,
  }) = _ReplyEmailRequestImpl;

  factory ReplyEmailRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReplyEmailRequest(
      originalMessageId: jsonSerialization['originalMessageId'] as String,
      bodyPlainText: jsonSerialization['bodyPlainText'] as String?,
      bodyHtml: jsonSerialization['bodyHtml'] as String?,
      replyAll: jsonSerialization['replyAll'] as bool,
    );
  }

  String originalMessageId;

  String? bodyPlainText;

  String? bodyHtml;

  bool replyAll;

  /// Returns a shallow copy of this [ReplyEmailRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReplyEmailRequest copyWith({
    String? originalMessageId,
    String? bodyPlainText,
    String? bodyHtml,
    bool? replyAll,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReplyEmailRequest',
      'originalMessageId': originalMessageId,
      if (bodyPlainText != null) 'bodyPlainText': bodyPlainText,
      if (bodyHtml != null) 'bodyHtml': bodyHtml,
      'replyAll': replyAll,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReplyEmailRequest',
      'originalMessageId': originalMessageId,
      if (bodyPlainText != null) 'bodyPlainText': bodyPlainText,
      if (bodyHtml != null) 'bodyHtml': bodyHtml,
      'replyAll': replyAll,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReplyEmailRequestImpl extends ReplyEmailRequest {
  _ReplyEmailRequestImpl({
    required String originalMessageId,
    String? bodyPlainText,
    String? bodyHtml,
    bool? replyAll,
  }) : super._(
         originalMessageId: originalMessageId,
         bodyPlainText: bodyPlainText,
         bodyHtml: bodyHtml,
         replyAll: replyAll,
       );

  /// Returns a shallow copy of this [ReplyEmailRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReplyEmailRequest copyWith({
    String? originalMessageId,
    Object? bodyPlainText = _Undefined,
    Object? bodyHtml = _Undefined,
    bool? replyAll,
  }) {
    return ReplyEmailRequest(
      originalMessageId: originalMessageId ?? this.originalMessageId,
      bodyPlainText: bodyPlainText is String?
          ? bodyPlainText
          : this.bodyPlainText,
      bodyHtml: bodyHtml is String? ? bodyHtml : this.bodyHtml,
      replyAll: replyAll ?? this.replyAll,
    );
  }
}
