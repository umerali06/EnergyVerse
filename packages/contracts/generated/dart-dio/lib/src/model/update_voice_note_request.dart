//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_voice_note_request.g.dart';

/// UpdateVoiceNoteRequest
///
/// Properties:
/// * [checklistItemId]
@BuiltValue()
abstract class UpdateVoiceNoteRequest
    implements Built<UpdateVoiceNoteRequest, UpdateVoiceNoteRequestBuilder> {
  @BuiltValueField(wireName: r'checklist_item_id')
  String? get checklistItemId;

  UpdateVoiceNoteRequest._();

  factory UpdateVoiceNoteRequest(
          [void updates(UpdateVoiceNoteRequestBuilder b)]) =
      _$UpdateVoiceNoteRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateVoiceNoteRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateVoiceNoteRequest> get serializer =>
      _$UpdateVoiceNoteRequestSerializer();
}

class _$UpdateVoiceNoteRequestSerializer
    implements PrimitiveSerializer<UpdateVoiceNoteRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateVoiceNoteRequest,
    _$UpdateVoiceNoteRequest
  ];

  @override
  final String wireName = r'UpdateVoiceNoteRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateVoiceNoteRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    UpdateVoiceNoteRequest object, {
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
    required UpdateVoiceNoteRequestBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateVoiceNoteRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateVoiceNoteRequestBuilder();
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
