//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout_session_request.g.dart';

/// CheckoutSessionRequest
///
/// Properties:
/// * [interval]
/// * [tier]
@BuiltValue()
abstract class CheckoutSessionRequest
    implements Built<CheckoutSessionRequest, CheckoutSessionRequestBuilder> {
  @BuiltValueField(wireName: r'interval')
  String get interval;

  @BuiltValueField(wireName: r'tier')
  String get tier;

  CheckoutSessionRequest._();

  factory CheckoutSessionRequest(
          [void updates(CheckoutSessionRequestBuilder b)]) =
      _$CheckoutSessionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckoutSessionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckoutSessionRequest> get serializer =>
      _$CheckoutSessionRequestSerializer();
}

class _$CheckoutSessionRequestSerializer
    implements PrimitiveSerializer<CheckoutSessionRequest> {
  @override
  final Iterable<Type> types = const [
    CheckoutSessionRequest,
    _$CheckoutSessionRequest
  ];

  @override
  final String wireName = r'CheckoutSessionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckoutSessionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'interval';
    yield serializers.serialize(
      object.interval,
      specifiedType: const FullType(String),
    );
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckoutSessionRequest object, {
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
    required CheckoutSessionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'interval':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.interval = valueDes;
          break;
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tier = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckoutSessionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckoutSessionRequestBuilder();
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
