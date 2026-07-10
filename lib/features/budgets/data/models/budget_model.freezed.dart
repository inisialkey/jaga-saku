// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BudgetModel {

 int get categoryId; String get period; int get limitAmount; int? get id; int get createdAt; int get spent;
/// Create a copy of BudgetModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetModelCopyWith<BudgetModel> get copyWith => _$BudgetModelCopyWithImpl<BudgetModel>(this as BudgetModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetModel&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.period, period) || other.period == period)&&(identical(other.limitAmount, limitAmount) || other.limitAmount == limitAmount)&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.spent, spent) || other.spent == spent));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,period,limitAmount,id,createdAt,spent);

@override
String toString() {
  return 'BudgetModel(categoryId: $categoryId, period: $period, limitAmount: $limitAmount, id: $id, createdAt: $createdAt, spent: $spent)';
}


}

/// @nodoc
abstract mixin class $BudgetModelCopyWith<$Res>  {
  factory $BudgetModelCopyWith(BudgetModel value, $Res Function(BudgetModel) _then) = _$BudgetModelCopyWithImpl;
@useResult
$Res call({
 int categoryId, String period, int limitAmount, int? id, int createdAt, int spent
});




}
/// @nodoc
class _$BudgetModelCopyWithImpl<$Res>
    implements $BudgetModelCopyWith<$Res> {
  _$BudgetModelCopyWithImpl(this._self, this._then);

  final BudgetModel _self;
  final $Res Function(BudgetModel) _then;

/// Create a copy of BudgetModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? period = null,Object? limitAmount = null,Object? id = freezed,Object? createdAt = null,Object? spent = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as int,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,spent: null == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetModel].
extension BudgetModelPatterns on BudgetModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetModel value)  $default,){
final _that = this;
switch (_that) {
case _BudgetModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetModel value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int categoryId,  String period,  int limitAmount,  int? id,  int createdAt,  int spent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetModel() when $default != null:
return $default(_that.categoryId,_that.period,_that.limitAmount,_that.id,_that.createdAt,_that.spent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int categoryId,  String period,  int limitAmount,  int? id,  int createdAt,  int spent)  $default,) {final _that = this;
switch (_that) {
case _BudgetModel():
return $default(_that.categoryId,_that.period,_that.limitAmount,_that.id,_that.createdAt,_that.spent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int categoryId,  String period,  int limitAmount,  int? id,  int createdAt,  int spent)?  $default,) {final _that = this;
switch (_that) {
case _BudgetModel() when $default != null:
return $default(_that.categoryId,_that.period,_that.limitAmount,_that.id,_that.createdAt,_that.spent);case _:
  return null;

}
}

}

/// @nodoc


class _BudgetModel extends BudgetModel {
  const _BudgetModel({required this.categoryId, required this.period, required this.limitAmount, this.id, this.createdAt = 0, this.spent = 0}): super._();
  

@override final  int categoryId;
@override final  String period;
@override final  int limitAmount;
@override final  int? id;
@override@JsonKey() final  int createdAt;
@override@JsonKey() final  int spent;

/// Create a copy of BudgetModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetModelCopyWith<_BudgetModel> get copyWith => __$BudgetModelCopyWithImpl<_BudgetModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetModel&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.period, period) || other.period == period)&&(identical(other.limitAmount, limitAmount) || other.limitAmount == limitAmount)&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.spent, spent) || other.spent == spent));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,period,limitAmount,id,createdAt,spent);

@override
String toString() {
  return 'BudgetModel(categoryId: $categoryId, period: $period, limitAmount: $limitAmount, id: $id, createdAt: $createdAt, spent: $spent)';
}


}

/// @nodoc
abstract mixin class _$BudgetModelCopyWith<$Res> implements $BudgetModelCopyWith<$Res> {
  factory _$BudgetModelCopyWith(_BudgetModel value, $Res Function(_BudgetModel) _then) = __$BudgetModelCopyWithImpl;
@override @useResult
$Res call({
 int categoryId, String period, int limitAmount, int? id, int createdAt, int spent
});




}
/// @nodoc
class __$BudgetModelCopyWithImpl<$Res>
    implements _$BudgetModelCopyWith<$Res> {
  __$BudgetModelCopyWithImpl(this._self, this._then);

  final _BudgetModel _self;
  final $Res Function(_BudgetModel) _then;

/// Create a copy of BudgetModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? period = null,Object? limitAmount = null,Object? id = freezed,Object? createdAt = null,Object? spent = null,}) {
  return _then(_BudgetModel(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as int,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,spent: null == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
