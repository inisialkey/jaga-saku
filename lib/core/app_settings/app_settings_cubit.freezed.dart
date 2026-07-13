// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppSettingsState {

/// Default light per style guide §20; `System` is an explicit user choice.
 ThemeMode get themeMode;/// null → follow the device locale (System).
 Locale? get locale;/// Greeting name; null/blank → guest greeting on Home.
 String? get userName;/// Day-of-month a budget cycle starts (1..31; V2-M1). Default 1 == the
/// calendar month, so every existing budget is unchanged. Clamped to the
/// month's last valid day by `BudgetCycle`.
 int get budgetCycleStartDay;
/// Create a copy of AppSettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsStateCopyWith<AppSettingsState> get copyWith => _$AppSettingsStateCopyWithImpl<AppSettingsState>(this as AppSettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettingsState&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.budgetCycleStartDay, budgetCycleStartDay) || other.budgetCycleStartDay == budgetCycleStartDay));
}


@override
int get hashCode => Object.hash(runtimeType,themeMode,locale,userName,budgetCycleStartDay);

@override
String toString() {
  return 'AppSettingsState(themeMode: $themeMode, locale: $locale, userName: $userName, budgetCycleStartDay: $budgetCycleStartDay)';
}


}

/// @nodoc
abstract mixin class $AppSettingsStateCopyWith<$Res>  {
  factory $AppSettingsStateCopyWith(AppSettingsState value, $Res Function(AppSettingsState) _then) = _$AppSettingsStateCopyWithImpl;
@useResult
$Res call({
 ThemeMode themeMode, Locale? locale, String? userName, int budgetCycleStartDay
});




}
/// @nodoc
class _$AppSettingsStateCopyWithImpl<$Res>
    implements $AppSettingsStateCopyWith<$Res> {
  _$AppSettingsStateCopyWithImpl(this._self, this._then);

  final AppSettingsState _self;
  final $Res Function(AppSettingsState) _then;

/// Create a copy of AppSettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = null,Object? locale = freezed,Object? userName = freezed,Object? budgetCycleStartDay = null,}) {
  return _then(_self.copyWith(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as Locale?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,budgetCycleStartDay: null == budgetCycleStartDay ? _self.budgetCycleStartDay : budgetCycleStartDay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettingsState].
extension AppSettingsStatePatterns on AppSettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettingsState value)  $default,){
final _that = this;
switch (_that) {
case _AppSettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ThemeMode themeMode,  Locale? locale,  String? userName,  int budgetCycleStartDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettingsState() when $default != null:
return $default(_that.themeMode,_that.locale,_that.userName,_that.budgetCycleStartDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ThemeMode themeMode,  Locale? locale,  String? userName,  int budgetCycleStartDay)  $default,) {final _that = this;
switch (_that) {
case _AppSettingsState():
return $default(_that.themeMode,_that.locale,_that.userName,_that.budgetCycleStartDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ThemeMode themeMode,  Locale? locale,  String? userName,  int budgetCycleStartDay)?  $default,) {final _that = this;
switch (_that) {
case _AppSettingsState() when $default != null:
return $default(_that.themeMode,_that.locale,_that.userName,_that.budgetCycleStartDay);case _:
  return null;

}
}

}

/// @nodoc


class _AppSettingsState implements AppSettingsState {
  const _AppSettingsState({this.themeMode = ThemeMode.light, this.locale, this.userName, this.budgetCycleStartDay = 1});
  

/// Default light per style guide §20; `System` is an explicit user choice.
@override@JsonKey() final  ThemeMode themeMode;
/// null → follow the device locale (System).
@override final  Locale? locale;
/// Greeting name; null/blank → guest greeting on Home.
@override final  String? userName;
/// Day-of-month a budget cycle starts (1..31; V2-M1). Default 1 == the
/// calendar month, so every existing budget is unchanged. Clamped to the
/// month's last valid day by `BudgetCycle`.
@override@JsonKey() final  int budgetCycleStartDay;

/// Create a copy of AppSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsStateCopyWith<_AppSettingsState> get copyWith => __$AppSettingsStateCopyWithImpl<_AppSettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettingsState&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.budgetCycleStartDay, budgetCycleStartDay) || other.budgetCycleStartDay == budgetCycleStartDay));
}


@override
int get hashCode => Object.hash(runtimeType,themeMode,locale,userName,budgetCycleStartDay);

@override
String toString() {
  return 'AppSettingsState(themeMode: $themeMode, locale: $locale, userName: $userName, budgetCycleStartDay: $budgetCycleStartDay)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsStateCopyWith<$Res> implements $AppSettingsStateCopyWith<$Res> {
  factory _$AppSettingsStateCopyWith(_AppSettingsState value, $Res Function(_AppSettingsState) _then) = __$AppSettingsStateCopyWithImpl;
@override @useResult
$Res call({
 ThemeMode themeMode, Locale? locale, String? userName, int budgetCycleStartDay
});




}
/// @nodoc
class __$AppSettingsStateCopyWithImpl<$Res>
    implements _$AppSettingsStateCopyWith<$Res> {
  __$AppSettingsStateCopyWithImpl(this._self, this._then);

  final _AppSettingsState _self;
  final $Res Function(_AppSettingsState) _then;

/// Create a copy of AppSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = null,Object? locale = freezed,Object? userName = freezed,Object? budgetCycleStartDay = null,}) {
  return _then(_AppSettingsState(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as Locale?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,budgetCycleStartDay: null == budgetCycleStartDay ? _self.budgetCycleStartDay : budgetCycleStartDay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
