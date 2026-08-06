//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fev_api_client/src/model/signature_point_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'signature_stroke_response.g.dart';

/// SignatureStrokeResponse
///
/// Properties:
/// * [points]
@BuiltValue()
abstract class SignatureStrokeResponse
    implements Built<SignatureStrokeResponse, SignatureStrokeResponseBuilder> {
  @BuiltValueField(wireName: r'points')
  BuiltList<SignaturePointResponse> get points;

  SignatureStrokeResponse._();

  factory SignatureStrokeResponse(
          [void updates(SignatureStrokeResponseBuilder b)]) =
      _$SignatureStrokeResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SignatureStrokeResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SignatureStrokeResponse> get serializer =>
      _$SignatureStrokeResponseSerializer();
}

class _$SignatureStrokeResponseSerializer
    implements PrimitiveSerializer<SignatureStrokeResponse> {
  @override
  final Iterable<Type> types = const [
    SignatureStrokeResponse,
    _$SignatureStrokeResponse
  ];

  @override
  final String wireName = r'SignatureStrokeResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SignatureStrokeResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'points';
    yield serializers.serialize(
      object.points,
      specifiedType:
          const FullType(BuiltList, [FullType(SignaturePointResponse)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SignatureStrokeResponse object, {
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
    required SignatureStrokeResponseBuilder result,
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
                const FullType(BuiltList, [FullType(SignaturePointResponse)]),
          ) as BuiltList<SignaturePointResponse>;
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
  SignatureStrokeResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SignatureStrokeResponseBuilder();
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
