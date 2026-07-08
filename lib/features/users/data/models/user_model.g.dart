// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  role: json['role'] as String,
  isActive: const BoolFromIntConverter().fromJson(json['is_active']),
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  phone: json['phone'] as String?,
  avatarUrl: json['avatar_url'] as String?,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
      'is_active': const BoolFromIntConverter().toJson(instance.isActive),
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'phone': instance.phone,
      'avatar_url': instance.avatarUrl,
    };
