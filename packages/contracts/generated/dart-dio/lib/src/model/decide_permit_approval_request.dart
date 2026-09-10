//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'decide_permit_approval_request.g.dart';

/// DecidePermitApprovalRequest
///
/// Properties:
/// * [decision]
/// * [digitalSignatureAttestation]
/// * [expectedRevision]
/// * [rejectionReason]
@BuiltValue()
abstract class DecidePermitApprovalRequest
    implements
        Built<DecidePermitApprovalRequest, DecidePermitApprovalRequestBuilder> {
  @BuiltValueField(wireName: r'decision')
  DecidePermitApprovalRequestDecisionEnum get decision;
  // enum decisionEnum {  approve,  reject,  };

  @BuiltValueField(wireName: r'digital_signature_attestation')
  DecidePermitApprovalRequestDigitalSignatureAttestationEnum
      get digitalSignatureAttestation;
  // enum digitalSignatureAttestationEnum {  true,  };

  @BuiltValueField(wireName: r'expected_revision')
  int get expectedRevision;

  @BuiltValueField(wireName: r'rejection_reason')
  String? get rejectionReason;

  DecidePermitApprovalRequest._();

  factory DecidePermitApprovalRequest(
          [void updates(DecidePermitApprovalRequestBuilder b)]) =
      _$DecidePermitApprovalRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DecidePermitApprovalRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DecidePermitApprovalRequest> get serializer =>
      _$DecidePermitApprovalRequestSerializer();
}

class _$DecidePermitApprovalRequestSerializer
    implements PrimitiveSerializer<DecidePermitApprovalRequest> {
  @override
  final Iterable<Type> types = const [
    DecidePermitApprovalRequest,
    _$DecidePermitApprovalRequest
  ];

  @override
  final String wireName = r'DecidePermitApprovalRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DecidePermitApprovalRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'decision';
    yield serializers.serialize(
      object.decision,
      specifiedType: const FullType(DecidePermitApprovalRequestDecisionEnum),
    );
    yield r'digital_signature_attestation';
    yield serializers.serialize(
      object.digitalSignatureAttestation,
      specifiedType: const FullType(
          DecidePermitApprovalRequestDigitalSignatureAttestationEnum),
    );
    yield r'expected_revision';
    yield serializers.serialize(
      object.expectedRevision,
      specifiedType: const FullType(int),
    );
    if (object.rejectionReason != null) {
      yield r'rejection_reason';
      yield serializers.serialize(
        object.rejectionReason,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DecidePermitApprovalRequest object, {
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
    required DecidePermitApprovalRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'decision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(DecidePermitApprovalRequestDecisionEnum),
          ) as DecidePermitApprovalRequestDecisionEnum;
          result.decision = valueDes;
          break;
        case r'digital_signature_attestation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                DecidePermitApprovalRequestDigitalSignatureAttestationEnum),
          ) as DecidePermitApprovalRequestDigitalSignatureAttestationEnum;
          result.digitalSignatureAttestation = valueDes;
          break;
        case r'expected_revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expectedRevision = valueDes;
          break;
        case r'rejection_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.rejectionReason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DecidePermitApprovalRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DecidePermitApprovalRequestBuilder();
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

class DecidePermitApprovalRequestDecisionEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'approve')
  static const DecidePermitApprovalRequestDecisionEnum approve =
      _$decidePermitApprovalRequestDecisionEnum_approve;
  @BuiltValueEnumConst(wireName: r'reject')
  static const DecidePermitApprovalRequestDecisionEnum reject =
      _$decidePermitApprovalRequestDecisionEnum_reject;

  static Serializer<DecidePermitApprovalRequestDecisionEnum> get serializer =>
      _$decidePermitApprovalRequestDecisionEnumSerializer;

  const DecidePermitApprovalRequestDecisionEnum._(String name) : super(name);

  static BuiltSet<DecidePermitApprovalRequestDecisionEnum> get values =>
      _$decidePermitApprovalRequestDecisionEnumValues;
  static DecidePermitApprovalRequestDecisionEnum valueOf(String name) =>
      _$decidePermitApprovalRequestDecisionEnumValueOf(name);
}

class DecidePermitApprovalRequestDigitalSignatureAttestationEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'true')
  static const DecidePermitApprovalRequestDigitalSignatureAttestationEnum
      true_ =
      _$decidePermitApprovalRequestDigitalSignatureAttestationEnum_true_;

  static Serializer<DecidePermitApprovalRequestDigitalSignatureAttestationEnum>
      get serializer =>
          _$decidePermitApprovalRequestDigitalSignatureAttestationEnumSerializer;

  const DecidePermitApprovalRequestDigitalSignatureAttestationEnum._(
      String name)
      : super(name);

  static BuiltSet<DecidePermitApprovalRequestDigitalSignatureAttestationEnum>
      get values =>
          _$decidePermitApprovalRequestDigitalSignatureAttestationEnumValues;
  static DecidePermitApprovalRequestDigitalSignatureAttestationEnum valueOf(
          String name) =>
      _$decidePermitApprovalRequestDigitalSignatureAttestationEnumValueOf(name);
}
