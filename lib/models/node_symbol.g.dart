// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_symbol.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NodeSymbolImpl _$$NodeSymbolImplFromJson(Map<String, dynamic> json) =>
    _$NodeSymbolImpl(
      type: $enumDecode(_$SymbolTypeEnumMap, json['type']),
      position:
          $enumDecodeNullable(_$SymbolPositionEnumMap, json['position']) ??
          SymbolPosition.topRight,
    );

Map<String, dynamic> _$$NodeSymbolImplToJson(_$NodeSymbolImpl instance) =>
    <String, dynamic>{
      'type': _$SymbolTypeEnumMap[instance.type]!,
      'position': _$SymbolPositionEnumMap[instance.position]!,
    };

const _$SymbolTypeEnumMap = {
  SymbolType.star: 'star',
  SymbolType.lightbulb: 'lightbulb',
  SymbolType.question: 'question',
  SymbolType.check: 'check',
  SymbolType.warning: 'warning',
  SymbolType.heart: 'heart',
  SymbolType.arrowUp: 'arrowUp',
  SymbolType.arrowDown: 'arrowDown',
};

const _$SymbolPositionEnumMap = {
  SymbolPosition.topRight: 'topRight',
  SymbolPosition.bottomLeft: 'bottomLeft',
};
