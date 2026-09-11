//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout_session_response.g.dart';

/// CheckoutSessionResponse
///
/// Properties:
/// * [checkoutUrl]
/// * [sessionId]
@BuiltValue()
abstract class CheckoutSessionResponse
    implements Built<CheckoutSessionResponse, CheckoutSessionResponseBuilder> {
  @BuiltValueField(wireName: r'checkout_url')
  String get checkoutUrl;

  @BuiltValueField(wireName: r'session_id')
  String get sessionId;

  CheckoutSessionResponse._();

  factory CheckoutSessionResponse(
          [void updates(CheckoutSessionResponseBuilder b)]) =
      _$CheckoutSessionResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckoutSessionResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckoutSessionResponse> get serializer =>
      _$CheckoutSessionResponseSerializer();
}

class _$CheckoutSessionResponseSerializer
    implements PrimitiveSerializer<CheckoutSessionResponse> {
  @override
  final Iterable<Type> types = const [
    CheckoutSessionResponse,
    _$CheckoutSessionResponse
  ];

  @override
  final String wireName = r'CheckoutSessionResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckoutSessionResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'checkout_url';
    yield serializers.serialize(
      object.checkoutUrl,
      specifiedType: const FullType(String),
    );
    yield r'session_id';
    yield serializers.serialize(
      object.sessionId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckoutSessionResponse object, {
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
    required CheckoutSessionResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'checkout_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.checkoutUrl = valueDes;
          break;
        case r'session_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sessionId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckoutSessionResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckoutSessionResponseBuilder();
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
