//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'activate_permit_request.g.dart';

/// ActivatePermitRequest
///
/// Properties:
/// * [activationAttestation]
/// * [expectedRevision]
@BuiltValue()
abstract class ActivatePermitRequest
    implements Built<ActivatePermitRequest, ActivatePermitRequestBuilder> {
  @BuiltValueField(wireName: r'activation_attestation')
  ActivatePermitRequestActivationAttestationEnum get activationAttestation;
  // enum activationAttestationEnum {  true,  };

  @BuiltValueField(wireName: r'expected_revision')
  int get expectedRevision;

  ActivatePermitRequest._();

  factory ActivatePermitRequest(
      [void updates(ActivatePermitRequestBuilder b)]) = _$ActivatePermitRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ActivatePermitRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ActivatePermitRequest> get serializer =>
      _$ActivatePermitRequestSerializer();
}

class _$ActivatePermitRequestSerializer
    implements PrimitiveSerializer<ActivatePermitRequest> {
  @override
  final Iterable<Type> types = const [
    ActivatePermitRequest,
    _$ActivatePermitRequest
  ];

  @override
  final String wireName = r'ActivatePermitRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ActivatePermitRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'activation_attestation';
    yield serializers.serialize(
      object.activationAttestation,
      specifiedType:
          const FullType(ActivatePermitRequestActivationAttestationEnum),
    );
    yield r'expected_revision';
    yield serializers.serialize(
      object.expectedRevision,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ActivatePermitRequest object, {
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
    required ActivatePermitRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'activation_attestation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(ActivatePermitRequestActivationAttestationEnum),
          ) as ActivatePermitRequestActivationAttestationEnum;
          result.activationAttestation = valueDes;
          break;
        case r'expected_revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expectedRevision = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ActivatePermitRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ActivatePermitRequestBuilder();
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

class ActivatePermitRequestActivationAttestationEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'true')
  static const ActivatePermitRequestActivationAttestationEnum true_ =
      _$activatePermitRequestActivationAttestationEnum_true_;

  static Serializer<ActivatePermitRequestActivationAttestationEnum>
      get serializer =>
          _$activatePermitRequestActivationAttestationEnumSerializer;

  const ActivatePermitRequestActivationAttestationEnum._(String name)
      : super(name);

  static BuiltSet<ActivatePermitRequestActivationAttestationEnum> get values =>
      _$activatePermitRequestActivationAttestationEnumValues;
  static ActivatePermitRequestActivationAttestationEnum valueOf(String name) =>
      _$activatePermitRequestActivationAttestationEnumValueOf(name);
}
