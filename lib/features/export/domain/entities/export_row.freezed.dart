// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_row.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExportRow {

/// Day the entry belongs to (epoch millis) → ISO `YYYY-MM-DD`.
 int get date; TransactionType get type; TransactionSource get source;/// Source account name (empty if the account was hard-deleted).
 String get account;/// Positive rupiah amount; sign is carried by [type].
 int get amount;/// Row creation time (epoch millis) → ISO `YYYY-MM-DD HH:mm`.
 int get createdAt;/// True when the row has a stored receipt path (the path itself is never
/// exported — it is device-local).
 bool get receiptAttached;/// Transfer destination name; `null` for non-transfers.
 String? get targetAccount;/// Category name; `null` for a transfer.
 String? get category;/// Expense-only; `null` otherwise.
 PlannedStatus? get plannedStatus;/// Expense-only; `null` otherwise.
 SpendingType? get spendingType; String? get note;
/// Create a copy of ExportRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportRowCopyWith<ExportRow> get copyWith => _$ExportRowCopyWithImpl<ExportRow>(this as ExportRow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportRow&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type)&&(identical(other.source, source) || other.source == source)&&(identical(other.account, account) || other.account == account)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.receiptAttached, receiptAttached) || other.receiptAttached == receiptAttached)&&(identical(other.targetAccount, targetAccount) || other.targetAccount == targetAccount)&&(identical(other.category, category) || other.category == category)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,date,type,source,account,amount,createdAt,receiptAttached,targetAccount,category,plannedStatus,spendingType,note);

@override
String toString() {
  return 'ExportRow(date: $date, type: $type, source: $source, account: $account, amount: $amount, createdAt: $createdAt, receiptAttached: $receiptAttached, targetAccount: $targetAccount, category: $category, plannedStatus: $plannedStatus, spendingType: $spendingType, note: $note)';
}


}

