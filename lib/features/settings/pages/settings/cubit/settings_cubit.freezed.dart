// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsState()';
}


}

/// @nodoc
class $SettingsStateCopyWith<$Res>  {
$SettingsStateCopyWith(SettingsState _, $Res Function(SettingsState) __);
}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SettingsStateInitial value)?  initial,TResult Function( SettingsStateLoaded value)?  loaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SettingsStateInitial() when initial != null:
return initial(_that);case SettingsStateLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SettingsStateInitial value)  initial,required TResult Function( SettingsStateLoaded value)  loaded,}){
final _that = this;
switch (_that) {
case SettingsStateInitial():
return initial(_that);case SettingsStateLoaded():
return loaded(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SettingsStateInitial value)?  initial,TResult? Function( SettingsStateLoaded value)?  loaded,}){
final _that = this;
switch (_that) {
case SettingsStateInitial() when initial != null:
return initial(_that);case SettingsStateLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( ActiveTheme activeTheme,  String locale)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SettingsStateInitial() when initial != null:
return initial();case SettingsStateLoaded() when loaded != null:
return loaded(_that.activeTheme,_that.locale);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( ActiveTheme activeTheme,  String locale)  loaded,}) {final _that = this;
switch (_that) {
case SettingsStateInitial():
return initial();case SettingsStateLoaded():
return loaded(_that.activeTheme,_that.locale);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( ActiveTheme activeTheme,  String locale)?  loaded,}) {final _that = this;
switch (_that) {
case SettingsStateInitial() when initial != null:
return initial();case SettingsStateLoaded() when loaded != null:
return loaded(_that.activeTheme,_that.locale);case _:
  return null;

}
}

}

/// @nodoc


class SettingsStateInitial implements SettingsState {
  const SettingsStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsState.initial()';
}


}




/// @nodoc


class SettingsStateLoaded implements SettingsState {
  const SettingsStateLoaded({required this.activeTheme, required this.locale});
  

 final  ActiveTheme activeTheme;
 final  String locale;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateLoadedCopyWith<SettingsStateLoaded> get copyWith => _$SettingsStateLoadedCopyWithImpl<SettingsStateLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsStateLoaded&&(identical(other.activeTheme, activeTheme) || other.activeTheme == activeTheme)&&(identical(other.locale, locale) || other.locale == locale));
}


@override
int get hashCode => Object.hash(runtimeType,activeTheme,locale);

@override
String toString() {
  return 'SettingsState.loaded(activeTheme: $activeTheme, locale: $locale)';
}


}

/// @nodoc
abstract mixin class $SettingsStateLoadedCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory $SettingsStateLoadedCopyWith(SettingsStateLoaded value, $Res Function(SettingsStateLoaded) _then) = _$SettingsStateLoadedCopyWithImpl;
@useResult
$Res call({
 ActiveTheme activeTheme, String locale
});




}
/// @nodoc
class _$SettingsStateLoadedCopyWithImpl<$Res>
    implements $SettingsStateLoadedCopyWith<$Res> {
  _$SettingsStateLoadedCopyWithImpl(this._self, this._then);

  final SettingsStateLoaded _self;
  final $Res Function(SettingsStateLoaded) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? activeTheme = null,Object? locale = null,}) {
  return _then(SettingsStateLoaded(
activeTheme: null == activeTheme ? _self.activeTheme : activeTheme // ignore: cast_nullable_to_non_nullable
as ActiveTheme,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
