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

abstract class GoogleOAuthToken
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  GoogleOAuthToken._({
    this.id,
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    this.createdAt,
    this.updatedAt,
  });

  factory GoogleOAuthToken({
    int? id,
    required int userId,
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _GoogleOAuthTokenImpl;

  factory GoogleOAuthToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return GoogleOAuthToken(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      accessToken: jsonSerialization['accessToken'] as String,
      refreshToken: jsonSerialization['refreshToken'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = GoogleOAuthTokenTable();

  static const db = GoogleOAuthTokenRepository._();

  @override
  int? id;

  /// The user ID this token belongs to
  int userId;

  /// Encrypted access token
  String accessToken;

  /// Encrypted refresh token
  String refreshToken;

  /// When the access token expires
  DateTime expiresAt;

  /// When this record was created
  DateTime? createdAt;

  /// When this record was last updated
  DateTime? updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [GoogleOAuthToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GoogleOAuthToken copyWith({
    int? id,
    int? userId,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GoogleOAuthToken',
      if (id != null) 'id': id,
      'userId': userId,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'GoogleOAuthToken',
      if (id != null) 'id': id,
      'userId': userId,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static GoogleOAuthTokenInclude include() {
    return GoogleOAuthTokenInclude._();
  }

  static GoogleOAuthTokenIncludeList includeList({
    _i1.WhereExpressionBuilder<GoogleOAuthTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GoogleOAuthTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GoogleOAuthTokenTable>? orderByList,
    GoogleOAuthTokenInclude? include,
  }) {
    return GoogleOAuthTokenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GoogleOAuthToken.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(GoogleOAuthToken.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GoogleOAuthTokenImpl extends GoogleOAuthToken {
  _GoogleOAuthTokenImpl({
    int? id,
    required int userId,
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         accessToken: accessToken,
         refreshToken: refreshToken,
         expiresAt: expiresAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [GoogleOAuthToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GoogleOAuthToken copyWith({
    Object? id = _Undefined,
    int? userId,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    Object? createdAt = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return GoogleOAuthToken(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}

class GoogleOAuthTokenUpdateTable
    extends _i1.UpdateTable<GoogleOAuthTokenTable> {
  GoogleOAuthTokenUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> accessToken(String value) => _i1.ColumnValue(
    table.accessToken,
    value,
  );

  _i1.ColumnValue<String, String> refreshToken(String value) => _i1.ColumnValue(
    table.refreshToken,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _i1.ColumnValue(
        table.expiresAt,
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

class GoogleOAuthTokenTable extends _i1.Table<int?> {
  GoogleOAuthTokenTable({super.tableRelation})
    : super(tableName: 'google_oauth_token') {
    updateTable = GoogleOAuthTokenUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    accessToken = _i1.ColumnString(
      'accessToken',
      this,
    );
    refreshToken = _i1.ColumnString(
      'refreshToken',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
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

  late final GoogleOAuthTokenUpdateTable updateTable;

  /// The user ID this token belongs to
  late final _i1.ColumnInt userId;

  /// Encrypted access token
  late final _i1.ColumnString accessToken;

  /// Encrypted refresh token
  late final _i1.ColumnString refreshToken;

  /// When the access token expires
  late final _i1.ColumnDateTime expiresAt;

  /// When this record was created
  late final _i1.ColumnDateTime createdAt;

  /// When this record was last updated
  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    accessToken,
    refreshToken,
    expiresAt,
    createdAt,
    updatedAt,
  ];
}

class GoogleOAuthTokenInclude extends _i1.IncludeObject {
  GoogleOAuthTokenInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => GoogleOAuthToken.t;
}

class GoogleOAuthTokenIncludeList extends _i1.IncludeList {
  GoogleOAuthTokenIncludeList._({
    _i1.WhereExpressionBuilder<GoogleOAuthTokenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(GoogleOAuthToken.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => GoogleOAuthToken.t;
}

class GoogleOAuthTokenRepository {
  const GoogleOAuthTokenRepository._();

  /// Returns a list of [GoogleOAuthToken]s matching the given query parameters.
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
  Future<List<GoogleOAuthToken>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GoogleOAuthTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GoogleOAuthTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GoogleOAuthTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<GoogleOAuthToken>(
      where: where?.call(GoogleOAuthToken.t),
      orderBy: orderBy?.call(GoogleOAuthToken.t),
      orderByList: orderByList?.call(GoogleOAuthToken.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [GoogleOAuthToken] matching the given query parameters.
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
  Future<GoogleOAuthToken?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GoogleOAuthTokenTable>? where,
    int? offset,
    _i1.OrderByBuilder<GoogleOAuthTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GoogleOAuthTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<GoogleOAuthToken>(
      where: where?.call(GoogleOAuthToken.t),
      orderBy: orderBy?.call(GoogleOAuthToken.t),
      orderByList: orderByList?.call(GoogleOAuthToken.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [GoogleOAuthToken] by its [id] or null if no such row exists.
  Future<GoogleOAuthToken?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<GoogleOAuthToken>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [GoogleOAuthToken]s in the list and returns the inserted rows.
  ///
  /// The returned [GoogleOAuthToken]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<GoogleOAuthToken>> insert(
    _i1.Session session,
    List<GoogleOAuthToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<GoogleOAuthToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [GoogleOAuthToken] and returns the inserted row.
  ///
  /// The returned [GoogleOAuthToken] will have its `id` field set.
  Future<GoogleOAuthToken> insertRow(
    _i1.Session session,
    GoogleOAuthToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<GoogleOAuthToken>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [GoogleOAuthToken]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<GoogleOAuthToken>> update(
    _i1.Session session,
    List<GoogleOAuthToken> rows, {
    _i1.ColumnSelections<GoogleOAuthTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<GoogleOAuthToken>(
      rows,
      columns: columns?.call(GoogleOAuthToken.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GoogleOAuthToken]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<GoogleOAuthToken> updateRow(
    _i1.Session session,
    GoogleOAuthToken row, {
    _i1.ColumnSelections<GoogleOAuthTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<GoogleOAuthToken>(
      row,
      columns: columns?.call(GoogleOAuthToken.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GoogleOAuthToken] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<GoogleOAuthToken?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<GoogleOAuthTokenUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<GoogleOAuthToken>(
      id,
      columnValues: columnValues(GoogleOAuthToken.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [GoogleOAuthToken]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<GoogleOAuthToken>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<GoogleOAuthTokenUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<GoogleOAuthTokenTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GoogleOAuthTokenTable>? orderBy,
    _i1.OrderByListBuilder<GoogleOAuthTokenTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<GoogleOAuthToken>(
      columnValues: columnValues(GoogleOAuthToken.t.updateTable),
      where: where(GoogleOAuthToken.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GoogleOAuthToken.t),
      orderByList: orderByList?.call(GoogleOAuthToken.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [GoogleOAuthToken]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<GoogleOAuthToken>> delete(
    _i1.Session session,
    List<GoogleOAuthToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<GoogleOAuthToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [GoogleOAuthToken].
  Future<GoogleOAuthToken> deleteRow(
    _i1.Session session,
    GoogleOAuthToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<GoogleOAuthToken>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<GoogleOAuthToken>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<GoogleOAuthTokenTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<GoogleOAuthToken>(
      where: where(GoogleOAuthToken.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GoogleOAuthTokenTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<GoogleOAuthToken>(
      where: where?.call(GoogleOAuthToken.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
