// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExportOptions {

 ExportDatePreset get preset; int? get customStart; int? get customEnd; int? get accountId; int? get categoryId; TransactionType? get type; PlannedStatus? get plannedStatus; SpendingType? get spendingType;
/// Create a copy of ExportOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportOptionsCopyWith<ExportOptions> get copyWith => _$ExportOptionsCopyWithImpl<ExportOptions>(this as ExportOptions, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportOptions&&(identical(other.preset, preset) || other.preset == preset)&&(identical(other.customStart, customStart) || other.customStart == customStart)&&(identical(other.customEnd, customEnd) || other.customEnd == customEnd)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.type, type) || other.type == type)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType));
}


@override
int get hashCode => Object.hash(runtimeType,preset,customStart,customEnd,accountId,categoryId,type,plannedStatus,spendingType);

@override
String toString() {
  return 'ExportOptions(preset: $preset, customStart: $customStart, customEnd: $customEnd, accountId: $accountId, categoryId: $categoryId, type: $type, plannedStatus: $plannedStatus, spendingType: $spendingType)';
}


}

/// @nodoc
abstract mixin class $ExportOptionsCopyWith<$Res>  {
  factory $ExportOptionsCopyWith(ExportOptions value, $Res Function(ExportOptions) _then) = _$ExportOptionsCopyWithImpl;
@useResult
$Res call({
 ExportDatePreset preset, int? customStart, int? customEnd, int? accountId, int? categoryId, TransactionType? type, PlannedStatus? plannedStatus, SpendingType? spendingType
});




}
/// @nodoc
class _$ExportOptionsCopyWithImpl<$Res>
    implements $ExportOptionsCopyWith<$Res> {
  _$ExportOptionsCopyWithImpl(this._self, this._then);

  final ExportOptions _self;
  final $Res Function(ExportOptions) _then;

/// Create a copy of ExportOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? preset = null,Object? customStart = freezed,Object? customEnd = freezed,Object? accountId = freezed,Object? categoryId = freezed,Object? type = freezed,Object? plannedStatus = freezed,Object? spendingType = freezed,}) {
  return _then(_self.copyWith(
preset: null == preset ? _self.preset : preset // ignore: cast_nullable_to_non_nullable
as ExportDatePreset,customStart: freezed == customStart ? _self.customStart : customStart // ignore: cast_nullable_to_non_nullable
as int?,customEnd: freezed == customEnd ? _self.customEnd : customEnd // ignore: cast_nullable_to_non_nullable
as int?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType?,plannedStatus: freezed == plannedStatus ? _self.plannedStatus : plannedStatus // ignore: cast_nullable_to_non_nullable
as PlannedStatus?,spendingType: freezed == spendingType ? _self.spendingType : spendingType // ignore: cast_nullable_to_non_nullable
as SpendingType?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportOptions].
extension ExportOptionsPatterns on ExportOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportOptions value)  $default,){
final _that = this;
switch (_that) {
case _ExportOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportOptions value)?  $default,){
final _that = this;
switch (_that) {
case _ExportOptions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ExportDatePreset preset,  int? customStart,  int? customEnd,  int? accountId,  int? categoryId,  TransactionType? type,  PlannedStatus? plannedStatus,  SpendingType? spendingType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportOptions() when $default != null:
return $default(_that.preset,_that.customStart,_that.customEnd,_that.accountId,_that.categoryId,_that.type,_that.plannedStatus,_that.spendingType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ExportDatePreset preset,  int? customStart,  int? customEnd,  int? accountId,  int? categoryId,  TransactionType? type,  PlannedStatus? plannedStatus,  SpendingType? spendingType)  $default,) {final _that = this;
switch (_that) {
case _ExportOptions():
return $default(_that.preset,_that.customStart,_that.customEnd,_that.accountId,_that.categoryId,_that.type,_that.plannedStatus,_that.spendingType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ExportDatePreset preset,  int? customStart,  int? customEnd,  int? accountId,  int? categoryId,  TransactionType? type,  PlannedStatus? plannedStatus,  SpendingType? spendingType)?  $default,) {final _that = this;
switch (_that) {
case _ExportOptions() when $default != null:
return $default(_that.preset,_that.customStart,_that.customEnd,_that.accountId,_that.categoryId,_that.type,_that.plannedStatus,_that.spendingType);case _:
  return null;

}
}

}

/// @nodoc


class _ExportOptions extends ExportOptions {
  const _ExportOptions({this.preset = ExportDatePreset.thisMonth, this.customStart, this.customEnd, this.accountId, this.categoryId, this.type, this.plannedStatus, this.spendingType}): super._();
  

@override@JsonKey() final  ExportDatePreset preset;
@override final  int? customStart;
@override final  int? customEnd;
@override final  int? accountId;
@override final  int? categoryId;
@override final  TransactionType? type;
@override final  PlannedStatus? plannedStatus;
@override final  SpendingType? spendingType;

/// Create a copy of ExportOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportOptionsCopyWith<_ExportOptions> get copyWith => __$ExportOptionsCopyWithImpl<_ExportOptions>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportOptions&&(identical(other.preset, preset) || other.preset == preset)&&(identical(other.customStart, customStart) || other.customStart == customStart)&&(identical(other.customEnd, customEnd) || other.customEnd == customEnd)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.type, type) || other.type == type)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType));
}


@override
int get hashCode => Object.hash(runtimeType,preset,customStart,customEnd,accountId,categoryId,type,plannedStatus,spendingType);

@override
String toString() {
  return 'ExportOptions(preset: $preset, customStart: $customStart, customEnd: $customEnd, accountId: $accountId, categoryId: $categoryId, type: $type, plannedStatus: $plannedStatus, spendingType: $spendingType)';
}


}

/// @nodoc
abstract mixin class _$ExportOptionsCopyWith<$Res> implements $ExportOptionsCopyWith<$Res> {
  factory _$ExportOptionsCopyWith(_ExportOptions value, $Res Function(_ExportOptions) _then) = __$ExportOptionsCopyWithImpl;
@override @useResult
$Res call({
 ExportDatePreset preset, int? customStart, int? customEnd, int? accountId, int? categoryId, TransactionType? type, PlannedStatus? plannedStatus, SpendingType? spendingType
});




}
/// @nodoc
class __$ExportOptionsCopyWithImpl<$Res>
    implements _$ExportOptionsCopyWith<$Res> {
  __$ExportOptionsCopyWithImpl(this._self, this._then);

  final _ExportOptions _self;
  final $Res Function(_ExportOptions) _then;

/// Create a copy of ExportOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? preset = null,Object? customStart = freezed,Object? customEnd = freezed,Object? accountId = freezed,Object? categoryId = freezed,Object? type = freezed,Object? plannedStatus = freezed,Object? spendingType = freezed,}) {
  return _then(_ExportOptions(
preset: null == preset ? _self.preset : preset // ignore: cast_nullable_to_non_nullable
as ExportDatePreset,customStart: freezed == customStart ? _self.customStart : customStart // ignore: cast_nullable_to_non_nullable
as int?,customEnd: freezed == customEnd ? _self.customEnd : customEnd // ignore: cast_nullable_to_non_nullable
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
