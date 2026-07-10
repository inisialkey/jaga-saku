// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CalendarState {

 DateTime get focusedMonth; DateTime get selectedDay; List<Transaction> get monthTransactions; List<Transaction> get selectedDayTransactions; Map<int, Account> get accountsById; Map<int, Category> get categoriesById; CalendarStatus get status; Failure? get failure;
/// Create a copy of CalendarState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarStateCopyWith<CalendarState> get copyWith => _$CalendarStateCopyWithImpl<CalendarState>(this as CalendarState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarState&&(identical(other.focusedMonth, focusedMonth) || other.focusedMonth == focusedMonth)&&(identical(other.selectedDay, selectedDay) || other.selectedDay == selectedDay)&&const DeepCollectionEquality().equals(other.monthTransactions, monthTransactions)&&const DeepCollectionEquality().equals(other.selectedDayTransactions, selectedDayTransactions)&&const DeepCollectionEquality().equals(other.accountsById, accountsById)&&const DeepCollectionEquality().equals(other.categoriesById, categoriesById)&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,focusedMonth,selectedDay,const DeepCollectionEquality().hash(monthTransactions),const DeepCollectionEquality().hash(selectedDayTransactions),const DeepCollectionEquality().hash(accountsById),const DeepCollectionEquality().hash(categoriesById),status,failure);

