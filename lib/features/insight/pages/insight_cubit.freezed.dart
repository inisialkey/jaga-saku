// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insight_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategorySlice {

 int get categoryId; String get name; int get amount; double get pct;/// ARGB color of the category (drives the donut wedge + legend avatar).
 int? get color;
/// Create a copy of CategorySlice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategorySliceCopyWith<CategorySlice> get copyWith => _$CategorySliceCopyWithImpl<CategorySlice>(this as CategorySlice, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategorySlice&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.pct, pct) || other.pct == pct)&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,name,amount,pct,color);

@override
String toString() {
  return 'CategorySlice(categoryId: $categoryId, name: $name, amount: $amount, pct: $pct, color: $color)';
}


}

/// @nodoc
abstract mixin class $CategorySliceCopyWith<$Res>  {
  factory $CategorySliceCopyWith(CategorySlice value, $Res Function(CategorySlice) _then) = _$CategorySliceCopyWithImpl;
@useResult
$Res call({
 int categoryId, String name, int amount, double pct, int? color
});




}
/// @nodoc
class _$CategorySliceCopyWithImpl<$Res>
    implements $CategorySliceCopyWith<$Res> {
  _$CategorySliceCopyWithImpl(this._self, this._then);

  final CategorySlice _self;
  final $Res Function(CategorySlice) _then;

/// Create a copy of CategorySlice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? name = null,Object? amount = null,Object? pct = null,Object? color = freezed,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,pct: null == pct ? _self.pct : pct // ignore: cast_nullable_to_non_nullable
as double,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategorySlice].
extension CategorySlicePatterns on CategorySlice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategorySlice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategorySlice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategorySlice value)  $default,){
final _that = this;
switch (_that) {
case _CategorySlice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategorySlice value)?  $default,){
final _that = this;
switch (_that) {
case _CategorySlice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int categoryId,  String name,  int amount,  double pct,  int? color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategorySlice() when $default != null:
return $default(_that.categoryId,_that.name,_that.amount,_that.pct,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int categoryId,  String name,  int amount,  double pct,  int? color)  $default,) {final _that = this;
switch (_that) {
case _CategorySlice():
return $default(_that.categoryId,_that.name,_that.amount,_that.pct,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int categoryId,  String name,  int amount,  double pct,  int? color)?  $default,) {final _that = this;
switch (_that) {
case _CategorySlice() when $default != null:
return $default(_that.categoryId,_that.name,_that.amount,_that.pct,_that.color);case _:
  return null;

}
}

}

/// @nodoc


class _CategorySlice implements CategorySlice {
  const _CategorySlice({required this.categoryId, required this.name, required this.amount, required this.pct, this.color});
  

@override final  int categoryId;
@override final  String name;
@override final  int amount;
@override final  double pct;
/// ARGB color of the category (drives the donut wedge + legend avatar).
@override final  int? color;

/// Create a copy of CategorySlice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategorySliceCopyWith<_CategorySlice> get copyWith => __$CategorySliceCopyWithImpl<_CategorySlice>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategorySlice&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.pct, pct) || other.pct == pct)&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,name,amount,pct,color);

@override
String toString() {
  return 'CategorySlice(categoryId: $categoryId, name: $name, amount: $amount, pct: $pct, color: $color)';
}


}

/// @nodoc
abstract mixin class _$CategorySliceCopyWith<$Res> implements $CategorySliceCopyWith<$Res> {
  factory _$CategorySliceCopyWith(_CategorySlice value, $Res Function(_CategorySlice) _then) = __$CategorySliceCopyWithImpl;
@override @useResult
$Res call({
 int categoryId, String name, int amount, double pct, int? color
});




}
/// @nodoc
class __$CategorySliceCopyWithImpl<$Res>
    implements _$CategorySliceCopyWith<$Res> {
  __$CategorySliceCopyWithImpl(this._self, this._then);

  final _CategorySlice _self;
  final $Res Function(_CategorySlice) _then;

/// Create a copy of CategorySlice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? name = null,Object? amount = null,Object? pct = null,Object? color = freezed,}) {
  return _then(_CategorySlice(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,pct: null == pct ? _self.pct : pct // ignore: cast_nullable_to_non_nullable
as double,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$PlannedSplit {

 int get planned; int get unplanned; double get plannedPct; double get unplannedPct;
/// Create a copy of PlannedSplit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlannedSplitCopyWith<PlannedSplit> get copyWith => _$PlannedSplitCopyWithImpl<PlannedSplit>(this as PlannedSplit, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlannedSplit&&(identical(other.planned, planned) || other.planned == planned)&&(identical(other.unplanned, unplanned) || other.unplanned == unplanned)&&(identical(other.plannedPct, plannedPct) || other.plannedPct == plannedPct)&&(identical(other.unplannedPct, unplannedPct) || other.unplannedPct == unplannedPct));
}


@override
int get hashCode => Object.hash(runtimeType,planned,unplanned,plannedPct,unplannedPct);

@override
String toString() {
  return 'PlannedSplit(planned: $planned, unplanned: $unplanned, plannedPct: $plannedPct, unplannedPct: $unplannedPct)';
}


}

/// @nodoc
abstract mixin class $PlannedSplitCopyWith<$Res>  {
  factory $PlannedSplitCopyWith(PlannedSplit value, $Res Function(PlannedSplit) _then) = _$PlannedSplitCopyWithImpl;
@useResult
$Res call({
 int planned, int unplanned, double plannedPct, double unplannedPct
});




}
/// @nodoc
class _$PlannedSplitCopyWithImpl<$Res>
    implements $PlannedSplitCopyWith<$Res> {
  _$PlannedSplitCopyWithImpl(this._self, this._then);

  final PlannedSplit _self;
  final $Res Function(PlannedSplit) _then;

/// Create a copy of PlannedSplit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? planned = null,Object? unplanned = null,Object? plannedPct = null,Object? unplannedPct = null,}) {
  return _then(_self.copyWith(
planned: null == planned ? _self.planned : planned // ignore: cast_nullable_to_non_nullable
as int,unplanned: null == unplanned ? _self.unplanned : unplanned // ignore: cast_nullable_to_non_nullable
as int,plannedPct: null == plannedPct ? _self.plannedPct : plannedPct // ignore: cast_nullable_to_non_nullable
as double,unplannedPct: null == unplannedPct ? _self.unplannedPct : unplannedPct // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PlannedSplit].
extension PlannedSplitPatterns on PlannedSplit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlannedSplit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlannedSplit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlannedSplit value)  $default,){
final _that = this;
switch (_that) {
case _PlannedSplit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlannedSplit value)?  $default,){
final _that = this;
switch (_that) {
case _PlannedSplit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int planned,  int unplanned,  double plannedPct,  double unplannedPct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlannedSplit() when $default != null:
return $default(_that.planned,_that.unplanned,_that.plannedPct,_that.unplannedPct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int planned,  int unplanned,  double plannedPct,  double unplannedPct)  $default,) {final _that = this;
switch (_that) {
case _PlannedSplit():
return $default(_that.planned,_that.unplanned,_that.plannedPct,_that.unplannedPct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int planned,  int unplanned,  double plannedPct,  double unplannedPct)?  $default,) {final _that = this;
switch (_that) {
case _PlannedSplit() when $default != null:
return $default(_that.planned,_that.unplanned,_that.plannedPct,_that.unplannedPct);case _:
  return null;

}
}

}

/// @nodoc


class _PlannedSplit extends PlannedSplit {
  const _PlannedSplit({this.planned = 0, this.unplanned = 0, this.plannedPct = 0, this.unplannedPct = 0}): super._();
  

@override@JsonKey() final  int planned;
@override@JsonKey() final  int unplanned;
@override@JsonKey() final  double plannedPct;
@override@JsonKey() final  double unplannedPct;

/// Create a copy of PlannedSplit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlannedSplitCopyWith<_PlannedSplit> get copyWith => __$PlannedSplitCopyWithImpl<_PlannedSplit>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlannedSplit&&(identical(other.planned, planned) || other.planned == planned)&&(identical(other.unplanned, unplanned) || other.unplanned == unplanned)&&(identical(other.plannedPct, plannedPct) || other.plannedPct == plannedPct)&&(identical(other.unplannedPct, unplannedPct) || other.unplannedPct == unplannedPct));
}


@override
int get hashCode => Object.hash(runtimeType,planned,unplanned,plannedPct,unplannedPct);

@override
String toString() {
  return 'PlannedSplit(planned: $planned, unplanned: $unplanned, plannedPct: $plannedPct, unplannedPct: $unplannedPct)';
}


}

/// @nodoc
abstract mixin class _$PlannedSplitCopyWith<$Res> implements $PlannedSplitCopyWith<$Res> {
  factory _$PlannedSplitCopyWith(_PlannedSplit value, $Res Function(_PlannedSplit) _then) = __$PlannedSplitCopyWithImpl;
@override @useResult
$Res call({
 int planned, int unplanned, double plannedPct, double unplannedPct
});




}
/// @nodoc
class __$PlannedSplitCopyWithImpl<$Res>
    implements _$PlannedSplitCopyWith<$Res> {
  __$PlannedSplitCopyWithImpl(this._self, this._then);

  final _PlannedSplit _self;
  final $Res Function(_PlannedSplit) _then;

/// Create a copy of PlannedSplit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? planned = null,Object? unplanned = null,Object? plannedPct = null,Object? unplannedPct = null,}) {
  return _then(_PlannedSplit(
planned: null == planned ? _self.planned : planned // ignore: cast_nullable_to_non_nullable
as int,unplanned: null == unplanned ? _self.unplanned : unplanned // ignore: cast_nullable_to_non_nullable
as int,plannedPct: null == plannedPct ? _self.plannedPct : plannedPct // ignore: cast_nullable_to_non_nullable
as double,unplannedPct: null == unplannedPct ? _self.unplannedPct : unplannedPct // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$SpendingSlice {

 int get amount; double get pct;
/// Create a copy of SpendingSlice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpendingSliceCopyWith<SpendingSlice> get copyWith => _$SpendingSliceCopyWithImpl<SpendingSlice>(this as SpendingSlice, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpendingSlice&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.pct, pct) || other.pct == pct));
}


@override
int get hashCode => Object.hash(runtimeType,amount,pct);

@override
String toString() {
  return 'SpendingSlice(amount: $amount, pct: $pct)';
}


}

/// @nodoc
abstract mixin class $SpendingSliceCopyWith<$Res>  {
  factory $SpendingSliceCopyWith(SpendingSlice value, $Res Function(SpendingSlice) _then) = _$SpendingSliceCopyWithImpl;
@useResult
$Res call({
 int amount, double pct
});




}
/// @nodoc
class _$SpendingSliceCopyWithImpl<$Res>
    implements $SpendingSliceCopyWith<$Res> {
  _$SpendingSliceCopyWithImpl(this._self, this._then);

  final SpendingSlice _self;
  final $Res Function(SpendingSlice) _then;

/// Create a copy of SpendingSlice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = null,Object? pct = null,}) {
  return _then(_self.copyWith(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,pct: null == pct ? _self.pct : pct // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SpendingSlice].
extension SpendingSlicePatterns on SpendingSlice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpendingSlice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpendingSlice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpendingSlice value)  $default,){
final _that = this;
switch (_that) {
case _SpendingSlice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpendingSlice value)?  $default,){
final _that = this;
switch (_that) {
case _SpendingSlice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int amount,  double pct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpendingSlice() when $default != null:
return $default(_that.amount,_that.pct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int amount,  double pct)  $default,) {final _that = this;
switch (_that) {
case _SpendingSlice():
return $default(_that.amount,_that.pct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int amount,  double pct)?  $default,) {final _that = this;
switch (_that) {
case _SpendingSlice() when $default != null:
return $default(_that.amount,_that.pct);case _:
  return null;

}
}

}

/// @nodoc


class _SpendingSlice implements SpendingSlice {
  const _SpendingSlice({required this.amount, required this.pct});
  

@override final  int amount;
@override final  double pct;

/// Create a copy of SpendingSlice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpendingSliceCopyWith<_SpendingSlice> get copyWith => __$SpendingSliceCopyWithImpl<_SpendingSlice>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpendingSlice&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.pct, pct) || other.pct == pct));
}


@override
int get hashCode => Object.hash(runtimeType,amount,pct);

@override
String toString() {
  return 'SpendingSlice(amount: $amount, pct: $pct)';
}


}

/// @nodoc
abstract mixin class _$SpendingSliceCopyWith<$Res> implements $SpendingSliceCopyWith<$Res> {
  factory _$SpendingSliceCopyWith(_SpendingSlice value, $Res Function(_SpendingSlice) _then) = __$SpendingSliceCopyWithImpl;
@override @useResult
$Res call({
 int amount, double pct
});




}
/// @nodoc
class __$SpendingSliceCopyWithImpl<$Res>
    implements _$SpendingSliceCopyWith<$Res> {
  __$SpendingSliceCopyWithImpl(this._self, this._then);

  final _SpendingSlice _self;
  final $Res Function(_SpendingSlice) _then;

/// Create a copy of SpendingSlice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? pct = null,}) {
  return _then(_SpendingSlice(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,pct: null == pct ? _self.pct : pct // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$InsightReport {

/// The month this report covers (first-of-month), for the header selector.
 DateTime get month;/// Monthly overview totals (transfers excluded from both).
 int get income; int get expense;/// income − expense (can be negative — a display concern of `MoneyText`).
 int get saved;/// Expense-by-category wedges, sorted by amount desc. Empty → donut empty
/// state.
 List<CategorySlice> get expenseByCategory;/// Planned vs. unplanned split of the typed expense subset.
 PlannedSplit get plannedVsUnplanned;/// Need/want/lifestyle/emergency shares of the typed expense subset (only
/// the types that occur are present).
 Map<SpendingType, SpendingSlice> get needVsWant;/// Fired spending-insight cards (only rules that fired — may be empty).
 List<InsightItem> get insights;/// id → Category lookup used to resolve names/colors on the legend.
 Map<int, Category> get categoriesById;
/// Create a copy of InsightReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InsightReportCopyWith<InsightReport> get copyWith => _$InsightReportCopyWithImpl<InsightReport>(this as InsightReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsightReport&&(identical(other.month, month) || other.month == month)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.saved, saved) || other.saved == saved)&&const DeepCollectionEquality().equals(other.expenseByCategory, expenseByCategory)&&(identical(other.plannedVsUnplanned, plannedVsUnplanned) || other.plannedVsUnplanned == plannedVsUnplanned)&&const DeepCollectionEquality().equals(other.needVsWant, needVsWant)&&const DeepCollectionEquality().equals(other.insights, insights)&&const DeepCollectionEquality().equals(other.categoriesById, categoriesById));
}


@override
int get hashCode => Object.hash(runtimeType,month,income,expense,saved,const DeepCollectionEquality().hash(expenseByCategory),plannedVsUnplanned,const DeepCollectionEquality().hash(needVsWant),const DeepCollectionEquality().hash(insights),const DeepCollectionEquality().hash(categoriesById));

@override
String toString() {
  return 'InsightReport(month: $month, income: $income, expense: $expense, saved: $saved, expenseByCategory: $expenseByCategory, plannedVsUnplanned: $plannedVsUnplanned, needVsWant: $needVsWant, insights: $insights, categoriesById: $categoriesById)';
}


}

/// @nodoc
abstract mixin class $InsightReportCopyWith<$Res>  {
  factory $InsightReportCopyWith(InsightReport value, $Res Function(InsightReport) _then) = _$InsightReportCopyWithImpl;
@useResult
$Res call({
 DateTime month, int income, int expense, int saved, List<CategorySlice> expenseByCategory, PlannedSplit plannedVsUnplanned, Map<SpendingType, SpendingSlice> needVsWant, List<InsightItem> insights, Map<int, Category> categoriesById
});


$PlannedSplitCopyWith<$Res> get plannedVsUnplanned;

}
/// @nodoc
class _$InsightReportCopyWithImpl<$Res>
    implements $InsightReportCopyWith<$Res> {
  _$InsightReportCopyWithImpl(this._self, this._then);

  final InsightReport _self;
  final $Res Function(InsightReport) _then;

/// Create a copy of InsightReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? income = null,Object? expense = null,Object? saved = null,Object? expenseByCategory = null,Object? plannedVsUnplanned = null,Object? needVsWant = null,Object? insights = null,Object? categoriesById = null,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as int,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as int,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as int,expenseByCategory: null == expenseByCategory ? _self.expenseByCategory : expenseByCategory // ignore: cast_nullable_to_non_nullable
as List<CategorySlice>,plannedVsUnplanned: null == plannedVsUnplanned ? _self.plannedVsUnplanned : plannedVsUnplanned // ignore: cast_nullable_to_non_nullable
as PlannedSplit,needVsWant: null == needVsWant ? _self.needVsWant : needVsWant // ignore: cast_nullable_to_non_nullable
as Map<SpendingType, SpendingSlice>,insights: null == insights ? _self.insights : insights // ignore: cast_nullable_to_non_nullable
as List<InsightItem>,categoriesById: null == categoriesById ? _self.categoriesById : categoriesById // ignore: cast_nullable_to_non_nullable
as Map<int, Category>,
  ));
}
/// Create a copy of InsightReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlannedSplitCopyWith<$Res> get plannedVsUnplanned {
  
  return $PlannedSplitCopyWith<$Res>(_self.plannedVsUnplanned, (value) {
    return _then(_self.copyWith(plannedVsUnplanned: value));
  });
}
}


/// Adds pattern-matching-related methods to [InsightReport].
extension InsightReportPatterns on InsightReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InsightReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InsightReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InsightReport value)  $default,){
final _that = this;
switch (_that) {
case _InsightReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InsightReport value)?  $default,){
final _that = this;
switch (_that) {
case _InsightReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime month,  int income,  int expense,  int saved,  List<CategorySlice> expenseByCategory,  PlannedSplit plannedVsUnplanned,  Map<SpendingType, SpendingSlice> needVsWant,  List<InsightItem> insights,  Map<int, Category> categoriesById)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InsightReport() when $default != null:
return $default(_that.month,_that.income,_that.expense,_that.saved,_that.expenseByCategory,_that.plannedVsUnplanned,_that.needVsWant,_that.insights,_that.categoriesById);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime month,  int income,  int expense,  int saved,  List<CategorySlice> expenseByCategory,  PlannedSplit plannedVsUnplanned,  Map<SpendingType, SpendingSlice> needVsWant,  List<InsightItem> insights,  Map<int, Category> categoriesById)  $default,) {final _that = this;
switch (_that) {
case _InsightReport():
return $default(_that.month,_that.income,_that.expense,_that.saved,_that.expenseByCategory,_that.plannedVsUnplanned,_that.needVsWant,_that.insights,_that.categoriesById);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime month,  int income,  int expense,  int saved,  List<CategorySlice> expenseByCategory,  PlannedSplit plannedVsUnplanned,  Map<SpendingType, SpendingSlice> needVsWant,  List<InsightItem> insights,  Map<int, Category> categoriesById)?  $default,) {final _that = this;
switch (_that) {
case _InsightReport() when $default != null:
return $default(_that.month,_that.income,_that.expense,_that.saved,_that.expenseByCategory,_that.plannedVsUnplanned,_that.needVsWant,_that.insights,_that.categoriesById);case _:
  return null;

}
}

}

