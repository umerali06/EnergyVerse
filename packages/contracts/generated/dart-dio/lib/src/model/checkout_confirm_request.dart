//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout_confirm_request.g.dart';

/// The session id Stripe substitutes into the success URL.
///
/// Properties:
/// * [sessionId]
@BuiltValue()
abstract class CheckoutConfirmRequest
    implements Built<CheckoutConfirmRequest, CheckoutConfirmRequestBuilder> {
  @BuiltValueField(wireName: r'session_id')
  String get sessionId;

  CheckoutConfirmRequest._();

  factory CheckoutConfirmRequest(
          [void updates(CheckoutConfirmRequestBuilder b)]) =
      _$CheckoutConfirmRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckoutConfirmRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckoutConfirmRequest> get serializer =>
      _$CheckoutConfirmRequestSerializer();
}

class _$CheckoutConfirmRequestSerializer
    implements PrimitiveSerializer<CheckoutConfirmRequest> {
  @override
  final Iterable<Type> types = const [
    CheckoutConfirmRequest,
    _$CheckoutConfirmRequest
  ];

  @override
  final String wireName = r'CheckoutConfirmRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckoutConfirmRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'session_id';
    yield serializers.serialize(
      object.sessionId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckoutConfirmRequest object, {
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
    required CheckoutConfirmRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  CheckoutConfirmRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckoutConfirmRequestBuilder();
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