@override
String toString() {
  return 'CalendarState(focusedMonth: $focusedMonth, selectedDay: $selectedDay, monthTransactions: $monthTransactions, selectedDayTransactions: $selectedDayTransactions, accountsById: $accountsById, categoriesById: $categoriesById, status: $status, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $CalendarStateCopyWith<$Res>  {
  factory $CalendarStateCopyWith(CalendarState value, $Res Function(CalendarState) _then) = _$CalendarStateCopyWithImpl;
@useResult
$Res call({
 DateTime focusedMonth, DateTime selectedDay, List<Transaction> monthTransactions, List<Transaction> selectedDayTransactions, Map<int, Account> accountsById, Map<int, Category> categoriesById, CalendarStatus status, Failure? failure
});




}
/// @nodoc
class _$CalendarStateCopyWithImpl<$Res>
    implements $CalendarStateCopyWith<$Res> {
  _$CalendarStateCopyWithImpl(this._self, this._then);

  final CalendarState _self;
  final $Res Function(CalendarState) _then;

/// Create a copy of CalendarState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? focusedMonth = null,Object? selectedDay = null,Object? monthTransactions = null,Object? selectedDayTransactions = null,Object? accountsById = null,Object? categoriesById = null,Object? status = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
focusedMonth: null == focusedMonth ? _self.focusedMonth : focusedMonth // ignore: cast_nullable_to_non_nullable
as DateTime,selectedDay: null == selectedDay ? _self.selectedDay : selectedDay // ignore: cast_nullable_to_non_nullable
as DateTime,monthTransactions: null == monthTransactions ? _self.monthTransactions : monthTransactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,selectedDayTransactions: null == selectedDayTransactions ? _self.selectedDayTransactions : selectedDayTransactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,accountsById: null == accountsById ? _self.accountsById : accountsById // ignore: cast_nullable_to_non_nullable
as Map<int, Account>,categoriesById: null == categoriesById ? _self.categoriesById : categoriesById // ignore: cast_nullable_to_non_nullable
as Map<int, Category>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CalendarStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarState].
extension CalendarStatePatterns on CalendarState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarState value)  $default,){
final _that = this;
switch (_that) {
case _CalendarState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarState value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime focusedMonth,  DateTime selectedDay,  List<Transaction> monthTransactions,  List<Transaction> selectedDayTransactions,  Map<int, Account> accountsById,  Map<int, Category> categoriesById,  CalendarStatus status,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarState() when $default != null:
return $default(_that.focusedMonth,_that.selectedDay,_that.monthTransactions,_that.selectedDayTransactions,_that.accountsById,_that.categoriesById,_that.status,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime focusedMonth,  DateTime selectedDay,  List<Transaction> monthTransactions,  List<Transaction> selectedDayTransactions,  Map<int, Account> accountsById,  Map<int, Category> categoriesById,  CalendarStatus status,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _CalendarState():
return $default(_that.focusedMonth,_that.selectedDay,_that.monthTransactions,_that.selectedDayTransactions,_that.accountsById,_that.categoriesById,_that.status,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime focusedMonth,  DateTime selectedDay,  List<Transaction> monthTransactions,  List<Transaction> selectedDayTransactions,  Map<int, Account> accountsById,  Map<int, Category> categoriesById,  CalendarStatus status,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _CalendarState() when $default != null:
return $default(_that.focusedMonth,_that.selectedDay,_that.monthTransactions,_that.selectedDayTransactions,_that.accountsById,_that.categoriesById,_that.status,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _CalendarState extends CalendarState {
  const _CalendarState({required this.focusedMonth, required this.selectedDay, final  List<Transaction> monthTransactions = const <Transaction>[], final  List<Transaction> selectedDayTransactions = const <Transaction>[], final  Map<int, Account> accountsById = const <int, Account>{}, final  Map<int, Category> categoriesById = const <int, Category>{}, this.status = CalendarStatus.initial, this.failure}): _monthTransactions = monthTransactions,_selectedDayTransactions = selectedDayTransactions,_accountsById = accountsById,_categoriesById = categoriesById,super._();
  

@override final  DateTime focusedMonth;
@override final  DateTime selectedDay;
 final  List<Transaction> _monthTransactions;
@override@JsonKey() List<Transaction> get monthTransactions {
  if (_monthTransactions is EqualUnmodifiableListView) return _monthTransactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_monthTransactions);
}

 final  List<Transaction> _selectedDayTransactions;
@override@JsonKey() List<Transaction> get selectedDayTransactions {
  if (_selectedDayTransactions is EqualUnmodifiableListView) return _selectedDayTransactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedDayTransactions);
}

 final  Map<int, Account> _accountsById;
@override@JsonKey() Map<int, Account> get accountsById {
  if (_accountsById is EqualUnmodifiableMapView) return _accountsById;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_accountsById);
}

 final  Map<int, Category> _categoriesById;
@override@JsonKey() Map<int, Category> get categoriesById {
  if (_categoriesById is EqualUnmodifiableMapView) return _categoriesById;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_categoriesById);
}

@override@JsonKey() final  CalendarStatus status;
@override final  Failure? failure;

/// Create a copy of CalendarState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarStateCopyWith<_CalendarState> get copyWith => __$CalendarStateCopyWithImpl<_CalendarState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarState&&(identical(other.focusedMonth, focusedMonth) || other.focusedMonth == focusedMonth)&&(identical(other.selectedDay, selectedDay) || other.selectedDay == selectedDay)&&const DeepCollectionEquality().equals(other._monthTransactions, _monthTransactions)&&const DeepCollectionEquality().equals(other._selectedDayTransactions, _selectedDayTransactions)&&const DeepCollectionEquality().equals(other._accountsById, _accountsById)&&const DeepCollectionEquality().equals(other._categoriesById, _categoriesById)&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,focusedMonth,selectedDay,const DeepCollectionEquality().hash(_monthTransactions),const DeepCollectionEquality().hash(_selectedDayTransactions),const DeepCollectionEquality().hash(_accountsById),const DeepCollectionEquality().hash(_categoriesById),status,failure);

@override
String toString() {
  return 'CalendarState(focusedMonth: $focusedMonth, selectedDay: $selectedDay, monthTransactions: $monthTransactions, selectedDayTransactions: $selectedDayTransactions, accountsById: $accountsById, categoriesById: $categoriesById, status: $status, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$CalendarStateCopyWith<$Res> implements $CalendarStateCopyWith<$Res> {
  factory _$CalendarStateCopyWith(_CalendarState value, $Res Function(_CalendarState) _then) = __$CalendarStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime focusedMonth, DateTime selectedDay, List<Transaction> monthTransactions, List<Transaction> selectedDayTransactions, Map<int, Account> accountsById, Map<int, Category> categoriesById, CalendarStatus status, Failure? failure
});




}
/// @nodoc
class __$CalendarStateCopyWithImpl<$Res>
    implements _$CalendarStateCopyWith<$Res> {
  __$CalendarStateCopyWithImpl(this._self, this._then);

  final _CalendarState _self;
  final $Res Function(_CalendarState) _then;

/// Create a copy of CalendarState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? focusedMonth = null,Object? selectedDay = null,Object? monthTransactions = null,Object? selectedDayTransactions = null,Object? accountsById = null,Object? categoriesById = null,Object? status = null,Object? failure = freezed,}) {
  return _then(_CalendarState(
focusedMonth: null == focusedMonth ? _self.focusedMonth : focusedMonth // ignore: cast_nullable_to_non_nullable
as DateTime,selectedDay: null == selectedDay ? _self.selectedDay : selectedDay // ignore: cast_nullable_to_non_nullable
as DateTime,monthTransactions: null == monthTransactions ? _self._monthTransactions : monthTransactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,selectedDayTransactions: null == selectedDayTransactions ? _self._selectedDayTransactions : selectedDayTransactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,accountsById: null == accountsById ? _self._accountsById : accountsById // ignore: cast_nullable_to_non_nullable
as Map<int, Account>,categoriesById: null == categoriesById ? _self._categoriesById : categoriesById // ignore: cast_nullable_to_non_nullable
as Map<int, Category>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CalendarStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
