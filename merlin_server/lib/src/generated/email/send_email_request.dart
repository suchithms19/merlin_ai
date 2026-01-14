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

abstract class SendEmailRequest
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  SendEmailRequest._({
    required this.to,
    this.cc,
    this.bcc,
    required this.subject,
    this.bodyPlainText,
    this.bodyHtml,
  });

  factory SendEmailRequest({
    required List<String> to,
    List<String>? cc,
    List<String>? bcc,
    required String subject,
    String? bodyPlainText,
    String? bodyHtml,
  }) = _SendEmailRequestImpl;

  factory SendEmailRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return SendEmailRequest(
      to: _i2.Protocol().deserialize<List<String>>(jsonSerialization['to']),
      cc: jsonSerialization['cc'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(jsonSerialization['cc']),
      bcc: jsonSerialization['bcc'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(jsonSerialization['bcc']),
      subject: jsonSerialization['subject'] as String,
      bodyPlainText: jsonSerialization['bodyPlainText'] as String?,
      bodyHtml: jsonSerialization['bodyHtml'] as String?,
    );
  }

  List<String> to;

  List<String>? cc;

  List<String>? bcc;

  String subject;

  String? bodyPlainText;

  String? bodyHtml;

  /// Returns a shallow copy of this [SendEmailRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SendEmailRequest copyWith({
    List<String>? to,
    List<String>? cc,
    List<String>? bcc,
    String? subject,
    String? bodyPlainText,
    String? bodyHtml,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SendEmailRequest',
      'to': to.toJson(),
      if (cc != null) 'cc': cc?.toJson(),
      if (bcc != null) 'bcc': bcc?.toJson(),
      'subject': subject,
      if (bodyPlainText != null) 'bodyPlainText': bodyPlainText,
      if (bodyHtml != null) 'bodyHtml': bodyHtml,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SendEmailRequest',
      'to': to.toJson(),
      if (cc != null) 'cc': cc?.toJson(),
      if (bcc != null) 'bcc': bcc?.toJson(),
      'subject': subject,
      if (bodyPlainText != null) 'bodyPlainText': bodyPlainText,
      if (bodyHtml != null) 'bodyHtml': bodyHtml,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SendEmailRequestImpl extends SendEmailRequest {
  _SendEmailRequestImpl({
    required List<String> to,
    List<String>? cc,
    List<String>? bcc,
    required String subject,
    String? bodyPlainText,
    String? bodyHtml,
  }) : super._(
         to: to,
         cc: cc,
         bcc: bcc,
         subject: subject,
         bodyPlainText: bodyPlainText,
         bodyHtml: bodyHtml,
       );

  /// Returns a shallow copy of this [SendEmailRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SendEmailRequest copyWith({
    List<String>? to,
    Object? cc = _Undefined,
    Object? bcc = _Undefined,
    String? subject,
    Object? bodyPlainText = _Undefined,
    Object? bodyHtml = _Undefined,
  }) {
    return SendEmailRequest(
      to: to ?? this.to.map((e0) => e0).toList(),
      cc: cc is List<String>? ? cc : this.cc?.map((e0) => e0).toList(),
      bcc: bcc is List<String>? ? bcc : this.bcc?.map((e0) => e0).toList(),
      subject: subject ?? this.subject,
      bodyPlainText: bodyPlainText is String?
          ? bodyPlainText
          : this.bodyPlainText,
      bodyHtml: bodyHtml is String? ? bodyHtml : this.bodyHtml,
    );
  }
}
