// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_form_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BudgetFormState {

/// First-of-month for the selected period.
 DateTime get month; int? get categoryId; int get limitAmount;/// Active expense categories for the picker.
 List<Category> get categories; BudgetFormStatus get status; Failure? get error; bool get isEditing;
/// Create a copy of BudgetFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetFormStateCopyWith<BudgetFormState> get copyWith => _$BudgetFormStateCopyWithImpl<BudgetFormState>(this as BudgetFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetFormState&&(identical(other.month, month) || other.month == month)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.limitAmount, limitAmount) || other.limitAmount == limitAmount)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.isEditing, isEditing) || other.isEditing == isEditing));
}


@override
int get hashCode => Object.hash(runtimeType,month,categoryId,limitAmount,const DeepCollectionEquality().hash(categories),status,error,isEditing);

@override
String toString() {
  return 'BudgetFormState(month: $month, categoryId: $categoryId, limitAmount: $limitAmount, categories: $categories, status: $status, error: $error, isEditing: $isEditing)';
}


}

/// @nodoc
abstract mixin class $BudgetFormStateCopyWith<$Res>  {
  factory $BudgetFormStateCopyWith(BudgetFormState value, $Res Function(BudgetFormState) _then) = _$BudgetFormStateCopyWithImpl;
@useResult
$Res call({
 DateTime month, int? categoryId, int limitAmount, List<Category> categories, BudgetFormStatus status, Failure? error, bool isEditing
});




}
/// @nodoc
class _$BudgetFormStateCopyWithImpl<$Res>
    implements $BudgetFormStateCopyWith<$Res> {
  _$BudgetFormStateCopyWithImpl(this._self, this._then);

  final BudgetFormState _self;
  final $Res Function(BudgetFormState) _then;

/// Create a copy of BudgetFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? categoryId = freezed,Object? limitAmount = null,Object? categories = null,Object? status = null,Object? error = freezed,Object? isEditing = null,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as int,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BudgetFormStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,isEditing: null == isEditing ? _self.isEditing : isEditing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetFormState].
extension BudgetFormStatePatterns on BudgetFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetFormState value)  $default,){
final _that = this;
switch (_that) {
case _BudgetFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetFormState value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime month,  int? categoryId,  int limitAmount,  List<Category> categories,  BudgetFormStatus status,  Failure? error,  bool isEditing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetFormState() when $default != null:
return $default(_that.month,_that.categoryId,_that.limitAmount,_that.categories,_that.status,_that.error,_that.isEditing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime month,  int? categoryId,  int limitAmount,  List<Category> categories,  BudgetFormStatus status,  Failure? error,  bool isEditing)  $default,) {final _that = this;
switch (_that) {
case _BudgetFormState():
return $default(_that.month,_that.categoryId,_that.limitAmount,_that.categories,_that.status,_that.error,_that.isEditing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime month,  int? categoryId,  int limitAmount,  List<Category> categories,  BudgetFormStatus status,  Failure? error,  bool isEditing)?  $default,) {final _that = this;
switch (_that) {
case _BudgetFormState() when $default != null:
return $default(_that.month,_that.categoryId,_that.limitAmount,_that.categories,_that.status,_that.error,_that.isEditing);case _:
  return null;

}
}

}

/// @nodoc


class _BudgetFormState extends BudgetFormState {
  const _BudgetFormState({required this.month, this.categoryId, this.limitAmount = 0, final  List<Category> categories = const <Category>[], this.status = BudgetFormStatus.editing, this.error, this.isEditing = false}): _categories = categories,super._();
  

/// First-of-month for the selected period.
@override final  DateTime month;
@override final  int? categoryId;
@override@JsonKey() final  int limitAmount;
/// Active expense categories for the picker.
 final  List<Category> _categories;
/// Active expense categories for the picker.
@override@JsonKey() List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override@JsonKey() final  BudgetFormStatus status;
@override final  Failure? error;
@override@JsonKey() final  bool isEditing;

/// Create a copy of BudgetFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetFormStateCopyWith<_BudgetFormState> get copyWith => __$BudgetFormStateCopyWithImpl<_BudgetFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetFormState&&(identical(other.month, month) || other.month == month)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.limitAmount, limitAmount) || other.limitAmount == limitAmount)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.isEditing, isEditing) || other.isEditing == isEditing));
}


@override
int get hashCode => Object.hash(runtimeType,month,categoryId,limitAmount,const DeepCollectionEquality().hash(_categories),status,error,isEditing);

@override
String toString() {
  return 'BudgetFormState(month: $month, categoryId: $categoryId, limitAmount: $limitAmount, categories: $categories, status: $status, error: $error, isEditing: $isEditing)';
}


}

/// @nodoc
abstract mixin class _$BudgetFormStateCopyWith<$Res> implements $BudgetFormStateCopyWith<$Res> {
  factory _$BudgetFormStateCopyWith(_BudgetFormState value, $Res Function(_BudgetFormState) _then) = __$BudgetFormStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime month, int? categoryId, int limitAmount, List<Category> categories, BudgetFormStatus status, Failure? error, bool isEditing
});




}
/// @nodoc
class __$BudgetFormStateCopyWithImpl<$Res>
    implements _$BudgetFormStateCopyWith<$Res> {
  __$BudgetFormStateCopyWithImpl(this._self, this._then);

  final _BudgetFormState _self;
  final $Res Function(_BudgetFormState) _then;

/// Create a copy of BudgetFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? categoryId = freezed,Object? limitAmount = null,Object? categories = null,Object? status = null,Object? error = freezed,Object? isEditing = null,}) {
  return _then(_BudgetFormState(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as int,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BudgetFormStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,isEditing: null == isEditing ? _self.isEditing : isEditing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
