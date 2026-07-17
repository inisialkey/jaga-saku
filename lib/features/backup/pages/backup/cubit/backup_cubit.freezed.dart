// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BackupState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BackupState()';
}


}

/// @nodoc
class $BackupStateCopyWith<$Res>  {
$BackupStateCopyWith(BackupState _, $Res Function(BackupState) __);
}


/// Adds pattern-matching-related methods to [BackupState].
extension BackupStatePatterns on BackupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BackupIdle value)?  idle,TResult Function( BackupExporting value)?  exporting,TResult Function( BackupExportSuccess value)?  exportSuccess,TResult Function( BackupValidating value)?  validating,TResult Function( BackupPreviewReady value)?  previewReady,TResult Function( BackupRestoring value)?  restoring,TResult Function( BackupRestoreSuccess value)?  restoreSuccess,TResult Function( BackupFailureState value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BackupIdle() when idle != null:
return idle(_that);case BackupExporting() when exporting != null:
return exporting(_that);case BackupExportSuccess() when exportSuccess != null:
return exportSuccess(_that);case BackupValidating() when validating != null:
return validating(_that);case BackupPreviewReady() when previewReady != null:
return previewReady(_that);case BackupRestoring() when restoring != null:
return restoring(_that);case BackupRestoreSuccess() when restoreSuccess != null:
return restoreSuccess(_that);case BackupFailureState() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BackupIdle value)  idle,required TResult Function( BackupExporting value)  exporting,required TResult Function( BackupExportSuccess value)  exportSuccess,required TResult Function( BackupValidating value)  validating,required TResult Function( BackupPreviewReady value)  previewReady,required TResult Function( BackupRestoring value)  restoring,required TResult Function( BackupRestoreSuccess value)  restoreSuccess,required TResult Function( BackupFailureState value)  failure,}){
final _that = this;
switch (_that) {
case BackupIdle():
return idle(_that);case BackupExporting():
return exporting(_that);case BackupExportSuccess():
return exportSuccess(_that);case BackupValidating():
return validating(_that);case BackupPreviewReady():
return previewReady(_that);case BackupRestoring():
return restoring(_that);case BackupRestoreSuccess():
return restoreSuccess(_that);case BackupFailureState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BackupIdle value)?  idle,TResult? Function( BackupExporting value)?  exporting,TResult? Function( BackupExportSuccess value)?  exportSuccess,TResult? Function( BackupValidating value)?  validating,TResult? Function( BackupPreviewReady value)?  previewReady,TResult? Function( BackupRestoring value)?  restoring,TResult? Function( BackupRestoreSuccess value)?  restoreSuccess,TResult? Function( BackupFailureState value)?  failure,}){
final _that = this;
switch (_that) {
case BackupIdle() when idle != null:
return idle(_that);case BackupExporting() when exporting != null:
return exporting(_that);case BackupExportSuccess() when exportSuccess != null:
return exportSuccess(_that);case BackupValidating() when validating != null:
return validating(_that);case BackupPreviewReady() when previewReady != null:
return previewReady(_that);case BackupRestoring() when restoring != null:
return restoring(_that);case BackupRestoreSuccess() when restoreSuccess != null:
return restoreSuccess(_that);case BackupFailureState() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int? lastExportedAt,  int? lastItemCount)?  idle,TResult Function()?  exporting,TResult Function()?  exportSuccess,TResult Function()?  validating,TResult Function( BackupPreview preview,  BackupData data)?  previewReady,TResult Function()?  restoring,TResult Function( BackupPreview preview)?  restoreSuccess,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BackupIdle() when idle != null:
return idle(_that.lastExportedAt,_that.lastItemCount);case BackupExporting() when exporting != null:
return exporting();case BackupExportSuccess() when exportSuccess != null:
return exportSuccess();case BackupValidating() when validating != null:
return validating();case BackupPreviewReady() when previewReady != null:
return previewReady(_that.preview,_that.data);case BackupRestoring() when restoring != null:
return restoring();case BackupRestoreSuccess() when restoreSuccess != null:
return restoreSuccess(_that.preview);case BackupFailureState() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int? lastExportedAt,  int? lastItemCount)  idle,required TResult Function()  exporting,required TResult Function()  exportSuccess,required TResult Function()  validating,required TResult Function( BackupPreview preview,  BackupData data)  previewReady,required TResult Function()  restoring,required TResult Function( BackupPreview preview)  restoreSuccess,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case BackupIdle():
return idle(_that.lastExportedAt,_that.lastItemCount);case BackupExporting():
return exporting();case BackupExportSuccess():
return exportSuccess();case BackupValidating():
return validating();case BackupPreviewReady():
return previewReady(_that.preview,_that.data);case BackupRestoring():
return restoring();case BackupRestoreSuccess():
return restoreSuccess(_that.preview);case BackupFailureState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int? lastExportedAt,  int? lastItemCount)?  idle,TResult? Function()?  exporting,TResult? Function()?  exportSuccess,TResult? Function()?  validating,TResult? Function( BackupPreview preview,  BackupData data)?  previewReady,TResult? Function()?  restoring,TResult? Function( BackupPreview preview)?  restoreSuccess,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case BackupIdle() when idle != null:
return idle(_that.lastExportedAt,_that.lastItemCount);case BackupExporting() when exporting != null:
return exporting();case BackupExportSuccess() when exportSuccess != null:
return exportSuccess();case BackupValidating() when validating != null:
return validating();case BackupPreviewReady() when previewReady != null:
return previewReady(_that.preview,_that.data);case BackupRestoring() when restoring != null:
return restoring();case BackupRestoreSuccess() when restoreSuccess != null:
return restoreSuccess(_that.preview);case BackupFailureState() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class BackupIdle implements BackupState {
  const BackupIdle({this.lastExportedAt, this.lastItemCount});
  

 final  int? lastExportedAt;
 final  int? lastItemCount;

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupIdleCopyWith<BackupIdle> get copyWith => _$BackupIdleCopyWithImpl<BackupIdle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupIdle&&(identical(other.lastExportedAt, lastExportedAt) || other.lastExportedAt == lastExportedAt)&&(identical(other.lastItemCount, lastItemCount) || other.lastItemCount == lastItemCount));
}


