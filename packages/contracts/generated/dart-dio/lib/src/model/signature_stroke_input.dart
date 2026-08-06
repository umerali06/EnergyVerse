//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/signature_point_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'signature_stroke_input.g.dart';

/// SignatureStrokeInput
///
/// Properties:
/// * [points]
@BuiltValue()
abstract class SignatureStrokeInput
    implements Built<SignatureStrokeInput, SignatureStrokeInputBuilder> {
  @BuiltValueField(wireName: r'points')
  BuiltList<SignaturePointInput> get points;

  SignatureStrokeInput._();

  factory SignatureStrokeInput([void updates(SignatureStrokeInputBuilder b)]) =
      _$SignatureStrokeInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SignatureStrokeInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SignatureStrokeInput> get serializer =>
      _$SignatureStrokeInputSerializer();
}

class _$SignatureStrokeInputSerializer
    implements PrimitiveSerializer<SignatureStrokeInput> {
  @override
  final Iterable<Type> types = const [
    SignatureStrokeInput,
    _$SignatureStrokeInput
  ];

  @override
  final String wireName = r'SignatureStrokeInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SignatureStrokeInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'points';
    yield serializers.serialize(
      object.points,
      specifiedType: const FullType(BuiltList, [FullType(SignaturePointInput)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SignatureStrokeInput object, {
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
    required SignatureStrokeInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(SignaturePointInput)]),
          ) as BuiltList<SignaturePointInput>;
          result.points.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SignatureStrokeInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SignatureStrokeInputBuilder();
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
