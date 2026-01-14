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

abstract class ForwardEmailRequest implements _i1.SerializableModel {
  ForwardEmailRequest._({
    required this.originalMessageId,
    required this.to,
    this.cc,
    this.bcc,
    this.additionalMessage,
  });

  factory ForwardEmailRequest({
    required String originalMessageId,
    required List<String> to,
    List<String>? cc,
    List<String>? bcc,
    String? additionalMessage,
  }) = _ForwardEmailRequestImpl;

  factory ForwardEmailRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return ForwardEmailRequest(
      originalMessageId: jsonSerialization['originalMessageId'] as String,
      to: _i2.Protocol().deserialize<List<String>>(jsonSerialization['to']),
      cc: jsonSerialization['cc'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(jsonSerialization['cc']),
      bcc: jsonSerialization['bcc'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(jsonSerialization['bcc']),
      additionalMessage: jsonSerialization['additionalMessage'] as String?,
    );
  }

  String originalMessageId;

  List<String> to;

  List<String>? cc;

  List<String>? bcc;

  String? additionalMessage;

  /// Returns a shallow copy of this [ForwardEmailRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ForwardEmailRequest copyWith({
    String? originalMessageId,
    List<String>? to,
    List<String>? cc,
    List<String>? bcc,
    String? additionalMessage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ForwardEmailRequest',
      'originalMessageId': originalMessageId,
      'to': to.toJson(),
      if (cc != null) 'cc': cc?.toJson(),
      if (bcc != null) 'bcc': bcc?.toJson(),
      if (additionalMessage != null) 'additionalMessage': additionalMessage,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ForwardEmailRequestImpl extends ForwardEmailRequest {
  _ForwardEmailRequestImpl({
    required String originalMessageId,
    required List<String> to,
    List<String>? cc,
    List<String>? bcc,
    String? additionalMessage,
  }) : super._(
         originalMessageId: originalMessageId,
         to: to,
         cc: cc,
         bcc: bcc,
         additionalMessage: additionalMessage,
       );

  /// Returns a shallow copy of this [ForwardEmailRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ForwardEmailRequest copyWith({
    String? originalMessageId,
    List<String>? to,
    Object? cc = _Undefined,
    Object? bcc = _Undefined,
    Object? additionalMessage = _Undefined,
  }) {
    return ForwardEmailRequest(
      originalMessageId: originalMessageId ?? this.originalMessageId,
      to: to ?? this.to.map((e0) => e0).toList(),
      cc: cc is List<String>? ? cc : this.cc?.map((e0) => e0).toList(),
      bcc: bcc is List<String>? ? bcc : this.bcc?.map((e0) => e0).toList(),
      additionalMessage: additionalMessage is String?
          ? additionalMessage
          : this.additionalMessage,
    );
  }
}
