//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checklist_template_deleted.g.dart';

/// ChecklistTemplateDeleted
///
/// Properties:
/// * [deleted]
/// * [id]
@BuiltValue()
abstract class ChecklistTemplateDeleted
    implements
        Built<ChecklistTemplateDeleted, ChecklistTemplateDeletedBuilder> {
  @BuiltValueField(wireName: r'deleted')
  bool? get deleted;

  @BuiltValueField(wireName: r'id')
  String get id;

  ChecklistTemplateDeleted._();

  factory ChecklistTemplateDeleted(
          [void updates(ChecklistTemplateDeletedBuilder b)]) =
      _$ChecklistTemplateDeleted;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChecklistTemplateDeletedBuilder b) => b..deleted = true;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChecklistTemplateDeleted> get serializer =>
      _$ChecklistTemplateDeletedSerializer();
}

class _$ChecklistTemplateDeletedSerializer
    implements PrimitiveSerializer<ChecklistTemplateDeleted> {
  @override
  final Iterable<Type> types = const [
    ChecklistTemplateDeleted,
    _$ChecklistTemplateDeleted
  ];

  @override
  final String wireName = r'ChecklistTemplateDeleted';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChecklistTemplateDeleted object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.deleted != null) {
      yield r'deleted';
      yield serializers.serialize(
        object.deleted,
        specifiedType: const FullType(bool),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChecklistTemplateDeleted object, {
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
    required ChecklistTemplateDeletedBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'deleted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.deleted = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChecklistTemplateDeleted deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChecklistTemplateDeletedBuilder();
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
