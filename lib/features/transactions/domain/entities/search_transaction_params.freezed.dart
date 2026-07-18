// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_transaction_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchTransactionParams {

/// Trimmed free-text query; `null`/empty = no keyword. Matched
/// case-insensitively against `note` + the joined account / target-account /
/// category names (V3-M3 only — Export never sets it).
 String? get keyword;/// Inclusive lower bound (epoch millis); `null` = unbounded start.
 int? get startDate;/// Exclusive upper bound (epoch millis); `null` = unbounded end.
 int? get endDate;/// Matches a transaction touching this wallet on either side (source or
/// transfer target); `null` = every account.
 int? get accountId;/// Category filter; `null` = every category.
 int? get categoryId;/// Ledger-type filter; `null` = expense + income + transfer.
 TransactionType? get type;/// Derived provenance filter (via the category `system_key` join); `null` =
/// both manual + reconciliation. V3-M3 only — Export never sets it.
 TransactionSource? get source;/// Inclusive lower amount bound (rupiah); `null` = no minimum.
 int? get minAmount;/// Inclusive upper amount bound (rupiah); `null` = no maximum.
 int? get maxAmount;/// Planned/unplanned filter (expense-only column); `null` = all.
 PlannedStatus? get plannedStatus;/// Spending-bucket filter (expense-only column); `null` = all.
 SpendingType? get spendingType;/// Receipt filter: `true` = `receipt_path IS NOT NULL`, `false` = `IS NULL`,
/// `null` = ignore. V3-M3 only — Export never sets it.
 bool? get hasReceipt;/// Result ordering. Not a facet — it never widens/narrows the row set, so it
/// is excluded from [hasQuery] and [activeFilterCount].
 SortOption get sort;
/// Create a copy of SearchTransactionParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchTransactionParamsCopyWith<SearchTransactionParams> get copyWith => _$SearchTransactionParamsCopyWithImpl<SearchTransactionParams>(this as SearchTransactionParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchTransactionParams&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.type, type) || other.type == type)&&(identical(other.source, source) || other.source == source)&&(identical(other.minAmount, minAmount) || other.minAmount == minAmount)&&(identical(other.maxAmount, maxAmount) || other.maxAmount == maxAmount)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType)&&(identical(other.hasReceipt, hasReceipt) || other.hasReceipt == hasReceipt)&&(identical(other.sort, sort) || other.sort == sort));
}


@override
int get hashCode => Object.hash(runtimeType,keyword,startDate,endDate,accountId,categoryId,type,source,minAmount,maxAmount,plannedStatus,spendingType,hasReceipt,sort);

@override
String toString() {
  return 'SearchTransactionParams(keyword: $keyword, startDate: $startDate, endDate: $endDate, accountId: $accountId, categoryId: $categoryId, type: $type, source: $source, minAmount: $minAmount, maxAmount: $maxAmount, plannedStatus: $plannedStatus, spendingType: $spendingType, hasReceipt: $hasReceipt, sort: $sort)';
}


}

