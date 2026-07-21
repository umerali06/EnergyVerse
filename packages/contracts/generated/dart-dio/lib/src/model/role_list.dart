//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/role_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'role_list.g.dart';

/// RoleList
///
/// Properties:
/// * [items]
@BuiltValue()
abstract class RoleList implements Built<RoleList, RoleListBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<RoleSummary> get items;

  RoleList._();

  factory RoleList([void updates(RoleListBuilder b)]) = _$RoleList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RoleListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RoleList> get serializer => _$RoleListSerializer();
}

class _$RoleListSerializer implements PrimitiveSerializer<RoleList> {
  @override
  final Iterable<Type> types = const [RoleList, _$RoleList];

  @override
  final String wireName = r'RoleList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RoleList object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(RoleSummary)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RoleList object, {
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
    required RoleListBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RoleSummary)]),
          ) as BuiltList<RoleSummary>;
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
  RoleList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoleListBuilder();
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
