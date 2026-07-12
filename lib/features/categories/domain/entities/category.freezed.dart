// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Category {

 String get name; CategoryType get type;/// `null` until persisted (AUTOINCREMENT assigns it on insert).
 int? get id;/// Parent category id; `null` for a top-level category.
 int? get parentId;/// [AppIcons] catalog key.
 String? get icon;/// ARGB color value.
 int? get color; int get sortOrder; bool get archived; int get createdAt;/// Reserved system-category marker (V2-M6). Non-null for an app-owned
/// built-in — the reconcile "Penyesuaian" pair (`adjustment_in` /
/// `adjustment_out`); null for every normal user category. Matched at
/// runtime so a rename / locale change can't break report exclusion.
 String? get systemKey;
/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryCopyWith<Category> get copyWith => _$CategoryCopyWithImpl<Category>(this as Category, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Category&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.systemKey, systemKey) || other.systemKey == systemKey));
}


@override
int get hashCode => Object.hash(runtimeType,name,type,id,parentId,icon,color,sortOrder,archived,createdAt,systemKey);

@override
String toString() {
  return 'Category(name: $name, type: $type, id: $id, parentId: $parentId, icon: $icon, color: $color, sortOrder: $sortOrder, archived: $archived, createdAt: $createdAt, systemKey: $systemKey)';
}


}

/// @nodoc
abstract mixin class $CategoryCopyWith<$Res>  {
  factory $CategoryCopyWith(Category value, $Res Function(Category) _then) = _$CategoryCopyWithImpl;
@useResult
$Res call({
 String name, CategoryType type, int? id, int? parentId, String? icon, int? color, int sortOrder, bool archived, int createdAt, String? systemKey
});




}
/// @nodoc
class _$CategoryCopyWithImpl<$Res>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._self, this._then);

  final Category _self;
  final $Res Function(Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? id = freezed,Object? parentId = freezed,Object? icon = freezed,Object? color = freezed,Object? sortOrder = null,Object? archived = null,Object? createdAt = null,Object? systemKey = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CategoryType,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,systemKey: freezed == systemKey ? _self.systemKey : systemKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Category].
extension CategoryPatterns on Category {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Category value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Category() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Category value)  $default,){
final _that = this;
switch (_that) {
case _Category():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Category value)?  $default,){
final _that = this;
switch (_that) {
case _Category() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  CategoryType type,  int? id,  int? parentId,  String? icon,  int? color,  int sortOrder,  bool archived,  int createdAt,  String? systemKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.name,_that.type,_that.id,_that.parentId,_that.icon,_that.color,_that.sortOrder,_that.archived,_that.createdAt,_that.systemKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  CategoryType type,  int? id,  int? parentId,  String? icon,  int? color,  int sortOrder,  bool archived,  int createdAt,  String? systemKey)  $default,) {final _that = this;
switch (_that) {
case _Category():
return $default(_that.name,_that.type,_that.id,_that.parentId,_that.icon,_that.color,_that.sortOrder,_that.archived,_that.createdAt,_that.systemKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  CategoryType type,  int? id,  int? parentId,  String? icon,  int? color,  int sortOrder,  bool archived,  int createdAt,  String? systemKey)?  $default,) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.name,_that.type,_that.id,_that.parentId,_that.icon,_that.color,_that.sortOrder,_that.archived,_that.createdAt,_that.systemKey);case _:
  return null;

}
}

}

/// @nodoc


class _Category extends Category {
  const _Category({required this.name, required this.type, this.id, this.parentId, this.icon, this.color, this.sortOrder = 0, this.archived = false, this.createdAt = 0, this.systemKey}): super._();
  

@override final  String name;
@override final  CategoryType type;
/// `null` until persisted (AUTOINCREMENT assigns it on insert).
@override final  int? id;
/// Parent category id; `null` for a top-level category.
@override final  int? parentId;
/// [AppIcons] catalog key.
@override final  String? icon;
/// ARGB color value.
@override final  int? color;
@override@JsonKey() final  int sortOrder;
@override@JsonKey() final  bool archived;
@override@JsonKey() final  int createdAt;
/// Reserved system-category marker (V2-M6). Non-null for an app-owned
/// built-in — the reconcile "Penyesuaian" pair (`adjustment_in` /
/// `adjustment_out`); null for every normal user category. Matched at
/// runtime so a rename / locale change can't break report exclusion.
@override final  String? systemKey;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryCopyWith<_Category> get copyWith => __$CategoryCopyWithImpl<_Category>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Category&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.systemKey, systemKey) || other.systemKey == systemKey));
}


@override
int get hashCode => Object.hash(runtimeType,name,type,id,parentId,icon,color,sortOrder,archived,createdAt,systemKey);

@override
String toString() {
  return 'Category(name: $name, type: $type, id: $id, parentId: $parentId, icon: $icon, color: $color, sortOrder: $sortOrder, archived: $archived, createdAt: $createdAt, systemKey: $systemKey)';
}


}

/// @nodoc
abstract mixin class _$CategoryCopyWith<$Res> implements $CategoryCopyWith<$Res> {
  factory _$CategoryCopyWith(_Category value, $Res Function(_Category) _then) = __$CategoryCopyWithImpl;
@override @useResult
$Res call({
 String name, CategoryType type, int? id, int? parentId, String? icon, int? color, int sortOrder, bool archived, int createdAt, String? systemKey
});




}
/// @nodoc
class __$CategoryCopyWithImpl<$Res>
    implements _$CategoryCopyWith<$Res> {
  __$CategoryCopyWithImpl(this._self, this._then);

  final _Category _self;
  final $Res Function(_Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? id = freezed,Object? parentId = freezed,Object? icon = freezed,Object? color = freezed,Object? sortOrder = null,Object? archived = null,Object? createdAt = null,Object? systemKey = freezed,}) {
  return _then(_Category(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CategoryType,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,systemKey: freezed == systemKey ? _self.systemKey : systemKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
