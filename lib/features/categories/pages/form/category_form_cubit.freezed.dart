// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_form_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoryFormState {

 CategoryType get type; String get name; int? get parentId; String? get icon; int? get color;/// Top-level, same-type categories offered as a parent (excludes self).
 List<Category> get parentOptions; CategoryFormStatus get status; Failure? get error; bool get isEditing;
/// Create a copy of CategoryFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryFormStateCopyWith<CategoryFormState> get copyWith => _$CategoryFormStateCopyWithImpl<CategoryFormState>(this as CategoryFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryFormState&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&const DeepCollectionEquality().equals(other.parentOptions, parentOptions)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.isEditing, isEditing) || other.isEditing == isEditing));
}


@override
int get hashCode => Object.hash(runtimeType,type,name,parentId,icon,color,const DeepCollectionEquality().hash(parentOptions),status,error,isEditing);

@override
String toString() {
  return 'CategoryFormState(type: $type, name: $name, parentId: $parentId, icon: $icon, color: $color, parentOptions: $parentOptions, status: $status, error: $error, isEditing: $isEditing)';
}


}

/// @nodoc
abstract mixin class $CategoryFormStateCopyWith<$Res>  {
  factory $CategoryFormStateCopyWith(CategoryFormState value, $Res Function(CategoryFormState) _then) = _$CategoryFormStateCopyWithImpl;
@useResult
$Res call({
 CategoryType type, String name, int? parentId, String? icon, int? color, List<Category> parentOptions, CategoryFormStatus status, Failure? error, bool isEditing
});




}
/// @nodoc
class _$CategoryFormStateCopyWithImpl<$Res>
    implements $CategoryFormStateCopyWith<$Res> {
  _$CategoryFormStateCopyWithImpl(this._self, this._then);

  final CategoryFormState _self;
  final $Res Function(CategoryFormState) _then;

/// Create a copy of CategoryFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? name = null,Object? parentId = freezed,Object? icon = freezed,Object? color = freezed,Object? parentOptions = null,Object? status = null,Object? error = freezed,Object? isEditing = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CategoryType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int?,parentOptions: null == parentOptions ? _self.parentOptions : parentOptions // ignore: cast_nullable_to_non_nullable
as List<Category>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CategoryFormStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,isEditing: null == isEditing ? _self.isEditing : isEditing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryFormState].
extension CategoryFormStatePatterns on CategoryFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryFormState value)  $default,){
final _that = this;
switch (_that) {
case _CategoryFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryFormState value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CategoryType type,  String name,  int? parentId,  String? icon,  int? color,  List<Category> parentOptions,  CategoryFormStatus status,  Failure? error,  bool isEditing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryFormState() when $default != null:
return $default(_that.type,_that.name,_that.parentId,_that.icon,_that.color,_that.parentOptions,_that.status,_that.error,_that.isEditing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CategoryType type,  String name,  int? parentId,  String? icon,  int? color,  List<Category> parentOptions,  CategoryFormStatus status,  Failure? error,  bool isEditing)  $default,) {final _that = this;
switch (_that) {
case _CategoryFormState():
return $default(_that.type,_that.name,_that.parentId,_that.icon,_that.color,_that.parentOptions,_that.status,_that.error,_that.isEditing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CategoryType type,  String name,  int? parentId,  String? icon,  int? color,  List<Category> parentOptions,  CategoryFormStatus status,  Failure? error,  bool isEditing)?  $default,) {final _that = this;
switch (_that) {
case _CategoryFormState() when $default != null:
return $default(_that.type,_that.name,_that.parentId,_that.icon,_that.color,_that.parentOptions,_that.status,_that.error,_that.isEditing);case _:
  return null;

}
}

}

/// @nodoc


class _CategoryFormState extends CategoryFormState {
  const _CategoryFormState({this.type = CategoryType.expense, this.name = '', this.parentId, this.icon, this.color, final  List<Category> parentOptions = const <Category>[], this.status = CategoryFormStatus.editing, this.error, this.isEditing = false}): _parentOptions = parentOptions,super._();
  

@override@JsonKey() final  CategoryType type;
@override@JsonKey() final  String name;
@override final  int? parentId;
@override final  String? icon;
@override final  int? color;
/// Top-level, same-type categories offered as a parent (excludes self).
 final  List<Category> _parentOptions;
/// Top-level, same-type categories offered as a parent (excludes self).
@override@JsonKey() List<Category> get parentOptions {
  if (_parentOptions is EqualUnmodifiableListView) return _parentOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parentOptions);
}

@override@JsonKey() final  CategoryFormStatus status;
@override final  Failure? error;
@override@JsonKey() final  bool isEditing;

/// Create a copy of CategoryFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryFormStateCopyWith<_CategoryFormState> get copyWith => __$CategoryFormStateCopyWithImpl<_CategoryFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryFormState&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&const DeepCollectionEquality().equals(other._parentOptions, _parentOptions)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.isEditing, isEditing) || other.isEditing == isEditing));
}


@override
int get hashCode => Object.hash(runtimeType,type,name,parentId,icon,color,const DeepCollectionEquality().hash(_parentOptions),status,error,isEditing);

@override
String toString() {
  return 'CategoryFormState(type: $type, name: $name, parentId: $parentId, icon: $icon, color: $color, parentOptions: $parentOptions, status: $status, error: $error, isEditing: $isEditing)';
}


}

/// @nodoc
abstract mixin class _$CategoryFormStateCopyWith<$Res> implements $CategoryFormStateCopyWith<$Res> {
  factory _$CategoryFormStateCopyWith(_CategoryFormState value, $Res Function(_CategoryFormState) _then) = __$CategoryFormStateCopyWithImpl;
@override @useResult
$Res call({
 CategoryType type, String name, int? parentId, String? icon, int? color, List<Category> parentOptions, CategoryFormStatus status, Failure? error, bool isEditing
});




}
/// @nodoc
class __$CategoryFormStateCopyWithImpl<$Res>
    implements _$CategoryFormStateCopyWith<$Res> {
  __$CategoryFormStateCopyWithImpl(this._self, this._then);

  final _CategoryFormState _self;
  final $Res Function(_CategoryFormState) _then;

/// Create a copy of CategoryFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? name = null,Object? parentId = freezed,Object? icon = freezed,Object? color = freezed,Object? parentOptions = null,Object? status = null,Object? error = freezed,Object? isEditing = null,}) {
  return _then(_CategoryFormState(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CategoryType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int?,parentOptions: null == parentOptions ? _self._parentOptions : parentOptions // ignore: cast_nullable_to_non_nullable
as List<Category>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CategoryFormStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,isEditing: null == isEditing ? _self.isEditing : isEditing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
