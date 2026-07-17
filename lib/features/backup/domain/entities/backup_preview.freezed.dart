// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_preview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BackupPreview {

 int get accounts; int get transactions; int get categories; int get budgets; int get recurring; int get templates; int get settings; int get exportedAt;
/// Create a copy of BackupPreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupPreviewCopyWith<BackupPreview> get copyWith => _$BackupPreviewCopyWithImpl<BackupPreview>(this as BackupPreview, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupPreview&&(identical(other.accounts, accounts) || other.accounts == accounts)&&(identical(other.transactions, transactions) || other.transactions == transactions)&&(identical(other.categories, categories) || other.categories == categories)&&(identical(other.budgets, budgets) || other.budgets == budgets)&&(identical(other.recurring, recurring) || other.recurring == recurring)&&(identical(other.templates, templates) || other.templates == templates)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt));
}


@override
int get hashCode => Object.hash(runtimeType,accounts,transactions,categories,budgets,recurring,templates,settings,exportedAt);

@override
String toString() {
  return 'BackupPreview(accounts: $accounts, transactions: $transactions, categories: $categories, budgets: $budgets, recurring: $recurring, templates: $templates, settings: $settings, exportedAt: $exportedAt)';
}


}

/// @nodoc
abstract mixin class $BackupPreviewCopyWith<$Res>  {
  factory $BackupPreviewCopyWith(BackupPreview value, $Res Function(BackupPreview) _then) = _$BackupPreviewCopyWithImpl;
@useResult
$Res call({
 int accounts, int transactions, int categories, int budgets, int recurring, int templates, int settings, int exportedAt
});




}
/// @nodoc
class _$BackupPreviewCopyWithImpl<$Res>
    implements $BackupPreviewCopyWith<$Res> {
  _$BackupPreviewCopyWithImpl(this._self, this._then);

  final BackupPreview _self;
  final $Res Function(BackupPreview) _then;

/// Create a copy of BackupPreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accounts = null,Object? transactions = null,Object? categories = null,Object? budgets = null,Object? recurring = null,Object? templates = null,Object? settings = null,Object? exportedAt = null,}) {
  return _then(_self.copyWith(
accounts: null == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as int,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as int,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as int,budgets: null == budgets ? _self.budgets : budgets // ignore: cast_nullable_to_non_nullable
as int,recurring: null == recurring ? _self.recurring : recurring // ignore: cast_nullable_to_non_nullable
as int,templates: null == templates ? _self.templates : templates // ignore: cast_nullable_to_non_nullable
as int,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as int,exportedAt: null == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupPreview].
extension BackupPreviewPatterns on BackupPreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupPreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupPreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupPreview value)  $default,){
final _that = this;
switch (_that) {
case _BackupPreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupPreview value)?  $default,){
final _that = this;
switch (_that) {
case _BackupPreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int accounts,  int transactions,  int categories,  int budgets,  int recurring,  int templates,  int settings,  int exportedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupPreview() when $default != null:
return $default(_that.accounts,_that.transactions,_that.categories,_that.budgets,_that.recurring,_that.templates,_that.settings,_that.exportedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int accounts,  int transactions,  int categories,  int budgets,  int recurring,  int templates,  int settings,  int exportedAt)  $default,) {final _that = this;
switch (_that) {
case _BackupPreview():
return $default(_that.accounts,_that.transactions,_that.categories,_that.budgets,_that.recurring,_that.templates,_that.settings,_that.exportedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int accounts,  int transactions,  int categories,  int budgets,  int recurring,  int templates,  int settings,  int exportedAt)?  $default,) {final _that = this;
switch (_that) {
case _BackupPreview() when $default != null:
return $default(_that.accounts,_that.transactions,_that.categories,_that.budgets,_that.recurring,_that.templates,_that.settings,_that.exportedAt);case _:
  return null;

}
}

}

/// @nodoc


class _BackupPreview implements BackupPreview {
  const _BackupPreview({this.accounts = 0, this.transactions = 0, this.categories = 0, this.budgets = 0, this.recurring = 0, this.templates = 0, this.settings = 0, this.exportedAt = 0});
  

@override@JsonKey() final  int accounts;
@override@JsonKey() final  int transactions;
@override@JsonKey() final  int categories;
@override@JsonKey() final  int budgets;
@override@JsonKey() final  int recurring;
@override@JsonKey() final  int templates;
@override@JsonKey() final  int settings;
@override@JsonKey() final  int exportedAt;

/// Create a copy of BackupPreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupPreviewCopyWith<_BackupPreview> get copyWith => __$BackupPreviewCopyWithImpl<_BackupPreview>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupPreview&&(identical(other.accounts, accounts) || other.accounts == accounts)&&(identical(other.transactions, transactions) || other.transactions == transactions)&&(identical(other.categories, categories) || other.categories == categories)&&(identical(other.budgets, budgets) || other.budgets == budgets)&&(identical(other.recurring, recurring) || other.recurring == recurring)&&(identical(other.templates, templates) || other.templates == templates)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt));
}


@override
int get hashCode => Object.hash(runtimeType,accounts,transactions,categories,budgets,recurring,templates,settings,exportedAt);

@override
String toString() {
  return 'BackupPreview(accounts: $accounts, transactions: $transactions, categories: $categories, budgets: $budgets, recurring: $recurring, templates: $templates, settings: $settings, exportedAt: $exportedAt)';
}


}

/// @nodoc
abstract mixin class _$BackupPreviewCopyWith<$Res> implements $BackupPreviewCopyWith<$Res> {
  factory _$BackupPreviewCopyWith(_BackupPreview value, $Res Function(_BackupPreview) _then) = __$BackupPreviewCopyWithImpl;
@override @useResult
$Res call({
 int accounts, int transactions, int categories, int budgets, int recurring, int templates, int settings, int exportedAt
});




}
/// @nodoc
class __$BackupPreviewCopyWithImpl<$Res>
    implements _$BackupPreviewCopyWith<$Res> {
  __$BackupPreviewCopyWithImpl(this._self, this._then);

  final _BackupPreview _self;
  final $Res Function(_BackupPreview) _then;

/// Create a copy of BackupPreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accounts = null,Object? transactions = null,Object? categories = null,Object? budgets = null,Object? recurring = null,Object? templates = null,Object? settings = null,Object? exportedAt = null,}) {
  return _then(_BackupPreview(
accounts: null == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as int,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as int,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as int,budgets: null == budgets ? _self.budgets : budgets // ignore: cast_nullable_to_non_nullable
as int,recurring: null == recurring ? _self.recurring : recurring // ignore: cast_nullable_to_non_nullable
as int,templates: null == templates ? _self.templates : templates // ignore: cast_nullable_to_non_nullable
as int,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as int,exportedAt: null == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
