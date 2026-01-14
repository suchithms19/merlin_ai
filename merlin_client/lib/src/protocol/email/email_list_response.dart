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
import '../email/email.dart' as _i2;
import 'package:merlin_client/src/protocol/protocol.dart' as _i3;

abstract class EmailListResponse implements _i1.SerializableModel {
  EmailListResponse._({
    required this.emails,
    this.nextPageToken,
    this.totalEstimate,
  });

  factory EmailListResponse({
    required List<_i2.Email> emails,
    String? nextPageToken,
    int? totalEstimate,
  }) = _EmailListResponseImpl;

  factory EmailListResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailListResponse(
      emails: _i3.Protocol().deserialize<List<_i2.Email>>(
        jsonSerialization['emails'],
      ),
      nextPageToken: jsonSerialization['nextPageToken'] as String?,
      totalEstimate: jsonSerialization['totalEstimate'] as int?,
    );
  }

  List<_i2.Email> emails;

  String? nextPageToken;

  int? totalEstimate;

  /// Returns a shallow copy of this [EmailListResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailListResponse copyWith({
    List<_i2.Email>? emails,
    String? nextPageToken,
    int? totalEstimate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EmailListResponse',
      'emails': emails.toJson(valueToJson: (v) => v.toJson()),
      if (nextPageToken != null) 'nextPageToken': nextPageToken,
      if (totalEstimate != null) 'totalEstimate': totalEstimate,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailListResponseImpl extends EmailListResponse {
  _EmailListResponseImpl({
    required List<_i2.Email> emails,
    String? nextPageToken,
    int? totalEstimate,
  }) : super._(
         emails: emails,
         nextPageToken: nextPageToken,
         totalEstimate: totalEstimate,
       );

  /// Returns a shallow copy of this [EmailListResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailListResponse copyWith({
    List<_i2.Email>? emails,
    Object? nextPageToken = _Undefined,
    Object? totalEstimate = _Undefined,
  }) {
    return EmailListResponse(
      emails: emails ?? this.emails.map((e0) => e0.copyWith()).toList(),
      nextPageToken: nextPageToken is String?
          ? nextPageToken
          : this.nextPageToken,
      totalEstimate: totalEstimate is int? ? totalEstimate : this.totalEstimate,
    );
  }
}
