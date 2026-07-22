//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permission_catalog_item.g.dart';

/// PermissionCatalogItem
///
/// Properties:
/// * [description]
/// * [group]
/// * [key]
@BuiltValue()
abstract class PermissionCatalogItem
    implements Built<PermissionCatalogItem, PermissionCatalogItemBuilder> {
  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'group')
  String get group;

  @BuiltValueField(wireName: r'key')
  String get key;

  PermissionCatalogItem._();

  factory PermissionCatalogItem(
      [void updates(PermissionCatalogItemBuilder b)]) = _$PermissionCatalogItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermissionCatalogItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermissionCatalogItem> get serializer =>
      _$PermissionCatalogItemSerializer();
}

class _$PermissionCatalogItemSerializer
    implements PrimitiveSerializer<PermissionCatalogItem> {
  @override
  final Iterable<Type> types = const [
    PermissionCatalogItem,
    _$PermissionCatalogItem
  ];

  @override
  final String wireName = r'PermissionCatalogItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermissionCatalogItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'group';
    yield serializers.serialize(
      object.group,
      specifiedType: const FullType(String),
    );
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PermissionCatalogItem object, {
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
    required PermissionCatalogItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'group':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.group = valueDes;
          break;
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PermissionCatalogItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermissionCatalogItemBuilder();
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
