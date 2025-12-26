// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cross_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CrossLinkImpl _$$CrossLinkImplFromJson(Map<String, dynamic> json) =>
    _$CrossLinkImpl(
      id: json['id'] as String,
      sourceNodeId: json['sourceNodeId'] as String,
      targetNodeId: json['targetNodeId'] as String,
      label: json['label'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CrossLinkImplToJson(_$CrossLinkImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceNodeId': instance.sourceNodeId,
      'targetNodeId': instance.targetNodeId,
      'label': instance.label,
      'createdAt': instance.createdAt.toIso8601String(),
    };