/// @nodoc
abstract mixin class $ExportRowCopyWith<$Res>  {
  factory $ExportRowCopyWith(ExportRow value, $Res Function(ExportRow) _then) = _$ExportRowCopyWithImpl;
@useResult
$Res call({
 int date, TransactionType type, TransactionSource source, String account, int amount, int createdAt, bool receiptAttached, String? targetAccount, String? category, PlannedStatus? plannedStatus, SpendingType? spendingType, String? note
});




}
/// @nodoc
class _$ExportRowCopyWithImpl<$Res>
    implements $ExportRowCopyWith<$Res> {
  _$ExportRowCopyWithImpl(this._self, this._then);

  final ExportRow _self;
  final $Res Function(ExportRow) _then;

/// Create a copy of ExportRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? type = null,Object? source = null,Object? account = null,Object? amount = null,Object? createdAt = null,Object? receiptAttached = null,Object? targetAccount = freezed,Object? category = freezed,Object? plannedStatus = freezed,Object? spendingType = freezed,Object? note = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TransactionSource,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,receiptAttached: null == receiptAttached ? _self.receiptAttached : receiptAttached // ignore: cast_nullable_to_non_nullable
as bool,targetAccount: freezed == targetAccount ? _self.targetAccount : targetAccount // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,plannedStatus: freezed == plannedStatus ? _self.plannedStatus : plannedStatus // ignore: cast_nullable_to_non_nullable
as PlannedStatus?,spendingType: freezed == spendingType ? _self.spendingType : spendingType // ignore: cast_nullable_to_non_nullable
as SpendingType?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportRow].
extension ExportRowPatterns on ExportRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportRow value)  $default,){
final _that = this;
switch (_that) {
case _ExportRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportRow value)?  $default,){
final _that = this;
switch (_that) {
case _ExportRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int date,  TransactionType type,  TransactionSource source,  String account,  int amount,  int createdAt,  bool receiptAttached,  String? targetAccount,  String? category,  PlannedStatus? plannedStatus,  SpendingType? spendingType,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportRow() when $default != null:
return $default(_that.date,_that.type,_that.source,_that.account,_that.amount,_that.createdAt,_that.receiptAttached,_that.targetAccount,_that.category,_that.plannedStatus,_that.spendingType,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int date,  TransactionType type,  TransactionSource source,  String account,  int amount,  int createdAt,  bool receiptAttached,  String? targetAccount,  String? category,  PlannedStatus? plannedStatus,  SpendingType? spendingType,  String? note)  $default,) {final _that = this;
switch (_that) {
case _ExportRow():
return $default(_that.date,_that.type,_that.source,_that.account,_that.amount,_that.createdAt,_that.receiptAttached,_that.targetAccount,_that.category,_that.plannedStatus,_that.spendingType,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int date,  TransactionType type,  TransactionSource source,  String account,  int amount,  int createdAt,  bool receiptAttached,  String? targetAccount,  String? category,  PlannedStatus? plannedStatus,  SpendingType? spendingType,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _ExportRow() when $default != null:
return $default(_that.date,_that.type,_that.source,_that.account,_that.amount,_that.createdAt,_that.receiptAttached,_that.targetAccount,_that.category,_that.plannedStatus,_that.spendingType,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _ExportRow implements ExportRow {
  const _ExportRow({required this.date, required this.type, required this.source, required this.account, required this.amount, required this.createdAt, required this.receiptAttached, this.targetAccount, this.category, this.plannedStatus, this.spendingType, this.note});
  

/// Day the entry belongs to (epoch millis) → ISO `YYYY-MM-DD`.
@override final  int date;
@override final  TransactionType type;
@override final  TransactionSource source;
/// Source account name (empty if the account was hard-deleted).
@override final  String account;
/// Positive rupiah amount; sign is carried by [type].
@override final  int amount;
/// Row creation time (epoch millis) → ISO `YYYY-MM-DD HH:mm`.
@override final  int createdAt;
/// True when the row has a stored receipt path (the path itself is never
/// exported — it is device-local).
@override final  bool receiptAttached;
/// Transfer destination name; `null` for non-transfers.
@override final  String? targetAccount;
/// Category name; `null` for a transfer.
@override final  String? category;
/// Expense-only; `null` otherwise.
@override final  PlannedStatus? plannedStatus;
/// Expense-only; `null` otherwise.
@override final  SpendingType? spendingType;
@override final  String? note;

/// Create a copy of ExportRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportRowCopyWith<_ExportRow> get copyWith => __$ExportRowCopyWithImpl<_ExportRow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportRow&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type)&&(identical(other.source, source) || other.source == source)&&(identical(other.account, account) || other.account == account)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.receiptAttached, receiptAttached) || other.receiptAttached == receiptAttached)&&(identical(other.targetAccount, targetAccount) || other.targetAccount == targetAccount)&&(identical(other.category, category) || other.category == category)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,date,type,source,account,amount,createdAt,receiptAttached,targetAccount,category,plannedStatus,spendingType,note);

@override
String toString() {
  return 'ExportRow(date: $date, type: $type, source: $source, account: $account, amount: $amount, createdAt: $createdAt, receiptAttached: $receiptAttached, targetAccount: $targetAccount, category: $category, plannedStatus: $plannedStatus, spendingType: $spendingType, note: $note)';
}


}

/// @nodoc
abstract mixin class _$ExportRowCopyWith<$Res> implements $ExportRowCopyWith<$Res> {
  factory _$ExportRowCopyWith(_ExportRow value, $Res Function(_ExportRow) _then) = __$ExportRowCopyWithImpl;
@override @useResult
$Res call({
 int date, TransactionType type, TransactionSource source, String account, int amount, int createdAt, bool receiptAttached, String? targetAccount, String? category, PlannedStatus? plannedStatus, SpendingType? spendingType, String? note
});




}
/// @nodoc
class __$ExportRowCopyWithImpl<$Res>
    implements _$ExportRowCopyWith<$Res> {
  __$ExportRowCopyWithImpl(this._self, this._then);

  final _ExportRow _self;
  final $Res Function(_ExportRow) _then;

/// Create a copy of ExportRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? type = null,Object? source = null,Object? account = null,Object? amount = null,Object? createdAt = null,Object? receiptAttached = null,Object? targetAccount = freezed,Object? category = freezed,Object? plannedStatus = freezed,Object? spendingType = freezed,Object? note = freezed,}) {
  return _then(_ExportRow(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TransactionSource,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,receiptAttached: null == receiptAttached ? _self.receiptAttached : receiptAttached // ignore: cast_nullable_to_non_nullable
as bool,targetAccount: freezed == targetAccount ? _self.targetAccount : targetAccount // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,plannedStatus: freezed == plannedStatus ? _self.plannedStatus : plannedStatus // ignore: cast_nullable_to_non_nullable
as PlannedStatus?,spendingType: freezed == spendingType ? _self.spendingType : spendingType // ignore: cast_nullable_to_non_nullable
as SpendingType?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
