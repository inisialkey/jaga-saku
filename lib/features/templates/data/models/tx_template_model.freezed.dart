// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tx_template_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TxTemplateModel {

 String get label; TransactionType get type; int get accountId; int? get id; int? get amount; int? get toAccountId; int? get categoryId; PlannedStatus? get plannedStatus; SpendingType? get spendingType; String? get note; bool get isFavorite; int get sortOrder; int get createdAt;
/// Create a copy of TxTemplateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TxTemplateModelCopyWith<TxTemplateModel> get copyWith => _$TxTemplateModelCopyWithImpl<TxTemplateModel>(this as TxTemplateModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TxTemplateModel&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.toAccountId, toAccountId) || other.toAccountId == toAccountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType)&&(identical(other.note, note) || other.note == note)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,label,type,accountId,id,amount,toAccountId,categoryId,plannedStatus,spendingType,note,isFavorite,sortOrder,createdAt);

@override
String toString() {
  return 'TxTemplateModel(label: $label, type: $type, accountId: $accountId, id: $id, amount: $amount, toAccountId: $toAccountId, categoryId: $categoryId, plannedStatus: $plannedStatus, spendingType: $spendingType, note: $note, isFavorite: $isFavorite, sortOrder: $sortOrder, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TxTemplateModelCopyWith<$Res>  {
  factory $TxTemplateModelCopyWith(TxTemplateModel value, $Res Function(TxTemplateModel) _then) = _$TxTemplateModelCopyWithImpl;
@useResult
$Res call({
 String label, TransactionType type, int accountId, int? id, int? amount, int? toAccountId, int? categoryId, PlannedStatus? plannedStatus, SpendingType? spendingType, String? note, bool isFavorite, int sortOrder, int createdAt
});




}
/// @nodoc
class _$TxTemplateModelCopyWithImpl<$Res>
    implements $TxTemplateModelCopyWith<$Res> {
  _$TxTemplateModelCopyWithImpl(this._self, this._then);

  final TxTemplateModel _self;
  final $Res Function(TxTemplateModel) _then;

/// Create a copy of TxTemplateModel
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


/// Adds pattern-matching-related methods to [TxTemplateModel].
extension TxTemplateModelPatterns on TxTemplateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TxTemplateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TxTemplateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TxTemplateModel value)  $default,){
final _that = this;
switch (_that) {
case _TxTemplateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TxTemplateModel value)?  $default,){
final _that = this;
switch (_that) {
case _TxTemplateModel() when $default != null:
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
case _TxTemplateModel() when $default != null:
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
case _TxTemplateModel():
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
case _TxTemplateModel() when $default != null:
return $default(_that.label,_that.type,_that.accountId,_that.id,_that.amount,_that.toAccountId,_that.categoryId,_that.plannedStatus,_that.spendingType,_that.note,_that.isFavorite,_that.sortOrder,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _TxTemplateModel extends TxTemplateModel {
  const _TxTemplateModel({required this.label, required this.type, required this.accountId, this.id, this.amount, this.toAccountId, this.categoryId, this.plannedStatus, this.spendingType, this.note, this.isFavorite = true, this.sortOrder = 0, this.createdAt = 0}): super._();
  

@override final  String label;
@override final  TransactionType type;
@override final  int accountId;
@override final  int? id;
@override final  int? amount;
@override final  int? toAccountId;
@override final  int? categoryId;
@override final  PlannedStatus? plannedStatus;
@override final  SpendingType? spendingType;
@override final  String? note;
@override@JsonKey() final  bool isFavorite;
@override@JsonKey() final  int sortOrder;
@override@JsonKey() final  int createdAt;

/// Create a copy of TxTemplateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TxTemplateModelCopyWith<_TxTemplateModel> get copyWith => __$TxTemplateModelCopyWithImpl<_TxTemplateModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TxTemplateModel&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.toAccountId, toAccountId) || other.toAccountId == toAccountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType)&&(identical(other.note, note) || other.note == note)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,label,type,accountId,id,amount,toAccountId,categoryId,plannedStatus,spendingType,note,isFavorite,sortOrder,createdAt);

@override
String toString() {
  return 'TxTemplateModel(label: $label, type: $type, accountId: $accountId, id: $id, amount: $amount, toAccountId: $toAccountId, categoryId: $categoryId, plannedStatus: $plannedStatus, spendingType: $spendingType, note: $note, isFavorite: $isFavorite, sortOrder: $sortOrder, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TxTemplateModelCopyWith<$Res> implements $TxTemplateModelCopyWith<$Res> {
  factory _$TxTemplateModelCopyWith(_TxTemplateModel value, $Res Function(_TxTemplateModel) _then) = __$TxTemplateModelCopyWithImpl;
@override @useResult
$Res call({
 String label, TransactionType type, int accountId, int? id, int? amount, int? toAccountId, int? categoryId, PlannedStatus? plannedStatus, SpendingType? spendingType, String? note, bool isFavorite, int sortOrder, int createdAt
});




}
/// @nodoc
class __$TxTemplateModelCopyWithImpl<$Res>
    implements _$TxTemplateModelCopyWith<$Res> {
  __$TxTemplateModelCopyWithImpl(this._self, this._then);

  final _TxTemplateModel _self;
  final $Res Function(_TxTemplateModel) _then;

/// Create a copy of TxTemplateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? type = null,Object? accountId = null,Object? id = freezed,Object? amount = freezed,Object? toAccountId = freezed,Object? categoryId = freezed,Object? plannedStatus = freezed,Object? spendingType = freezed,Object? note = freezed,Object? isFavorite = null,Object? sortOrder = null,Object? createdAt = null,}) {
  return _then(_TxTemplateModel(
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
