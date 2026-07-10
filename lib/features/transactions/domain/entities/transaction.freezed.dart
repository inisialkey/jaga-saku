// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Transaction {

 TransactionType get type;/// Positive rupiah amount (> 0); the sign is derived from [type].
 int get amount;/// Source account id (the "From" account for a transfer).
 int get accountId;/// `null` until persisted (SQLite AUTOINCREMENT assigns it on insert).
 int? get id;/// Destination account id — transfer only, must differ from [accountId].
 int? get toAccountId;/// Category id — expense / income only (`null` for a transfer).
 int? get categoryId;/// Planned vs. unplanned — expense only.
 PlannedStatus? get plannedStatus;/// Need / want / lifestyle / emergency — expense only.
 SpendingType? get spendingType;/// Day the entry belongs to, stored as midnight-local epoch millis so
/// day-grouping is deterministic. Time-of-day lives in [createdAt].
 int get date; String? get note; int get createdAt;
/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionCopyWith<Transaction> get copyWith => _$TransactionCopyWithImpl<Transaction>(this as Transaction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transaction&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.id, id) || other.id == id)&&(identical(other.toAccountId, toAccountId) || other.toAccountId == toAccountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,type,amount,accountId,id,toAccountId,categoryId,plannedStatus,spendingType,date,note,createdAt);

@override
String toString() {
  return 'Transaction(type: $type, amount: $amount, accountId: $accountId, id: $id, toAccountId: $toAccountId, categoryId: $categoryId, plannedStatus: $plannedStatus, spendingType: $spendingType, date: $date, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TransactionCopyWith<$Res>  {
  factory $TransactionCopyWith(Transaction value, $Res Function(Transaction) _then) = _$TransactionCopyWithImpl;
@useResult
$Res call({
 TransactionType type, int amount, int accountId, int? id, int? toAccountId, int? categoryId, PlannedStatus? plannedStatus, SpendingType? spendingType, int date, String? note, int createdAt
});




}
/// @nodoc
class _$TransactionCopyWithImpl<$Res>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._self, this._then);

  final Transaction _self;
  final $Res Function(Transaction) _then;

/// Create a copy of Transaction
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


/// Adds pattern-matching-related methods to [Transaction].
extension TransactionPatterns on Transaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transaction value)  $default,){
final _that = this;
switch (_that) {
case _Transaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transaction value)?  $default,){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
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
case _Transaction() when $default != null:
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
case _Transaction():
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
case _Transaction() when $default != null:
return $default(_that.type,_that.amount,_that.accountId,_that.id,_that.toAccountId,_that.categoryId,_that.plannedStatus,_that.spendingType,_that.date,_that.note,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _Transaction implements Transaction {
  const _Transaction({required this.type, required this.amount, required this.accountId, this.id, this.toAccountId, this.categoryId, this.plannedStatus, this.spendingType, this.date = 0, this.note, this.createdAt = 0});
  

@override final  TransactionType type;
/// Positive rupiah amount (> 0); the sign is derived from [type].
@override final  int amount;
/// Source account id (the "From" account for a transfer).
@override final  int accountId;
/// `null` until persisted (SQLite AUTOINCREMENT assigns it on insert).
@override final  int? id;
/// Destination account id — transfer only, must differ from [accountId].
@override final  int? toAccountId;
/// Category id — expense / income only (`null` for a transfer).
@override final  int? categoryId;
/// Planned vs. unplanned — expense only.
@override final  PlannedStatus? plannedStatus;
/// Need / want / lifestyle / emergency — expense only.
@override final  SpendingType? spendingType;
/// Day the entry belongs to, stored as midnight-local epoch millis so
/// day-grouping is deterministic. Time-of-day lives in [createdAt].
@override@JsonKey() final  int date;
@override final  String? note;
@override@JsonKey() final  int createdAt;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionCopyWith<_Transaction> get copyWith => __$TransactionCopyWithImpl<_Transaction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transaction&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.id, id) || other.id == id)&&(identical(other.toAccountId, toAccountId) || other.toAccountId == toAccountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,type,amount,accountId,id,toAccountId,categoryId,plannedStatus,spendingType,date,note,createdAt);

@override
String toString() {
  return 'Transaction(type: $type, amount: $amount, accountId: $accountId, id: $id, toAccountId: $toAccountId, categoryId: $categoryId, plannedStatus: $plannedStatus, spendingType: $spendingType, date: $date, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TransactionCopyWith<$Res> implements $TransactionCopyWith<$Res> {
  factory _$TransactionCopyWith(_Transaction value, $Res Function(_Transaction) _then) = __$TransactionCopyWithImpl;
@override @useResult
$Res call({
 TransactionType type, int amount, int accountId, int? id, int? toAccountId, int? categoryId, PlannedStatus? plannedStatus, SpendingType? spendingType, int date, String? note, int createdAt
});




}
/// @nodoc
class __$TransactionCopyWithImpl<$Res>
    implements _$TransactionCopyWith<$Res> {
  __$TransactionCopyWithImpl(this._self, this._then);

  final _Transaction _self;
  final $Res Function(_Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? amount = null,Object? accountId = null,Object? id = freezed,Object? toAccountId = freezed,Object? categoryId = freezed,Object? plannedStatus = freezed,Object? spendingType = freezed,Object? date = null,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_Transaction(
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
