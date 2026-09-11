//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permit_template_deleted.g.dart';

/// PermitTemplateDeleted
///
/// Properties:
/// * [deleted]
/// * [id]
@BuiltValue()
abstract class PermitTemplateDeleted
    implements Built<PermitTemplateDeleted, PermitTemplateDeletedBuilder> {
  @BuiltValueField(wireName: r'deleted')
  bool? get deleted;

  @BuiltValueField(wireName: r'id')
  String get id;

  PermitTemplateDeleted._();

  factory PermitTemplateDeleted(
      [void updates(PermitTemplateDeletedBuilder b)]) = _$PermitTemplateDeleted;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermitTemplateDeletedBuilder b) => b..deleted = true;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermitTemplateDeleted> get serializer =>
      _$PermitTemplateDeletedSerializer();
}

class _$PermitTemplateDeletedSerializer
    implements PrimitiveSerializer<PermitTemplateDeleted> {
  @override
  final Iterable<Type> types = const [
    PermitTemplateDeleted,
    _$PermitTemplateDeleted
  ];

  @override
  final String wireName = r'PermitTemplateDeleted';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermitTemplateDeleted object, {
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
    PermitTemplateDeleted object, {
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
    required PermitTemplateDeletedBuilder result,
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
  PermitTemplateDeleted deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermitTemplateDeletedBuilder();
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
