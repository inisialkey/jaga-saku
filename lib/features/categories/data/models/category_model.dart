import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';

part 'category_model.freezed.dart';

/// Data-layer row model for the `categories` table. Maps are hand-written:
/// `type` <-> enum, `archived` int <-> bool, `parent_id` nullable int.
@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String name,
    required CategoryType type,
    int? id,
    int? parentId,
    String? icon,
    int? color,
    @Default(0) int sortOrder,
    @Default(false) bool archived,
    @Default(0) int createdAt,
  }) = _CategoryModel;

  const CategoryModel._();

  factory CategoryModel.fromMap(Map<String, Object?> map) => CategoryModel(
    id: map['id'] as int?,
    name: map['name']! as String,
    type: CategoryType.fromValue(map['type'] as String?),
    parentId: map['parent_id'] as int?,
    icon: map['icon'] as String?,
    color: map['color'] as int?,
    sortOrder: (map['sort_order'] as int?) ?? 0,
    archived: ((map['archived'] as int?) ?? 0) == 1,
    createdAt: (map['created_at'] as int?) ?? 0,
  );

  factory CategoryModel.fromEntity(Category category) => CategoryModel(
    id: category.id,
    name: category.name,
    type: category.type,
    parentId: category.parentId,
    icon: category.icon,
    color: category.color,
    sortOrder: category.sortOrder,
    archived: category.archived,
    createdAt: category.createdAt,
  );

  /// Column map for insert/update. Omits `id` when null so AUTOINCREMENT fires.
  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'name': name,
    'type': type.value,
    'parent_id': parentId,
    'icon': icon,
    'color': color,
    'sort_order': sortOrder,
    'archived': archived ? 1 : 0,
    'created_at': createdAt,
  };

  Category toEntity() => Category(
    id: id,
    name: name,
    type: type,
    parentId: parentId,
    icon: icon,
    color: color,
    sortOrder: sortOrder,
    archived: archived,
    createdAt: createdAt,
  );
}
