// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_transaction_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddTransactionState {

 TransactionType get type; int get amount; int? get accountId; int? get toAccountId; int? get categoryId; PlannedStatus? get plannedStatus; SpendingType? get spendingType;/// Selected day as midnight-local epoch millis.
 int get date; String get note;/// All accounts (incl. archived — filtered by [selectableAccounts]).
 List<Account> get accounts;/// Expense + income categories loaded once; filtered by [categoriesForType].
 List<Category> get categories; AddTxStatus get status; AddTxValidation get validation; Failure? get error; bool get isEditing;
/// Create a copy of AddTransactionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddTransactionStateCopyWith<AddTransactionState> get copyWith => _$AddTransactionStateCopyWithImpl<AddTransactionState>(this as AddTransactionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddTransactionState&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.toAccountId, toAccountId) || other.toAccountId == toAccountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note)&&const DeepCollectionEquality().equals(other.accounts, accounts)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.status, status) || other.status == status)&&(identical(other.validation, validation) || other.validation == validation)&&(identical(other.error, error) || other.error == error)&&(identical(other.isEditing, isEditing) || other.isEditing == isEditing));
}


@override
int get hashCode => Object.hash(runtimeType,type,amount,accountId,toAccountId,categoryId,plannedStatus,spendingType,date,note,const DeepCollectionEquality().hash(accounts),const DeepCollectionEquality().hash(categories),status,validation,error,isEditing);

@override
String toString() {
  return 'AddTransactionState(type: $type, amount: $amount, accountId: $accountId, toAccountId: $toAccountId, categoryId: $categoryId, plannedStatus: $plannedStatus, spendingType: $spendingType, date: $date, note: $note, accounts: $accounts, categories: $categories, status: $status, validation: $validation, error: $error, isEditing: $isEditing)';
}


}

/// @nodoc
abstract mixin class $AddTransactionStateCopyWith<$Res>  {
  factory $AddTransactionStateCopyWith(AddTransactionState value, $Res Function(AddTransactionState) _then) = _$AddTransactionStateCopyWithImpl;
@useResult
$Res call({
 TransactionType type, int amount, int? accountId, int? toAccountId, int? categoryId, PlannedStatus? plannedStatus, SpendingType? spendingType, int date, String note, List<Account> accounts, List<Category> categories, AddTxStatus status, AddTxValidation validation, Failure? error, bool isEditing
});




}
/// @nodoc
class _$AddTransactionStateCopyWithImpl<$Res>
    implements $AddTransactionStateCopyWith<$Res> {
  _$AddTransactionStateCopyWithImpl(this._self, this._then);

  final AddTransactionState _self;
  final $Res Function(AddTransactionState) _then;

/// Create a copy of AddTransactionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? amount = null,Object? accountId = freezed,Object? toAccountId = freezed,Object? categoryId = freezed,Object? plannedStatus = freezed,Object? spendingType = freezed,Object? date = null,Object? note = null,Object? accounts = null,Object? categories = null,Object? status = null,Object? validation = null,Object? error = freezed,Object? isEditing = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int?,toAccountId: freezed == toAccountId ? _self.toAccountId : toAccountId // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,plannedStatus: freezed == plannedStatus ? _self.plannedStatus : plannedStatus // ignore: cast_nullable_to_non_nullable
as PlannedStatus?,spendingType: freezed == spendingType ? _self.spendingType : spendingType // ignore: cast_nullable_to_non_nullable
as SpendingType?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as int,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,accounts: null == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<Account>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AddTxStatus,validation: null == validation ? _self.validation : validation // ignore: cast_nullable_to_non_nullable
as AddTxValidation,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,isEditing: null == isEditing ? _self.isEditing : isEditing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AddTransactionState].
extension AddTransactionStatePatterns on AddTransactionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddTransactionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddTransactionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddTransactionState value)  $default,){
final _that = this;
switch (_that) {
case _AddTransactionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddTransactionState value)?  $default,){
final _that = this;
switch (_that) {
case _AddTransactionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TransactionType type,  int amount,  int? accountId,  int? toAccountId,  int? categoryId,  PlannedStatus? plannedStatus,  SpendingType? spendingType,  int date,  String note,  List<Account> accounts,  List<Category> categories,  AddTxStatus status,  AddTxValidation validation,  Failure? error,  bool isEditing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddTransactionState() when $default != null:
return $default(_that.type,_that.amount,_that.accountId,_that.toAccountId,_that.categoryId,_that.plannedStatus,_that.spendingType,_that.date,_that.note,_that.accounts,_that.categories,_that.status,_that.validation,_that.error,_that.isEditing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TransactionType type,  int amount,  int? accountId,  int? toAccountId,  int? categoryId,  PlannedStatus? plannedStatus,  SpendingType? spendingType,  int date,  String note,  List<Account> accounts,  List<Category> categories,  AddTxStatus status,  AddTxValidation validation,  Failure? error,  bool isEditing)  $default,) {final _that = this;
switch (_that) {
case _AddTransactionState():
return $default(_that.type,_that.amount,_that.accountId,_that.toAccountId,_that.categoryId,_that.plannedStatus,_that.spendingType,_that.date,_that.note,_that.accounts,_that.categories,_that.status,_that.validation,_that.error,_that.isEditing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TransactionType type,  int amount,  int? accountId,  int? toAccountId,  int? categoryId,  PlannedStatus? plannedStatus,  SpendingType? spendingType,  int date,  String note,  List<Account> accounts,  List<Category> categories,  AddTxStatus status,  AddTxValidation validation,  Failure? error,  bool isEditing)?  $default,) {final _that = this;
switch (_that) {
case _AddTransactionState() when $default != null:
return $default(_that.type,_that.amount,_that.accountId,_that.toAccountId,_that.categoryId,_that.plannedStatus,_that.spendingType,_that.date,_that.note,_that.accounts,_that.categories,_that.status,_that.validation,_that.error,_that.isEditing);case _:
  return null;

}
}

}

/// @nodoc


class _AddTransactionState extends AddTransactionState {
  const _AddTransactionState({this.type = TransactionType.expense, this.amount = 0, this.accountId, this.toAccountId, this.categoryId, this.plannedStatus, this.spendingType, this.date = 0, this.note = '', final  List<Account> accounts = const <Account>[], final  List<Category> categories = const <Category>[], this.status = AddTxStatus.editing, this.validation = AddTxValidation.none, this.error, this.isEditing = false}): _accounts = accounts,_categories = categories,super._();
  

@override@JsonKey() final  TransactionType type;
@override@JsonKey() final  int amount;
@override final  int? accountId;
@override final  int? toAccountId;
@override final  int? categoryId;
@override final  PlannedStatus? plannedStatus;
@override final  SpendingType? spendingType;
/// Selected day as midnight-local epoch millis.
@override@JsonKey() final  int date;
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

@override@JsonKey() final  AddTxStatus status;
@override@JsonKey() final  AddTxValidation validation;
@override final  Failure? error;
@override@JsonKey() final  bool isEditing;

/// Create a copy of AddTransactionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddTransactionStateCopyWith<_AddTransactionState> get copyWith => __$AddTransactionStateCopyWithImpl<_AddTransactionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddTransactionState&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.toAccountId, toAccountId) || other.toAccountId == toAccountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.plannedStatus, plannedStatus) || other.plannedStatus == plannedStatus)&&(identical(other.spendingType, spendingType) || other.spendingType == spendingType)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note)&&const DeepCollectionEquality().equals(other._accounts, _accounts)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.status, status) || other.status == status)&&(identical(other.validation, validation) || other.validation == validation)&&(identical(other.error, error) || other.error == error)&&(identical(other.isEditing, isEditing) || other.isEditing == isEditing));
}


@override
int get hashCode => Object.hash(runtimeType,type,amount,accountId,toAccountId,categoryId,plannedStatus,spendingType,date,note,const DeepCollectionEquality().hash(_accounts),const DeepCollectionEquality().hash(_categories),status,validation,error,isEditing);

@override
String toString() {
  return 'AddTransactionState(type: $type, amount: $amount, accountId: $accountId, toAccountId: $toAccountId, categoryId: $categoryId, plannedStatus: $plannedStatus, spendingType: $spendingType, date: $date, note: $note, accounts: $accounts, categories: $categories, status: $status, validation: $validation, error: $error, isEditing: $isEditing)';
}


}