/// @nodoc


class _InsightReport extends InsightReport {
  const _InsightReport({required this.month, this.income = 0, this.expense = 0, this.saved = 0, final  List<CategorySlice> expenseByCategory = const <CategorySlice>[], this.plannedVsUnplanned = const PlannedSplit(), final  Map<SpendingType, SpendingSlice> needVsWant = const <SpendingType, SpendingSlice>{}, final  List<InsightItem> insights = const <InsightItem>[], final  Map<int, Category> categoriesById = const <int, Category>{}}): _expenseByCategory = expenseByCategory,_needVsWant = needVsWant,_insights = insights,_categoriesById = categoriesById,super._();
  

/// The month this report covers (first-of-month), for the header selector.
@override final  DateTime month;
/// Monthly overview totals (transfers excluded from both).
@override@JsonKey() final  int income;
@override@JsonKey() final  int expense;
/// income − expense (can be negative — a display concern of `MoneyText`).
@override@JsonKey() final  int saved;
/// Expense-by-category wedges, sorted by amount desc. Empty → donut empty
/// state.
 final  List<CategorySlice> _expenseByCategory;
/// Expense-by-category wedges, sorted by amount desc. Empty → donut empty
/// state.
@override@JsonKey() List<CategorySlice> get expenseByCategory {
  if (_expenseByCategory is EqualUnmodifiableListView) return _expenseByCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expenseByCategory);
}

