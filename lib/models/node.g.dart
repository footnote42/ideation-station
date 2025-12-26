// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NodeImpl _$$NodeImplFromJson(Map<String, dynamic> json) => _$NodeImpl(
  id: json['id'] as String,
  text: json['text'] as String,
  type: $enumDecode(_$NodeTypeEnumMap, json['type']),
  position: Position.fromJson(json['position'] as Map<String, dynamic>),
  color: const ColorConverter().fromJson((json['color'] as num).toInt()),
  symbols:
      (json['symbols'] as List<dynamic>?)
          ?.map((e) => NodeSymbol.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  parentId: json['parentId'] as String?,
  childIds:
      (json['childIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$$NodeImplToJson(_$NodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'type': _$NodeTypeEnumMap[instance.type]!,
      'position': instance.position,
      'color': const ColorConverter().toJson(instance.color),
      'symbols': instance.symbols,
      'parentId': instance.parentId,
      'childIds': instance.childIds,
    };

const _$NodeTypeEnumMap = {
  NodeType.central: 'central',
  NodeType.branch: 'branch',
  NodeType.subBranch: 'subBranch',
};
