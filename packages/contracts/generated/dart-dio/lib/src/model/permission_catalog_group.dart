//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/permission_catalog_item.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permission_catalog_group.g.dart';

/// PermissionCatalogGroup
///
/// Properties:
/// * [group]
/// * [items]
@BuiltValue()
abstract class PermissionCatalogGroup
    implements Built<PermissionCatalogGroup, PermissionCatalogGroupBuilder> {
  @BuiltValueField(wireName: r'group')
  String get group;

  @BuiltValueField(wireName: r'items')
  BuiltList<PermissionCatalogItem> get items;

  PermissionCatalogGroup._();

  factory PermissionCatalogGroup(
          [void updates(PermissionCatalogGroupBuilder b)]) =
      _$PermissionCatalogGroup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermissionCatalogGroupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermissionCatalogGroup> get serializer =>
      _$PermissionCatalogGroupSerializer();
}

class _$PermissionCatalogGroupSerializer
    implements PrimitiveSerializer<PermissionCatalogGroup> {
  @override
  final Iterable<Type> types = const [
    PermissionCatalogGroup,
    _$PermissionCatalogGroup
  ];

  @override
  final String wireName = r'PermissionCatalogGroup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermissionCatalogGroup object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'group';
    yield serializers.serialize(
      object.group,
      specifiedType: const FullType(String),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType:
          const FullType(BuiltList, [FullType(PermissionCatalogItem)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PermissionCatalogGroup object, {
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
    required PermissionCatalogGroupBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'group':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.group = valueDes;
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(PermissionCatalogItem)]),
          ) as BuiltList<PermissionCatalogItem>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PermissionCatalogGroup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermissionCatalogGroupBuilder();
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
