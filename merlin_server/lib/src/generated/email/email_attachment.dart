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

abstract class EmailAttachment
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = EmailAttachmentTable();

  static const db = EmailAttachmentRepository._();

  @override
  int? id;

  int emailId;

  String attachmentId;

  String filename;

  String mimeType;

  int size;

  DateTime? createdAt;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static EmailAttachmentInclude include() {
    return EmailAttachmentInclude._();
  }

  static EmailAttachmentIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailAttachmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAttachmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAttachmentTable>? orderByList,
    EmailAttachmentInclude? include,
  }) {
    return EmailAttachmentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAttachment.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmailAttachment.t),
      include: include,
    );
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

class EmailAttachmentUpdateTable extends _i1.UpdateTable<EmailAttachmentTable> {
  EmailAttachmentUpdateTable(super.table);

  _i1.ColumnValue<int, int> emailId(int value) => _i1.ColumnValue(
    table.emailId,
    value,
  );

  _i1.ColumnValue<String, String> attachmentId(String value) => _i1.ColumnValue(
    table.attachmentId,
    value,
  );

  _i1.ColumnValue<String, String> filename(String value) => _i1.ColumnValue(
    table.filename,
    value,
  );

  _i1.ColumnValue<String, String> mimeType(String value) => _i1.ColumnValue(
    table.mimeType,
    value,
  );

  _i1.ColumnValue<int, int> size(int value) => _i1.ColumnValue(
    table.size,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime? value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class EmailAttachmentTable extends _i1.Table<int?> {
  EmailAttachmentTable({super.tableRelation})
    : super(tableName: 'email_attachment') {
    updateTable = EmailAttachmentUpdateTable(this);
    emailId = _i1.ColumnInt(
      'emailId',
      this,
    );
    attachmentId = _i1.ColumnString(
      'attachmentId',
      this,
    );
    filename = _i1.ColumnString(
      'filename',
      this,
    );
    mimeType = _i1.ColumnString(
      'mimeType',
      this,
    );
    size = _i1.ColumnInt(
      'size',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final EmailAttachmentUpdateTable updateTable;

  late final _i1.ColumnInt emailId;

  late final _i1.ColumnString attachmentId;

  late final _i1.ColumnString filename;

  late final _i1.ColumnString mimeType;

  late final _i1.ColumnInt size;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    emailId,
    attachmentId,
    filename,
    mimeType,
    size,
    createdAt,
  ];
}

class EmailAttachmentInclude extends _i1.IncludeObject {
  EmailAttachmentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => EmailAttachment.t;
}

class EmailAttachmentIncludeList extends _i1.IncludeList {
  EmailAttachmentIncludeList._({
    _i1.WhereExpressionBuilder<EmailAttachmentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailAttachment.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => EmailAttachment.t;
}

class EmailAttachmentRepository {
  const EmailAttachmentRepository._();

  /// Returns a list of [EmailAttachment]s matching the given query parameters.
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
  Future<List<EmailAttachment>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAttachmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAttachmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAttachmentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailAttachment>(
      where: where?.call(EmailAttachment.t),
      orderBy: orderBy?.call(EmailAttachment.t),
      orderByList: orderByList?.call(EmailAttachment.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [EmailAttachment] matching the given query parameters.
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
  Future<EmailAttachment?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAttachmentTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmailAttachmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAttachmentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<EmailAttachment>(
      where: where?.call(EmailAttachment.t),
      orderBy: orderBy?.call(EmailAttachment.t),
      orderByList: orderByList?.call(EmailAttachment.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [EmailAttachment] by its [id] or null if no such row exists.
  Future<EmailAttachment?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EmailAttachment>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [EmailAttachment]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailAttachment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EmailAttachment>> insert(
    _i1.Session session,
    List<EmailAttachment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmailAttachment>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EmailAttachment] and returns the inserted row.
  ///
  /// The returned [EmailAttachment] will have its `id` field set.
  Future<EmailAttachment> insertRow(
    _i1.Session session,
    EmailAttachment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailAttachment>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmailAttachment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmailAttachment>> update(
    _i1.Session session,
    List<EmailAttachment> rows, {
    _i1.ColumnSelections<EmailAttachmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmailAttachment>(
      rows,
      columns: columns?.call(EmailAttachment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAttachment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailAttachment> updateRow(
    _i1.Session session,
    EmailAttachment row, {
    _i1.ColumnSelections<EmailAttachmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailAttachment>(
      row,
      columns: columns?.call(EmailAttachment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAttachment] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EmailAttachment?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<EmailAttachmentUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<EmailAttachment>(
      id,
      columnValues: columnValues(EmailAttachment.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EmailAttachment]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<EmailAttachment>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<EmailAttachmentUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<EmailAttachmentTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAttachmentTable>? orderBy,
    _i1.OrderByListBuilder<EmailAttachmentTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<EmailAttachment>(
      columnValues: columnValues(EmailAttachment.t.updateTable),
      where: where(EmailAttachment.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAttachment.t),
      orderByList: orderByList?.call(EmailAttachment.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [EmailAttachment]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmailAttachment>> delete(
    _i1.Session session,
    List<EmailAttachment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailAttachment>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmailAttachment].
  Future<EmailAttachment> deleteRow(
    _i1.Session session,
    EmailAttachment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailAttachment>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmailAttachment>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmailAttachmentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmailAttachment>(
      where: where(EmailAttachment.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAttachmentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailAttachment>(
      where: where?.call(EmailAttachment.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