/// Planned vs. unplanned split of the typed expense subset.
@override@JsonKey() final  PlannedSplit plannedVsUnplanned;
/// Need/want/lifestyle/emergency shares of the typed expense subset (only
/// the types that occur are present).
 final  Map<SpendingType, SpendingSlice> _needVsWant;
/// Need/want/lifestyle/emergency shares of the typed expense subset (only
/// the types that occur are present).
@override@JsonKey() Map<SpendingType, SpendingSlice> get needVsWant {
  if (_needVsWant is EqualUnmodifiableMapView) return _needVsWant;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_needVsWant);
}

/// Fired spending-insight cards (only rules that fired — may be empty).
 final  List<InsightItem> _insights;
/// Fired spending-insight cards (only rules that fired — may be empty).
@override@JsonKey() List<InsightItem> get insights {
  if (_insights is EqualUnmodifiableListView) return _insights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_insights);
}

/// id → Category lookup used to resolve names/colors on the legend.
 final  Map<int, Category> _categoriesById;
/// id → Category lookup used to resolve names/colors on the legend.
@override@JsonKey() Map<int, Category> get categoriesById {
  if (_categoriesById is EqualUnmodifiableMapView) return _categoriesById;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_categoriesById);
}


/// Create a copy of InsightReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InsightReportCopyWith<_InsightReport> get copyWith => __$InsightReportCopyWithImpl<_InsightReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InsightReport&&(identical(other.month, month) || other.month == month)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.saved, saved) || other.saved == saved)&&const DeepCollectionEquality().equals(other._expenseByCategory, _expenseByCategory)&&(identical(other.plannedVsUnplanned, plannedVsUnplanned) || other.plannedVsUnplanned == plannedVsUnplanned)&&const DeepCollectionEquality().equals(other._needVsWant, _needVsWant)&&const DeepCollectionEquality().equals(other._insights, _insights)&&const DeepCollectionEquality().equals(other._categoriesById, _categoriesById));
}


