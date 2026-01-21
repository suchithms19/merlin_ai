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

abstract class UserContext
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserContext._({
    this.id,
    required this.userProfileId,
    required this.title,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory UserContext({
    int? id,
    required int userProfileId,
    required String title,
    required String content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserContextImpl;

  factory UserContext.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserContext(
      id: jsonSerialization['id'] as int?,
      userProfileId: jsonSerialization['userProfileId'] as int,
      title: jsonSerialization['title'] as String,
      content: jsonSerialization['content'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = UserContextTable();

  static const db = UserContextRepository._();

  @override
  int? id;

  int userProfileId;

  String title;

  String content;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserContext]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserContext copyWith({
    int? id,
    int? userProfileId,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserContext',
      if (id != null) 'id': id,
      'userProfileId': userProfileId,
      'title': title,
      'content': content,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserContext',
      if (id != null) 'id': id,
      'userProfileId': userProfileId,
      'title': title,
      'content': content,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static UserContextInclude include() {
    return UserContextInclude._();
  }

  static UserContextIncludeList includeList({
    _i1.WhereExpressionBuilder<UserContextTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserContextTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserContextTable>? orderByList,
    UserContextInclude? include,
  }) {
    return UserContextIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserContext.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserContext.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserContextImpl extends UserContext {
  _UserContextImpl({
    int? id,
    required int userProfileId,
    required String title,
    required String content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userProfileId: userProfileId,
         title: title,
         content: content,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserContext]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserContext copyWith({
    Object? id = _Undefined,
    int? userProfileId,
    String? title,
    String? content,
    Object? createdAt = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return UserContext(
      id: id is int? ? id : this.id,
      userProfileId: userProfileId ?? this.userProfileId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}

class UserContextUpdateTable extends _i1.UpdateTable<UserContextTable> {
  UserContextUpdateTable(super.table);

  _i1.ColumnValue<int, int> userProfileId(int value) => _i1.ColumnValue(
    table.userProfileId,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> content(String value) => _i1.ColumnValue(
    table.content,
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

class UserContextTable extends _i1.Table<int?> {
  UserContextTable({super.tableRelation}) : super(tableName: 'user_context') {
    updateTable = UserContextUpdateTable(this);
    userProfileId = _i1.ColumnInt(
      'userProfileId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    content = _i1.ColumnString(
      'content',
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

  late final UserContextUpdateTable updateTable;

  late final _i1.ColumnInt userProfileId;

  late final _i1.ColumnString title;

  late final _i1.ColumnString content;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userProfileId,
    title,
    content,
    createdAt,
    updatedAt,
  ];
}

class UserContextInclude extends _i1.IncludeObject {
  UserContextInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserContext.t;
}

class UserContextIncludeList extends _i1.IncludeList {
  UserContextIncludeList._({
    _i1.WhereExpressionBuilder<UserContextTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserContext.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserContext.t;
}

class UserContextRepository {
  const UserContextRepository._();

  /// Returns a list of [UserContext]s matching the given query parameters.
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
  Future<List<UserContext>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserContextTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserContextTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserContextTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserContext>(
      where: where?.call(UserContext.t),
      orderBy: orderBy?.call(UserContext.t),
      orderByList: orderByList?.call(UserContext.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserContext] matching the given query parameters.
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
  Future<UserContext?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserContextTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserContextTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserContextTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserContext>(
      where: where?.call(UserContext.t),
      orderBy: orderBy?.call(UserContext.t),
      orderByList: orderByList?.call(UserContext.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserContext] by its [id] or null if no such row exists.
  Future<UserContext?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserContext>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserContext]s in the list and returns the inserted rows.
  ///
  /// The returned [UserContext]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserContext>> insert(
    _i1.Session session,
    List<UserContext> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserContext>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserContext] and returns the inserted row.
  ///
  /// The returned [UserContext] will have its `id` field set.
  Future<UserContext> insertRow(
    _i1.Session session,
    UserContext row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserContext>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserContext]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserContext>> update(
    _i1.Session session,
    List<UserContext> rows, {
    _i1.ColumnSelections<UserContextTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserContext>(
      rows,
      columns: columns?.call(UserContext.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserContext]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserContext> updateRow(
    _i1.Session session,
    UserContext row, {
    _i1.ColumnSelections<UserContextTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserContext>(
      row,
      columns: columns?.call(UserContext.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserContext] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserContext?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UserContextUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserContext>(
      id,
      columnValues: columnValues(UserContext.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserContext]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserContext>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserContextUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UserContextTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserContextTable>? orderBy,
    _i1.OrderByListBuilder<UserContextTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserContext>(
      columnValues: columnValues(UserContext.t.updateTable),
      where: where(UserContext.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserContext.t),
      orderByList: orderByList?.call(UserContext.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserContext]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserContext>> delete(
    _i1.Session session,
    List<UserContext> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserContext>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserContext].
  Future<UserContext> deleteRow(
    _i1.Session session,
    UserContext row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserContext>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserContext>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserContextTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserContext>(
      where: where(UserContext.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserContextTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserContext>(
      where: where?.call(UserContext.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
