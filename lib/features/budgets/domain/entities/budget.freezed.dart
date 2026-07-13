// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Budget {

/// The category this budget caps. One budget per category per [period].
 int get categoryId;/// The cycle's display + lookup label, as 'YYYY-MM' (the calendar month of
/// [periodStart]; see `periodKey`).
 String get period;/// The monthly cap in positive rupiah (the form enforces `> 0`).
 int get limitAmount;/// `null` until persisted (SQLite AUTOINCREMENT assigns it on insert).
 int? get id; int get createdAt;/// Local-midnight epoch millis of the cycle's start (inclusive). `0` only on
/// a legacy/unmapped row — post-`_v7` every persisted row is backfilled.
 int get periodStart;/// Local-midnight epoch millis of the cycle's end (exclusive — the next
/// cycle's start). Spend/remaining are computed off `[periodStart, periodEnd)`.
 int get periodEnd;/// Derived, non-persisted expense total for this category+cycle, populated
/// by the datasource's join query; 0 on a plain (non-joined) read.
 int get spent;
/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetCopyWith<Budget> get copyWith => _$BudgetCopyWithImpl<Budget>(this as Budget, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Budget&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.period, period) || other.period == period)&&(identical(other.limitAmount, limitAmount) || other.limitAmount == limitAmount)&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.spent, spent) || other.spent == spent));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,period,limitAmount,id,createdAt,periodStart,periodEnd,spent);

@override
String toString() {
  return 'Budget(categoryId: $categoryId, period: $period, limitAmount: $limitAmount, id: $id, createdAt: $createdAt, periodStart: $periodStart, periodEnd: $periodEnd, spent: $spent)';
}


}

/// @nodoc
abstract mixin class $BudgetCopyWith<$Res>  {
  factory $BudgetCopyWith(Budget value, $Res Function(Budget) _then) = _$BudgetCopyWithImpl;
@useResult
$Res call({
 int categoryId, String period, int limitAmount, int? id, int createdAt, int periodStart, int periodEnd, int spent
});




}
/// @nodoc
class _$BudgetCopyWithImpl<$Res>
    implements $BudgetCopyWith<$Res> {
  _$BudgetCopyWithImpl(this._self, this._then);

  final Budget _self;
  final $Res Function(Budget) _then;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? period = null,Object? limitAmount = null,Object? id = freezed,Object? createdAt = null,Object? periodStart = null,Object? periodEnd = null,Object? spent = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as int,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as int,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as int,spent: null == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Budget].
extension BudgetPatterns on Budget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Budget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Budget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Budget value)  $default,){
final _that = this;
switch (_that) {
case _Budget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Budget value)?  $default,){
final _that = this;
switch (_that) {
case _Budget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int categoryId,  String period,  int limitAmount,  int? id,  int createdAt,  int periodStart,  int periodEnd,  int spent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Budget() when $default != null:
return $default(_that.categoryId,_that.period,_that.limitAmount,_that.id,_that.createdAt,_that.periodStart,_that.periodEnd,_that.spent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int categoryId,  String period,  int limitAmount,  int? id,  int createdAt,  int periodStart,  int periodEnd,  int spent)  $default,) {final _that = this;
switch (_that) {
case _Budget():
return $default(_that.categoryId,_that.period,_that.limitAmount,_that.id,_that.createdAt,_that.periodStart,_that.periodEnd,_that.spent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int categoryId,  String period,  int limitAmount,  int? id,  int createdAt,  int periodStart,  int periodEnd,  int spent)?  $default,) {final _that = this;
switch (_that) {
case _Budget() when $default != null:
return $default(_that.categoryId,_that.period,_that.limitAmount,_that.id,_that.createdAt,_that.periodStart,_that.periodEnd,_that.spent);case _:
  return null;

}
}

}

/// @nodoc


class _Budget implements Budget {
  const _Budget({required this.categoryId, required this.period, required this.limitAmount, this.id, this.createdAt = 0, this.periodStart = 0, this.periodEnd = 0, this.spent = 0});
  

/// The category this budget caps. One budget per category per [period].
@override final  int categoryId;
/// The cycle's display + lookup label, as 'YYYY-MM' (the calendar month of
/// [periodStart]; see `periodKey`).
@override final  String period;
/// The monthly cap in positive rupiah (the form enforces `> 0`).
@override final  int limitAmount;
/// `null` until persisted (SQLite AUTOINCREMENT assigns it on insert).
@override final  int? id;
@override@JsonKey() final  int createdAt;
/// Local-midnight epoch millis of the cycle's start (inclusive). `0` only on
/// a legacy/unmapped row — post-`_v7` every persisted row is backfilled.
@override@JsonKey() final  int periodStart;
/// Local-midnight epoch millis of the cycle's end (exclusive — the next
/// cycle's start). Spend/remaining are computed off `[periodStart, periodEnd)`.
@override@JsonKey() final  int periodEnd;
/// Derived, non-persisted expense total for this category+cycle, populated
/// by the datasource's join query; 0 on a plain (non-joined) read.
@override@JsonKey() final  int spent;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetCopyWith<_Budget> get copyWith => __$BudgetCopyWithImpl<_Budget>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Budget&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.period, period) || other.period == period)&&(identical(other.limitAmount, limitAmount) || other.limitAmount == limitAmount)&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.spent, spent) || other.spent == spent));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,period,limitAmount,id,createdAt,periodStart,periodEnd,spent);

@override
String toString() {
  return 'Budget(categoryId: $categoryId, period: $period, limitAmount: $limitAmount, id: $id, createdAt: $createdAt, periodStart: $periodStart, periodEnd: $periodEnd, spent: $spent)';
}


}

/// @nodoc
abstract mixin class _$BudgetCopyWith<$Res> implements $BudgetCopyWith<$Res> {
  factory _$BudgetCopyWith(_Budget value, $Res Function(_Budget) _then) = __$BudgetCopyWithImpl;
@override @useResult
$Res call({
 int categoryId, String period, int limitAmount, int? id, int createdAt, int periodStart, int periodEnd, int spent
});




}
/// @nodoc
class __$BudgetCopyWithImpl<$Res>
    implements _$BudgetCopyWith<$Res> {
  __$BudgetCopyWithImpl(this._self, this._then);

  final _Budget _self;
  final $Res Function(_Budget) _then;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? period = null,Object? limitAmount = null,Object? id = freezed,Object? createdAt = null,Object? periodStart = null,Object? periodEnd = null,Object? spent = null,}) {
  return _then(_Budget(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as int,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as int,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as int,spent: null == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
