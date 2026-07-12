// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_form_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecurringFormState {

 String get label; TransactionType get type;/// Required rupiah amount (`> 0`) — [isValid] blocks a zero.
 int get amount; int? get accountId; int? get toAccountId; int? get categoryId; PlannedStatus? get plannedStatus; SpendingType? get spendingType; String get note;/// All accounts (incl. archived — filtered by [selectableAccounts]).
 List<Account> get accounts;/// Expense + income categories loaded once; filtered by [categoriesForType].
 List<Category> get categories; RecurringFormStatus get status; Failure? get error; bool get isEditing;// ── Schedule ──
 RecurrenceFreq get freq; int get interval;/// First occurrence + the clamp anchor (midnight-local millis); required.
 int? get startDate;/// Optional inclusive last bound (midnight-local millis).
 int? get endDate;
/// Create a copy of RecurringFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringFormStateCopyWith<RecurringFormState> get copyWith => _$RecurringFormStateCopyWithImpl<RecurringFormState>(this as RecurringFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringFormState&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.toAccountId, toAccountId) || other.toAccountId == toAccountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType)&&(identical(other.note, note) || other.note == note)&&const DeepCollectionEquality().equals(other.accounts, accounts)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.isEditing, isEditing) || other.isEditing == isEditing)&&(identical(other.freq, freq) || other.freq == freq)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,label,type,amount,accountId,toAccountId,categoryId,plannedStatus,spendingType,note,const DeepCollectionEquality().hash(accounts),const DeepCollectionEquality().hash(categories),status,error,isEditing,freq,interval,startDate,endDate);

