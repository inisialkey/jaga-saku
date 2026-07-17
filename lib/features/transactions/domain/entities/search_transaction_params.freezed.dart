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

/// Inclusive lower bound (epoch millis); `null` = unbounded start.
 int? get startDate;/// Exclusive upper bound (epoch millis); `null` = unbounded end.
 int? get endDate;/// Matches a transaction touching this wallet on either side (source or
/// transfer target); `null` = every account.
 int? get accountId;/// Category filter; `null` = every category.
 int? get categoryId;/// Ledger-type filter; `null` = expense + income + transfer.
 TransactionType? get type;/// Planned/unplanned filter (expense-only column); `null` = all.
 PlannedStatus? get plannedStatus;/// Spending-bucket filter (expense-only column); `null` = all.
 SpendingType? get spendingType;
/// Create a copy of SearchTransactionParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchTransactionParamsCopyWith<SearchTransactionParams> get copyWith => _$SearchTransactionParamsCopyWithImpl<SearchTransactionParams>(this as SearchTransactionParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchTransactionParams&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.type, type) || other.type == type)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType));
}


@override
int get hashCode => Object.hash(runtimeType,startDate,endDate,accountId,categoryId,type,plannedStatus,spendingType);

@override
String toString() {
  return 'SearchTransactionParams(startDate: $startDate, endDate: $endDate, accountId: $accountId, categoryId: $categoryId, type: $type, plannedStatus: $plannedStatus, spendingType: $spendingType)';
}


}

/// @nodoc
abstract mixin class $SearchTransactionParamsCopyWith<$Res>  {
  factory $SearchTransactionParamsCopyWith(SearchTransactionParams value, $Res Function(SearchTransactionParams) _then) = _$SearchTransactionParamsCopyWithImpl;
@useResult
$Res call({
 int? startDate, int? endDate, int? accountId, int? categoryId, TransactionType? type, PlannedStatus? plannedStatus, SpendingType? spendingType
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
@pragma('vm:prefer-inline') @override $Res call({Object? startDate = freezed,Object? endDate = freezed,Object? accountId = freezed,Object? categoryId = freezed,Object? type = freezed,Object? plannedStatus = freezed,Object? spendingType = freezed,}) {
  return _then(_self.copyWith(
startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as int?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as int?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType?,plannedStatus: freezed == plannedStatus ? _self.plannedStatus : plannedStatus // ignore: cast_nullable_to_non_nullable
as PlannedStatus?,spendingType: freezed == spendingType ? _self.spendingType : spendingType // ignore: cast_nullable_to_non_nullable
as SpendingType?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? startDate,  int? endDate,  int? accountId,  int? categoryId,  TransactionType? type,  PlannedStatus? plannedStatus,  SpendingType? spendingType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchTransactionParams() when $default != null:
return $default(_that.startDate,_that.endDate,_that.accountId,_that.categoryId,_that.type,_that.plannedStatus,_that.spendingType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? startDate,  int? endDate,  int? accountId,  int? categoryId,  TransactionType? type,  PlannedStatus? plannedStatus,  SpendingType? spendingType)  $default,) {final _that = this;
switch (_that) {
case _SearchTransactionParams():
return $default(_that.startDate,_that.endDate,_that.accountId,_that.categoryId,_that.type,_that.plannedStatus,_that.spendingType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? startDate,  int? endDate,  int? accountId,  int? categoryId,  TransactionType? type,  PlannedStatus? plannedStatus,  SpendingType? spendingType)?  $default,) {final _that = this;
switch (_that) {
case _SearchTransactionParams() when $default != null:
return $default(_that.startDate,_that.endDate,_that.accountId,_that.categoryId,_that.type,_that.plannedStatus,_that.spendingType);case _:
  return null;

}
}

}

/// @nodoc


class _SearchTransactionParams implements SearchTransactionParams {
  const _SearchTransactionParams({this.startDate, this.endDate, this.accountId, this.categoryId, this.type, this.plannedStatus, this.spendingType});
  

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
/// Planned/unplanned filter (expense-only column); `null` = all.
@override final  PlannedStatus? plannedStatus;
/// Spending-bucket filter (expense-only column); `null` = all.
@override final  SpendingType? spendingType;

/// Create a copy of SearchTransactionParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchTransactionParamsCopyWith<_SearchTransactionParams> get copyWith => __$SearchTransactionParamsCopyWithImpl<_SearchTransactionParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchTransactionParams&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.type, type) || other.type == type)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType));
}


@override
int get hashCode => Object.hash(runtimeType,startDate,endDate,accountId,categoryId,type,plannedStatus,spendingType);

@override
String toString() {
  return 'SearchTransactionParams(startDate: $startDate, endDate: $endDate, accountId: $accountId, categoryId: $categoryId, type: $type, plannedStatus: $plannedStatus, spendingType: $spendingType)';
}


}

/// @nodoc
abstract mixin class _$SearchTransactionParamsCopyWith<$Res> implements $SearchTransactionParamsCopyWith<$Res> {
  factory _$SearchTransactionParamsCopyWith(_SearchTransactionParams value, $Res Function(_SearchTransactionParams) _then) = __$SearchTransactionParamsCopyWithImpl;
@override @useResult
$Res call({
 int? startDate, int? endDate, int? accountId, int? categoryId, TransactionType? type, PlannedStatus? plannedStatus, SpendingType? spendingType
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
@override @pragma('vm:prefer-inline') $Res call({Object? startDate = freezed,Object? endDate = freezed,Object? accountId = freezed,Object? categoryId = freezed,Object? type = freezed,Object? plannedStatus = freezed,Object? spendingType = freezed,}) {
  return _then(_SearchTransactionParams(
startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as int?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as int?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType?,plannedStatus: freezed == plannedStatus ? _self.plannedStatus : plannedStatus // ignore: cast_nullable_to_non_nullable
as PlannedStatus?,spendingType: freezed == spendingType ? _self.spendingType : spendingType // ignore: cast_nullable_to_non_nullable
as SpendingType?,
  ));
}


}

// dart format on