@override
int get hashCode => Object.hash(runtimeType,lastExportedAt,lastItemCount);

@override
String toString() {
  return 'BackupState.idle(lastExportedAt: $lastExportedAt, lastItemCount: $lastItemCount)';
}


}

/// @nodoc
abstract mixin class $BackupIdleCopyWith<$Res> implements $BackupStateCopyWith<$Res> {
  factory $BackupIdleCopyWith(BackupIdle value, $Res Function(BackupIdle) _then) = _$BackupIdleCopyWithImpl;
@useResult
$Res call({
 int? lastExportedAt, int? lastItemCount
});




}
/// @nodoc
class _$BackupIdleCopyWithImpl<$Res>
    implements $BackupIdleCopyWith<$Res> {
  _$BackupIdleCopyWithImpl(this._self, this._then);

  final BackupIdle _self;
  final $Res Function(BackupIdle) _then;

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lastExportedAt = freezed,Object? lastItemCount = freezed,}) {
  return _then(BackupIdle(
lastExportedAt: freezed == lastExportedAt ? _self.lastExportedAt : lastExportedAt // ignore: cast_nullable_to_non_nullable
as int?,lastItemCount: freezed == lastItemCount ? _self.lastItemCount : lastItemCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class BackupExporting implements BackupState {
  const BackupExporting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupExporting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BackupState.exporting()';
}


}




/// @nodoc


class BackupExportSuccess implements BackupState {
  const BackupExportSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupExportSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BackupState.exportSuccess()';
}


}




/// @nodoc


class BackupValidating implements BackupState {
  const BackupValidating();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupValidating);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BackupState.validating()';
}


}




/// @nodoc


class BackupPreviewReady implements BackupState {
  const BackupPreviewReady({required this.preview, required this.data});
  

 final  BackupPreview preview;
 final  BackupData data;

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupPreviewReadyCopyWith<BackupPreviewReady> get copyWith => _$BackupPreviewReadyCopyWithImpl<BackupPreviewReady>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupPreviewReady&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,preview,data);

