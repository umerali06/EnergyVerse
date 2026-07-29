//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'assign_checklist_template_request.g.dart';

/// AssignChecklistTemplateRequest
///
/// Properties:
/// * [checklistTemplateId]
/// * [expectedRevision]
@BuiltValue()
abstract class AssignChecklistTemplateRequest
    implements
        Built<AssignChecklistTemplateRequest,
            AssignChecklistTemplateRequestBuilder> {
  @BuiltValueField(wireName: r'checklist_template_id')
  String get checklistTemplateId;

  @BuiltValueField(wireName: r'expected_revision')
  int? get expectedRevision;

  AssignChecklistTemplateRequest._();

  factory AssignChecklistTemplateRequest(
          [void updates(AssignChecklistTemplateRequestBuilder b)]) =
      _$AssignChecklistTemplateRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssignChecklistTemplateRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssignChecklistTemplateRequest> get serializer =>
      _$AssignChecklistTemplateRequestSerializer();
}

class _$AssignChecklistTemplateRequestSerializer
    implements PrimitiveSerializer<AssignChecklistTemplateRequest> {
  @override
  final Iterable<Type> types = const [
    AssignChecklistTemplateRequest,
    _$AssignChecklistTemplateRequest
  ];

  @override
  final String wireName = r'AssignChecklistTemplateRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssignChecklistTemplateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'checklist_template_id';
    yield serializers.serialize(
      object.checklistTemplateId,
      specifiedType: const FullType(String),
    );
    if (object.expectedRevision != null) {
      yield r'expected_revision';
      yield serializers.serialize(
        object.expectedRevision,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AssignChecklistTemplateRequest object, {
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
    required AssignChecklistTemplateRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'checklist_template_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.checklistTemplateId = valueDes;
          break;
        case r'expected_revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
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
  AssignChecklistTemplateRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssignChecklistTemplateRequestBuilder();
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
