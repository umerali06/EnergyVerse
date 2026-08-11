//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'assign_work_order_request.g.dart';

/// AssignWorkOrderRequest
///
/// Properties:
/// * [dueDate]
/// * [expectedRevision]
/// * [technicianId]
@BuiltValue()
abstract class AssignWorkOrderRequest
    implements Built<AssignWorkOrderRequest, AssignWorkOrderRequestBuilder> {
  @BuiltValueField(wireName: r'due_date')
  DateTime? get dueDate;

  @BuiltValueField(wireName: r'expected_revision')
  int? get expectedRevision;

  @BuiltValueField(wireName: r'technician_id')
  String get technicianId;

  AssignWorkOrderRequest._();

  factory AssignWorkOrderRequest(
          [void updates(AssignWorkOrderRequestBuilder b)]) =
      _$AssignWorkOrderRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssignWorkOrderRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssignWorkOrderRequest> get serializer =>
      _$AssignWorkOrderRequestSerializer();
}

class _$AssignWorkOrderRequestSerializer
    implements PrimitiveSerializer<AssignWorkOrderRequest> {
  @override
  final Iterable<Type> types = const [
    AssignWorkOrderRequest,
    _$AssignWorkOrderRequest
  ];

  @override
  final String wireName = r'AssignWorkOrderRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssignWorkOrderRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dueDate != null) {
      yield r'due_date';
      yield serializers.serialize(
        object.dueDate,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.expectedRevision != null) {
      yield r'expected_revision';
      yield serializers.serialize(
        object.expectedRevision,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'technician_id';
    yield serializers.serialize(
      object.technicianId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssignWorkOrderRequest object, {
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
    required AssignWorkOrderRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'due_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.dueDate = valueDes;
          break;
        case r'expected_revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.expectedRevision = valueDes;
          break;
        case r'technician_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.technicianId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssignWorkOrderRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssignWorkOrderRequestBuilder();
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
