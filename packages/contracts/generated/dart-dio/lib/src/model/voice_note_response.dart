//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'voice_note_response.g.dart';

/// VoiceNoteResponse
///
/// Properties:
/// * [checklistItemId]
/// * [contentType]
/// * [durationMs]
/// * [filename]
/// * [id]
/// * [localId]
/// * [size]
/// * [uploadedAt]
/// * [uploadedBy]
/// * [url]
@BuiltValue()
abstract class VoiceNoteResponse
    implements Built<VoiceNoteResponse, VoiceNoteResponseBuilder> {
  @BuiltValueField(wireName: r'checklist_item_id')
  String? get checklistItemId;

  @BuiltValueField(wireName: r'content_type')
  String get contentType;

  @BuiltValueField(wireName: r'duration_ms')
  int get durationMs;

  @BuiltValueField(wireName: r'filename')
  String get filename;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'local_id')
  String get localId;

  @BuiltValueField(wireName: r'size')
  int get size;

  @BuiltValueField(wireName: r'uploaded_at')
  DateTime get uploadedAt;

  @BuiltValueField(wireName: r'uploaded_by')
  String get uploadedBy;

  @BuiltValueField(wireName: r'url')
  String get url;

  VoiceNoteResponse._();

  factory VoiceNoteResponse([void updates(VoiceNoteResponseBuilder b)]) =
      _$VoiceNoteResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VoiceNoteResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VoiceNoteResponse> get serializer =>
      _$VoiceNoteResponseSerializer();
}

class _$VoiceNoteResponseSerializer
    implements PrimitiveSerializer<VoiceNoteResponse> {
  @override
  final Iterable<Type> types = const [VoiceNoteResponse, _$VoiceNoteResponse];

  @override
  final String wireName = r'VoiceNoteResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VoiceNoteResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.checklistItemId != null) {
      yield r'checklist_item_id';
      yield serializers.serialize(
        object.checklistItemId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'content_type';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(String),
    );
    yield r'duration_ms';
    yield serializers.serialize(
      object.durationMs,
      specifiedType: const FullType(int),
    );
    yield r'filename';
    yield serializers.serialize(
      object.filename,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'local_id';
    yield serializers.serialize(
      object.localId,
      specifiedType: const FullType(String),
    );
    yield r'size';
    yield serializers.serialize(
      object.size,
      specifiedType: const FullType(int),
    );
    yield r'uploaded_at';
    yield serializers.serialize(
      object.uploadedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'uploaded_by';
    yield serializers.serialize(
      object.uploadedBy,
      specifiedType: const FullType(String),
    );
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VoiceNoteResponse object, {
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
    required VoiceNoteResponseBuilder result,
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
        case r'content_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentType = valueDes;
          break;
        case r'duration_ms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.durationMs = valueDes;
          break;
        case r'filename':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.filename = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'local_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.localId = valueDes;
          break;
        case r'size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.size = valueDes;
          break;
        case r'uploaded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.uploadedAt = valueDes;
          break;
        case r'uploaded_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uploadedBy = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VoiceNoteResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VoiceNoteResponseBuilder();
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
