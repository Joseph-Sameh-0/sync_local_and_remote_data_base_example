// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_item_operation_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTransactionItemOperationEntityCollection on Isar {
  IsarCollection<TransactionItemOperationEntity>
      get transactionItemOperationEntitys => this.collection();
}

const TransactionItemOperationEntitySchema = CollectionSchema(
  name: r'TransactionItemOperationEntity',
  id: 7950322133067558126,
  properties: {
    r'columnName': PropertySchema(
      id: 0,
      name: r'columnName',
      type: IsarType.string,
    ),
    r'itemId': PropertySchema(
      id: 1,
      name: r'itemId',
      type: IsarType.string,
    ),
    r'operationType': PropertySchema(
      id: 2,
      name: r'operationType',
      type: IsarType.byte,
      enumMap: _TransactionItemOperationEntityoperationTypeEnumValueMap,
    ),
    r'timestamp': PropertySchema(
      id: 3,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
    r'value': PropertySchema(
      id: 4,
      name: r'value',
      type: IsarType.string,
    )
  },
  estimateSize: _transactionItemOperationEntityEstimateSize,
  serialize: _transactionItemOperationEntitySerialize,
  deserialize: _transactionItemOperationEntityDeserialize,
  deserializeProp: _transactionItemOperationEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _transactionItemOperationEntityGetId,
  getLinks: _transactionItemOperationEntityGetLinks,
  attach: _transactionItemOperationEntityAttach,
  version: '3.1.0+1',
);

int _transactionItemOperationEntityEstimateSize(
  TransactionItemOperationEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.columnName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.itemId.length * 3;
  {
    final value = object.value;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _transactionItemOperationEntitySerialize(
  TransactionItemOperationEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.columnName);
  writer.writeString(offsets[1], object.itemId);
  writer.writeByte(offsets[2], object.operationType.index);
  writer.writeDateTime(offsets[3], object.timestamp);
  writer.writeString(offsets[4], object.value);
}

TransactionItemOperationEntity _transactionItemOperationEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TransactionItemOperationEntity(
    columnName: reader.readStringOrNull(offsets[0]),
    itemId: reader.readString(offsets[1]),
    operationType: _TransactionItemOperationEntityoperationTypeValueEnumMap[
            reader.readByteOrNull(offsets[2])] ??
        TransactionItemOperationType.add,
    timestamp: reader.readDateTime(offsets[3]),
    value: reader.readStringOrNull(offsets[4]),
  );
  object.id = id;
  return object;
}

P _transactionItemOperationEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (_TransactionItemOperationEntityoperationTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          TransactionItemOperationType.add) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TransactionItemOperationEntityoperationTypeEnumValueMap = {
  'add': 0,
  'updateQuantity': 1,
  'updateSubtotal': 2,
  'remove': 3,
};
const _TransactionItemOperationEntityoperationTypeValueEnumMap = {
  0: TransactionItemOperationType.add,
  1: TransactionItemOperationType.updateQuantity,
  2: TransactionItemOperationType.updateSubtotal,
  3: TransactionItemOperationType.remove,
};

Id _transactionItemOperationEntityGetId(TransactionItemOperationEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _transactionItemOperationEntityGetLinks(
    TransactionItemOperationEntity object) {
  return [];
}

void _transactionItemOperationEntityAttach(
    IsarCollection<dynamic> col, Id id, TransactionItemOperationEntity object) {
  object.id = id;
}

extension TransactionItemOperationEntityQueryWhereSort on QueryBuilder<
    TransactionItemOperationEntity, TransactionItemOperationEntity, QWhere> {
  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TransactionItemOperationEntityQueryWhere on QueryBuilder<
    TransactionItemOperationEntity,
    TransactionItemOperationEntity,
    QWhereClause> {
  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TransactionItemOperationEntityQueryFilter on QueryBuilder<
    TransactionItemOperationEntity,
    TransactionItemOperationEntity,
    QFilterCondition> {
  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> columnNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'columnName',
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> columnNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'columnName',
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> columnNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'columnName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> columnNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'columnName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> columnNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'columnName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> columnNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'columnName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> columnNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'columnName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> columnNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'columnName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
          QAfterFilterCondition>
      columnNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'columnName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
          QAfterFilterCondition>
      columnNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'columnName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> columnNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'columnName',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> columnNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'columnName',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> itemIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> itemIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> itemIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> itemIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> itemIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> itemIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
          QAfterFilterCondition>
      itemIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
          QAfterFilterCondition>
      itemIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> itemIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemId',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> itemIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemId',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
          QAfterFilterCondition>
      operationTypeEqualTo(TransactionItemOperationType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'operationType',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> operationTypeGreaterThan(
    TransactionItemOperationType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'operationType',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> operationTypeLessThan(
    TransactionItemOperationType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'operationType',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> operationTypeBetween(
    TransactionItemOperationType lower,
    TransactionItemOperationType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'operationType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> valueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'value',
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> valueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'value',
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> valueEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> valueGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> valueLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> valueBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> valueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> valueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
          QAfterFilterCondition>
      valueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
          QAfterFilterCondition>
      valueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'value',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterFilterCondition> valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'value',
        value: '',
      ));
    });
  }
}

extension TransactionItemOperationEntityQueryObject on QueryBuilder<
    TransactionItemOperationEntity,
    TransactionItemOperationEntity,
    QFilterCondition> {}

extension TransactionItemOperationEntityQueryLinks on QueryBuilder<
    TransactionItemOperationEntity,
    TransactionItemOperationEntity,
    QFilterCondition> {}

extension TransactionItemOperationEntityQuerySortBy on QueryBuilder<
    TransactionItemOperationEntity, TransactionItemOperationEntity, QSortBy> {
  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> sortByColumnName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'columnName', Sort.asc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> sortByColumnNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'columnName', Sort.desc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> sortByItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.asc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> sortByItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.desc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> sortByOperationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationType', Sort.asc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> sortByOperationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationType', Sort.desc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension TransactionItemOperationEntityQuerySortThenBy on QueryBuilder<
    TransactionItemOperationEntity,
    TransactionItemOperationEntity,
    QSortThenBy> {
  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> thenByColumnName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'columnName', Sort.asc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> thenByColumnNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'columnName', Sort.desc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> thenByItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.asc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> thenByItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.desc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> thenByOperationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationType', Sort.asc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> thenByOperationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationType', Sort.desc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension TransactionItemOperationEntityQueryWhereDistinct on QueryBuilder<
    TransactionItemOperationEntity, TransactionItemOperationEntity, QDistinct> {
  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QDistinct> distinctByColumnName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'columnName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QDistinct> distinctByItemId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QDistinct> distinctByOperationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'operationType');
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QDistinct> distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationEntity,
      QDistinct> distinctByValue({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value', caseSensitive: caseSensitive);
    });
  }
}

extension TransactionItemOperationEntityQueryProperty on QueryBuilder<
    TransactionItemOperationEntity,
    TransactionItemOperationEntity,
    QQueryProperty> {
  QueryBuilder<TransactionItemOperationEntity, int, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TransactionItemOperationEntity, String?, QQueryOperations>
      columnNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'columnName');
    });
  }

  QueryBuilder<TransactionItemOperationEntity, String, QQueryOperations>
      itemIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemId');
    });
  }

  QueryBuilder<TransactionItemOperationEntity, TransactionItemOperationType,
      QQueryOperations> operationTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'operationType');
    });
  }

  QueryBuilder<TransactionItemOperationEntity, DateTime, QQueryOperations>
      timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<TransactionItemOperationEntity, String?, QQueryOperations>
      valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}
