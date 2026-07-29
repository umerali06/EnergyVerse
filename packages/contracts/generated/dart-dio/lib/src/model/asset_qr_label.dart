//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_qr_label.g.dart';

/// Printable label payload -- the frontend renders the QR image itself (client-side, from `url`) rather than the backend generating pixels.
///
/// Properties:
/// * [assetTag]
/// * [name]
/// * [qrCodeId]
/// * [url]
@BuiltValue()
abstract class AssetQrLabel
    implements Built<AssetQrLabel, AssetQrLabelBuilder> {
  @BuiltValueField(wireName: r'asset_tag')
  String get assetTag;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'qr_code_id')
  String? get qrCodeId;

  @BuiltValueField(wireName: r'url')
  String? get url;

  AssetQrLabel._();

  factory AssetQrLabel([void updates(AssetQrLabelBuilder b)]) = _$AssetQrLabel;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetQrLabelBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetQrLabel> get serializer => _$AssetQrLabelSerializer();
}

class _$AssetQrLabelSerializer implements PrimitiveSerializer<AssetQrLabel> {
  @override
  final Iterable<Type> types = const [AssetQrLabel, _$AssetQrLabel];

  @override
  final String wireName = r'AssetQrLabel';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetQrLabel object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'asset_tag';
    yield serializers.serialize(
      object.assetTag,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.qrCodeId != null) {
      yield r'qr_code_id';
      yield serializers.serialize(
        object.qrCodeId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.url != null) {
      yield r'url';
      yield serializers.serialize(
        object.url,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetQrLabel object, {
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
    required AssetQrLabelBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'asset_tag':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assetTag = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'qr_code_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.qrCodeId = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  AssetQrLabel deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetQrLabelBuilder();
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
