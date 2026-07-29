//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fev_api_client/src/model/value.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checklist_response.g.dart';

/// ChecklistResponse
///
/// Properties:
/// * [answeredAt]
/// * [answeredBy]
/// * [itemId]
/// * [note]
/// * [value]
@BuiltValue()
abstract class ChecklistResponse
    implements Built<ChecklistResponse, ChecklistResponseBuilder> {
  @BuiltValueField(wireName: r'answered_at')
  DateTime? get answeredAt;

  @BuiltValueField(wireName: r'answered_by')
  String? get answeredBy;

  @BuiltValueField(wireName: r'item_id')
  String get itemId;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'value')
  Value? get value;

  ChecklistResponse._();

  factory ChecklistResponse([void updates(ChecklistResponseBuilder b)]) =
      _$ChecklistResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChecklistResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChecklistResponse> get serializer =>
      _$ChecklistResponseSerializer();
}

class _$ChecklistResponseSerializer
    implements PrimitiveSerializer<ChecklistResponse> {
  @override
  final Iterable<Type> types = const [ChecklistResponse, _$ChecklistResponse];

  @override
  final String wireName = r'ChecklistResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChecklistResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.answeredAt != null) {
      yield r'answered_at';
      yield serializers.serialize(
        object.answeredAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.answeredBy != null) {
      yield r'answered_by';
      yield serializers.serialize(
        object.answeredBy,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'item_id';
    yield serializers.serialize(
      object.itemId,
      specifiedType: const FullType(String),
    );
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.value != null) {
      yield r'value';
      yield serializers.serialize(
        object.value,
        specifiedType: const FullType.nullable(Value),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ChecklistResponse object, {
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
    required ChecklistResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'answered_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.answeredAt = valueDes;
          break;
        case r'answered_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.answeredBy = valueDes;
          break;
        case r'item_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.itemId = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Value),
          ) as Value?;
          if (valueDes == null) continue;
          result.value.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChecklistResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChecklistResponseBuilder();
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
