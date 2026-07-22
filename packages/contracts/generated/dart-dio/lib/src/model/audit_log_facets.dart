//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'audit_log_facets.g.dart';

/// AuditLogFacets
///
/// Properties:
/// * [actions]
/// * [targetTypes]
@BuiltValue()
abstract class AuditLogFacets
    implements Built<AuditLogFacets, AuditLogFacetsBuilder> {
  @BuiltValueField(wireName: r'actions')
  BuiltList<String> get actions;

  @BuiltValueField(wireName: r'target_types')
  BuiltList<String> get targetTypes;

  AuditLogFacets._();

  factory AuditLogFacets([void updates(AuditLogFacetsBuilder b)]) =
      _$AuditLogFacets;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuditLogFacetsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuditLogFacets> get serializer =>
      _$AuditLogFacetsSerializer();
}

class _$AuditLogFacetsSerializer
    implements PrimitiveSerializer<AuditLogFacets> {
  @override
  final Iterable<Type> types = const [AuditLogFacets, _$AuditLogFacets];

  @override
  final String wireName = r'AuditLogFacets';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuditLogFacets object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'actions';
    yield serializers.serialize(
      object.actions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'target_types';
    yield serializers.serialize(
      object.targetTypes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AuditLogFacets object, {
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
    required AuditLogFacetsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'actions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.actions.replace(valueDes);
          break;
        case r'target_types':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.targetTypes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AuditLogFacets deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuditLogFacetsBuilder();
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
