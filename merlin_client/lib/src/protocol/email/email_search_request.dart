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

abstract class EmailSearchRequest implements _i1.SerializableModel {
  EmailSearchRequest._({
    required this.query,
    int? maxResults,
    this.pageToken,
    this.labelIds,
  }) : maxResults = maxResults ?? 20;

  factory EmailSearchRequest({
    required String query,
    int? maxResults,
    String? pageToken,
    List<String>? labelIds,
  }) = _EmailSearchRequestImpl;

  factory EmailSearchRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailSearchRequest(
      query: jsonSerialization['query'] as String,
      maxResults: jsonSerialization['maxResults'] as int,
      pageToken: jsonSerialization['pageToken'] as String?,
      labelIds: jsonSerialization['labelIds'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['labelIds'],
            ),
    );
  }

  String query;

  int maxResults;

  String? pageToken;

  List<String>? labelIds;

  /// Returns a shallow copy of this [EmailSearchRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailSearchRequest copyWith({
    String? query,
    int? maxResults,
    String? pageToken,
    List<String>? labelIds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EmailSearchRequest',
      'query': query,
      'maxResults': maxResults,
      if (pageToken != null) 'pageToken': pageToken,
      if (labelIds != null) 'labelIds': labelIds?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailSearchRequestImpl extends EmailSearchRequest {
  _EmailSearchRequestImpl({
    required String query,
    int? maxResults,
    String? pageToken,
    List<String>? labelIds,
  }) : super._(
         query: query,
         maxResults: maxResults,
         pageToken: pageToken,
         labelIds: labelIds,
       );

  /// Returns a shallow copy of this [EmailSearchRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailSearchRequest copyWith({
    String? query,
    int? maxResults,
    Object? pageToken = _Undefined,
    Object? labelIds = _Undefined,
  }) {
    return EmailSearchRequest(
      query: query ?? this.query,
      maxResults: maxResults ?? this.maxResults,
      pageToken: pageToken is String? ? pageToken : this.pageToken,
      labelIds: labelIds is List<String>?
          ? labelIds
          : this.labelIds?.map((e0) => e0).toList(),
    );
  }
}