/// @nodoc
abstract mixin class $SearchTransactionParamsCopyWith<$Res>  {
  factory $SearchTransactionParamsCopyWith(SearchTransactionParams value, $Res Function(SearchTransactionParams) _then) = _$SearchTransactionParamsCopyWithImpl;
@useResult
$Res call({
 String? keyword, int? startDate, int? endDate, int? accountId, int? categoryId, TransactionType? type, TransactionSource? source, int? minAmount, int? maxAmount, PlannedStatus? plannedStatus, SpendingType? spendingType, bool? hasReceipt, SortOption sort
});




}
/// @nodoc
class _$SearchTransactionParamsCopyWithImpl<$Res>
    implements $SearchTransactionParamsCopyWith<$Res> {
  _$SearchTransactionParamsCopyWithImpl(this._self, this._then);

  final SearchTransactionParams _self;
  final $Res Function(SearchTransactionParams) _then;

/// Create a copy of SearchTransactionParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? keyword = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? accountId = freezed,Object? categoryId = freezed,Object? type = freezed,Object? source = freezed,Object? minAmount = freezed,Object? maxAmount = freezed,Object? plannedStatus = freezed,Object? spendingType = freezed,Object? hasReceipt = freezed,Object? sort = null,}) {
  return _then(_self.copyWith(
keyword: freezed == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as int?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as int?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TransactionSource?,minAmount: freezed == minAmount ? _self.minAmount : minAmount // ignore: cast_nullable_to_non_nullable
as int?,maxAmount: freezed == maxAmount ? _self.maxAmount : maxAmount // ignore: cast_nullable_to_non_nullable
as int?,plannedStatus: freezed == plannedStatus ? _self.plannedStatus : plannedStatus // ignore: cast_nullable_to_non_nullable
as PlannedStatus?,spendingType: freezed == spendingType ? _self.spendingType : spendingType // ignore: cast_nullable_to_non_nullable
as SpendingType?,hasReceipt: freezed == hasReceipt ? _self.hasReceipt : hasReceipt // ignore: cast_nullable_to_non_nullable
as bool?,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as SortOption,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchTransactionParams].
extension SearchTransactionParamsPatterns on SearchTransactionParams {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchTransactionParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchTransactionParams() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchTransactionParams value)  $default,){
final _that = this;
switch (_that) {
case _SearchTransactionParams():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchTransactionParams value)?  $default,){
final _that = this;
switch (_that) {
case _SearchTransactionParams() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? keyword,  int? startDate,  int? endDate,  int? accountId,  int? categoryId,  TransactionType? type,  TransactionSource? source,  int? minAmount,  int? maxAmount,  PlannedStatus? plannedStatus,  SpendingType? spendingType,  bool? hasReceipt,  SortOption sort)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchTransactionParams() when $default != null:
return $default(_that.keyword,_that.startDate,_that.endDate,_that.accountId,_that.categoryId,_that.type,_that.source,_that.minAmount,_that.maxAmount,_that.plannedStatus,_that.spendingType,_that.hasReceipt,_that.sort);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? keyword,  int? startDate,  int? endDate,  int? accountId,  int? categoryId,  TransactionType? type,  TransactionSource? source,  int? minAmount,  int? maxAmount,  PlannedStatus? plannedStatus,  SpendingType? spendingType,  bool? hasReceipt,  SortOption sort)  $default,) {final _that = this;
switch (_that) {
case _SearchTransactionParams():
return $default(_that.keyword,_that.startDate,_that.endDate,_that.accountId,_that.categoryId,_that.type,_that.source,_that.minAmount,_that.maxAmount,_that.plannedStatus,_that.spendingType,_that.hasReceipt,_that.sort);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? keyword,  int? startDate,  int? endDate,  int? accountId,  int? categoryId,  TransactionType? type,  TransactionSource? source,  int? minAmount,  int? maxAmount,  PlannedStatus? plannedStatus,  SpendingType? spendingType,  bool? hasReceipt,  SortOption sort)?  $default,) {final _that = this;
switch (_that) {
case _SearchTransactionParams() when $default != null:
return $default(_that.keyword,_that.startDate,_that.endDate,_that.accountId,_that.categoryId,_that.type,_that.source,_that.minAmount,_that.maxAmount,_that.plannedStatus,_that.spendingType,_that.hasReceipt,_that.sort);case _:
  return null;

}
}

}

/// @nodoc


