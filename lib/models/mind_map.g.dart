// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mind_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MindMapImpl _$$MindMapImplFromJson(Map<String, dynamic> json) =>
    _$MindMapImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModifiedAt: DateTime.parse(json['lastModifiedAt'] as String),
      centralNode: Node.fromJson(json['centralNode'] as Map<String, dynamic>),
      nodes:
          (json['nodes'] as List<dynamic>?)
              ?.map((e) => Node.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      crossLinks:
          (json['crossLinks'] as List<dynamic>?)
              ?.map((e) => CrossLink.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MindMapImplToJson(_$MindMapImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastModifiedAt': instance.lastModifiedAt.toIso8601String(),
      'centralNode': instance.centralNode,
      'nodes': instance.nodes,
      'crossLinks': instance.crossLinks,
    };
