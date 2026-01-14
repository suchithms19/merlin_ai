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
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'calendar/calendar.dart' as _i5;
import 'calendar/calendar_event.dart' as _i6;
import 'calendar/create_event_request.dart' as _i7;
import 'calendar/find_slots_request.dart' as _i8;
import 'calendar/time_slot.dart' as _i9;
import 'calendar/update_event_request.dart' as _i10;
import 'chat/chat_message.dart' as _i11;
import 'chat/chat_request.dart' as _i12;
import 'chat/chat_response.dart' as _i13;
import 'email/email.dart' as _i14;
import 'email/email_attachment.dart' as _i15;
import 'email/email_list_response.dart' as _i16;
import 'email/email_search_request.dart' as _i17;
import 'email/forward_email_request.dart' as _i18;
import 'email/reply_email_request.dart' as _i19;
import 'email/send_email_request.dart' as _i20;
import 'google_oauth/google_oauth_token.dart' as _i21;
import 'greetings/greeting.dart' as _i22;
import 'user_profile/user_profile.dart' as _i23;
import 'package:merlin_server/src/generated/chat/chat_message.dart' as _i24;
import 'package:merlin_server/src/generated/calendar/calendar.dart' as _i25;
import 'package:merlin_server/src/generated/calendar/calendar_event.dart'
    as _i26;