class _SearchTransactionParams extends SearchTransactionParams {
  const _SearchTransactionParams({this.keyword, this.startDate, this.endDate, this.accountId, this.categoryId, this.type, this.source, this.minAmount, this.maxAmount, this.plannedStatus, this.spendingType, this.hasReceipt, this.sort = SortOption.newest}): super._();
  

/// Trimmed free-text query; `null`/empty = no keyword. Matched
/// case-insensitively against `note` + the joined account / target-account /
/// category names (V3-M3 only — Export never sets it).
@override final  String? keyword;
/// Inclusive lower bound (epoch millis); `null` = unbounded start.
@override final  int? startDate;
/// Exclusive upper bound (epoch millis); `null` = unbounded end.
@override final  int? endDate;
/// Matches a transaction touching this wallet on either side (source or
/// transfer target); `null` = every account.
@override final  int? accountId;
/// Category filter; `null` = every category.
@override final  int? categoryId;
/// Ledger-type filter; `null` = expense + income + transfer.
@override final  TransactionType? type;
/// Derived provenance filter (via the category `system_key` join); `null` =
/// both manual + reconciliation. V3-M3 only — Export never sets it.
@override final  TransactionSource? source;
/// Inclusive lower amount bound (rupiah); `null` = no minimum.
@override final  int? minAmount;
/// Inclusive upper amount bound (rupiah); `null` = no maximum.
@override final  int? maxAmount;
/// Planned/unplanned filter (expense-only column); `null` = all.
@override final  PlannedStatus? plannedStatus;
/// Spending-bucket filter (expense-only column); `null` = all.
@override final  SpendingType? spendingType;
/// Receipt filter: `true` = `receipt_path IS NOT NULL`, `false` = `IS NULL`,
/// `null` = ignore. V3-M3 only — Export never sets it.
@override final  bool? hasReceipt;
/// Result ordering. Not a facet — it never widens/narrows the row set, so it
/// is excluded from [hasQuery] and [activeFilterCount].
@override@JsonKey() final  SortOption sort;

/// Create a copy of SearchTransactionParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchTransactionParamsCopyWith<_SearchTransactionParams> get copyWith => __$SearchTransactionParamsCopyWithImpl<_SearchTransactionParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchTransactionParams&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.type, type) || other.type == type)&&(identical(other.source, source) || other.source == source)&&(identical(other.minAmount, minAmount) || other.minAmount == minAmount)&&(identical(other.maxAmount, maxAmount) || other.maxAmount == maxAmount)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType)&&(identical(other.hasReceipt, hasReceipt) || other.hasReceipt == hasReceipt)&&(identical(other.sort, sort) || other.sort == sort));
}


@override
int get hashCode => Object.hash(runtimeType,keyword,startDate,endDate,accountId,categoryId,type,source,minAmount,maxAmount,plannedStatus,spendingType,hasReceipt,sort);

@override
String toString() {
  return 'SearchTransactionParams(keyword: $keyword, startDate: $startDate, endDate: $endDate, accountId: $accountId, categoryId: $categoryId, type: $type, source: $source, minAmount: $minAmount, maxAmount: $maxAmount, plannedStatus: $plannedStatus, spendingType: $spendingType, hasReceipt: $hasReceipt, sort: $sort)';
}


}

/// @nodoc
abstract mixin class _$SearchTransactionParamsCopyWith<$Res> implements $SearchTransactionParamsCopyWith<$Res> {
  factory _$SearchTransactionParamsCopyWith(_SearchTransactionParams value, $Res Function(_SearchTransactionParams) _then) = __$SearchTransactionParamsCopyWithImpl;
@override @useResult
$Res call({
 String? keyword, int? startDate, int? endDate, int? accountId, int? categoryId, TransactionType? type, TransactionSource? source, int? minAmount, int? maxAmount, PlannedStatus? plannedStatus, SpendingType? spendingType, bool? hasReceipt, SortOption sort
});




}
/// @nodoc
class __$SearchTransactionParamsCopyWithImpl<$Res>
    implements _$SearchTransactionParamsCopyWith<$Res> {
  __$SearchTransactionParamsCopyWithImpl(this._self, this._then);

  final _SearchTransactionParams _self;
  final $Res Function(_SearchTransactionParams) _then;

/// Create a copy of SearchTransactionParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keyword = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? accountId = freezed,Object? categoryId = freezed,Object? type = freezed,Object? source = freezed,Object? minAmount = freezed,Object? maxAmount = freezed,Object? plannedStatus = freezed,Object? spendingType = freezed,Object? hasReceipt = freezed,Object? sort = null,}) {
  return _then(_SearchTransactionParams(
keyword: freezed == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as int?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as int?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TransactionSource?,minAmount: freezed == minAmount ? _self.minAmount : minAmount // ignore: cast_nullable_to_non_nullable
as int?,maxAmount: freezed == maxAmount ? _self.maxAmount : maxAmount // ignore: cast_nullable_to_non_nullable
as int?,plannedStatus: freezed == plannedStatus ? _self.plannedStatus : plannedStatus // ignore: cast_nullable_to_non_nullable
as PlannedStatus?,spendingType: freezed == spendingType ? _self.spendingType : spendingType // ignore: cast_nullable_to_non_nullable
as SpendingType?,hasReceipt: freezed == hasReceipt ? _self.hasReceipt : hasReceipt // ignore: cast_nullable_to_non_nullable
as bool?,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as SortOption,
  ));
}


}

// dart format on
