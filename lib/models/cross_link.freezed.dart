// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cross_link.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CrossLink _$CrossLinkFromJson(Map<String, dynamic> json) {
  return _CrossLink.fromJson(json);
}

/// @nodoc
mixin _$CrossLink {
  /// Unique identifier for this cross-link
  String get id => throw _privateConstructorUsedError;

  /// ID of the source node
  String get sourceNodeId => throw _privateConstructorUsedError;

  /// ID of the target node
  String get targetNodeId => throw _privateConstructorUsedError;

  /// Optional label describing the relationship
  String? get label => throw _privateConstructorUsedError;

  /// Timestamp when this cross-link was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CrossLink to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CrossLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CrossLinkCopyWith<CrossLink> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CrossLinkCopyWith<$Res> {
  factory $CrossLinkCopyWith(CrossLink value, $Res Function(CrossLink) then) =
      _$CrossLinkCopyWithImpl<$Res, CrossLink>;
  @useResult
  $Res call({
    String id,
    String sourceNodeId,
    String targetNodeId,
    String? label,
    DateTime createdAt,
  });
}

/// @nodoc
class _$CrossLinkCopyWithImpl<$Res, $Val extends CrossLink>
    implements $CrossLinkCopyWith<$Res> {
  _$CrossLinkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CrossLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sourceNodeId = null,
    Object? targetNodeId = null,
    Object? label = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            sourceNodeId: null == sourceNodeId
                ? _value.sourceNodeId
                : sourceNodeId // ignore: cast_nullable_to_non_nullable
                      as String,
            targetNodeId: null == targetNodeId
                ? _value.targetNodeId
                : targetNodeId // ignore: cast_nullable_to_non_nullable
                      as String,
            label: freezed == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CrossLinkImplCopyWith<$Res>
    implements $CrossLinkCopyWith<$Res> {
  factory _$$CrossLinkImplCopyWith(
    _$CrossLinkImpl value,
    $Res Function(_$CrossLinkImpl) then,
  ) = __$$CrossLinkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String sourceNodeId,
    String targetNodeId,
    String? label,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$CrossLinkImplCopyWithImpl<$Res>
    extends _$CrossLinkCopyWithImpl<$Res, _$CrossLinkImpl>
    implements _$$CrossLinkImplCopyWith<$Res> {
  __$$CrossLinkImplCopyWithImpl(
    _$CrossLinkImpl _value,
    $Res Function(_$CrossLinkImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CrossLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sourceNodeId = null,
    Object? targetNodeId = null,
    Object? label = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$CrossLinkImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        sourceNodeId: null == sourceNodeId
            ? _value.sourceNodeId
            : sourceNodeId // ignore: cast_nullable_to_non_nullable
                  as String,
        targetNodeId: null == targetNodeId
            ? _value.targetNodeId
            : targetNodeId // ignore: cast_nullable_to_non_nullable
                  as String,
        label: freezed == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CrossLinkImpl implements _CrossLink {
  const _$CrossLinkImpl({
    required this.id,
    required this.sourceNodeId,
    required this.targetNodeId,
    this.label,
    required this.createdAt,
  });

  factory _$CrossLinkImpl.fromJson(Map<String, dynamic> json) =>
      _$$CrossLinkImplFromJson(json);

  /// Unique identifier for this cross-link
  @override
  final String id;

  /// ID of the source node
  @override
  final String sourceNodeId;

  /// ID of the target node
  @override
  final String targetNodeId;

  /// Optional label describing the relationship
  @override
  final String? label;

  /// Timestamp when this cross-link was created
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'CrossLink(id: $id, sourceNodeId: $sourceNodeId, targetNodeId: $targetNodeId, label: $label, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CrossLinkImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sourceNodeId, sourceNodeId) ||
                other.sourceNodeId == sourceNodeId) &&
            (identical(other.targetNodeId, targetNodeId) ||
                other.targetNodeId == targetNodeId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    sourceNodeId,
    targetNodeId,
    label,
    createdAt,
  );

  /// Create a copy of CrossLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CrossLinkImplCopyWith<_$CrossLinkImpl> get copyWith =>
      __$$CrossLinkImplCopyWithImpl<_$CrossLinkImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CrossLinkImplToJson(this);
  }
}

abstract class _CrossLink implements CrossLink {
  const factory _CrossLink({
    required final String id,
    required final String sourceNodeId,
    required final String targetNodeId,
    final String? label,
    required final DateTime createdAt,
  }) = _$CrossLinkImpl;

  factory _CrossLink.fromJson(Map<String, dynamic> json) =
      _$CrossLinkImpl.fromJson;

  /// Unique identifier for this cross-link
  @override
  String get id;

  /// ID of the source node
  @override
  String get sourceNodeId;

  /// ID of the target node
  @override
  String get targetNodeId;

  /// Optional label describing the relationship
  @override
  String? get label;

  /// Timestamp when this cross-link was created
  @override
  DateTime get createdAt;

  /// Create a copy of CrossLink
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CrossLinkImplCopyWith<_$CrossLinkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
