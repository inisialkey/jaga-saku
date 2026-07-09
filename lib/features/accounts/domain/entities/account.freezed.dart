// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Account {

 String get name; AccountType get type;/// `null` until persisted (SQLite AUTOINCREMENT assigns it on insert).
 int? get id; int get openingBalance;/// [AppIcons] catalog key, resolved to an `IconData` in the UI layer.
 String? get icon;/// ARGB color value.
 int? get color; int get sortOrder; bool get archived; int get createdAt;/// Derived, non-persisted spendable balance. Populated by the balance SQL
/// query (opening balance +/- signed transaction sums); equals
/// [openingBalance] until transactions exist (M2).
 int get balance;
/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountCopyWith<Account> get copyWith => _$AccountCopyWithImpl<Account>(this as Account, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Account&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.openingBalance, openingBalance) || other.openingBalance == openingBalance)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.balance, balance) || other.balance == balance));
}


@override
int get hashCode => Object.hash(runtimeType,name,type,id,openingBalance,icon,color,sortOrder,archived,createdAt,balance);

@override
String toString() {
  return 'Account(name: $name, type: $type, id: $id, openingBalance: $openingBalance, icon: $icon, color: $color, sortOrder: $sortOrder, archived: $archived, createdAt: $createdAt, balance: $balance)';
}


}

/// @nodoc
abstract mixin class $AccountCopyWith<$Res>  {
  factory $AccountCopyWith(Account value, $Res Function(Account) _then) = _$AccountCopyWithImpl;
@useResult
$Res call({
 String name, AccountType type, int? id, int openingBalance, String? icon, int? color, int sortOrder, bool archived, int createdAt, int balance
});




}
/// @nodoc
class _$AccountCopyWithImpl<$Res>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._self, this._then);

  final Account _self;
  final $Res Function(Account) _then;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? id = freezed,Object? openingBalance = null,Object? icon = freezed,Object? color = freezed,Object? sortOrder = null,Object? archived = null,Object? createdAt = null,Object? balance = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,openingBalance: null == openingBalance ? _self.openingBalance : openingBalance // ignore: cast_nullable_to_non_nullable
as int,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Account].
extension AccountPatterns on Account {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Account value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Account() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Account value)  $default,){
final _that = this;
switch (_that) {
case _Account():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Account value)?  $default,){
final _that = this;
switch (_that) {
case _Account() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  AccountType type,  int? id,  int openingBalance,  String? icon,  int? color,  int sortOrder,  bool archived,  int createdAt,  int balance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that.name,_that.type,_that.id,_that.openingBalance,_that.icon,_that.color,_that.sortOrder,_that.archived,_that.createdAt,_that.balance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  AccountType type,  int? id,  int openingBalance,  String? icon,  int? color,  int sortOrder,  bool archived,  int createdAt,  int balance)  $default,) {final _that = this;
switch (_that) {
case _Account():
return $default(_that.name,_that.type,_that.id,_that.openingBalance,_that.icon,_that.color,_that.sortOrder,_that.archived,_that.createdAt,_that.balance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  AccountType type,  int? id,  int openingBalance,  String? icon,  int? color,  int sortOrder,  bool archived,  int createdAt,  int balance)?  $default,) {final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that.name,_that.type,_that.id,_that.openingBalance,_that.icon,_that.color,_that.sortOrder,_that.archived,_that.createdAt,_that.balance);case _:
  return null;

}
}

}

/// @nodoc


class _Account implements Account {
  const _Account({required this.name, required this.type, this.id, this.openingBalance = 0, this.icon, this.color, this.sortOrder = 0, this.archived = false, this.createdAt = 0, this.balance = 0});
  

@override final  String name;
@override final  AccountType type;
/// `null` until persisted (SQLite AUTOINCREMENT assigns it on insert).
@override final  int? id;
@override@JsonKey() final  int openingBalance;
/// [AppIcons] catalog key, resolved to an `IconData` in the UI layer.
@override final  String? icon;
/// ARGB color value.
@override final  int? color;
@override@JsonKey() final  int sortOrder;
@override@JsonKey() final  bool archived;
@override@JsonKey() final  int createdAt;
/// Derived, non-persisted spendable balance. Populated by the balance SQL
/// query (opening balance +/- signed transaction sums); equals
/// [openingBalance] until transactions exist (M2).
@override@JsonKey() final  int balance;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountCopyWith<_Account> get copyWith => __$AccountCopyWithImpl<_Account>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Account&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.openingBalance, openingBalance) || other.openingBalance == openingBalance)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.balance, balance) || other.balance == balance));
}


@override
int get hashCode => Object.hash(runtimeType,name,type,id,openingBalance,icon,color,sortOrder,archived,createdAt,balance);

@override
String toString() {
  return 'Account(name: $name, type: $type, id: $id, openingBalance: $openingBalance, icon: $icon, color: $color, sortOrder: $sortOrder, archived: $archived, createdAt: $createdAt, balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$AccountCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$AccountCopyWith(_Account value, $Res Function(_Account) _then) = __$AccountCopyWithImpl;
@override @useResult
$Res call({
 String name, AccountType type, int? id, int openingBalance, String? icon, int? color, int sortOrder, bool archived, int createdAt, int balance
});




}
/// @nodoc
class __$AccountCopyWithImpl<$Res>
    implements _$AccountCopyWith<$Res> {
  __$AccountCopyWithImpl(this._self, this._then);

  final _Account _self;
  final $Res Function(_Account) _then;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? id = freezed,Object? openingBalance = null,Object? icon = freezed,Object? color = freezed,Object? sortOrder = null,Object? archived = null,Object? createdAt = null,Object? balance = null,}) {
  return _then(_Account(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,openingBalance: null == openingBalance ? _self.openingBalance : openingBalance // ignore: cast_nullable_to_non_nullable
as int,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
