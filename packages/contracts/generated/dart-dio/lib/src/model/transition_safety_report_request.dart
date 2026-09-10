//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transition_safety_report_request.g.dart';

/// TransitionSafetyReportRequest
///
/// Properties:
/// * [expectedRevision]
/// * [status]
@BuiltValue()
abstract class TransitionSafetyReportRequest
    implements
        Built<TransitionSafetyReportRequest,
            TransitionSafetyReportRequestBuilder> {
  @BuiltValueField(wireName: r'expected_revision')
  int? get expectedRevision;

  @BuiltValueField(wireName: r'status')
  TransitionSafetyReportRequestStatusEnum get status;
  // enum statusEnum {  under_review,  corrective_action,  resolved,  cancelled,  };

  TransitionSafetyReportRequest._();

  factory TransitionSafetyReportRequest(
          [void updates(TransitionSafetyReportRequestBuilder b)]) =
      _$TransitionSafetyReportRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TransitionSafetyReportRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TransitionSafetyReportRequest> get serializer =>
      _$TransitionSafetyReportRequestSerializer();
}

class _$TransitionSafetyReportRequestSerializer
    implements PrimitiveSerializer<TransitionSafetyReportRequest> {
  @override
  final Iterable<Type> types = const [
    TransitionSafetyReportRequest,
    _$TransitionSafetyReportRequest
  ];

  @override
  final String wireName = r'TransitionSafetyReportRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TransitionSafetyReportRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.expectedRevision != null) {
      yield r'expected_revision';
      yield serializers.serialize(
        object.expectedRevision,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(TransitionSafetyReportRequestStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TransitionSafetyReportRequest object, {
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
    required TransitionSafetyReportRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'expected_revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.expectedRevision = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(TransitionSafetyReportRequestStatusEnum),
          ) as TransitionSafetyReportRequestStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TransitionSafetyReportRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TransitionSafetyReportRequestBuilder();
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

class TransitionSafetyReportRequestStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'under_review')
  static const TransitionSafetyReportRequestStatusEnum underReview =
      _$transitionSafetyReportRequestStatusEnum_underReview;
  @BuiltValueEnumConst(wireName: r'corrective_action')
  static const TransitionSafetyReportRequestStatusEnum correctiveAction =
      _$transitionSafetyReportRequestStatusEnum_correctiveAction;
  @BuiltValueEnumConst(wireName: r'resolved')
  static const TransitionSafetyReportRequestStatusEnum resolved =
      _$transitionSafetyReportRequestStatusEnum_resolved;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const TransitionSafetyReportRequestStatusEnum cancelled =
      _$transitionSafetyReportRequestStatusEnum_cancelled;

  static Serializer<TransitionSafetyReportRequestStatusEnum> get serializer =>
      _$transitionSafetyReportRequestStatusEnumSerializer;

  const TransitionSafetyReportRequestStatusEnum._(String name) : super(name);

  static BuiltSet<TransitionSafetyReportRequestStatusEnum> get values =>
      _$transitionSafetyReportRequestStatusEnumValues;
  static TransitionSafetyReportRequestStatusEnum valueOf(String name) =>
      _$transitionSafetyReportRequestStatusEnumValueOf(name);
}
