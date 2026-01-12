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

abstract class Calendar
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Calendar._({
    this.id,
    required this.userProfileId,
    required this.googleCalendarId,
    required this.name,
    this.description,
    this.backgroundColor,
    required this.isPrimary,
    this.createdAt,
    this.updatedAt,
  });

  factory Calendar({
    int? id,
    required int userProfileId,
    required String googleCalendarId,
    required String name,
    String? description,
    String? backgroundColor,
    required bool isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CalendarImpl;

  factory Calendar.fromJson(Map<String, dynamic> jsonSerialization) {
    return Calendar(
      id: jsonSerialization['id'] as int?,
      userProfileId: jsonSerialization['userProfileId'] as int,
      googleCalendarId: jsonSerialization['googleCalendarId'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      backgroundColor: jsonSerialization['backgroundColor'] as String?,
      isPrimary: jsonSerialization['isPrimary'] as bool,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = CalendarTable();

  static const db = CalendarRepository._();

  @override
  int? id;

  int userProfileId;

  String googleCalendarId;

  String name;

  String? description;

  String? backgroundColor;

  bool isPrimary;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Calendar]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Calendar copyWith({
    int? id,
    int? userProfileId,
    String? googleCalendarId,
    String? name,
    String? description,
    String? backgroundColor,
    bool? isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Calendar',
      if (id != null) 'id': id,
      'userProfileId': userProfileId,
      'googleCalendarId': googleCalendarId,
      'name': name,
      if (description != null) 'description': description,
      if (backgroundColor != null) 'backgroundColor': backgroundColor,
      'isPrimary': isPrimary,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Calendar',
      if (id != null) 'id': id,
      'userProfileId': userProfileId,
      'googleCalendarId': googleCalendarId,
      'name': name,
      if (description != null) 'description': description,
      if (backgroundColor != null) 'backgroundColor': backgroundColor,
      'isPrimary': isPrimary,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static CalendarInclude include() {
    return CalendarInclude._();
  }

  static CalendarIncludeList includeList({
    _i1.WhereExpressionBuilder<CalendarTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CalendarTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CalendarTable>? orderByList,
    CalendarInclude? include,
  }) {
    return CalendarIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Calendar.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Calendar.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CalendarImpl extends Calendar {
  _CalendarImpl({
    int? id,
    required int userProfileId,
    required String googleCalendarId,
    required String name,
    String? description,
    String? backgroundColor,
    required bool isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userProfileId: userProfileId,
         googleCalendarId: googleCalendarId,
         name: name,
         description: description,
         backgroundColor: backgroundColor,
         isPrimary: isPrimary,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Calendar]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Calendar copyWith({
    Object? id = _Undefined,
    int? userProfileId,
    String? googleCalendarId,
    String? name,
    Object? description = _Undefined,
    Object? backgroundColor = _Undefined,
    bool? isPrimary,
    Object? createdAt = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return Calendar(
      id: id is int? ? id : this.id,
      userProfileId: userProfileId ?? this.userProfileId,
      googleCalendarId: googleCalendarId ?? this.googleCalendarId,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      backgroundColor: backgroundColor is String?
          ? backgroundColor
          : this.backgroundColor,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}

class CalendarUpdateTable extends _i1.UpdateTable<CalendarTable> {
  CalendarUpdateTable(super.table);

  _i1.ColumnValue<int, int> userProfileId(int value) => _i1.ColumnValue(
    table.userProfileId,
    value,
  );

  _i1.ColumnValue<String, String> googleCalendarId(String value) =>
      _i1.ColumnValue(
        table.googleCalendarId,
        value,
      );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> backgroundColor(String? value) =>
      _i1.ColumnValue(
        table.backgroundColor,
        value,
      );

  _i1.ColumnValue<bool, bool> isPrimary(bool value) => _i1.ColumnValue(
    table.isPrimary,
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

class CalendarTable extends _i1.Table<int?> {
  CalendarTable({super.tableRelation}) : super(tableName: 'calendar') {
    updateTable = CalendarUpdateTable(this);
    userProfileId = _i1.ColumnInt(
      'userProfileId',
      this,
    );
    googleCalendarId = _i1.ColumnString(
      'googleCalendarId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    backgroundColor = _i1.ColumnString(
      'backgroundColor',
      this,
    );
    isPrimary = _i1.ColumnBool(
      'isPrimary',
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

  late final CalendarUpdateTable updateTable;

  late final _i1.ColumnInt userProfileId;

  late final _i1.ColumnString googleCalendarId;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnString backgroundColor;

  late final _i1.ColumnBool isPrimary;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userProfileId,
    googleCalendarId,
    name,
    description,
    backgroundColor,
    isPrimary,
    createdAt,
    updatedAt,
  ];
}

class CalendarInclude extends _i1.IncludeObject {
  CalendarInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Calendar.t;
}

class CalendarIncludeList extends _i1.IncludeList {
  CalendarIncludeList._({
    _i1.WhereExpressionBuilder<CalendarTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Calendar.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Calendar.t;
}

class CalendarRepository {
  const CalendarRepository._();

  /// Returns a list of [Calendar]s matching the given query parameters.
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
  Future<List<Calendar>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CalendarTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CalendarTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CalendarTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Calendar>(
      where: where?.call(Calendar.t),
      orderBy: orderBy?.call(Calendar.t),
      orderByList: orderByList?.call(Calendar.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Calendar] matching the given query parameters.
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
  Future<Calendar?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CalendarTable>? where,
    int? offset,
    _i1.OrderByBuilder<CalendarTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CalendarTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Calendar>(
      where: where?.call(Calendar.t),
      orderBy: orderBy?.call(Calendar.t),
      orderByList: orderByList?.call(Calendar.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Calendar] by its [id] or null if no such row exists.
  Future<Calendar?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Calendar>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Calendar]s in the list and returns the inserted rows.
  ///
  /// The returned [Calendar]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Calendar>> insert(
    _i1.Session session,
    List<Calendar> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Calendar>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Calendar] and returns the inserted row.
  ///
  /// The returned [Calendar] will have its `id` field set.
  Future<Calendar> insertRow(
    _i1.Session session,
    Calendar row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Calendar>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Calendar]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Calendar>> update(
    _i1.Session session,
    List<Calendar> rows, {
    _i1.ColumnSelections<CalendarTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Calendar>(
      rows,
      columns: columns?.call(Calendar.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Calendar]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Calendar> updateRow(
    _i1.Session session,
    Calendar row, {
    _i1.ColumnSelections<CalendarTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Calendar>(
      row,
      columns: columns?.call(Calendar.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Calendar] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Calendar?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<CalendarUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Calendar>(
      id,
      columnValues: columnValues(Calendar.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Calendar]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Calendar>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CalendarUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CalendarTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CalendarTable>? orderBy,
    _i1.OrderByListBuilder<CalendarTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Calendar>(
      columnValues: columnValues(Calendar.t.updateTable),
      where: where(Calendar.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Calendar.t),
      orderByList: orderByList?.call(Calendar.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Calendar]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Calendar>> delete(
    _i1.Session session,
    List<Calendar> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Calendar>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Calendar].
  Future<Calendar> deleteRow(
    _i1.Session session,
    Calendar row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Calendar>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Calendar>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CalendarTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Calendar>(
      where: where(Calendar.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CalendarTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Calendar>(
      where: where?.call(Calendar.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
