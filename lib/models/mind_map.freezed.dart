// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mind_map.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MindMap _$MindMapFromJson(Map<String, dynamic> json) {
  return _MindMap.fromJson(json);
}

/// @nodoc
mixin _$MindMap {
  /// Unique identifier for this mind map
  String get id => throw _privateConstructorUsedError;

  /// User-friendly name for this mind map
  String get name => throw _privateConstructorUsedError;

  /// Timestamp when this mind map was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Timestamp of last modification
  DateTime get lastModifiedAt => throw _privateConstructorUsedError;

  /// The central node (required - every mind map has exactly one)
  Node get centralNode => throw _privateConstructorUsedError;

  /// All nodes in the mind map (includes central node and all branches)
  List<Node> get nodes => throw _privateConstructorUsedError;

  /// Cross-link connections between non-adjacent nodes
  List<CrossLink> get crossLinks => throw _privateConstructorUsedError;

  /// Serializes this MindMap to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MindMap
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MindMapCopyWith<MindMap> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MindMapCopyWith<$Res> {
  factory $MindMapCopyWith(MindMap value, $Res Function(MindMap) then) =
      _$MindMapCopyWithImpl<$Res, MindMap>;
  @useResult
  $Res call({
    String id,
    String name,
    DateTime createdAt,
    DateTime lastModifiedAt,
    Node centralNode,
    List<Node> nodes,
    List<CrossLink> crossLinks,
  });

  $NodeCopyWith<$Res> get centralNode;
}

/// @nodoc
class _$MindMapCopyWithImpl<$Res, $Val extends MindMap>
    implements $MindMapCopyWith<$Res> {
  _$MindMapCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MindMap
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? createdAt = null,
    Object? lastModifiedAt = null,
    Object? centralNode = null,
    Object? nodes = null,
    Object? crossLinks = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastModifiedAt: null == lastModifiedAt
                ? _value.lastModifiedAt
                : lastModifiedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            centralNode: null == centralNode
                ? _value.centralNode
                : centralNode // ignore: cast_nullable_to_non_nullable
                      as Node,
            nodes: null == nodes
                ? _value.nodes
                : nodes // ignore: cast_nullable_to_non_nullable
                      as List<Node>,
            crossLinks: null == crossLinks
                ? _value.crossLinks
                : crossLinks // ignore: cast_nullable_to_non_nullable
                      as List<CrossLink>,
          )
          as $Val,
    );
  }

  /// Create a copy of MindMap
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NodeCopyWith<$Res> get centralNode {
    return $NodeCopyWith<$Res>(_value.centralNode, (value) {
      return _then(_value.copyWith(centralNode: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MindMapImplCopyWith<$Res> implements $MindMapCopyWith<$Res> {
  factory _$$MindMapImplCopyWith(
    _$MindMapImpl value,
    $Res Function(_$MindMapImpl) then,
  ) = __$$MindMapImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    DateTime createdAt,
    DateTime lastModifiedAt,
    Node centralNode,
    List<Node> nodes,
    List<CrossLink> crossLinks,
  });

  @override
  $NodeCopyWith<$Res> get centralNode;
}

/// @nodoc
class __$$MindMapImplCopyWithImpl<$Res>
    extends _$MindMapCopyWithImpl<$Res, _$MindMapImpl>
    implements _$$MindMapImplCopyWith<$Res> {
  __$$MindMapImplCopyWithImpl(
    _$MindMapImpl _value,
    $Res Function(_$MindMapImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MindMap
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? createdAt = null,
    Object? lastModifiedAt = null,
    Object? centralNode = null,
    Object? nodes = null,
    Object? crossLinks = null,
  }) {
    return _then(
      _$MindMapImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastModifiedAt: null == lastModifiedAt
            ? _value.lastModifiedAt
            : lastModifiedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        centralNode: null == centralNode
            ? _value.centralNode
            : centralNode // ignore: cast_nullable_to_non_nullable
                  as Node,
        nodes: null == nodes
            ? _value._nodes
            : nodes // ignore: cast_nullable_to_non_nullable
                  as List<Node>,
        crossLinks: null == crossLinks
            ? _value._crossLinks
            : crossLinks // ignore: cast_nullable_to_non_nullable
                  as List<CrossLink>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MindMapImpl implements _MindMap {
  const _$MindMapImpl({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.lastModifiedAt,
    required this.centralNode,
    final List<Node> nodes = const [],
    final List<CrossLink> crossLinks = const [],
  }) : _nodes = nodes,
       _crossLinks = crossLinks;

  factory _$MindMapImpl.fromJson(Map<String, dynamic> json) =>
      _$$MindMapImplFromJson(json);

  /// Unique identifier for this mind map
  @override
  final String id;

  /// User-friendly name for this mind map
  @override
  final String name;

  /// Timestamp when this mind map was created
  @override
  final DateTime createdAt;

  /// Timestamp of last modification
  @override
  final DateTime lastModifiedAt;

  /// The central node (required - every mind map has exactly one)
  @override
  final Node centralNode;

  /// All nodes in the mind map (includes central node and all branches)
  final List<Node> _nodes;

  /// All nodes in the mind map (includes central node and all branches)
  @override
  @JsonKey()
  List<Node> get nodes {
    if (_nodes is EqualUnmodifiableListView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nodes);
  }

  /// Cross-link connections between non-adjacent nodes
  final List<CrossLink> _crossLinks;

  /// Cross-link connections between non-adjacent nodes
  @override
  @JsonKey()
  List<CrossLink> get crossLinks {
    if (_crossLinks is EqualUnmodifiableListView) return _crossLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_crossLinks);
  }

  @override
  String toString() {
    return 'MindMap(id: $id, name: $name, createdAt: $createdAt, lastModifiedAt: $lastModifiedAt, centralNode: $centralNode, nodes: $nodes, crossLinks: $crossLinks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MindMapImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastModifiedAt, lastModifiedAt) ||
                other.lastModifiedAt == lastModifiedAt) &&
            (identical(other.centralNode, centralNode) ||
                other.centralNode == centralNode) &&
            const DeepCollectionEquality().equals(other._nodes, _nodes) &&
            const DeepCollectionEquality().equals(
              other._crossLinks,
              _crossLinks,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    createdAt,
    lastModifiedAt,
    centralNode,
    const DeepCollectionEquality().hash(_nodes),
    const DeepCollectionEquality().hash(_crossLinks),
  );

  /// Create a copy of MindMap
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MindMapImplCopyWith<_$MindMapImpl> get copyWith =>
      __$$MindMapImplCopyWithImpl<_$MindMapImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MindMapImplToJson(this);
  }
}

abstract class _MindMap implements MindMap {
  const factory _MindMap({
    required final String id,
    required final String name,
    required final DateTime createdAt,
    required final DateTime lastModifiedAt,
    required final Node centralNode,
    final List<Node> nodes,
    final List<CrossLink> crossLinks,
  }) = _$MindMapImpl;

  factory _MindMap.fromJson(Map<String, dynamic> json) = _$MindMapImpl.fromJson;

  /// Unique identifier for this mind map
  @override
  String get id;

  /// User-friendly name for this mind map
  @override
  String get name;

  /// Timestamp when this mind map was created
  @override
  DateTime get createdAt;

  /// Timestamp of last modification
  @override
  DateTime get lastModifiedAt;

  /// The central node (required - every mind map has exactly one)
  @override
  Node get centralNode;

  /// All nodes in the mind map (includes central node and all branches)
  @override
  List<Node> get nodes;

  /// Cross-link connections between non-adjacent nodes
  @override
  List<CrossLink> get crossLinks;

  /// Create a copy of MindMap
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MindMapImplCopyWith<_$MindMapImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
