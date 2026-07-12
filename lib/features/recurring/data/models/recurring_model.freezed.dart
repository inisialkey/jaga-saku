// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecurringModel {

 int get templateId; RecurrenceFreq get freq; int get startDate; int get nextDue; int? get id; int get interval; int? get endDate; int get createdAt;
/// Create a copy of RecurringModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringModelCopyWith<RecurringModel> get copyWith => _$RecurringModelCopyWithImpl<RecurringModel>(this as RecurringModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringModel&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.freq, freq) || other.freq == freq)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.nextDue, nextDue) || other.nextDue == nextDue)&&(identical(other.id, id) || other.id == id)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,templateId,freq,startDate,nextDue,id,interval,endDate,createdAt);

@override
String toString() {
  return 'RecurringModel(templateId: $templateId, freq: $freq, startDate: $startDate, nextDue: $nextDue, id: $id, interval: $interval, endDate: $endDate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RecurringModelCopyWith<$Res>  {
  factory $RecurringModelCopyWith(RecurringModel value, $Res Function(RecurringModel) _then) = _$RecurringModelCopyWithImpl;
@useResult
$Res call({
 int templateId, RecurrenceFreq freq, int startDate, int nextDue, int? id, int interval, int? endDate, int createdAt
});




}
/// @nodoc
class _$RecurringModelCopyWithImpl<$Res>
    implements $RecurringModelCopyWith<$Res> {
  _$RecurringModelCopyWithImpl(this._self, this._then);

  final RecurringModel _self;
  final $Res Function(RecurringModel) _then;

/// Create a copy of RecurringModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? templateId = null,Object? freq = null,Object? startDate = null,Object? nextDue = null,Object? id = freezed,Object? interval = null,Object? endDate = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as int,freq: null == freq ? _self.freq : freq // ignore: cast_nullable_to_non_nullable
as RecurrenceFreq,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as int,nextDue: null == nextDue ? _self.nextDue : nextDue // ignore: cast_nullable_to_non_nullable
as int,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurringModel].
extension RecurringModelPatterns on RecurringModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringModel value)  $default,){
final _that = this;
switch (_that) {
case _RecurringModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringModel value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int templateId,  RecurrenceFreq freq,  int startDate,  int nextDue,  int? id,  int interval,  int? endDate,  int createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringModel() when $default != null:
return $default(_that.templateId,_that.freq,_that.startDate,_that.nextDue,_that.id,_that.interval,_that.endDate,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int templateId,  RecurrenceFreq freq,  int startDate,  int nextDue,  int? id,  int interval,  int? endDate,  int createdAt)  $default,) {final _that = this;
switch (_that) {
case _RecurringModel():
return $default(_that.templateId,_that.freq,_that.startDate,_that.nextDue,_that.id,_that.interval,_that.endDate,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int templateId,  RecurrenceFreq freq,  int startDate,  int nextDue,  int? id,  int interval,  int? endDate,  int createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RecurringModel() when $default != null:
return $default(_that.templateId,_that.freq,_that.startDate,_that.nextDue,_that.id,_that.interval,_that.endDate,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _RecurringModel extends RecurringModel {
  const _RecurringModel({required this.templateId, required this.freq, required this.startDate, required this.nextDue, this.id, this.interval = 1, this.endDate, this.createdAt = 0}): super._();
  

@override final  int templateId;
@override final  RecurrenceFreq freq;
@override final  int startDate;
@override final  int nextDue;
@override final  int? id;
@override@JsonKey() final  int interval;
@override final  int? endDate;
@override@JsonKey() final  int createdAt;

/// Create a copy of RecurringModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringModelCopyWith<_RecurringModel> get copyWith => __$RecurringModelCopyWithImpl<_RecurringModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringModel&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.freq, freq) || other.freq == freq)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.nextDue, nextDue) || other.nextDue == nextDue)&&(identical(other.id, id) || other.id == id)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,templateId,freq,startDate,nextDue,id,interval,endDate,createdAt);

@override
String toString() {
  return 'RecurringModel(templateId: $templateId, freq: $freq, startDate: $startDate, nextDue: $nextDue, id: $id, interval: $interval, endDate: $endDate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RecurringModelCopyWith<$Res> implements $RecurringModelCopyWith<$Res> {
  factory _$RecurringModelCopyWith(_RecurringModel value, $Res Function(_RecurringModel) _then) = __$RecurringModelCopyWithImpl;
@override @useResult
$Res call({
 int templateId, RecurrenceFreq freq, int startDate, int nextDue, int? id, int interval, int? endDate, int createdAt
});




}
/// @nodoc
class __$RecurringModelCopyWithImpl<$Res>
    implements _$RecurringModelCopyWith<$Res> {
  __$RecurringModelCopyWithImpl(this._self, this._then);

  final _RecurringModel _self;
  final $Res Function(_RecurringModel) _then;

/// Create a copy of RecurringModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? templateId = null,Object? freq = null,Object? startDate = null,Object? nextDue = null,Object? id = freezed,Object? interval = null,Object? endDate = freezed,Object? createdAt = null,}) {
  return _then(_RecurringModel(
templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as int,freq: null == freq ? _self.freq : freq // ignore: cast_nullable_to_non_nullable
as RecurrenceFreq,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as int,nextDue: null == nextDue ? _self.nextDue : nextDue // ignore: cast_nullable_to_non_nullable
as int,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
