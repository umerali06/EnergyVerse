//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'resume_permit_request.g.dart';

/// ResumePermitRequest
///
/// Properties:
/// * [expectedRevision]
/// * [resumeAttestation]
@BuiltValue()
abstract class ResumePermitRequest
    implements Built<ResumePermitRequest, ResumePermitRequestBuilder> {
  @BuiltValueField(wireName: r'expected_revision')
  int get expectedRevision;

  @BuiltValueField(wireName: r'resume_attestation')
  ResumePermitRequestResumeAttestationEnum get resumeAttestation;
  // enum resumeAttestationEnum {  true,  };

  ResumePermitRequest._();

  factory ResumePermitRequest([void updates(ResumePermitRequestBuilder b)]) =
      _$ResumePermitRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ResumePermitRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ResumePermitRequest> get serializer =>
      _$ResumePermitRequestSerializer();
}

class _$ResumePermitRequestSerializer
    implements PrimitiveSerializer<ResumePermitRequest> {
  @override
  final Iterable<Type> types = const [
    ResumePermitRequest,
    _$ResumePermitRequest
  ];

  @override
  final String wireName = r'ResumePermitRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ResumePermitRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expected_revision';
    yield serializers.serialize(
      object.expectedRevision,
      specifiedType: const FullType(int),
    );
    yield r'resume_attestation';
    yield serializers.serialize(
      object.resumeAttestation,
      specifiedType: const FullType(ResumePermitRequestResumeAttestationEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ResumePermitRequest object, {
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
    required ResumePermitRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'expected_revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expectedRevision = valueDes;
          break;
        case r'resume_attestation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(ResumePermitRequestResumeAttestationEnum),
          ) as ResumePermitRequestResumeAttestationEnum;
          result.resumeAttestation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ResumePermitRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ResumePermitRequestBuilder();
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

class ResumePermitRequestResumeAttestationEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'true')
  static const ResumePermitRequestResumeAttestationEnum true_ =
      _$resumePermitRequestResumeAttestationEnum_true_;

  static Serializer<ResumePermitRequestResumeAttestationEnum> get serializer =>
      _$resumePermitRequestResumeAttestationEnumSerializer;

  const ResumePermitRequestResumeAttestationEnum._(String name) : super(name);

  static BuiltSet<ResumePermitRequestResumeAttestationEnum> get values =>
      _$resumePermitRequestResumeAttestationEnumValues;
  static ResumePermitRequestResumeAttestationEnum valueOf(String name) =>
      _$resumePermitRequestResumeAttestationEnumValueOf(name);
}
