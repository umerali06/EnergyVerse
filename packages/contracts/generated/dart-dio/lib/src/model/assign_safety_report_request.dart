//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'assign_safety_report_request.g.dart';

/// AssignSafetyReportRequest
///
/// Properties:
/// * [expectedRevision]
/// * [managerId]
@BuiltValue()
abstract class AssignSafetyReportRequest
    implements
        Built<AssignSafetyReportRequest, AssignSafetyReportRequestBuilder> {
  @BuiltValueField(wireName: r'expected_revision')
  int? get expectedRevision;

  @BuiltValueField(wireName: r'manager_id')
  String get managerId;

  AssignSafetyReportRequest._();

  factory AssignSafetyReportRequest(
          [void updates(AssignSafetyReportRequestBuilder b)]) =
      _$AssignSafetyReportRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssignSafetyReportRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssignSafetyReportRequest> get serializer =>
      _$AssignSafetyReportRequestSerializer();
}

class _$AssignSafetyReportRequestSerializer
    implements PrimitiveSerializer<AssignSafetyReportRequest> {
  @override
  final Iterable<Type> types = const [
    AssignSafetyReportRequest,
    _$AssignSafetyReportRequest
  ];

  @override
  final String wireName = r'AssignSafetyReportRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssignSafetyReportRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.expectedRevision != null) {
      yield r'expected_revision';
      yield serializers.serialize(
        object.expectedRevision,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'manager_id';
    yield serializers.serialize(
      object.managerId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssignSafetyReportRequest object, {
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
    required AssignSafetyReportRequestBuilder result,
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
        case r'manager_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.managerId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssignSafetyReportRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssignSafetyReportRequestBuilder();
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
