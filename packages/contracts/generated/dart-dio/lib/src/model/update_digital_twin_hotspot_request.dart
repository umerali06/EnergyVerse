//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_digital_twin_hotspot_request.g.dart';

/// UpdateDigitalTwinHotspotRequest
///
/// Properties:
/// * [assetId]
/// * [id]
/// * [label]
/// * [position]
/// * [radius]
@BuiltValue()
abstract class UpdateDigitalTwinHotspotRequest
    implements
        Built<UpdateDigitalTwinHotspotRequest,
            UpdateDigitalTwinHotspotRequestBuilder> {
  @BuiltValueField(wireName: r'asset_id')
  String get assetId;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'position')
  BuiltList<num> get position;

  @BuiltValueField(wireName: r'radius')
  num? get radius;

  UpdateDigitalTwinHotspotRequest._();

  factory UpdateDigitalTwinHotspotRequest(
          [void updates(UpdateDigitalTwinHotspotRequestBuilder b)]) =
      _$UpdateDigitalTwinHotspotRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateDigitalTwinHotspotRequestBuilder b) =>
      b..radius = 1.0;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateDigitalTwinHotspotRequest> get serializer =>
      _$UpdateDigitalTwinHotspotRequestSerializer();
}

class _$UpdateDigitalTwinHotspotRequestSerializer
    implements PrimitiveSerializer<UpdateDigitalTwinHotspotRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateDigitalTwinHotspotRequest,
    _$UpdateDigitalTwinHotspotRequest
  ];

  @override
  final String wireName = r'UpdateDigitalTwinHotspotRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateDigitalTwinHotspotRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'asset_id';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.label != null) {
      yield r'label';
      yield serializers.serialize(
        object.label,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'position';
    yield serializers.serialize(
      object.position,
      specifiedType: const FullType(BuiltList, [FullType(num)]),
    );
    if (object.radius != null) {
      yield r'radius';
      yield serializers.serialize(
        object.radius,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateDigitalTwinHotspotRequest object, {
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
    required UpdateDigitalTwinHotspotRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'asset_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assetId = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        case r'position':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(num)]),
          ) as BuiltList<num>;
          result.position.replace(valueDes);
          break;
        case r'radius':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.radius = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateDigitalTwinHotspotRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateDigitalTwinHotspotRequestBuilder();
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
