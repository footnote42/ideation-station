// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Node _$NodeFromJson(Map<String, dynamic> json) {
  return _Node.fromJson(json);
}

/// @nodoc
mixin _$Node {
  /// Unique identifier for this node
  String get id => throw _privateConstructorUsedError;

  /// Text content - ideally a single keyword (1-4 words recommended)
  String get text => throw _privateConstructorUsedError;

  /// Hierarchical type: CENTRAL, BRANCH, or SUB_BRANCH
  NodeType get type => throw _privateConstructorUsedError;

  /// Position on the canvas (normalized coordinates, center = 0,0)
  Position get position => throw _privateConstructorUsedError;

  /// Visual color for this node and its branch connection
  @ColorConverter()
  Color get color => throw _privateConstructorUsedError;

  /// Visual symbols attached to this node for quick meaning
  List<NodeSymbol> get symbols => throw _privateConstructorUsedError;

  /// ID of parent node (null for central node)
  String? get parentId => throw _privateConstructorUsedError;

  /// IDs of child nodes (empty for leaf nodes)
  List<String> get childIds => throw _privateConstructorUsedError;

  /// Serializes this Node to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Node
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NodeCopyWith<Node> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NodeCopyWith<$Res> {
  factory $NodeCopyWith(Node value, $Res Function(Node) then) =
      _$NodeCopyWithImpl<$Res, Node>;
  @useResult
  $Res call({
    String id,
    String text,
    NodeType type,
    Position position,
    @ColorConverter() Color color,
    List<NodeSymbol> symbols,
    String? parentId,
    List<String> childIds,
  });

  $PositionCopyWith<$Res> get position;
}

/// @nodoc
class _$NodeCopyWithImpl<$Res, $Val extends Node>
    implements $NodeCopyWith<$Res> {
  _$NodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Node
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? type = null,
    Object? position = null,
    Object? color = null,
    Object? symbols = null,
    Object? parentId = freezed,
    Object? childIds = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as NodeType,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as Position,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as Color,
            symbols: null == symbols
                ? _value.symbols
                : symbols // ignore: cast_nullable_to_non_nullable
                      as List<NodeSymbol>,
            parentId: freezed == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            childIds: null == childIds
                ? _value.childIds
                : childIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }

  /// Create a copy of Node
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PositionCopyWith<$Res> get position {
    return $PositionCopyWith<$Res>(_value.position, (value) {
      return _then(_value.copyWith(position: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NodeImplCopyWith<$Res> implements $NodeCopyWith<$Res> {
  factory _$$NodeImplCopyWith(
    _$NodeImpl value,
    $Res Function(_$NodeImpl) then,
  ) = __$$NodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String text,
    NodeType type,
    Position position,
    @ColorConverter() Color color,
    List<NodeSymbol> symbols,
    String? parentId,
    List<String> childIds,
  });

  @override
  $PositionCopyWith<$Res> get position;
}

/// @nodoc
class __$$NodeImplCopyWithImpl<$Res>
    extends _$NodeCopyWithImpl<$Res, _$NodeImpl>
    implements _$$NodeImplCopyWith<$Res> {
  __$$NodeImplCopyWithImpl(_$NodeImpl _value, $Res Function(_$NodeImpl) _then)
    : super(_value, _then);

  /// Create a copy of Node
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? type = null,
    Object? position = null,
    Object? color = null,
    Object? symbols = null,
    Object? parentId = freezed,
    Object? childIds = null,
  }) {
    return _then(
      _$NodeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as NodeType,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as Position,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as Color,
        symbols: null == symbols
            ? _value._symbols
            : symbols // ignore: cast_nullable_to_non_nullable
                  as List<NodeSymbol>,
        parentId: freezed == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        childIds: null == childIds
            ? _value._childIds
            : childIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NodeImpl implements _Node {
  const _$NodeImpl({
    required this.id,
    required this.text,
    required this.type,
    required this.position,
    @ColorConverter() required this.color,
    final List<NodeSymbol> symbols = const [],
    this.parentId,
    final List<String> childIds = const [],
  }) : _symbols = symbols,
       _childIds = childIds;

  factory _$NodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$NodeImplFromJson(json);

  /// Unique identifier for this node
  @override
  final String id;

  /// Text content - ideally a single keyword (1-4 words recommended)
  @override
  final String text;

  /// Hierarchical type: CENTRAL, BRANCH, or SUB_BRANCH
  @override
  final NodeType type;

  /// Position on the canvas (normalized coordinates, center = 0,0)
  @override
  final Position position;

  /// Visual color for this node and its branch connection
  @override
  @ColorConverter()
  final Color color;

  /// Visual symbols attached to this node for quick meaning
  final List<NodeSymbol> _symbols;

  /// Visual symbols attached to this node for quick meaning
  @override
  @JsonKey()
  List<NodeSymbol> get symbols {
    if (_symbols is EqualUnmodifiableListView) return _symbols;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symbols);
  }

  /// ID of parent node (null for central node)
  @override
  final String? parentId;

  /// IDs of child nodes (empty for leaf nodes)
  final List<String> _childIds;

  /// IDs of child nodes (empty for leaf nodes)
  @override
  @JsonKey()
  List<String> get childIds {
    if (_childIds is EqualUnmodifiableListView) return _childIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_childIds);
  }

  @override
  String toString() {
    return 'Node(id: $id, text: $text, type: $type, position: $position, color: $color, symbols: $symbols, parentId: $parentId, childIds: $childIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.color, color) || other.color == color) &&
            const DeepCollectionEquality().equals(other._symbols, _symbols) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            const DeepCollectionEquality().equals(other._childIds, _childIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    text,
    type,
    position,
    color,
    const DeepCollectionEquality().hash(_symbols),
    parentId,
    const DeepCollectionEquality().hash(_childIds),
  );

  /// Create a copy of Node
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NodeImplCopyWith<_$NodeImpl> get copyWith =>
      __$$NodeImplCopyWithImpl<_$NodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NodeImplToJson(this);
  }
}

abstract class _Node implements Node {
  const factory _Node({
    required final String id,
    required final String text,
    required final NodeType type,
    required final Position position,
    @ColorConverter() required final Color color,
    final List<NodeSymbol> symbols,
    final String? parentId,
    final List<String> childIds,
  }) = _$NodeImpl;

  factory _Node.fromJson(Map<String, dynamic> json) = _$NodeImpl.fromJson;

  /// Unique identifier for this node
  @override
  String get id;

  /// Text content - ideally a single keyword (1-4 words recommended)
  @override
  String get text;

  /// Hierarchical type: CENTRAL, BRANCH, or SUB_BRANCH
  @override
  NodeType get type;

  /// Position on the canvas (normalized coordinates, center = 0,0)
  @override
  Position get position;

  /// Visual color for this node and its branch connection
  @override
  @ColorConverter()
  Color get color;

  /// Visual symbols attached to this node for quick meaning
  @override
  List<NodeSymbol> get symbols;

  /// ID of parent node (null for central node)
  @override
  String? get parentId;

  /// IDs of child nodes (empty for leaf nodes)
  @override
  List<String> get childIds;

  /// Create a copy of Node
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NodeImplCopyWith<_$NodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