@override
int get hashCode => Object.hash(runtimeType,month,income,expense,saved,const DeepCollectionEquality().hash(_expenseByCategory),plannedVsUnplanned,const DeepCollectionEquality().hash(_needVsWant),const DeepCollectionEquality().hash(_insights),const DeepCollectionEquality().hash(_categoriesById));

@override
String toString() {
  return 'InsightReport(month: $month, income: $income, expense: $expense, saved: $saved, expenseByCategory: $expenseByCategory, plannedVsUnplanned: $plannedVsUnplanned, needVsWant: $needVsWant, insights: $insights, categoriesById: $categoriesById)';
}


}

/// @nodoc
abstract mixin class _$InsightReportCopyWith<$Res> implements $InsightReportCopyWith<$Res> {
  factory _$InsightReportCopyWith(_InsightReport value, $Res Function(_InsightReport) _then) = __$InsightReportCopyWithImpl;
@override @useResult
$Res call({
 DateTime month, int income, int expense, int saved, List<CategorySlice> expenseByCategory, PlannedSplit plannedVsUnplanned, Map<SpendingType, SpendingSlice> needVsWant, List<InsightItem> insights, Map<int, Category> categoriesById
});


@override $PlannedSplitCopyWith<$Res> get plannedVsUnplanned;

}
/// @nodoc
class __$InsightReportCopyWithImpl<$Res>
    implements _$InsightReportCopyWith<$Res> {
  __$InsightReportCopyWithImpl(this._self, this._then);

  final _InsightReport _self;
  final $Res Function(_InsightReport) _then;

/// Create a copy of InsightReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? income = null,Object? expense = null,Object? saved = null,Object? expenseByCategory = null,Object? plannedVsUnplanned = null,Object? needVsWant = null,Object? insights = null,Object? categoriesById = null,}) {
  return _then(_InsightReport(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as int,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as int,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as int,expenseByCategory: null == expenseByCategory ? _self._expenseByCategory : expenseByCategory // ignore: cast_nullable_to_non_nullable
as List<CategorySlice>,plannedVsUnplanned: null == plannedVsUnplanned ? _self.plannedVsUnplanned : plannedVsUnplanned // ignore: cast_nullable_to_non_nullable
as PlannedSplit,needVsWant: null == needVsWant ? _self._needVsWant : needVsWant // ignore: cast_nullable_to_non_nullable
as Map<SpendingType, SpendingSlice>,insights: null == insights ? _self._insights : insights // ignore: cast_nullable_to_non_nullable
as List<InsightItem>,categoriesById: null == categoriesById ? _self._categoriesById : categoriesById // ignore: cast_nullable_to_non_nullable
as Map<int, Category>,
  ));
}