import 'package:merlin_server/src/generated/email/email.dart' as _i27;
export 'calendar/calendar.dart';
export 'calendar/calendar_event.dart';
export 'calendar/create_event_request.dart';
export 'calendar/find_slots_request.dart';
export 'calendar/time_slot.dart';
export 'calendar/update_event_request.dart';
export 'chat/chat_message.dart';
export 'chat/chat_request.dart';
export 'chat/chat_response.dart';
export 'email/email.dart';
export 'email/email_attachment.dart';
export 'email/email_list_response.dart';
export 'email/email_search_request.dart';
export 'email/forward_email_request.dart';
export 'email/reply_email_request.dart';
export 'email/send_email_request.dart';
export 'google_oauth/google_oauth_token.dart';
export 'greetings/greeting.dart';
export 'user_profile/user_profile.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'calendar',
      dartName: 'Calendar',
      schema: 'public',
      module: 'merlin',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'calendar_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userProfileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'googleCalendarId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'backgroundColor',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'isPrimary',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'calendar_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'calendar_event',
      dartName: 'CalendarEvent',
      schema: 'public',
      module: 'merlin',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'calendar_event_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userProfileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'calendarId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'googleEventId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'startTime',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'endTime',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'location',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'attendees',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _i2.ColumnDefinition(
          name: 'organizerEmail',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'recurrenceRule',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'calendar_event_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'chat_message',
      dartName: 'ChatMessage',
      schema: 'public',
      module: 'merlin',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'chat_message_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userProfileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'role',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'content',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'functionName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'functionArgs',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'functionResult',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'chat_message_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'email',
      dartName: 'Email',
      schema: 'public',
      module: 'merlin',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'email_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userProfileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'googleMessageId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'googleThreadId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'subject',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'fromEmail',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'fromName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'toEmails',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _i2.ColumnDefinition(
          name: 'ccEmails',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'List<String>?',
        ),
        _i2.ColumnDefinition(
          name: 'bccEmails',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'List<String>?',
        ),
        _i2.ColumnDefinition(
          name: 'snippet',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'bodyPlainText',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'bodyHtml',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'isRead',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'isStarred',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'hasAttachments',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'labels',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _i2.ColumnDefinition(
          name: 'receivedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'email_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'email_attachment',
      dartName: 'EmailAttachment',
      schema: 'public',
      module: 'merlin',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'email_attachment_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'emailId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'attachmentId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'filename',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'mimeType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'size',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'email_attachment_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'google_oauth_token',
      dartName: 'GoogleOAuthToken',
      schema: 'public',
      module: 'merlin',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'google_oauth_token_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userProfileId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'accessToken',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'refreshToken',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'expiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'google_oauth_token_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'user_profile',
      dartName: 'UserProfile',
      schema: 'public',
      module: 'merlin',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'user_profile_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'fullName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_profile_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i5.Calendar) {
      return _i5.Calendar.fromJson(data) as T;
    }
    if (t == _i6.CalendarEvent) {
      return _i6.CalendarEvent.fromJson(data) as T;
    }
    if (t == _i7.CreateEventRequest) {
      return _i7.CreateEventRequest.fromJson(data) as T;
    }
    if (t == _i8.FindSlotsRequest) {
      return _i8.FindSlotsRequest.fromJson(data) as T;
    }
    if (t == _i9.TimeSlot) {
      return _i9.TimeSlot.fromJson(data) as T;
    }
    if (t == _i10.UpdateEventRequest) {
      return _i10.UpdateEventRequest.fromJson(data) as T;
    }
    if (t == _i11.ChatMessage) {
      return _i11.ChatMessage.fromJson(data) as T;
    }
    if (t == _i12.ChatRequest) {
      return _i12.ChatRequest.fromJson(data) as T;
    }
    if (t == _i13.ChatResponse) {
      return _i13.ChatResponse.fromJson(data) as T;
    }
    if (t == _i14.Email) {
      return _i14.Email.fromJson(data) as T;
    }
    if (t == _i15.EmailAttachment) {
      return _i15.EmailAttachment.fromJson(data) as T;
    }
    if (t == _i16.EmailListResponse) {
      return _i16.EmailListResponse.fromJson(data) as T;
    }
    if (t == _i17.EmailSearchRequest) {
      return _i17.EmailSearchRequest.fromJson(data) as T;
    }
    if (t == _i18.ForwardEmailRequest) {
      return _i18.ForwardEmailRequest.fromJson(data) as T;
    }
    if (t == _i19.ReplyEmailRequest) {
      return _i19.ReplyEmailRequest.fromJson(data) as T;
    }
    if (t == _i20.SendEmailRequest) {
      return _i20.SendEmailRequest.fromJson(data) as T;
    }
    if (t == _i21.GoogleOAuthToken) {
      return _i21.GoogleOAuthToken.fromJson(data) as T;
    }
    if (t == _i22.Greeting) {
      return _i22.Greeting.fromJson(data) as T;
    }
    if (t == _i23.UserProfile) {
      return _i23.UserProfile.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.Calendar?>()) {
      return (data != null ? _i5.Calendar.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.CalendarEvent?>()) {
      return (data != null ? _i6.CalendarEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.CreateEventRequest?>()) {
      return (data != null ? _i7.CreateEventRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.FindSlotsRequest?>()) {
      return (data != null ? _i8.FindSlotsRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.TimeSlot?>()) {
      return (data != null ? _i9.TimeSlot.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.UpdateEventRequest?>()) {
      return (data != null ? _i10.UpdateEventRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.ChatMessage?>()) {
      return (data != null ? _i11.ChatMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.ChatRequest?>()) {
      return (data != null ? _i12.ChatRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.ChatResponse?>()) {
      return (data != null ? _i13.ChatResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.Email?>()) {
      return (data != null ? _i14.Email.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.EmailAttachment?>()) {
      return (data != null ? _i15.EmailAttachment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.EmailListResponse?>()) {
      return (data != null ? _i16.EmailListResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.EmailSearchRequest?>()) {
      return (data != null ? _i17.EmailSearchRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.ForwardEmailRequest?>()) {
      return (data != null ? _i18.ForwardEmailRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.ReplyEmailRequest?>()) {
      return (data != null ? _i19.ReplyEmailRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.SendEmailRequest?>()) {
      return (data != null ? _i20.SendEmailRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.GoogleOAuthToken?>()) {
      return (data != null ? _i21.GoogleOAuthToken.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.Greeting?>()) {
      return (data != null ? _i22.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.UserProfile?>()) {
      return (data != null ? _i23.UserProfile.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i11.ChatMessage>) {
      return (data as List)
              .map((e) => deserialize<_i11.ChatMessage>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i11.ChatMessage>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i11.ChatMessage>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i14.Email>) {
      return (data as List).map((e) => deserialize<_i14.Email>(e)).toList()
          as T;
    }
    if (t == List<_i24.ChatMessage>) {
      return (data as List)
              .map((e) => deserialize<_i24.ChatMessage>(e))
              .toList()
          as T;
    }
    if (t == List<_i25.Calendar>) {
      return (data as List).map((e) => deserialize<_i25.Calendar>(e)).toList()
          as T;
    }
    if (t == List<_i26.CalendarEvent>) {
      return (data as List)
              .map((e) => deserialize<_i26.CalendarEvent>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<Map<String, dynamic>>) {
      return (data as List)
              .map((e) => deserialize<Map<String, dynamic>>(e))
              .toList()
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i27.Email>) {
      return (data as List).map((e) => deserialize<_i27.Email>(e)).toList()
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.Calendar => 'Calendar',
      _i6.CalendarEvent => 'CalendarEvent',
      _i7.CreateEventRequest => 'CreateEventRequest',
      _i8.FindSlotsRequest => 'FindSlotsRequest',
      _i9.TimeSlot => 'TimeSlot',
      _i10.UpdateEventRequest => 'UpdateEventRequest',
      _i11.ChatMessage => 'ChatMessage',
      _i12.ChatRequest => 'ChatRequest',
      _i13.ChatResponse => 'ChatResponse',
      _i14.Email => 'Email',
      _i15.EmailAttachment => 'EmailAttachment',
      _i16.EmailListResponse => 'EmailListResponse',
      _i17.EmailSearchRequest => 'EmailSearchRequest',
      _i18.ForwardEmailRequest => 'ForwardEmailRequest',
      _i19.ReplyEmailRequest => 'ReplyEmailRequest',
      _i20.SendEmailRequest => 'SendEmailRequest',
      _i21.GoogleOAuthToken => 'GoogleOAuthToken',
      _i22.Greeting => 'Greeting',
      _i23.UserProfile => 'UserProfile',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('merlin.', '');
    }

    switch (data) {
      case _i5.Calendar():
        return 'Calendar';
      case _i6.CalendarEvent():
        return 'CalendarEvent';
      case _i7.CreateEventRequest():
        return 'CreateEventRequest';
      case _i8.FindSlotsRequest():
        return 'FindSlotsRequest';
      case _i9.TimeSlot():
        return 'TimeSlot';
      case _i10.UpdateEventRequest():
        return 'UpdateEventRequest';
      case _i11.ChatMessage():
        return 'ChatMessage';
      case _i12.ChatRequest():
        return 'ChatRequest';
      case _i13.ChatResponse():
        return 'ChatResponse';
      case _i14.Email():
        return 'Email';
      case _i15.EmailAttachment():
        return 'EmailAttachment';
      case _i16.EmailListResponse():
        return 'EmailListResponse';
      case _i17.EmailSearchRequest():
        return 'EmailSearchRequest';
      case _i18.ForwardEmailRequest():
        return 'ForwardEmailRequest';
      case _i19.ReplyEmailRequest():
        return 'ReplyEmailRequest';
      case _i20.SendEmailRequest():
        return 'SendEmailRequest';
      case _i21.GoogleOAuthToken():
        return 'GoogleOAuthToken';
      case _i22.Greeting():
        return 'Greeting';
      case _i23.UserProfile():
        return 'UserProfile';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Calendar') {
      return deserialize<_i5.Calendar>(data['data']);
    }
    if (dataClassName == 'CalendarEvent') {
      return deserialize<_i6.CalendarEvent>(data['data']);
    }
    if (dataClassName == 'CreateEventRequest') {
      return deserialize<_i7.CreateEventRequest>(data['data']);
    }
    if (dataClassName == 'FindSlotsRequest') {
      return deserialize<_i8.FindSlotsRequest>(data['data']);
    }
    if (dataClassName == 'TimeSlot') {
      return deserialize<_i9.TimeSlot>(data['data']);
    }
    if (dataClassName == 'UpdateEventRequest') {
      return deserialize<_i10.UpdateEventRequest>(data['data']);
    }
    if (dataClassName == 'ChatMessage') {
      return deserialize<_i11.ChatMessage>(data['data']);
    }
    if (dataClassName == 'ChatRequest') {
      return deserialize<_i12.ChatRequest>(data['data']);
    }
    if (dataClassName == 'ChatResponse') {
      return deserialize<_i13.ChatResponse>(data['data']);
    }
    if (dataClassName == 'Email') {
      return deserialize<_i14.Email>(data['data']);
    }
    if (dataClassName == 'EmailAttachment') {
      return deserialize<_i15.EmailAttachment>(data['data']);
    }
    if (dataClassName == 'EmailListResponse') {
      return deserialize<_i16.EmailListResponse>(data['data']);
    }
    if (dataClassName == 'EmailSearchRequest') {
      return deserialize<_i17.EmailSearchRequest>(data['data']);
    }
    if (dataClassName == 'ForwardEmailRequest') {
      return deserialize<_i18.ForwardEmailRequest>(data['data']);
    }
    if (dataClassName == 'ReplyEmailRequest') {
      return deserialize<_i19.ReplyEmailRequest>(data['data']);
    }
    if (dataClassName == 'SendEmailRequest') {
      return deserialize<_i20.SendEmailRequest>(data['data']);
    }
    if (dataClassName == 'GoogleOAuthToken') {
      return deserialize<_i21.GoogleOAuthToken>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i22.Greeting>(data['data']);
    }
    if (dataClassName == 'UserProfile') {
      return deserialize<_i23.UserProfile>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i5.Calendar:
        return _i5.Calendar.t;
      case _i6.CalendarEvent:
        return _i6.CalendarEvent.t;
      case _i11.ChatMessage:
        return _i11.ChatMessage.t;
      case _i14.Email:
        return _i14.Email.t;
      case _i15.EmailAttachment:
        return _i15.EmailAttachment.t;
      case _i21.GoogleOAuthToken:
        return _i21.GoogleOAuthToken.t;
      case _i23.UserProfile:
        return _i23.UserProfile.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'merlin';
}
