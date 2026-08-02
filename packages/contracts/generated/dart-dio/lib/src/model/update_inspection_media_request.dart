//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_inspection_media_request.g.dart';

/// UpdateInspectionMediaRequest
///
/// Properties:
/// * [beforeAfterTag]
/// * [checklistItemId]
@BuiltValue()
abstract class UpdateInspectionMediaRequest
    implements
        Built<UpdateInspectionMediaRequest,
            UpdateInspectionMediaRequestBuilder> {
  @BuiltValueField(wireName: r'before_after_tag')
  UpdateInspectionMediaRequestBeforeAfterTagEnum? get beforeAfterTag;
  // enum beforeAfterTagEnum {  before,  after,  };

  @BuiltValueField(wireName: r'checklist_item_id')
  String? get checklistItemId;

  UpdateInspectionMediaRequest._();

  factory UpdateInspectionMediaRequest(
          [void updates(UpdateInspectionMediaRequestBuilder b)]) =
      _$UpdateInspectionMediaRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateInspectionMediaRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateInspectionMediaRequest> get serializer =>
      _$UpdateInspectionMediaRequestSerializer();
}

class _$UpdateInspectionMediaRequestSerializer
    implements PrimitiveSerializer<UpdateInspectionMediaRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateInspectionMediaRequest,
    _$UpdateInspectionMediaRequest
  ];

  @override
  final String wireName = r'UpdateInspectionMediaRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateInspectionMediaRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.beforeAfterTag != null) {
      yield r'before_after_tag';
      yield serializers.serialize(
        object.beforeAfterTag,
        specifiedType: const FullType.nullable(
            UpdateInspectionMediaRequestBeforeAfterTagEnum),
      );
    }
    if (object.checklistItemId != null) {
      yield r'checklist_item_id';
      yield serializers.serialize(
        object.checklistItemId,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateInspectionMediaRequest object, {
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
    required UpdateInspectionMediaRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'before_after_tag':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
                UpdateInspectionMediaRequestBeforeAfterTagEnum),
          ) as UpdateInspectionMediaRequestBeforeAfterTagEnum?;
          if (valueDes == null) continue;
          result.beforeAfterTag = valueDes;
          break;
        case r'checklist_item_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.checklistItemId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateInspectionMediaRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateInspectionMediaRequestBuilder();
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

class UpdateInspectionMediaRequestBeforeAfterTagEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'before')
  static const UpdateInspectionMediaRequestBeforeAfterTagEnum before =
      _$updateInspectionMediaRequestBeforeAfterTagEnum_before;
  @BuiltValueEnumConst(wireName: r'after')
  static const UpdateInspectionMediaRequestBeforeAfterTagEnum after =
      _$updateInspectionMediaRequestBeforeAfterTagEnum_after;

  static Serializer<UpdateInspectionMediaRequestBeforeAfterTagEnum>
      get serializer =>
          _$updateInspectionMediaRequestBeforeAfterTagEnumSerializer;

  const UpdateInspectionMediaRequestBeforeAfterTagEnum._(String name)
      : super(name);

  static BuiltSet<UpdateInspectionMediaRequestBeforeAfterTagEnum> get values =>
      _$updateInspectionMediaRequestBeforeAfterTagEnumValues;
  static UpdateInspectionMediaRequestBeforeAfterTagEnum valueOf(String name) =>
      _$updateInspectionMediaRequestBeforeAfterTagEnumValueOf(name);
}
