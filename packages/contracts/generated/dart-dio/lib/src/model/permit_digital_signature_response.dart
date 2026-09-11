//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permit_digital_signature_response.g.dart';

/// PermitDigitalSignatureResponse
///
/// Properties:
/// * [meaning]
/// * [signedAt]
/// * [signerId]
@BuiltValue()
abstract class PermitDigitalSignatureResponse
    implements
        Built<PermitDigitalSignatureResponse,
            PermitDigitalSignatureResponseBuilder> {
  @BuiltValueField(wireName: r'meaning')
  String get meaning;

  @BuiltValueField(wireName: r'signed_at')
  DateTime get signedAt;

  @BuiltValueField(wireName: r'signer_id')
  String get signerId;

  PermitDigitalSignatureResponse._();

  factory PermitDigitalSignatureResponse(
          [void updates(PermitDigitalSignatureResponseBuilder b)]) =
      _$PermitDigitalSignatureResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermitDigitalSignatureResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermitDigitalSignatureResponse> get serializer =>
      _$PermitDigitalSignatureResponseSerializer();
}

class _$PermitDigitalSignatureResponseSerializer
    implements PrimitiveSerializer<PermitDigitalSignatureResponse> {
  @override
  final Iterable<Type> types = const [
    PermitDigitalSignatureResponse,
    _$PermitDigitalSignatureResponse
  ];

  @override
  final String wireName = r'PermitDigitalSignatureResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermitDigitalSignatureResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'meaning';
    yield serializers.serialize(
      object.meaning,
      specifiedType: const FullType(String),
    );
    yield r'signed_at';
    yield serializers.serialize(
      object.signedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'signer_id';
    yield serializers.serialize(
      object.signerId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PermitDigitalSignatureResponse object, {
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
    required PermitDigitalSignatureResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'meaning':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.meaning = valueDes;
          break;
        case r'signed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.signedAt = valueDes;
          break;
        case r'signer_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.signerId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PermitDigitalSignatureResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermitDigitalSignatureResponseBuilder();
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
