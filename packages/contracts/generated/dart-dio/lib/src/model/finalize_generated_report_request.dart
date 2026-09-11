//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'finalize_generated_report_request.g.dart';

/// FinalizeGeneratedReportRequest
///
/// Properties:
/// * [expectedRevision]
/// * [finalizationAttestation]
@BuiltValue()
abstract class FinalizeGeneratedReportRequest
    implements
        Built<FinalizeGeneratedReportRequest,
            FinalizeGeneratedReportRequestBuilder> {
  @BuiltValueField(wireName: r'expected_revision')
  int get expectedRevision;

  @BuiltValueField(wireName: r'finalization_attestation')
  FinalizeGeneratedReportRequestFinalizationAttestationEnum
      get finalizationAttestation;
  // enum finalizationAttestationEnum {  true,  };

  FinalizeGeneratedReportRequest._();

  factory FinalizeGeneratedReportRequest(
          [void updates(FinalizeGeneratedReportRequestBuilder b)]) =
      _$FinalizeGeneratedReportRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FinalizeGeneratedReportRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FinalizeGeneratedReportRequest> get serializer =>
      _$FinalizeGeneratedReportRequestSerializer();
}

class _$FinalizeGeneratedReportRequestSerializer
    implements PrimitiveSerializer<FinalizeGeneratedReportRequest> {
  @override
  final Iterable<Type> types = const [
    FinalizeGeneratedReportRequest,
    _$FinalizeGeneratedReportRequest
  ];

  @override
  final String wireName = r'FinalizeGeneratedReportRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FinalizeGeneratedReportRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expected_revision';
    yield serializers.serialize(
      object.expectedRevision,
      specifiedType: const FullType(int),
    );
    yield r'finalization_attestation';
    yield serializers.serialize(
      object.finalizationAttestation,
      specifiedType: const FullType(
          FinalizeGeneratedReportRequestFinalizationAttestationEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FinalizeGeneratedReportRequest object, {
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
    required FinalizeGeneratedReportRequestBuilder result,
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
        case r'finalization_attestation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                FinalizeGeneratedReportRequestFinalizationAttestationEnum),
          ) as FinalizeGeneratedReportRequestFinalizationAttestationEnum;
          result.finalizationAttestation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FinalizeGeneratedReportRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FinalizeGeneratedReportRequestBuilder();
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

class FinalizeGeneratedReportRequestFinalizationAttestationEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'true')
  static const FinalizeGeneratedReportRequestFinalizationAttestationEnum true_ =
      _$finalizeGeneratedReportRequestFinalizationAttestationEnum_true_;

  static Serializer<FinalizeGeneratedReportRequestFinalizationAttestationEnum>
      get serializer =>
          _$finalizeGeneratedReportRequestFinalizationAttestationEnumSerializer;

  const FinalizeGeneratedReportRequestFinalizationAttestationEnum._(String name)
      : super(name);

  static BuiltSet<FinalizeGeneratedReportRequestFinalizationAttestationEnum>
      get values =>
          _$finalizeGeneratedReportRequestFinalizationAttestationEnumValues;
  static FinalizeGeneratedReportRequestFinalizationAttestationEnum valueOf(
          String name) =>
      _$finalizeGeneratedReportRequestFinalizationAttestationEnumValueOf(name);
}
