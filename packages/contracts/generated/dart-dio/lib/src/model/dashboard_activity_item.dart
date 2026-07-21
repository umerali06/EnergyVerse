//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dashboard_activity_item.g.dart';

/// DashboardActivityItem
///
/// Properties:
/// * [action]
/// * [actorName]
/// * [actorUid]
/// * [createdAt]
/// * [id]
/// * [targetId]
/// * [targetType]
@BuiltValue()
abstract class DashboardActivityItem
    implements Built<DashboardActivityItem, DashboardActivityItemBuilder> {
  @BuiltValueField(wireName: r'action')
  String get action;

  @BuiltValueField(wireName: r'actor_name')
  String? get actorName;

  @BuiltValueField(wireName: r'actor_uid')
  String get actorUid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'target_id')
  String get targetId;

  @BuiltValueField(wireName: r'target_type')
  String get targetType;

  DashboardActivityItem._();

  factory DashboardActivityItem(
      [void updates(DashboardActivityItemBuilder b)]) = _$DashboardActivityItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DashboardActivityItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DashboardActivityItem> get serializer =>
      _$DashboardActivityItemSerializer();
}

class _$DashboardActivityItemSerializer
    implements PrimitiveSerializer<DashboardActivityItem> {
  @override
  final Iterable<Type> types = const [
    DashboardActivityItem,
    _$DashboardActivityItem
  ];

  @override
  final String wireName = r'DashboardActivityItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DashboardActivityItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(String),
    );
    if (object.actorName != null) {
      yield r'actor_name';
      yield serializers.serialize(
        object.actorName,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'actor_uid';
    yield serializers.serialize(
      object.actorUid,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'target_id';
    yield serializers.serialize(
      object.targetId,
      specifiedType: const FullType(String),
    );
    yield r'target_type';
    yield serializers.serialize(
      object.targetType,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DashboardActivityItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DashboardActivityItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.action = valueDes;
          break;
        case r'actor_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.actorName = valueDes;
          break;
        case r'actor_uid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actorUid = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'target_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.targetId = valueDes;
          break;
        case r'target_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.targetType = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DashboardActivityItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DashboardActivityItemBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}
