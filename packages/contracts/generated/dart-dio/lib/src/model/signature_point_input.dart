//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'signature_point_input.g.dart';

/// SignaturePointInput
///
/// Properties:
/// * [x]
/// * [y]
@BuiltValue()
abstract class SignaturePointInput
    implements Built<SignaturePointInput, SignaturePointInputBuilder> {
  @BuiltValueField(wireName: r'x')
  num get x;

  @BuiltValueField(wireName: r'y')
  num get y;

  SignaturePointInput._();

  factory SignaturePointInput([void updates(SignaturePointInputBuilder b)]) =
      _$SignaturePointInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SignaturePointInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SignaturePointInput> get serializer =>
      _$SignaturePointInputSerializer();
}

class _$SignaturePointInputSerializer
    implements PrimitiveSerializer<SignaturePointInput> {
  @override
  final Iterable<Type> types = const [
    SignaturePointInput,
    _$SignaturePointInput
  ];

  @override
  final String wireName = r'SignaturePointInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SignaturePointInput object, {
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
    SignaturePointInput object, {
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
    required SignaturePointInputBuilder result,
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
  SignaturePointInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SignaturePointInputBuilder();
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
