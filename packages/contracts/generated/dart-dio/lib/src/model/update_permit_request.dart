//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/permit_risk_assessment_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_permit_request.g.dart';

/// UpdatePermitRequest
///
/// Properties:
/// * [description]
/// * [expectedRevision]
/// * [riskAssessment]
/// * [title]
/// * [validFrom]
/// * [validUntil]
/// * [workerIds]
@BuiltValue()
abstract class UpdatePermitRequest
    implements Built<UpdatePermitRequest, UpdatePermitRequestBuilder> {
  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'expected_revision')
  int get expectedRevision;

  @BuiltValueField(wireName: r'risk_assessment')
  BuiltList<PermitRiskAssessmentInput>? get riskAssessment;

  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'valid_from')
  DateTime? get validFrom;

  @BuiltValueField(wireName: r'valid_until')
  DateTime? get validUntil;

  @BuiltValueField(wireName: r'worker_ids')
  BuiltList<String>? get workerIds;

  UpdatePermitRequest._();

  factory UpdatePermitRequest([void updates(UpdatePermitRequestBuilder b)]) =
      _$UpdatePermitRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdatePermitRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdatePermitRequest> get serializer =>
      _$UpdatePermitRequestSerializer();
}

class _$UpdatePermitRequestSerializer
    implements PrimitiveSerializer<UpdatePermitRequest> {
  @override
  final Iterable<Type> types = const [
    UpdatePermitRequest,
    _$UpdatePermitRequest
  ];

  @override
  final String wireName = r'UpdatePermitRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdatePermitRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'expected_revision';
    yield serializers.serialize(
      object.expectedRevision,
      specifiedType: const FullType(int),
    );
    if (object.riskAssessment != null) {
      yield r'risk_assessment';
      yield serializers.serialize(
        object.riskAssessment,
        specifiedType: const FullType.nullable(
            BuiltList, [FullType(PermitRiskAssessmentInput)]),
      );
    }
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.validFrom != null) {
      yield r'valid_from';
      yield serializers.serialize(
        object.validFrom,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.validUntil != null) {
      yield r'valid_until';
      yield serializers.serialize(
        object.validUntil,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.workerIds != null) {
      yield r'worker_ids';
      yield serializers.serialize(
        object.workerIds,
        specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdatePermitRequest object, {
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
    required UpdatePermitRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'expected_revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expectedRevision = valueDes;
          break;
        case r'risk_assessment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
                BuiltList, [FullType(PermitRiskAssessmentInput)]),
          ) as BuiltList<PermitRiskAssessmentInput>?;
          if (valueDes == null) continue;
          result.riskAssessment.replace(valueDes);
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.title = valueDes;
          break;
        case r'valid_from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.validFrom = valueDes;
          break;
        case r'valid_until':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.validUntil = valueDes;
          break;
        case r'worker_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.workerIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdatePermitRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdatePermitRequestBuilder();
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
