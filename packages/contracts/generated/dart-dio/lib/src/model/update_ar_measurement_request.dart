//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_ar_measurement_request.g.dart';

/// UpdateArMeasurementRequest
///
/// Properties:
/// * [checklistItemId]
/// * [label]
/// * [note]
@BuiltValue()
abstract class UpdateArMeasurementRequest
    implements
        Built<UpdateArMeasurementRequest, UpdateArMeasurementRequestBuilder> {
  @BuiltValueField(wireName: r'checklist_item_id')
  String? get checklistItemId;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'note')
  String? get note;

  UpdateArMeasurementRequest._();

  factory UpdateArMeasurementRequest(
          [void updates(UpdateArMeasurementRequestBuilder b)]) =
      _$UpdateArMeasurementRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateArMeasurementRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateArMeasurementRequest> get serializer =>
      _$UpdateArMeasurementRequestSerializer();
}

class _$UpdateArMeasurementRequestSerializer
    implements PrimitiveSerializer<UpdateArMeasurementRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateArMeasurementRequest,
    _$UpdateArMeasurementRequest
  ];

  @override
  final String wireName = r'UpdateArMeasurementRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateArMeasurementRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.checklistItemId != null) {
      yield r'checklist_item_id';
      yield serializers.serialize(
        object.checklistItemId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.label != null) {
      yield r'label';
      yield serializers.serialize(
        object.label,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateArMeasurementRequest object, {
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
    required UpdateArMeasurementRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'checklist_item_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.checklistItemId = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateArMeasurementRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateArMeasurementRequestBuilder();
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
