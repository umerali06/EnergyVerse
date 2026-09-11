//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'safety_evidence_response.g.dart';

/// SafetyEvidenceResponse
///
/// Properties:
/// * [contentType]
/// * [filename]
/// * [id]
/// * [kind]
/// * [size]
/// * [uploadedAt]
/// * [uploadedBy]
/// * [url]
@BuiltValue()
abstract class SafetyEvidenceResponse
    implements Built<SafetyEvidenceResponse, SafetyEvidenceResponseBuilder> {
  @BuiltValueField(wireName: r'content_type')
  String get contentType;

  @BuiltValueField(wireName: r'filename')
  String get filename;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  SafetyEvidenceResponseKindEnum get kind;
  // enum kindEnum {  photo,  video,  };

  @BuiltValueField(wireName: r'size')
  int get size;

  @BuiltValueField(wireName: r'uploaded_at')
  DateTime get uploadedAt;

  @BuiltValueField(wireName: r'uploaded_by')
  String get uploadedBy;

  @BuiltValueField(wireName: r'url')
  String get url;

  SafetyEvidenceResponse._();

  factory SafetyEvidenceResponse(
          [void updates(SafetyEvidenceResponseBuilder b)]) =
      _$SafetyEvidenceResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SafetyEvidenceResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SafetyEvidenceResponse> get serializer =>
      _$SafetyEvidenceResponseSerializer();
}

class _$SafetyEvidenceResponseSerializer
    implements PrimitiveSerializer<SafetyEvidenceResponse> {
  @override
  final Iterable<Type> types = const [
    SafetyEvidenceResponse,
    _$SafetyEvidenceResponse
  ];

  @override
  final String wireName = r'SafetyEvidenceResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SafetyEvidenceResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'content_type';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(String),
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
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(SafetyEvidenceResponseKindEnum),
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
    SafetyEvidenceResponse object, {
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
    required SafetyEvidenceResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'content_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentType = valueDes;
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
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SafetyEvidenceResponseKindEnum),
          ) as SafetyEvidenceResponseKindEnum;
          result.kind = valueDes;
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
  SafetyEvidenceResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SafetyEvidenceResponseBuilder();
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

class SafetyEvidenceResponseKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'photo')
  static const SafetyEvidenceResponseKindEnum photo =
      _$safetyEvidenceResponseKindEnum_photo;
  @BuiltValueEnumConst(wireName: r'video')
  static const SafetyEvidenceResponseKindEnum video =
      _$safetyEvidenceResponseKindEnum_video;

  static Serializer<SafetyEvidenceResponseKindEnum> get serializer =>
      _$safetyEvidenceResponseKindEnumSerializer;

  const SafetyEvidenceResponseKindEnum._(String name) : super(name);

  static BuiltSet<SafetyEvidenceResponseKindEnum> get values =>
      _$safetyEvidenceResponseKindEnumValues;
  static SafetyEvidenceResponseKindEnum valueOf(String name) =>
      _$safetyEvidenceResponseKindEnumValueOf(name);
}