/// Create a copy of InsightReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlannedSplitCopyWith<$Res> get plannedVsUnplanned {
  
  return $PlannedSplitCopyWith<$Res>(_self.plannedVsUnplanned, (value) {
    return _then(_self.copyWith(plannedVsUnplanned: value));
  });
}
}

/// @nodoc
mixin _$InsightState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsightState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InsightState()';
}


}

/// @nodoc
class $InsightStateCopyWith<$Res>  {
$InsightStateCopyWith(InsightState _, $Res Function(InsightState) __);
}


/// Adds pattern-matching-related methods to [InsightState].
extension InsightStatePatterns on InsightState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InsightInitial value)?  initial,TResult Function( InsightLoading value)?  loading,TResult Function( InsightLoaded value)?  loaded,TResult Function( InsightError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InsightInitial() when initial != null:
return initial(_that);case InsightLoading() when loading != null:
return loading(_that);case InsightLoaded() when loaded != null:
return loaded(_that);case InsightError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InsightInitial value)  initial,required TResult Function( InsightLoading value)  loading,required TResult Function( InsightLoaded value)  loaded,required TResult Function( InsightError value)  error,}){
final _that = this;
switch (_that) {
case InsightInitial():
return initial(_that);case InsightLoading():
return loading(_that);case InsightLoaded():
return loaded(_that);case InsightError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InsightInitial value)?  initial,TResult? Function( InsightLoading value)?  loading,TResult? Function( InsightLoaded value)?  loaded,TResult? Function( InsightError value)?  error,}){
final _that = this;
switch (_that) {
case InsightInitial() when initial != null:
return initial(_that);case InsightLoading() when loading != null:
return loading(_that);case InsightLoaded() when loaded != null:
return loaded(_that);case InsightError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( InsightReport report)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InsightInitial() when initial != null:
return initial();case InsightLoading() when loading != null:
return loading();case InsightLoaded() when loaded != null:
return loaded(_that.report);case InsightError() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( InsightReport report)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case InsightInitial():
return initial();case InsightLoading():
return loading();case InsightLoaded():
return loaded(_that.report);case InsightError():
return error(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( InsightReport report)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case InsightInitial() when initial != null:
return initial();case InsightLoading() when loading != null:
return loading();case InsightLoaded() when loaded != null:
return loaded(_that.report);case InsightError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class InsightInitial implements InsightState {
  const InsightInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsightInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InsightState.initial()';
}


}




/// @nodoc


class InsightLoading implements InsightState {
  const InsightLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsightLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InsightState.loading()';
}


}




/// @nodoc


class InsightLoaded implements InsightState {
  const InsightLoaded(this.report);
  

 final  InsightReport report;

/// Create a copy of InsightState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InsightLoadedCopyWith<InsightLoaded> get copyWith => _$InsightLoadedCopyWithImpl<InsightLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsightLoaded&&(identical(other.report, report) || other.report == report));
}


@override
int get hashCode => Object.hash(runtimeType,report);

@override
String toString() {
  return 'InsightState.loaded(report: $report)';
}


}

