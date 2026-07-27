//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_media_response.g.dart';

/// AssetMediaResponse
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
abstract class AssetMediaResponse
    implements Built<AssetMediaResponse, AssetMediaResponseBuilder> {
  @BuiltValueField(wireName: r'content_type')
  String get contentType;

  @BuiltValueField(wireName: r'filename')
  String get filename;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  AssetMediaResponseKindEnum get kind;
  // enum kindEnum {  photo,  document,  manual,  };

  @BuiltValueField(wireName: r'size')
  int get size;

  @BuiltValueField(wireName: r'uploaded_at')
  DateTime get uploadedAt;

  @BuiltValueField(wireName: r'uploaded_by')
  String get uploadedBy;

  @BuiltValueField(wireName: r'url')
  String get url;

  AssetMediaResponse._();

  factory AssetMediaResponse([void updates(AssetMediaResponseBuilder b)]) =
      _$AssetMediaResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetMediaResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetMediaResponse> get serializer =>
      _$AssetMediaResponseSerializer();
}

class _$AssetMediaResponseSerializer
    implements PrimitiveSerializer<AssetMediaResponse> {
  @override
  final Iterable<Type> types = const [AssetMediaResponse, _$AssetMediaResponse];

  @override
  final String wireName = r'AssetMediaResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetMediaResponse object, {
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
      specifiedType: const FullType(AssetMediaResponseKindEnum),
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
    AssetMediaResponse object, {
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
    required AssetMediaResponseBuilder result,
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
            specifiedType: const FullType(AssetMediaResponseKindEnum),
          ) as AssetMediaResponseKindEnum;
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
  AssetMediaResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetMediaResponseBuilder();
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

class AssetMediaResponseKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'photo')
  static const AssetMediaResponseKindEnum photo =
      _$assetMediaResponseKindEnum_photo;
  @BuiltValueEnumConst(wireName: r'document')
  static const AssetMediaResponseKindEnum document =
      _$assetMediaResponseKindEnum_document;
  @BuiltValueEnumConst(wireName: r'manual')
  static const AssetMediaResponseKindEnum manual =
      _$assetMediaResponseKindEnum_manual;

  static Serializer<AssetMediaResponseKindEnum> get serializer =>
      _$assetMediaResponseKindEnumSerializer;

  const AssetMediaResponseKindEnum._(String name) : super(name);

  static BuiltSet<AssetMediaResponseKindEnum> get values =>
      _$assetMediaResponseKindEnumValues;
  static AssetMediaResponseKindEnum valueOf(String name) =>
      _$assetMediaResponseKindEnumValueOf(name);
}
