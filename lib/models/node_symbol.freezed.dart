// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'node_symbol.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NodeSymbol _$NodeSymbolFromJson(Map<String, dynamic> json) {
  return _NodeSymbol.fromJson(json);
}

/// @nodoc
mixin _$NodeSymbol {
  SymbolType get type => throw _privateConstructorUsedError;
  SymbolPosition get position => throw _privateConstructorUsedError;

  /// Serializes this NodeSymbol to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NodeSymbol
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NodeSymbolCopyWith<NodeSymbol> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NodeSymbolCopyWith<$Res> {
  factory $NodeSymbolCopyWith(
    NodeSymbol value,
    $Res Function(NodeSymbol) then,
  ) = _$NodeSymbolCopyWithImpl<$Res, NodeSymbol>;
  @useResult
  $Res call({SymbolType type, SymbolPosition position});
}

/// @nodoc
class _$NodeSymbolCopyWithImpl<$Res, $Val extends NodeSymbol>
    implements $NodeSymbolCopyWith<$Res> {
  _$NodeSymbolCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NodeSymbol
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? position = null}) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as SymbolType,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as SymbolPosition,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NodeSymbolImplCopyWith<$Res>
    implements $NodeSymbolCopyWith<$Res> {
  factory _$$NodeSymbolImplCopyWith(
    _$NodeSymbolImpl value,
    $Res Function(_$NodeSymbolImpl) then,
  ) = __$$NodeSymbolImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SymbolType type, SymbolPosition position});
}

/// @nodoc
class __$$NodeSymbolImplCopyWithImpl<$Res>
    extends _$NodeSymbolCopyWithImpl<$Res, _$NodeSymbolImpl>
    implements _$$NodeSymbolImplCopyWith<$Res> {
  __$$NodeSymbolImplCopyWithImpl(
    _$NodeSymbolImpl _value,
    $Res Function(_$NodeSymbolImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NodeSymbol
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? position = null}) {
    return _then(
      _$NodeSymbolImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as SymbolType,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as SymbolPosition,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NodeSymbolImpl implements _NodeSymbol {
  const _$NodeSymbolImpl({
    required this.type,
    this.position = SymbolPosition.topRight,
  });

  factory _$NodeSymbolImpl.fromJson(Map<String, dynamic> json) =>
      _$$NodeSymbolImplFromJson(json);

  @override
  final SymbolType type;
  @override
  @JsonKey()
  final SymbolPosition position;

  @override
  String toString() {
    return 'NodeSymbol(type: $type, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NodeSymbolImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.position, position) ||
                other.position == position));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, position);

  /// Create a copy of NodeSymbol
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NodeSymbolImplCopyWith<_$NodeSymbolImpl> get copyWith =>
      __$$NodeSymbolImplCopyWithImpl<_$NodeSymbolImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NodeSymbolImplToJson(this);
  }
}

abstract class _NodeSymbol implements NodeSymbol {
  const factory _NodeSymbol({
    required final SymbolType type,
    final SymbolPosition position,
  }) = _$NodeSymbolImpl;

  factory _NodeSymbol.fromJson(Map<String, dynamic> json) =
      _$NodeSymbolImpl.fromJson;

  @override
  SymbolType get type;
  @override
  SymbolPosition get position;

  /// Create a copy of NodeSymbol
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NodeSymbolImplCopyWith<_$NodeSymbolImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
