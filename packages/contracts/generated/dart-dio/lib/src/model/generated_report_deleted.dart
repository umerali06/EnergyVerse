//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'generated_report_deleted.g.dart';

/// GeneratedReportDeleted
///
/// Properties:
/// * [deleted]
/// * [id]
@BuiltValue()
abstract class GeneratedReportDeleted
    implements Built<GeneratedReportDeleted, GeneratedReportDeletedBuilder> {
  @BuiltValueField(wireName: r'deleted')
  bool? get deleted;

  @BuiltValueField(wireName: r'id')
  String get id;

  GeneratedReportDeleted._();

  factory GeneratedReportDeleted(
          [void updates(GeneratedReportDeletedBuilder b)]) =
      _$GeneratedReportDeleted;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeneratedReportDeletedBuilder b) => b..deleted = true;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeneratedReportDeleted> get serializer =>
      _$GeneratedReportDeletedSerializer();
}

class _$GeneratedReportDeletedSerializer
    implements PrimitiveSerializer<GeneratedReportDeleted> {
  @override
  final Iterable<Type> types = const [
    GeneratedReportDeleted,
    _$GeneratedReportDeleted
  ];

  @override
  final String wireName = r'GeneratedReportDeleted';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeneratedReportDeleted object, {
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
    GeneratedReportDeleted object, {
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
    required GeneratedReportDeletedBuilder result,
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
  GeneratedReportDeleted deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeneratedReportDeletedBuilder();
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