@override
String toString() {
  return 'BackupState.previewReady(preview: $preview, data: $data)';
}


}

/// @nodoc
abstract mixin class $BackupPreviewReadyCopyWith<$Res> implements $BackupStateCopyWith<$Res> {
  factory $BackupPreviewReadyCopyWith(BackupPreviewReady value, $Res Function(BackupPreviewReady) _then) = _$BackupPreviewReadyCopyWithImpl;
@useResult
$Res call({
 BackupPreview preview, BackupData data
});


$BackupPreviewCopyWith<$Res> get preview;$BackupDataCopyWith<$Res> get data;

}
/// @nodoc
class _$BackupPreviewReadyCopyWithImpl<$Res>
    implements $BackupPreviewReadyCopyWith<$Res> {
  _$BackupPreviewReadyCopyWithImpl(this._self, this._then);

  final BackupPreviewReady _self;
  final $Res Function(BackupPreviewReady) _then;

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? preview = null,Object? data = null,}) {
  return _then(BackupPreviewReady(
preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as BackupPreview,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as BackupData,
  ));
}

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackupPreviewCopyWith<$Res> get preview {
  
  return $BackupPreviewCopyWith<$Res>(_self.preview, (value) {
    return _then(_self.copyWith(preview: value));
  });
}/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackupDataCopyWith<$Res> get data {
  
  return $BackupDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc


class BackupRestoring implements BackupState {
  const BackupRestoring();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupRestoring);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BackupState.restoring()';
}


}




/// @nodoc


class BackupRestoreSuccess implements BackupState {
  const BackupRestoreSuccess(this.preview);
  

 final  BackupPreview preview;

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupRestoreSuccessCopyWith<BackupRestoreSuccess> get copyWith => _$BackupRestoreSuccessCopyWithImpl<BackupRestoreSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupRestoreSuccess&&(identical(other.preview, preview) || other.preview == preview));
}


@override
int get hashCode => Object.hash(runtimeType,preview);

@override
String toString() {
  return 'BackupState.restoreSuccess(preview: $preview)';
}


}

/// @nodoc
abstract mixin class $BackupRestoreSuccessCopyWith<$Res> implements $BackupStateCopyWith<$Res> {
  factory $BackupRestoreSuccessCopyWith(BackupRestoreSuccess value, $Res Function(BackupRestoreSuccess) _then) = _$BackupRestoreSuccessCopyWithImpl;
@useResult
$Res call({
 BackupPreview preview
});


$BackupPreviewCopyWith<$Res> get preview;

}
/// @nodoc
class _$BackupRestoreSuccessCopyWithImpl<$Res>
    implements $BackupRestoreSuccessCopyWith<$Res> {
  _$BackupRestoreSuccessCopyWithImpl(this._self, this._then);

  final BackupRestoreSuccess _self;
  final $Res Function(BackupRestoreSuccess) _then;

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? preview = null,}) {
  return _then(BackupRestoreSuccess(
null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as BackupPreview,
  ));
}

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackupPreviewCopyWith<$Res> get preview {
  
  return $BackupPreviewCopyWith<$Res>(_self.preview, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}

/// @nodoc


class BackupFailureState implements BackupState {
  const BackupFailureState(this.failure);
  

 final  Failure failure;

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupFailureStateCopyWith<BackupFailureState> get copyWith => _$BackupFailureStateCopyWithImpl<BackupFailureState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupFailureState&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'BackupState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $BackupFailureStateCopyWith<$Res> implements $BackupStateCopyWith<$Res> {
  factory $BackupFailureStateCopyWith(BackupFailureState value, $Res Function(BackupFailureState) _then) = _$BackupFailureStateCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$BackupFailureStateCopyWithImpl<$Res>
    implements $BackupFailureStateCopyWith<$Res> {
  _$BackupFailureStateCopyWithImpl(this._self, this._then);

  final BackupFailureState _self;
  final $Res Function(BackupFailureState) _then;

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(BackupFailureState(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
