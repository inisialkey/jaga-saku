// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExportState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExportState()';
}


}

/// @nodoc
class $ExportStateCopyWith<$Res>  {
$ExportStateCopyWith(ExportState _, $Res Function(ExportState) __);
}


/// Adds pattern-matching-related methods to [ExportState].
extension ExportStatePatterns on ExportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ExportLoading value)?  loading,TResult Function( ExportLoadFailure value)?  loadFailure,TResult Function( ExportConfiguring value)?  configuring,TResult Function( ExportSuccess value)?  success,TResult Function( ExportEmptyResult value)?  emptyResult,TResult Function( ExportFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ExportLoading() when loading != null:
return loading(_that);case ExportLoadFailure() when loadFailure != null:
return loadFailure(_that);case ExportConfiguring() when configuring != null:
return configuring(_that);case ExportSuccess() when success != null:
return success(_that);case ExportEmptyResult() when emptyResult != null:
return emptyResult(_that);case ExportFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ExportLoading value)  loading,required TResult Function( ExportLoadFailure value)  loadFailure,required TResult Function( ExportConfiguring value)  configuring,required TResult Function( ExportSuccess value)  success,required TResult Function( ExportEmptyResult value)  emptyResult,required TResult Function( ExportFailure value)  failure,}){
final _that = this;
switch (_that) {
case ExportLoading():
return loading(_that);case ExportLoadFailure():
return loadFailure(_that);case ExportConfiguring():
return configuring(_that);case ExportSuccess():
return success(_that);case ExportEmptyResult():
return emptyResult(_that);case ExportFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ExportLoading value)?  loading,TResult? Function( ExportLoadFailure value)?  loadFailure,TResult? Function( ExportConfiguring value)?  configuring,TResult? Function( ExportSuccess value)?  success,TResult? Function( ExportEmptyResult value)?  emptyResult,TResult? Function( ExportFailure value)?  failure,}){
final _that = this;
switch (_that) {
case ExportLoading() when loading != null:
return loading(_that);case ExportLoadFailure() when loadFailure != null:
return loadFailure(_that);case ExportConfiguring() when configuring != null:
return configuring(_that);case ExportSuccess() when success != null:
return success(_that);case ExportEmptyResult() when emptyResult != null:
return emptyResult(_that);case ExportFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( Failure failure)?  loadFailure,TResult Function( ExportOptions options,  List<Account> accounts,  List<Category> categories,  bool isExporting)?  configuring,TResult Function( int rowCount)?  success,TResult Function()?  emptyResult,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ExportLoading() when loading != null:
return loading();case ExportLoadFailure() when loadFailure != null:
return loadFailure(_that.failure);case ExportConfiguring() when configuring != null:
return configuring(_that.options,_that.accounts,_that.categories,_that.isExporting);case ExportSuccess() when success != null:
return success(_that.rowCount);case ExportEmptyResult() when emptyResult != null:
return emptyResult();case ExportFailure() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( Failure failure)  loadFailure,required TResult Function( ExportOptions options,  List<Account> accounts,  List<Category> categories,  bool isExporting)  configuring,required TResult Function( int rowCount)  success,required TResult Function()  emptyResult,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case ExportLoading():
return loading();case ExportLoadFailure():
return loadFailure(_that.failure);case ExportConfiguring():
return configuring(_that.options,_that.accounts,_that.categories,_that.isExporting);case ExportSuccess():
return success(_that.rowCount);case ExportEmptyResult():
return emptyResult();case ExportFailure():
return failure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( Failure failure)?  loadFailure,TResult? Function( ExportOptions options,  List<Account> accounts,  List<Category> categories,  bool isExporting)?  configuring,TResult? Function( int rowCount)?  success,TResult? Function()?  emptyResult,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case ExportLoading() when loading != null:
return loading();case ExportLoadFailure() when loadFailure != null:
return loadFailure(_that.failure);case ExportConfiguring() when configuring != null:
return configuring(_that.options,_that.accounts,_that.categories,_that.isExporting);case ExportSuccess() when success != null:
return success(_that.rowCount);case ExportEmptyResult() when emptyResult != null:
return emptyResult();case ExportFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ExportLoading implements ExportState {
  const ExportLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExportState.loading()';
}


}




/// @nodoc


class ExportLoadFailure implements ExportState {
  const ExportLoadFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of ExportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportLoadFailureCopyWith<ExportLoadFailure> get copyWith => _$ExportLoadFailureCopyWithImpl<ExportLoadFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportLoadFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ExportState.loadFailure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ExportLoadFailureCopyWith<$Res> implements $ExportStateCopyWith<$Res> {
  factory $ExportLoadFailureCopyWith(ExportLoadFailure value, $Res Function(ExportLoadFailure) _then) = _$ExportLoadFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$ExportLoadFailureCopyWithImpl<$Res>
    implements $ExportLoadFailureCopyWith<$Res> {
  _$ExportLoadFailureCopyWithImpl(this._self, this._then);

  final ExportLoadFailure _self;
  final $Res Function(ExportLoadFailure) _then;

/// Create a copy of ExportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ExportLoadFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

/// @nodoc


class ExportConfiguring implements ExportState {
  const ExportConfiguring({required this.options, required final  List<Account> accounts, required final  List<Category> categories, this.isExporting = false}): _accounts = accounts,_categories = categories;
  

 final  ExportOptions options;
 final  List<Account> _accounts;
 List<Account> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}

 final  List<Category> _categories;
 List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@JsonKey() final  bool isExporting;

/// Create a copy of ExportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportConfiguringCopyWith<ExportConfiguring> get copyWith => _$ExportConfiguringCopyWithImpl<ExportConfiguring>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportConfiguring&&(identical(other.options, options) || other.options == options)&&const DeepCollectionEquality().equals(other._accounts, _accounts)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.isExporting, isExporting) || other.isExporting == isExporting));
}


@override
int get hashCode => Object.hash(runtimeType,options,const DeepCollectionEquality().hash(_accounts),const DeepCollectionEquality().hash(_categories),isExporting);

@override
String toString() {
  return 'ExportState.configuring(options: $options, accounts: $accounts, categories: $categories, isExporting: $isExporting)';
}


}

/// @nodoc
abstract mixin class $ExportConfiguringCopyWith<$Res> implements $ExportStateCopyWith<$Res> {
  factory $ExportConfiguringCopyWith(ExportConfiguring value, $Res Function(ExportConfiguring) _then) = _$ExportConfiguringCopyWithImpl;
@useResult
$Res call({
 ExportOptions options, List<Account> accounts, List<Category> categories, bool isExporting
});


$ExportOptionsCopyWith<$Res> get options;

}
/// @nodoc
class _$ExportConfiguringCopyWithImpl<$Res>
    implements $ExportConfiguringCopyWith<$Res> {
  _$ExportConfiguringCopyWithImpl(this._self, this._then);

  final ExportConfiguring _self;
  final $Res Function(ExportConfiguring) _then;

/// Create a copy of ExportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? options = null,Object? accounts = null,Object? categories = null,Object? isExporting = null,}) {
  return _then(ExportConfiguring(
options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as ExportOptions,accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<Account>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,isExporting: null == isExporting ? _self.isExporting : isExporting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ExportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExportOptionsCopyWith<$Res> get options {
  
  return $ExportOptionsCopyWith<$Res>(_self.options, (value) {
    return _then(_self.copyWith(options: value));
  });
}
}

/// @nodoc


class ExportSuccess implements ExportState {
  const ExportSuccess(this.rowCount);
  

 final  int rowCount;

/// Create a copy of ExportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportSuccessCopyWith<ExportSuccess> get copyWith => _$ExportSuccessCopyWithImpl<ExportSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportSuccess&&(identical(other.rowCount, rowCount) || other.rowCount == rowCount));
}


@override
int get hashCode => Object.hash(runtimeType,rowCount);

@override
String toString() {
  return 'ExportState.success(rowCount: $rowCount)';
}


}

/// @nodoc
abstract mixin class $ExportSuccessCopyWith<$Res> implements $ExportStateCopyWith<$Res> {
  factory $ExportSuccessCopyWith(ExportSuccess value, $Res Function(ExportSuccess) _then) = _$ExportSuccessCopyWithImpl;
@useResult
$Res call({
 int rowCount
});




}
/// @nodoc
class _$ExportSuccessCopyWithImpl<$Res>
    implements $ExportSuccessCopyWith<$Res> {
  _$ExportSuccessCopyWithImpl(this._self, this._then);

  final ExportSuccess _self;
  final $Res Function(ExportSuccess) _then;

/// Create a copy of ExportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? rowCount = null,}) {
  return _then(ExportSuccess(
null == rowCount ? _self.rowCount : rowCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ExportEmptyResult implements ExportState {
  const ExportEmptyResult();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportEmptyResult);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExportState.emptyResult()';
}


}




/// @nodoc


class ExportFailure implements ExportState {
  const ExportFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of ExportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportFailureCopyWith<ExportFailure> get copyWith => _$ExportFailureCopyWithImpl<ExportFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ExportState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ExportFailureCopyWith<$Res> implements $ExportStateCopyWith<$Res> {
  factory $ExportFailureCopyWith(ExportFailure value, $Res Function(ExportFailure) _then) = _$ExportFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$ExportFailureCopyWithImpl<$Res>
    implements $ExportFailureCopyWith<$Res> {
  _$ExportFailureCopyWithImpl(this._self, this._then);

  final ExportFailure _self;
  final $Res Function(ExportFailure) _then;

/// Create a copy of ExportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ExportFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
