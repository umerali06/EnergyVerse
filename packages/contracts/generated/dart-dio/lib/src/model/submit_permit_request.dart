//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'submit_permit_request.g.dart';

/// SubmitPermitRequest
///
/// Properties:
/// * [completedChecklistItemIds]
/// * [expectedRevision]
/// * [issuerAttestation]
@BuiltValue()
abstract class SubmitPermitRequest
    implements Built<SubmitPermitRequest, SubmitPermitRequestBuilder> {
  @BuiltValueField(wireName: r'completed_checklist_item_ids')
  BuiltList<String> get completedChecklistItemIds;

  @BuiltValueField(wireName: r'expected_revision')
  int get expectedRevision;

  @BuiltValueField(wireName: r'issuer_attestation')
  SubmitPermitRequestIssuerAttestationEnum get issuerAttestation;
  // enum issuerAttestationEnum {  true,  };

  SubmitPermitRequest._();

  factory SubmitPermitRequest([void updates(SubmitPermitRequestBuilder b)]) =
      _$SubmitPermitRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubmitPermitRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubmitPermitRequest> get serializer =>
      _$SubmitPermitRequestSerializer();
}

class _$SubmitPermitRequestSerializer
    implements PrimitiveSerializer<SubmitPermitRequest> {
  @override
  final Iterable<Type> types = const [
    SubmitPermitRequest,
    _$SubmitPermitRequest
  ];

  @override
  final String wireName = r'SubmitPermitRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubmitPermitRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'completed_checklist_item_ids';
    yield serializers.serialize(
      object.completedChecklistItemIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'expected_revision';
    yield serializers.serialize(
      object.expectedRevision,
      specifiedType: const FullType(int),
    );
    yield r'issuer_attestation';
    yield serializers.serialize(
      object.issuerAttestation,
      specifiedType: const FullType(SubmitPermitRequestIssuerAttestationEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SubmitPermitRequest object, {
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
    required SubmitPermitRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'completed_checklist_item_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.completedChecklistItemIds.replace(valueDes);
          break;
        case r'expected_revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expectedRevision = valueDes;
          break;
        case r'issuer_attestation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(SubmitPermitRequestIssuerAttestationEnum),
          ) as SubmitPermitRequestIssuerAttestationEnum;
          result.issuerAttestation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubmitPermitRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubmitPermitRequestBuilder();
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

class SubmitPermitRequestIssuerAttestationEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'true')
  static const SubmitPermitRequestIssuerAttestationEnum true_ =
      _$submitPermitRequestIssuerAttestationEnum_true_;

  static Serializer<SubmitPermitRequestIssuerAttestationEnum> get serializer =>
      _$submitPermitRequestIssuerAttestationEnumSerializer;

  const SubmitPermitRequestIssuerAttestationEnum._(String name) : super(name);

  static BuiltSet<SubmitPermitRequestIssuerAttestationEnum> get values =>
      _$submitPermitRequestIssuerAttestationEnumValues;
  static SubmitPermitRequestIssuerAttestationEnum valueOf(String name) =>
      _$submitPermitRequestIssuerAttestationEnumValueOf(name);
}
