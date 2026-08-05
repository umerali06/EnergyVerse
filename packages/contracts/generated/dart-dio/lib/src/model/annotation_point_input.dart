//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'annotation_point_input.g.dart';

/// AnnotationPointInput
///
/// Properties:
/// * [x]
/// * [y]
@BuiltValue()
abstract class AnnotationPointInput
    implements Built<AnnotationPointInput, AnnotationPointInputBuilder> {
  @BuiltValueField(wireName: r'x')
  num get x;

  @BuiltValueField(wireName: r'y')
  num get y;

  AnnotationPointInput._();

  factory AnnotationPointInput([void updates(AnnotationPointInputBuilder b)]) =
      _$AnnotationPointInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AnnotationPointInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AnnotationPointInput> get serializer =>
      _$AnnotationPointInputSerializer();
}

class _$AnnotationPointInputSerializer
    implements PrimitiveSerializer<AnnotationPointInput> {
  @override
  final Iterable<Type> types = const [
    AnnotationPointInput,
    _$AnnotationPointInput
  ];

  @override
  final String wireName = r'AnnotationPointInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AnnotationPointInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'x';
    yield serializers.serialize(
      object.x,
      specifiedType: const FullType(num),
    );
    yield r'y';
    yield serializers.serialize(
      object.y,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AnnotationPointInput object, {
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
    required AnnotationPointInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'x':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.x = valueDes;
          break;
        case r'y':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.y = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AnnotationPointInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AnnotationPointInputBuilder();
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
