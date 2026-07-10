// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionModel {

 TransactionType get type; int get amount; int get accountId; int? get id; int? get toAccountId; int? get categoryId; PlannedStatus? get plannedStatus; SpendingType? get spendingType; int get date; String? get note; int get createdAt;
/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionModelCopyWith<TransactionModel> get copyWith => _$TransactionModelCopyWithImpl<TransactionModel>(this as TransactionModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionModel&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.id, id) || other.id == id)&&(identical(other.toAccountId, toAccountId) || other.toAccountId == toAccountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,type,amount,accountId,id,toAccountId,categoryId,plannedStatus,spendingType,date,note,createdAt);

@override
String toString() {
  return 'TransactionModel(type: $type, amount: $amount, accountId: $accountId, id: $id, toAccountId: $toAccountId, categoryId: $categoryId, plannedStatus: $plannedStatus, spendingType: $spendingType, date: $date, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TransactionModelCopyWith<$Res>  {
  factory $TransactionModelCopyWith(TransactionModel value, $Res Function(TransactionModel) _then) = _$TransactionModelCopyWithImpl;
@useResult
$Res call({
 TransactionType type, int amount, int accountId, int? id, int? toAccountId, int? categoryId, PlannedStatus? plannedStatus, SpendingType? spendingType, int date, String? note, int createdAt
});




}
/// @nodoc
class _$TransactionModelCopyWithImpl<$Res>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._self, this._then);

  final TransactionModel _self;
  final $Res Function(TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? amount = null,Object? accountId = null,Object? id = freezed,Object? toAccountId = freezed,Object? categoryId = freezed,Object? plannedStatus = freezed,Object? spendingType = freezed,Object? date = null,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,toAccountId: freezed == toAccountId ? _self.toAccountId : toAccountId // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,plannedStatus: freezed == plannedStatus ? _self.plannedStatus : plannedStatus // ignore: cast_nullable_to_non_nullable
as PlannedStatus?,spendingType: freezed == spendingType ? _self.spendingType : spendingType // ignore: cast_nullable_to_non_nullable
as SpendingType?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionModel].
extension TransactionModelPatterns on TransactionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionModel value)  $default,){
final _that = this;
switch (_that) {
case _TransactionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionModel value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TransactionType type,  int amount,  int accountId,  int? id,  int? toAccountId,  int? categoryId,  PlannedStatus? plannedStatus,  SpendingType? spendingType,  int date,  String? note,  int createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.type,_that.amount,_that.accountId,_that.id,_that.toAccountId,_that.categoryId,_that.plannedStatus,_that.spendingType,_that.date,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TransactionType type,  int amount,  int accountId,  int? id,  int? toAccountId,  int? categoryId,  PlannedStatus? plannedStatus,  SpendingType? spendingType,  int date,  String? note,  int createdAt)  $default,) {final _that = this;
switch (_that) {
case _TransactionModel():
return $default(_that.type,_that.amount,_that.accountId,_that.id,_that.toAccountId,_that.categoryId,_that.plannedStatus,_that.spendingType,_that.date,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TransactionType type,  int amount,  int accountId,  int? id,  int? toAccountId,  int? categoryId,  PlannedStatus? plannedStatus,  SpendingType? spendingType,  int date,  String? note,  int createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.type,_that.amount,_that.accountId,_that.id,_that.toAccountId,_that.categoryId,_that.plannedStatus,_that.spendingType,_that.date,_that.note,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionModel extends TransactionModel {
  const _TransactionModel({required this.type, required this.amount, required this.accountId, this.id, this.toAccountId, this.categoryId, this.plannedStatus, this.spendingType, this.date = 0, this.note, this.createdAt = 0}): super._();
  

@override final  TransactionType type;
@override final  int amount;
@override final  int accountId;
@override final  int? id;
@override final  int? toAccountId;
@override final  int? categoryId;
@override final  PlannedStatus? plannedStatus;
@override final  SpendingType? spendingType;
@override@JsonKey() final  int date;
@override final  String? note;
@override@JsonKey() final  int createdAt;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionModelCopyWith<_TransactionModel> get copyWith => __$TransactionModelCopyWithImpl<_TransactionModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionModel&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.id, id) || other.id == id)&&(identical(other.toAccountId, toAccountId) || other.toAccountId == toAccountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,type,amount,accountId,id,toAccountId,categoryId,plannedStatus,spendingType,date,note,createdAt);

@override
String toString() {
  return 'TransactionModel(type: $type, amount: $amount, accountId: $accountId, id: $id, toAccountId: $toAccountId, categoryId: $categoryId, plannedStatus: $plannedStatus, spendingType: $spendingType, date: $date, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TransactionModelCopyWith<$Res> implements $TransactionModelCopyWith<$Res> {
  factory _$TransactionModelCopyWith(_TransactionModel value, $Res Function(_TransactionModel) _then) = __$TransactionModelCopyWithImpl;
@override @useResult
$Res call({
 TransactionType type, int amount, int accountId, int? id, int? toAccountId, int? categoryId, PlannedStatus? plannedStatus, SpendingType? spendingType, int date, String? note, int createdAt
});




}
/// @nodoc
class __$TransactionModelCopyWithImpl<$Res>
    implements _$TransactionModelCopyWith<$Res> {
  __$TransactionModelCopyWithImpl(this._self, this._then);

  final _TransactionModel _self;
  final $Res Function(_TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? amount = null,Object? accountId = null,Object? id = freezed,Object? toAccountId = freezed,Object? categoryId = freezed,Object? plannedStatus = freezed,Object? spendingType = freezed,Object? date = null,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_TransactionModel(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,toAccountId: freezed == toAccountId ? _self.toAccountId : toAccountId // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,plannedStatus: freezed == plannedStatus ? _self.plannedStatus : plannedStatus // ignore: cast_nullable_to_non_nullable
as PlannedStatus?,spendingType: freezed == spendingType ? _self.spendingType : spendingType // ignore: cast_nullable_to_non_nullable
as SpendingType?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
