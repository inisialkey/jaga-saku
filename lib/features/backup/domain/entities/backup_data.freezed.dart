// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BackupData {

 List<Map<String, Object?>> get settings; List<Map<String, Object?>> get accounts; List<Map<String, Object?>> get categories; List<Map<String, Object?>> get transactions; List<Map<String, Object?>> get budgets; List<Map<String, Object?>> get txTemplates; List<Map<String, Object?>> get recurring;
/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupDataCopyWith<BackupData> get copyWith => _$BackupDataCopyWithImpl<BackupData>(this as BackupData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupData&&const DeepCollectionEquality().equals(other.settings, settings)&&const DeepCollectionEquality().equals(other.accounts, accounts)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.transactions, transactions)&&const DeepCollectionEquality().equals(other.budgets, budgets)&&const DeepCollectionEquality().equals(other.txTemplates, txTemplates)&&const DeepCollectionEquality().equals(other.recurring, recurring));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(settings),const DeepCollectionEquality().hash(accounts),const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(transactions),const DeepCollectionEquality().hash(budgets),const DeepCollectionEquality().hash(txTemplates),const DeepCollectionEquality().hash(recurring));

@override
String toString() {
  return 'BackupData(settings: $settings, accounts: $accounts, categories: $categories, transactions: $transactions, budgets: $budgets, txTemplates: $txTemplates, recurring: $recurring)';
}


}

/// @nodoc
abstract mixin class $BackupDataCopyWith<$Res>  {
  factory $BackupDataCopyWith(BackupData value, $Res Function(BackupData) _then) = _$BackupDataCopyWithImpl;
@useResult
$Res call({
 List<Map<String, Object?>> settings, List<Map<String, Object?>> accounts, List<Map<String, Object?>> categories, List<Map<String, Object?>> transactions, List<Map<String, Object?>> budgets, List<Map<String, Object?>> txTemplates, List<Map<String, Object?>> recurring
});




}
/// @nodoc
class _$BackupDataCopyWithImpl<$Res>
    implements $BackupDataCopyWith<$Res> {
  _$BackupDataCopyWithImpl(this._self, this._then);

  final BackupData _self;
  final $Res Function(BackupData) _then;

/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? settings = null,Object? accounts = null,Object? categories = null,Object? transactions = null,Object? budgets = null,Object? txTemplates = null,Object? recurring = null,}) {
  return _then(_self.copyWith(
settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as List<Map<String, Object?>>,accounts: null == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<Map<String, Object?>>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Map<String, Object?>>,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<Map<String, Object?>>,budgets: null == budgets ? _self.budgets : budgets // ignore: cast_nullable_to_non_nullable
as List<Map<String, Object?>>,txTemplates: null == txTemplates ? _self.txTemplates : txTemplates // ignore: cast_nullable_to_non_nullable
as List<Map<String, Object?>>,recurring: null == recurring ? _self.recurring : recurring // ignore: cast_nullable_to_non_nullable
as List<Map<String, Object?>>,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupData].
extension BackupDataPatterns on BackupData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupData value)  $default,){
final _that = this;
switch (_that) {
case _BackupData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupData value)?  $default,){
final _that = this;
switch (_that) {
case _BackupData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Map<String, Object?>> settings,  List<Map<String, Object?>> accounts,  List<Map<String, Object?>> categories,  List<Map<String, Object?>> transactions,  List<Map<String, Object?>> budgets,  List<Map<String, Object?>> txTemplates,  List<Map<String, Object?>> recurring)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupData() when $default != null:
return $default(_that.settings,_that.accounts,_that.categories,_that.transactions,_that.budgets,_that.txTemplates,_that.recurring);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Map<String, Object?>> settings,  List<Map<String, Object?>> accounts,  List<Map<String, Object?>> categories,  List<Map<String, Object?>> transactions,  List<Map<String, Object?>> budgets,  List<Map<String, Object?>> txTemplates,  List<Map<String, Object?>> recurring)  $default,) {final _that = this;
switch (_that) {
case _BackupData():
return $default(_that.settings,_that.accounts,_that.categories,_that.transactions,_that.budgets,_that.txTemplates,_that.recurring);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Map<String, Object?>> settings,  List<Map<String, Object?>> accounts,  List<Map<String, Object?>> categories,  List<Map<String, Object?>> transactions,  List<Map<String, Object?>> budgets,  List<Map<String, Object?>> txTemplates,  List<Map<String, Object?>> recurring)?  $default,) {final _that = this;
switch (_that) {
case _BackupData() when $default != null:
return $default(_that.settings,_that.accounts,_that.categories,_that.transactions,_that.budgets,_that.txTemplates,_that.recurring);case _:
  return null;

}
}

}