/// @nodoc
abstract mixin class _$AddTransactionStateCopyWith<$Res> implements $AddTransactionStateCopyWith<$Res> {
  factory _$AddTransactionStateCopyWith(_AddTransactionState value, $Res Function(_AddTransactionState) _then) = __$AddTransactionStateCopyWithImpl;
@override @useResult
$Res call({
 TransactionType type, int amount, int? accountId, int? toAccountId, int? categoryId, PlannedStatus? plannedStatus, SpendingType? spendingType, int date, String note, List<Account> accounts, List<Category> categories, AddTxStatus status, AddTxValidation validation, Failure? error, bool isEditing
});




}
/// @nodoc
class __$AddTransactionStateCopyWithImpl<$Res>
    implements _$AddTransactionStateCopyWith<$Res> {
  __$AddTransactionStateCopyWithImpl(this._self, this._then);

  final _AddTransactionState _self;
  final $Res Function(_AddTransactionState) _then;

/// Create a copy of AddTransactionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? amount = null,Object? accountId = freezed,Object? toAccountId = freezed,Object? categoryId = freezed,Object? plannedStatus = freezed,Object? spendingType = freezed,Object? date = null,Object? note = null,Object? accounts = null,Object? categories = null,Object? status = null,Object? validation = null,Object? error = freezed,Object? isEditing = null,}) {
  return _then(_AddTransactionState(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int?,toAccountId: freezed == toAccountId ? _self.toAccountId : toAccountId // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,plannedStatus: freezed == plannedStatus ? _self.plannedStatus : plannedStatus // ignore: cast_nullable_to_non_nullable
as PlannedStatus?,spendingType: freezed == spendingType ? _self.spendingType : spendingType // ignore: cast_nullable_to_non_nullable
as SpendingType?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as int,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<Account>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AddTxStatus,validation: null == validation ? _self.validation : validation // ignore: cast_nullable_to_non_nullable
as AddTxValidation,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,isEditing: null == isEditing ? _self.isEditing : isEditing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
