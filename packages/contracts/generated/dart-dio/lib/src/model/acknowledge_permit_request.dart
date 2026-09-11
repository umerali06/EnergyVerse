//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'acknowledge_permit_request.g.dart';

/// AcknowledgePermitRequest
///
/// Properties:
/// * [clientMutationId]
/// * [clientSignedAt]
/// * [deviceId]
/// * [expectedRevision]
/// * [workerAttestation]
@BuiltValue()
abstract class AcknowledgePermitRequest
    implements
        Built<AcknowledgePermitRequest, AcknowledgePermitRequestBuilder> {
  @BuiltValueField(wireName: r'client_mutation_id')
  String get clientMutationId;

  @BuiltValueField(wireName: r'client_signed_at')
  DateTime get clientSignedAt;

  @BuiltValueField(wireName: r'device_id')
  String? get deviceId;

  @BuiltValueField(wireName: r'expected_revision')
  int get expectedRevision;

  @BuiltValueField(wireName: r'worker_attestation')
  AcknowledgePermitRequestWorkerAttestationEnum get workerAttestation;
  // enum workerAttestationEnum {  true,  };

  AcknowledgePermitRequest._();

  factory AcknowledgePermitRequest(
          [void updates(AcknowledgePermitRequestBuilder b)]) =
      _$AcknowledgePermitRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AcknowledgePermitRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AcknowledgePermitRequest> get serializer =>
      _$AcknowledgePermitRequestSerializer();
}

class _$AcknowledgePermitRequestSerializer
    implements PrimitiveSerializer<AcknowledgePermitRequest> {
  @override
  final Iterable<Type> types = const [
    AcknowledgePermitRequest,
    _$AcknowledgePermitRequest
  ];

  @override
  final String wireName = r'AcknowledgePermitRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AcknowledgePermitRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'client_mutation_id';
    yield serializers.serialize(
      object.clientMutationId,
      specifiedType: const FullType(String),
    );
    yield r'client_signed_at';
    yield serializers.serialize(
      object.clientSignedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.deviceId != null) {
      yield r'device_id';
      yield serializers.serialize(
        object.deviceId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'expected_revision';
    yield serializers.serialize(
      object.expectedRevision,
      specifiedType: const FullType(int),
    );
    yield r'worker_attestation';
    yield serializers.serialize(
      object.workerAttestation,
      specifiedType:
          const FullType(AcknowledgePermitRequestWorkerAttestationEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AcknowledgePermitRequest object, {
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
    required AcknowledgePermitRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'client_mutation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientMutationId = valueDes;
          break;
        case r'client_signed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.clientSignedAt = valueDes;
          break;
        case r'device_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.deviceId = valueDes;
          break;
        case r'expected_revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expectedRevision = valueDes;
          break;
        case r'worker_attestation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(AcknowledgePermitRequestWorkerAttestationEnum),
          ) as AcknowledgePermitRequestWorkerAttestationEnum;
          result.workerAttestation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AcknowledgePermitRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AcknowledgePermitRequestBuilder();
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

class AcknowledgePermitRequestWorkerAttestationEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'true')
  static const AcknowledgePermitRequestWorkerAttestationEnum true_ =
      _$acknowledgePermitRequestWorkerAttestationEnum_true_;

  static Serializer<AcknowledgePermitRequestWorkerAttestationEnum>
      get serializer =>
          _$acknowledgePermitRequestWorkerAttestationEnumSerializer;

  const AcknowledgePermitRequestWorkerAttestationEnum._(String name)
      : super(name);

  static BuiltSet<AcknowledgePermitRequestWorkerAttestationEnum> get values =>
      _$acknowledgePermitRequestWorkerAttestationEnumValues;
  static AcknowledgePermitRequestWorkerAttestationEnum valueOf(String name) =>
      _$acknowledgePermitRequestWorkerAttestationEnumValueOf(name);
}
