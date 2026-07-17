// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BackupFile {

/// DB schema the backup was written against — bound to
/// `Migrations.latestVersion`, never a literal.
 int get schemaVersion;/// Epoch millis the export ran; drives the filename + last-export metadata.
 int get exportedAt;/// Total rows across all seven tables (surfaced as "N items").
 int get itemCount;/// The serialized JSON envelope text, ready to persist to disk.
 String get content;
/// Create a copy of BackupFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupFileCopyWith<BackupFile> get copyWith => _$BackupFileCopyWithImpl<BackupFile>(this as BackupFile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupFile&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,schemaVersion,exportedAt,itemCount,content);

@override
String toString() {
  return 'BackupFile(schemaVersion: $schemaVersion, exportedAt: $exportedAt, itemCount: $itemCount, content: $content)';
}


}

/// @nodoc
abstract mixin class $BackupFileCopyWith<$Res>  {
  factory $BackupFileCopyWith(BackupFile value, $Res Function(BackupFile) _then) = _$BackupFileCopyWithImpl;
@useResult
$Res call({
 int schemaVersion, int exportedAt, int itemCount, String content
});




}
/// @nodoc
class _$BackupFileCopyWithImpl<$Res>
    implements $BackupFileCopyWith<$Res> {
  _$BackupFileCopyWithImpl(this._self, this._then);

  final BackupFile _self;
  final $Res Function(BackupFile) _then;

/// Create a copy of BackupFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schemaVersion = null,Object? exportedAt = null,Object? itemCount = null,Object? content = null,}) {
  return _then(_self.copyWith(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,exportedAt: null == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as int,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupFile].
extension BackupFilePatterns on BackupFile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupFile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupFile value)  $default,){
final _that = this;
switch (_that) {
case _BackupFile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupFile value)?  $default,){
final _that = this;
switch (_that) {
case _BackupFile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int schemaVersion,  int exportedAt,  int itemCount,  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupFile() when $default != null:
return $default(_that.schemaVersion,_that.exportedAt,_that.itemCount,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int schemaVersion,  int exportedAt,  int itemCount,  String content)  $default,) {final _that = this;
switch (_that) {
case _BackupFile():
return $default(_that.schemaVersion,_that.exportedAt,_that.itemCount,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int schemaVersion,  int exportedAt,  int itemCount,  String content)?  $default,) {final _that = this;
switch (_that) {
case _BackupFile() when $default != null:
return $default(_that.schemaVersion,_that.exportedAt,_that.itemCount,_that.content);case _:
  return null;

}
}

}

/// @nodoc


class _BackupFile implements BackupFile {
  const _BackupFile({required this.schemaVersion, required this.exportedAt, required this.itemCount, required this.content});
  

/// DB schema the backup was written against — bound to
/// `Migrations.latestVersion`, never a literal.
@override final  int schemaVersion;
/// Epoch millis the export ran; drives the filename + last-export metadata.
@override final  int exportedAt;
/// Total rows across all seven tables (surfaced as "N items").
@override final  int itemCount;
/// The serialized JSON envelope text, ready to persist to disk.
@override final  String content;

/// Create a copy of BackupFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupFileCopyWith<_BackupFile> get copyWith => __$BackupFileCopyWithImpl<_BackupFile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupFile&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,schemaVersion,exportedAt,itemCount,content);

@override
String toString() {
  return 'BackupFile(schemaVersion: $schemaVersion, exportedAt: $exportedAt, itemCount: $itemCount, content: $content)';
}


}

/// @nodoc
abstract mixin class _$BackupFileCopyWith<$Res> implements $BackupFileCopyWith<$Res> {
  factory _$BackupFileCopyWith(_BackupFile value, $Res Function(_BackupFile) _then) = __$BackupFileCopyWithImpl;
@override @useResult
$Res call({
 int schemaVersion, int exportedAt, int itemCount, String content
});




}
/// @nodoc
class __$BackupFileCopyWithImpl<$Res>
    implements _$BackupFileCopyWith<$Res> {
  __$BackupFileCopyWithImpl(this._self, this._then);

  final _BackupFile _self;
  final $Res Function(_BackupFile) _then;

/// Create a copy of BackupFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schemaVersion = null,Object? exportedAt = null,Object? itemCount = null,Object? content = null,}) {
  return _then(_BackupFile(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,exportedAt: null == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as int,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
