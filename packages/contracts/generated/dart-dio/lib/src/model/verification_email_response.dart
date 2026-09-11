//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'verification_email_response.g.dart';

/// `sent=False` means the address was already verified, not a failure -- re-verifying a confirmed address is a no-op rather than an error.
///
/// Properties:
/// * [sent]
@BuiltValue()
abstract class VerificationEmailResponse
    implements
        Built<VerificationEmailResponse, VerificationEmailResponseBuilder> {
  @BuiltValueField(wireName: r'sent')
  bool get sent;

  VerificationEmailResponse._();

  factory VerificationEmailResponse(
          [void updates(VerificationEmailResponseBuilder b)]) =
      _$VerificationEmailResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VerificationEmailResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VerificationEmailResponse> get serializer =>
      _$VerificationEmailResponseSerializer();
}

class _$VerificationEmailResponseSerializer
    implements PrimitiveSerializer<VerificationEmailResponse> {
  @override
  final Iterable<Type> types = const [
    VerificationEmailResponse,
    _$VerificationEmailResponse
  ];

  @override
  final String wireName = r'VerificationEmailResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VerificationEmailResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sent';
    yield serializers.serialize(
      object.sent,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VerificationEmailResponse object, {
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
    required VerificationEmailResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.sent = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VerificationEmailResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VerificationEmailResponseBuilder();
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
