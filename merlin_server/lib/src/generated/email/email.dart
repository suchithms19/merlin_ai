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

abstract class Email implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = EmailTable();

  static const db = EmailRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static EmailInclude include() {
    return EmailInclude._();
  }

  static EmailIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailTable>? orderByList,
    EmailInclude? include,
  }) {
    return EmailIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Email.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Email.t),
      include: include,
    );
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

class EmailUpdateTable extends _i1.UpdateTable<EmailTable> {
  EmailUpdateTable(super.table);

  _i1.ColumnValue<int, int> userProfileId(int value) => _i1.ColumnValue(
    table.userProfileId,
    value,
  );

  _i1.ColumnValue<String, String> googleMessageId(String value) =>
      _i1.ColumnValue(
        table.googleMessageId,
        value,
      );

  _i1.ColumnValue<String, String> googleThreadId(String value) =>
      _i1.ColumnValue(
        table.googleThreadId,
        value,
      );

  _i1.ColumnValue<String, String> subject(String? value) => _i1.ColumnValue(
    table.subject,
    value,
  );

  _i1.ColumnValue<String, String> fromEmail(String value) => _i1.ColumnValue(
    table.fromEmail,
    value,
  );

  _i1.ColumnValue<String, String> fromName(String? value) => _i1.ColumnValue(
    table.fromName,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> toEmails(List<String> value) =>
      _i1.ColumnValue(
        table.toEmails,
        value,
      );

  _i1.ColumnValue<List<String>, List<String>> ccEmails(List<String>? value) =>
      _i1.ColumnValue(
        table.ccEmails,
        value,
      );

  _i1.ColumnValue<List<String>, List<String>> bccEmails(List<String>? value) =>
      _i1.ColumnValue(
        table.bccEmails,
        value,
      );

  _i1.ColumnValue<String, String> snippet(String? value) => _i1.ColumnValue(
    table.snippet,
    value,
  );

  _i1.ColumnValue<String, String> bodyPlainText(String? value) =>
      _i1.ColumnValue(
        table.bodyPlainText,
        value,
      );

  _i1.ColumnValue<String, String> bodyHtml(String? value) => _i1.ColumnValue(
    table.bodyHtml,
    value,
  );

  _i1.ColumnValue<bool, bool> isRead(bool value) => _i1.ColumnValue(
    table.isRead,
    value,
  );

  _i1.ColumnValue<bool, bool> isStarred(bool value) => _i1.ColumnValue(
    table.isStarred,
    value,
  );

  _i1.ColumnValue<bool, bool> hasAttachments(bool value) => _i1.ColumnValue(
    table.hasAttachments,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> labels(List<String> value) =>
      _i1.ColumnValue(
        table.labels,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> receivedAt(DateTime value) =>
      _i1.ColumnValue(
        table.receivedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime? value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class EmailTable extends _i1.Table<int?> {
  EmailTable({super.tableRelation}) : super(tableName: 'email') {
    updateTable = EmailUpdateTable(this);
    userProfileId = _i1.ColumnInt(
      'userProfileId',
      this,
    );
    googleMessageId = _i1.ColumnString(
      'googleMessageId',
      this,
    );
    googleThreadId = _i1.ColumnString(
      'googleThreadId',
      this,
    );
    subject = _i1.ColumnString(
      'subject',
      this,
    );
    fromEmail = _i1.ColumnString(
      'fromEmail',
      this,
    );
    fromName = _i1.ColumnString(
      'fromName',
      this,
    );
    toEmails = _i1.ColumnSerializable<List<String>>(
      'toEmails',
      this,
    );
    ccEmails = _i1.ColumnSerializable<List<String>>(
      'ccEmails',
      this,
    );
    bccEmails = _i1.ColumnSerializable<List<String>>(
      'bccEmails',
      this,
    );
    snippet = _i1.ColumnString(
      'snippet',
      this,
    );
    bodyPlainText = _i1.ColumnString(
      'bodyPlainText',
      this,
    );
    bodyHtml = _i1.ColumnString(
      'bodyHtml',
      this,
    );
    isRead = _i1.ColumnBool(
      'isRead',
      this,
      hasDefault: true,
    );
    isStarred = _i1.ColumnBool(
      'isStarred',
      this,
      hasDefault: true,
    );
    hasAttachments = _i1.ColumnBool(
      'hasAttachments',
      this,
      hasDefault: true,
    );
    labels = _i1.ColumnSerializable<List<String>>(
      'labels',
      this,
    );
    receivedAt = _i1.ColumnDateTime(
      'receivedAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final EmailUpdateTable updateTable;

  late final _i1.ColumnInt userProfileId;

  late final _i1.ColumnString googleMessageId;

  late final _i1.ColumnString googleThreadId;

  late final _i1.ColumnString subject;

  late final _i1.ColumnString fromEmail;

  late final _i1.ColumnString fromName;

  late final _i1.ColumnSerializable<List<String>> toEmails;

  late final _i1.ColumnSerializable<List<String>> ccEmails;

  late final _i1.ColumnSerializable<List<String>> bccEmails;

  late final _i1.ColumnString snippet;

  late final _i1.ColumnString bodyPlainText;

  late final _i1.ColumnString bodyHtml;

  late final _i1.ColumnBool isRead;

  late final _i1.ColumnBool isStarred;

  late final _i1.ColumnBool hasAttachments;

  late final _i1.ColumnSerializable<List<String>> labels;

  late final _i1.ColumnDateTime receivedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userProfileId,
    googleMessageId,
    googleThreadId,
    subject,
    fromEmail,
    fromName,
    toEmails,
    ccEmails,
    bccEmails,
    snippet,
    bodyPlainText,
    bodyHtml,
    isRead,
    isStarred,
    hasAttachments,
    labels,
    receivedAt,
    createdAt,
    updatedAt,
  ];
}

class EmailInclude extends _i1.IncludeObject {
  EmailInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Email.t;
}

class EmailIncludeList extends _i1.IncludeList {
  EmailIncludeList._({
    _i1.WhereExpressionBuilder<EmailTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Email.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Email.t;
}

class EmailRepository {
  const EmailRepository._();

  /// Returns a list of [Email]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Email>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Email>(
      where: where?.call(Email.t),
      orderBy: orderBy?.call(Email.t),
      orderByList: orderByList?.call(Email.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Email] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Email?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmailTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Email>(
      where: where?.call(Email.t),
      orderBy: orderBy?.call(Email.t),
      orderByList: orderByList?.call(Email.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Email] by its [id] or null if no such row exists.
  Future<Email?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Email>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Email]s in the list and returns the inserted rows.
  ///
  /// The returned [Email]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Email>> insert(
    _i1.Session session,
    List<Email> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Email>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Email] and returns the inserted row.
  ///
  /// The returned [Email] will have its `id` field set.
  Future<Email> insertRow(
    _i1.Session session,
    Email row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Email>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Email]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Email>> update(
    _i1.Session session,
    List<Email> rows, {
    _i1.ColumnSelections<EmailTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Email>(
      rows,
      columns: columns?.call(Email.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Email]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Email> updateRow(
    _i1.Session session,
    Email row, {
    _i1.ColumnSelections<EmailTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Email>(
      row,
      columns: columns?.call(Email.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Email] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Email?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<EmailUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Email>(
      id,
      columnValues: columnValues(Email.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Email]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Email>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<EmailUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<EmailTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailTable>? orderBy,
    _i1.OrderByListBuilder<EmailTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Email>(
      columnValues: columnValues(Email.t.updateTable),
      where: where(Email.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Email.t),
      orderByList: orderByList?.call(Email.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Email]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Email>> delete(
    _i1.Session session,
    List<Email> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Email>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Email].
  Future<Email> deleteRow(
    _i1.Session session,
    Email row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Email>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Email>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmailTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Email>(
      where: where(Email.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Email>(
      where: where?.call(Email.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