@override
String toString() {
  return 'RecurringFormState(label: $label, type: $type, amount: $amount, accountId: $accountId, toAccountId: $toAccountId, categoryId: $categoryId, plannedStatus: $plannedStatus, spendingType: $spendingType, note: $note, accounts: $accounts, categories: $categories, status: $status, error: $error, isEditing: $isEditing, freq: $freq, interval: $interval, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $RecurringFormStateCopyWith<$Res>  {
  factory $RecurringFormStateCopyWith(RecurringFormState value, $Res Function(RecurringFormState) _then) = _$RecurringFormStateCopyWithImpl;
@useResult
$Res call({
 String label, TransactionType type, int amount, int? accountId, int? toAccountId, int? categoryId, PlannedStatus? plannedStatus, SpendingType? spendingType, String note, List<Account> accounts, List<Category> categories, RecurringFormStatus status, Failure? error, bool isEditing, RecurrenceFreq freq, int interval, int? startDate, int? endDate
});




}
/// @nodoc
class _$RecurringFormStateCopyWithImpl<$Res>
    implements $RecurringFormStateCopyWith<$Res> {
  _$RecurringFormStateCopyWithImpl(this._self, this._then);

  final RecurringFormState _self;
  final $Res Function(RecurringFormState) _then;

/// Create a copy of RecurringFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? type = null,Object? amount = null,Object? accountId = freezed,Object? toAccountId = freezed,Object? categoryId = freezed,Object? plannedStatus = freezed,Object? spendingType = freezed,Object? note = null,Object? accounts = null,Object? categories = null,Object? status = null,Object? error = freezed,Object? isEditing = null,Object? freq = null,Object? interval = null,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int?,toAccountId: freezed == toAccountId ? _self.toAccountId : toAccountId // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,plannedStatus: freezed == plannedStatus ? _self.plannedStatus : plannedStatus // ignore: cast_nullable_to_non_nullable
as PlannedStatus?,spendingType: freezed == spendingType ? _self.spendingType : spendingType // ignore: cast_nullable_to_non_nullable
as SpendingType?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,accounts: null == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<Account>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecurringFormStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,isEditing: null == isEditing ? _self.isEditing : isEditing // ignore: cast_nullable_to_non_nullable
as bool,freq: null == freq ? _self.freq : freq // ignore: cast_nullable_to_non_nullable
as RecurrenceFreq,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as int?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurringFormState].
extension RecurringFormStatePatterns on RecurringFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringFormState value)  $default,){
final _that = this;
switch (_that) {
case _RecurringFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringFormState value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  TransactionType type,  int amount,  int? accountId,  int? toAccountId,  int? categoryId,  PlannedStatus? plannedStatus,  SpendingType? spendingType,  String note,  List<Account> accounts,  List<Category> categories,  RecurringFormStatus status,  Failure? error,  bool isEditing,  RecurrenceFreq freq,  int interval,  int? startDate,  int? endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringFormState() when $default != null:
return $default(_that.label,_that.type,_that.amount,_that.accountId,_that.toAccountId,_that.categoryId,_that.plannedStatus,_that.spendingType,_that.note,_that.accounts,_that.categories,_that.status,_that.error,_that.isEditing,_that.freq,_that.interval,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  TransactionType type,  int amount,  int? accountId,  int? toAccountId,  int? categoryId,  PlannedStatus? plannedStatus,  SpendingType? spendingType,  String note,  List<Account> accounts,  List<Category> categories,  RecurringFormStatus status,  Failure? error,  bool isEditing,  RecurrenceFreq freq,  int interval,  int? startDate,  int? endDate)  $default,) {final _that = this;
switch (_that) {
case _RecurringFormState():
return $default(_that.label,_that.type,_that.amount,_that.accountId,_that.toAccountId,_that.categoryId,_that.plannedStatus,_that.spendingType,_that.note,_that.accounts,_that.categories,_that.status,_that.error,_that.isEditing,_that.freq,_that.interval,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  TransactionType type,  int amount,  int? accountId,  int? toAccountId,  int? categoryId,  PlannedStatus? plannedStatus,  SpendingType? spendingType,  String note,  List<Account> accounts,  List<Category> categories,  RecurringFormStatus status,  Failure? error,  bool isEditing,  RecurrenceFreq freq,  int interval,  int? startDate,  int? endDate)?  $default,) {final _that = this;
switch (_that) {
case _RecurringFormState() when $default != null:
return $default(_that.label,_that.type,_that.amount,_that.accountId,_that.toAccountId,_that.categoryId,_that.plannedStatus,_that.spendingType,_that.note,_that.accounts,_that.categories,_that.status,_that.error,_that.isEditing,_that.freq,_that.interval,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc


class _RecurringFormState extends RecurringFormState {
  const _RecurringFormState({this.label = '', this.type = TransactionType.expense, this.amount = 0, this.accountId, this.toAccountId, this.categoryId, this.plannedStatus, this.spendingType, this.note = '', final  List<Account> accounts = const <Account>[], final  List<Category> categories = const <Category>[], this.status = RecurringFormStatus.editing, this.error, this.isEditing = false, this.freq = RecurrenceFreq.monthly, this.interval = 1, this.startDate, this.endDate}): _accounts = accounts,_categories = categories,super._();
  

@override@JsonKey() final  String label;
@override@JsonKey() final  TransactionType type;
/// Required rupiah amount (`> 0`) — [isValid] blocks a zero.
@override@JsonKey() final  int amount;
@override final  int? accountId;
@override final  int? toAccountId;
@override final  int? categoryId;
@override final  PlannedStatus? plannedStatus;
@override final  SpendingType? spendingType;
@override@JsonKey() final  String note;
/// All accounts (incl. archived — filtered by [selectableAccounts]).
 final  List<Account> _accounts;
/// All accounts (incl. archived — filtered by [selectableAccounts]).
@override@JsonKey() List<Account> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}

/// Expense + income categories loaded once; filtered by [categoriesForType].
 final  List<Category> _categories;
/// Expense + income categories loaded once; filtered by [categoriesForType].
@override@JsonKey() List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override@JsonKey() final  RecurringFormStatus status;
@override final  Failure? error;
@override@JsonKey() final  bool isEditing;
// ── Schedule ──
@override@JsonKey() final  RecurrenceFreq freq;
@override@JsonKey() final  int interval;
/// First occurrence + the clamp anchor (midnight-local millis); required.
@override final  int? startDate;
/// Optional inclusive last bound (midnight-local millis).
@override final  int? endDate;

/// Create a copy of RecurringFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringFormStateCopyWith<_RecurringFormState> get copyWith => __$RecurringFormStateCopyWithImpl<_RecurringFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringFormState&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.toAccountId, toAccountId) || other.toAccountId == toAccountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType)&&(identical(other.note, note) || other.note == note)&&const DeepCollectionEquality().equals(other._accounts, _accounts)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.isEditing, isEditing) || other.isEditing == isEditing)&&(identical(other.freq, freq) || other.freq == freq)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,label,type,amount,accountId,toAccountId,categoryId,plannedStatus,spendingType,note,const DeepCollectionEquality().hash(_accounts),const DeepCollectionEquality().hash(_categories),status,error,isEditing,freq,interval,startDate,endDate);

@override
String toString() {
  return 'RecurringFormState(label: $label, type: $type, amount: $amount, accountId: $accountId, toAccountId: $toAccountId, categoryId: $categoryId, plannedStatus: $plannedStatus, spendingType: $spendingType, note: $note, accounts: $accounts, categories: $categories, status: $status, error: $error, isEditing: $isEditing, freq: $freq, interval: $interval, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$RecurringFormStateCopyWith<$Res> implements $RecurringFormStateCopyWith<$Res> {
  factory _$RecurringFormStateCopyWith(_RecurringFormState value, $Res Function(_RecurringFormState) _then) = __$RecurringFormStateCopyWithImpl;
@override @useResult
$Res call({
 String label, TransactionType type, int amount, int? accountId, int? toAccountId, int? categoryId, PlannedStatus? plannedStatus, SpendingType? spendingType, String note, List<Account> accounts, List<Category> categories, RecurringFormStatus status, Failure? error, bool isEditing, RecurrenceFreq freq, int interval, int? startDate, int? endDate
});




}
/// @nodoc
class __$RecurringFormStateCopyWithImpl<$Res>
    implements _$RecurringFormStateCopyWith<$Res> {
  __$RecurringFormStateCopyWithImpl(this._self, this._then);

  final _RecurringFormState _self;
  final $Res Function(_RecurringFormState) _then;

/// Create a copy of RecurringFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? type = null,Object? amount = null,Object? accountId = freezed,Object? toAccountId = freezed,Object? categoryId = freezed,Object? plannedStatus = freezed,Object? spendingType = freezed,Object? note = null,Object? accounts = null,Object? categories = null,Object? status = null,Object? error = freezed,Object? isEditing = null,Object? freq = null,Object? interval = null,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_RecurringFormState(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int?,toAccountId: freezed == toAccountId ? _self.toAccountId : toAccountId // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,plannedStatus: freezed == plannedStatus ? _self.plannedStatus : plannedStatus // ignore: cast_nullable_to_non_nullable
as PlannedStatus?,spendingType: freezed == spendingType ? _self.spendingType : spendingType // ignore: cast_nullable_to_non_nullable
as SpendingType?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<Account>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecurringFormStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,isEditing: null == isEditing ? _self.isEditing : isEditing // ignore: cast_nullable_to_non_nullable
as bool,freq: null == freq ? _self.freq : freq // ignore: cast_nullable_to_non_nullable
as RecurrenceFreq,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as int?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
