// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tx_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TxTemplate {

 String get label; TransactionType get type;/// Source account id (the "From" account for a transfer).
 int get accountId;/// `null` until persisted (SQLite AUTOINCREMENT assigns it on insert).
 int? get id;/// Positive rupiah amount, or `null` = ask at use (the prefill path).
 int? get amount;/// Destination account id — transfer only.
 int? get toAccountId;/// Category id — expense / income only.
 int? get categoryId;/// Planned vs. unplanned — expense only.
 PlannedStatus? get plannedStatus;/// Need / want / lifestyle / emergency — expense only.
 SpendingType? get spendingType; String? get note;/// `true` (int 1) = a Home favorite; `false` (int 0) = M5 schedule-only.
 bool get isFavorite; int get sortOrder; int get createdAt;
/// Create a copy of TxTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TxTemplateCopyWith<TxTemplate> get copyWith => _$TxTemplateCopyWithImpl<TxTemplate>(this as TxTemplate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TxTemplate&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.toAccountId, toAccountId) || other.toAccountId == toAccountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType)&&(identical(other.note, note) || other.note == note)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,label,type,accountId,id,amount,toAccountId,categoryId,plannedStatus,spendingType,note,isFavorite,sortOrder,createdAt);

@override
String toString() {
  return 'TxTemplate(label: $label, type: $type, accountId: $accountId, id: $id, amount: $amount, toAccountId: $toAccountId, categoryId: $categoryId, plannedStatus: $plannedStatus, spendingType: $spendingType, note: $note, isFavorite: $isFavorite, sortOrder: $sortOrder, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TxTemplateCopyWith<$Res>  {
  factory $TxTemplateCopyWith(TxTemplate value, $Res Function(TxTemplate) _then) = _$TxTemplateCopyWithImpl;
@useResult
$Res call({
 String label, TransactionType type, int accountId, int? id, int? amount, int? toAccountId, int? categoryId, PlannedStatus? plannedStatus, SpendingType? spendingType, String? note, bool isFavorite, int sortOrder, int createdAt
});




}
/// @nodoc
class _$TxTemplateCopyWithImpl<$Res>
    implements $TxTemplateCopyWith<$Res> {
  _$TxTemplateCopyWithImpl(this._self, this._then);

  final TxTemplate _self;
  final $Res Function(TxTemplate) _then;

/// Create a copy of TxTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? type = null,Object? accountId = null,Object? id = freezed,Object? amount = freezed,Object? toAccountId = freezed,Object? categoryId = freezed,Object? plannedStatus = freezed,Object? spendingType = freezed,Object? note = freezed,Object? isFavorite = null,Object? sortOrder = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,toAccountId: freezed == toAccountId ? _self.toAccountId : toAccountId // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,plannedStatus: freezed == plannedStatus ? _self.plannedStatus : plannedStatus // ignore: cast_nullable_to_non_nullable
as PlannedStatus?,spendingType: freezed == spendingType ? _self.spendingType : spendingType // ignore: cast_nullable_to_non_nullable
as SpendingType?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TxTemplate].
extension TxTemplatePatterns on TxTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TxTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TxTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TxTemplate value)  $default,){
final _that = this;
switch (_that) {
case _TxTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TxTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _TxTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  TransactionType type,  int accountId,  int? id,  int? amount,  int? toAccountId,  int? categoryId,  PlannedStatus? plannedStatus,  SpendingType? spendingType,  String? note,  bool isFavorite,  int sortOrder,  int createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TxTemplate() when $default != null:
return $default(_that.label,_that.type,_that.accountId,_that.id,_that.amount,_that.toAccountId,_that.categoryId,_that.plannedStatus,_that.spendingType,_that.note,_that.isFavorite,_that.sortOrder,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  TransactionType type,  int accountId,  int? id,  int? amount,  int? toAccountId,  int? categoryId,  PlannedStatus? plannedStatus,  SpendingType? spendingType,  String? note,  bool isFavorite,  int sortOrder,  int createdAt)  $default,) {final _that = this;
switch (_that) {
case _TxTemplate():
return $default(_that.label,_that.type,_that.accountId,_that.id,_that.amount,_that.toAccountId,_that.categoryId,_that.plannedStatus,_that.spendingType,_that.note,_that.isFavorite,_that.sortOrder,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  TransactionType type,  int accountId,  int? id,  int? amount,  int? toAccountId,  int? categoryId,  PlannedStatus? plannedStatus,  SpendingType? spendingType,  String? note,  bool isFavorite,  int sortOrder,  int createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TxTemplate() when $default != null:
return $default(_that.label,_that.type,_that.accountId,_that.id,_that.amount,_that.toAccountId,_that.categoryId,_that.plannedStatus,_that.spendingType,_that.note,_that.isFavorite,_that.sortOrder,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _TxTemplate implements TxTemplate {
  const _TxTemplate({required this.label, required this.type, required this.accountId, this.id, this.amount, this.toAccountId, this.categoryId, this.plannedStatus, this.spendingType, this.note, this.isFavorite = true, this.sortOrder = 0, this.createdAt = 0});
  

@override final  String label;
@override final  TransactionType type;
/// Source account id (the "From" account for a transfer).
@override final  int accountId;
/// `null` until persisted (SQLite AUTOINCREMENT assigns it on insert).
@override final  int? id;
/// Positive rupiah amount, or `null` = ask at use (the prefill path).
@override final  int? amount;
/// Destination account id — transfer only.
@override final  int? toAccountId;
/// Category id — expense / income only.
@override final  int? categoryId;
/// Planned vs. unplanned — expense only.
@override final  PlannedStatus? plannedStatus;
/// Need / want / lifestyle / emergency — expense only.
@override final  SpendingType? spendingType;
@override final  String? note;
/// `true` (int 1) = a Home favorite; `false` (int 0) = M5 schedule-only.
@override@JsonKey() final  bool isFavorite;
@override@JsonKey() final  int sortOrder;
@override@JsonKey() final  int createdAt;

/// Create a copy of TxTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TxTemplateCopyWith<_TxTemplate> get copyWith => __$TxTemplateCopyWithImpl<_TxTemplate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TxTemplate&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.toAccountId, toAccountId) || other.toAccountId == toAccountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType)&&(identical(other.note, note) || other.note == note)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,label,type,accountId,id,amount,toAccountId,categoryId,plannedStatus,spendingType,note,isFavorite,sortOrder,createdAt);

@override
String toString() {
  return 'TxTemplate(label: $label, type: $type, accountId: $accountId, id: $id, amount: $amount, toAccountId: $toAccountId, categoryId: $categoryId, plannedStatus: $plannedStatus, spendingType: $spendingType, note: $note, isFavorite: $isFavorite, sortOrder: $sortOrder, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TxTemplateCopyWith<$Res> implements $TxTemplateCopyWith<$Res> {
  factory _$TxTemplateCopyWith(_TxTemplate value, $Res Function(_TxTemplate) _then) = __$TxTemplateCopyWithImpl;
@override @useResult
$Res call({
 String label, TransactionType type, int accountId, int? id, int? amount, int? toAccountId, int? categoryId, PlannedStatus? plannedStatus, SpendingType? spendingType, String? note, bool isFavorite, int sortOrder, int createdAt
});




}
/// @nodoc
class __$TxTemplateCopyWithImpl<$Res>
    implements _$TxTemplateCopyWith<$Res> {
  __$TxTemplateCopyWithImpl(this._self, this._then);

  final _TxTemplate _self;
  final $Res Function(_TxTemplate) _then;

/// Create a copy of TxTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? type = null,Object? accountId = null,Object? id = freezed,Object? amount = freezed,Object? toAccountId = freezed,Object? categoryId = freezed,Object? plannedStatus = freezed,Object? spendingType = freezed,Object? note = freezed,Object? isFavorite = null,Object? sortOrder = null,Object? createdAt = null,}) {
  return _then(_TxTemplate(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,toAccountId: freezed == toAccountId ? _self.toAccountId : toAccountId // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,plannedStatus: freezed == plannedStatus ? _self.plannedStatus : plannedStatus // ignore: cast_nullable_to_non_nullable
as PlannedStatus?,spendingType: freezed == spendingType ? _self.spendingType : spendingType // ignore: cast_nullable_to_non_nullable
as SpendingType?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