/// @nodoc
abstract mixin class $InsightLoadedCopyWith<$Res> implements $InsightStateCopyWith<$Res> {
  factory $InsightLoadedCopyWith(InsightLoaded value, $Res Function(InsightLoaded) _then) = _$InsightLoadedCopyWithImpl;
@useResult
$Res call({
 InsightReport report
});


$InsightReportCopyWith<$Res> get report;

}
/// @nodoc
class _$InsightLoadedCopyWithImpl<$Res>
    implements $InsightLoadedCopyWith<$Res> {
  _$InsightLoadedCopyWithImpl(this._self, this._then);

  final InsightLoaded _self;
  final $Res Function(InsightLoaded) _then;

/// Create a copy of InsightState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? report = null,}) {
  return _then(InsightLoaded(
null == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as InsightReport,
  ));
}

/// Create a copy of InsightState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InsightReportCopyWith<$Res> get report {
  
  return $InsightReportCopyWith<$Res>(_self.report, (value) {
    return _then(_self.copyWith(report: value));
  });
}
}

/// @nodoc


class InsightError implements InsightState {
  const InsightError(this.failure);
  

 final  Failure failure;

/// Create a copy of InsightState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InsightErrorCopyWith<InsightError> get copyWith => _$InsightErrorCopyWithImpl<InsightError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsightError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'InsightState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $InsightErrorCopyWith<$Res> implements $InsightStateCopyWith<$Res> {
  factory $InsightErrorCopyWith(InsightError value, $Res Function(InsightError) _then) = _$InsightErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$InsightErrorCopyWithImpl<$Res>
    implements $InsightErrorCopyWith<$Res> {
  _$InsightErrorCopyWithImpl(this._self, this._then);

  final InsightError _self;
  final $Res Function(InsightError) _then;

/// Create a copy of InsightState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(InsightError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
