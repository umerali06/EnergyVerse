//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/permission_catalog_group.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permission_catalog.g.dart';

/// PermissionCatalog
///
/// Properties:
/// * [groups]
@BuiltValue()
abstract class PermissionCatalog
    implements Built<PermissionCatalog, PermissionCatalogBuilder> {
  @BuiltValueField(wireName: r'groups')
  BuiltList<PermissionCatalogGroup> get groups;

  PermissionCatalog._();

  factory PermissionCatalog([void updates(PermissionCatalogBuilder b)]) =
      _$PermissionCatalog;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermissionCatalogBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermissionCatalog> get serializer =>
      _$PermissionCatalogSerializer();
}

class _$PermissionCatalogSerializer
    implements PrimitiveSerializer<PermissionCatalog> {
  @override
  final Iterable<Type> types = const [PermissionCatalog, _$PermissionCatalog];

  @override
  final String wireName = r'PermissionCatalog';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermissionCatalog object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'groups';
    yield serializers.serialize(
      object.groups,
      specifiedType:
          const FullType(BuiltList, [FullType(PermissionCatalogGroup)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PermissionCatalog object, {
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
    required PermissionCatalogBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'groups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(PermissionCatalogGroup)]),
          ) as BuiltList<PermissionCatalogGroup>;
          result.groups.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PermissionCatalog deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermissionCatalogBuilder();
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
