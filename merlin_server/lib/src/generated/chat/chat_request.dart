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
import '../chat/chat_message.dart' as _i2;
import 'package:merlin_server/src/generated/protocol.dart' as _i3;

abstract class ChatRequest
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ChatRequest._({
    required this.message,
    this.conversationHistory,
    bool? includeCalendarContext,
    bool? includeEmailContext,
  }) : includeCalendarContext = includeCalendarContext ?? true,
       includeEmailContext = includeEmailContext ?? true;

  factory ChatRequest({
    required String message,
    List<_i2.ChatMessage>? conversationHistory,
    bool? includeCalendarContext,
    bool? includeEmailContext,
  }) = _ChatRequestImpl;

  factory ChatRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatRequest(
      message: jsonSerialization['message'] as String,
      conversationHistory: jsonSerialization['conversationHistory'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.ChatMessage>>(
              jsonSerialization['conversationHistory'],
            ),
      includeCalendarContext:
          jsonSerialization['includeCalendarContext'] as bool,
      includeEmailContext: jsonSerialization['includeEmailContext'] as bool,
    );
  }

  String message;

  List<_i2.ChatMessage>? conversationHistory;

  bool includeCalendarContext;

  bool includeEmailContext;

  /// Returns a shallow copy of this [ChatRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatRequest copyWith({
    String? message,
    List<_i2.ChatMessage>? conversationHistory,
    bool? includeCalendarContext,
    bool? includeEmailContext,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChatRequest',
      'message': message,
      if (conversationHistory != null)
        'conversationHistory': conversationHistory?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'includeCalendarContext': includeCalendarContext,
      'includeEmailContext': includeEmailContext,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChatRequest',
      'message': message,
      if (conversationHistory != null)
        'conversationHistory': conversationHistory?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      'includeCalendarContext': includeCalendarContext,
      'includeEmailContext': includeEmailContext,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChatRequestImpl extends ChatRequest {
  _ChatRequestImpl({
    required String message,
    List<_i2.ChatMessage>? conversationHistory,
    bool? includeCalendarContext,
    bool? includeEmailContext,
  }) : super._(
         message: message,
         conversationHistory: conversationHistory,
         includeCalendarContext: includeCalendarContext,
         includeEmailContext: includeEmailContext,
       );

  /// Returns a shallow copy of this [ChatRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatRequest copyWith({
    String? message,
    Object? conversationHistory = _Undefined,
    bool? includeCalendarContext,
    bool? includeEmailContext,
  }) {
    return ChatRequest(
      message: message ?? this.message,
      conversationHistory: conversationHistory is List<_i2.ChatMessage>?
          ? conversationHistory
          : this.conversationHistory?.map((e0) => e0.copyWith()).toList(),
      includeCalendarContext:
          includeCalendarContext ?? this.includeCalendarContext,
      includeEmailContext: includeEmailContext ?? this.includeEmailContext,
    );
  }
}
