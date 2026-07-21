//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'role_summary.g.dart';

/// RoleSummary
///
/// Properties:
/// * [id]
/// * [isSystem]
/// * [key]
/// * [name]
@BuiltValue()
abstract class RoleSummary implements Built<RoleSummary, RoleSummaryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'is_system')
  bool get isSystem;

  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'name')
  String get name;

  RoleSummary._();

  factory RoleSummary([void updates(RoleSummaryBuilder b)]) = _$RoleSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RoleSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RoleSummary> get serializer => _$RoleSummarySerializer();
}

class _$RoleSummarySerializer implements PrimitiveSerializer<RoleSummary> {
  @override
  final Iterable<Type> types = const [RoleSummary, _$RoleSummary];

  @override
  final String wireName = r'RoleSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RoleSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'is_system';
    yield serializers.serialize(
      object.isSystem,
      specifiedType: const FullType(bool),
    );
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RoleSummary object, {
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
    required RoleSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'is_system':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isSystem = valueDes;
          break;
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RoleSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoleSummaryBuilder();
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
