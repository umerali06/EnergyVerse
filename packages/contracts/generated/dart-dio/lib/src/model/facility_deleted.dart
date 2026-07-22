//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'facility_deleted.g.dart';

/// FacilityDeleted
///
/// Properties:
/// * [deleted]
/// * [id]
@BuiltValue()
abstract class FacilityDeleted
    implements Built<FacilityDeleted, FacilityDeletedBuilder> {
  @BuiltValueField(wireName: r'deleted')
  bool? get deleted;

  @BuiltValueField(wireName: r'id')
  String get id;

  FacilityDeleted._();

  factory FacilityDeleted([void updates(FacilityDeletedBuilder b)]) =
      _$FacilityDeleted;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FacilityDeletedBuilder b) => b..deleted = true;

  @BuiltValueSerializer(custom: true)
  static Serializer<FacilityDeleted> get serializer =>
      _$FacilityDeletedSerializer();
}

class _$FacilityDeletedSerializer
    implements PrimitiveSerializer<FacilityDeleted> {
  @override
  final Iterable<Type> types = const [FacilityDeleted, _$FacilityDeleted];

  @override
  final String wireName = r'FacilityDeleted';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FacilityDeleted object, {
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
    FacilityDeleted object, {
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
    required FacilityDeletedBuilder result,
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
  FacilityDeleted deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FacilityDeletedBuilder();
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