/// @nodoc


class _BackupData implements BackupData {
  const _BackupData({final  List<Map<String, Object?>> settings = const <Map<String, Object?>>[], final  List<Map<String, Object?>> accounts = const <Map<String, Object?>>[], final  List<Map<String, Object?>> categories = const <Map<String, Object?>>[], final  List<Map<String, Object?>> transactions = const <Map<String, Object?>>[], final  List<Map<String, Object?>> budgets = const <Map<String, Object?>>[], final  List<Map<String, Object?>> txTemplates = const <Map<String, Object?>>[], final  List<Map<String, Object?>> recurring = const <Map<String, Object?>>[]}): _settings = settings,_accounts = accounts,_categories = categories,_transactions = transactions,_budgets = budgets,_txTemplates = txTemplates,_recurring = recurring;
  

 final  List<Map<String, Object?>> _settings;
@override@JsonKey() List<Map<String, Object?>> get settings {
  if (_settings is EqualUnmodifiableListView) return _settings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_settings);
}

 final  List<Map<String, Object?>> _accounts;
@override@JsonKey() List<Map<String, Object?>> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}

 final  List<Map<String, Object?>> _categories;
@override@JsonKey() List<Map<String, Object?>> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<Map<String, Object?>> _transactions;
@override@JsonKey() List<Map<String, Object?>> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

 final  List<Map<String, Object?>> _budgets;
@override@JsonKey() List<Map<String, Object?>> get budgets {
  if (_budgets is EqualUnmodifiableListView) return _budgets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_budgets);
}

 final  List<Map<String, Object?>> _txTemplates;
@override@JsonKey() List<Map<String, Object?>> get txTemplates {
  if (_txTemplates is EqualUnmodifiableListView) return _txTemplates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_txTemplates);
}

 final  List<Map<String, Object?>> _recurring;
@override@JsonKey() List<Map<String, Object?>> get recurring {
  if (_recurring is EqualUnmodifiableListView) return _recurring;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recurring);
}


/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupDataCopyWith<_BackupData> get copyWith => __$BackupDataCopyWithImpl<_BackupData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupData&&const DeepCollectionEquality().equals(other._settings, _settings)&&const DeepCollectionEquality().equals(other._accounts, _accounts)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._transactions, _transactions)&&const DeepCollectionEquality().equals(other._budgets, _budgets)&&const DeepCollectionEquality().equals(other._txTemplates, _txTemplates)&&const DeepCollectionEquality().equals(other._recurring, _recurring));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_settings),const DeepCollectionEquality().hash(_accounts),const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_transactions),const DeepCollectionEquality().hash(_budgets),const DeepCollectionEquality().hash(_txTemplates),const DeepCollectionEquality().hash(_recurring));

@override
String toString() {
  return 'BackupData(settings: $settings, accounts: $accounts, categories: $categories, transactions: $transactions, budgets: $budgets, txTemplates: $txTemplates, recurring: $recurring)';
}


}

/// @nodoc
abstract mixin class _$BackupDataCopyWith<$Res> implements $BackupDataCopyWith<$Res> {
  factory _$BackupDataCopyWith(_BackupData value, $Res Function(_BackupData) _then) = __$BackupDataCopyWithImpl;
@override @useResult
$Res call({
 List<Map<String, Object?>> settings, List<Map<String, Object?>> accounts, List<Map<String, Object?>> categories, List<Map<String, Object?>> transactions, List<Map<String, Object?>> budgets, List<Map<String, Object?>> txTemplates, List<Map<String, Object?>> recurring
});




}
/// @nodoc
class __$BackupDataCopyWithImpl<$Res>
    implements _$BackupDataCopyWith<$Res> {
  __$BackupDataCopyWithImpl(this._self, this._then);

  final _BackupData _self;
  final $Res Function(_BackupData) _then;

/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? settings = null,Object? accounts = null,Object? categories = null,Object? transactions = null,Object? budgets = null,Object? txTemplates = null,Object? recurring = null,}) {
  return _then(_BackupData(
settings: null == settings ? _self._settings : settings // ignore: cast_nullable_to_non_nullable
as List<Map<String, Object?>>,accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<Map<String, Object?>>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Map<String, Object?>>,transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<Map<String, Object?>>,budgets: null == budgets ? _self._budgets : budgets // ignore: cast_nullable_to_non_nullable
as List<Map<String, Object?>>,txTemplates: null == txTemplates ? _self._txTemplates : txTemplates // ignore: cast_nullable_to_non_nullable
as List<Map<String, Object?>>,recurring: null == recurring ? _self._recurring : recurring // ignore: cast_nullable_to_non_nullable
as List<Map<String, Object?>>,
  ));
}


}

// dart format on
