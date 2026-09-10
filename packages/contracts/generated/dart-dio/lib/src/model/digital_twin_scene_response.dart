//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/camera_preset.dart';
import 'package:fev_api_client/src/model/digital_twin_hotspot_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'digital_twin_scene_response.g.dart';

/// DigitalTwinSceneResponse
///
/// Properties:
/// * [cameraPresets]
/// * [facilityId]
/// * [facilityName]
/// * [hotspots]
/// * [model3dUrl]
/// * [sceneType]
/// * [updatedAt]
@BuiltValue()
abstract class DigitalTwinSceneResponse
    implements
        Built<DigitalTwinSceneResponse, DigitalTwinSceneResponseBuilder> {
  @BuiltValueField(wireName: r'camera_presets')
  BuiltList<CameraPreset>? get cameraPresets;

  @BuiltValueField(wireName: r'facility_id')
  String get facilityId;

  @BuiltValueField(wireName: r'facility_name')
  String get facilityName;

  @BuiltValueField(wireName: r'hotspots')
  BuiltList<DigitalTwinHotspotResponse>? get hotspots;

  @BuiltValueField(wireName: r'model_3d_url')
  String? get model3dUrl;

  @BuiltValueField(wireName: r'scene_type')
  String? get sceneType;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  DigitalTwinSceneResponse._();

  factory DigitalTwinSceneResponse(
          [void updates(DigitalTwinSceneResponseBuilder b)]) =
      _$DigitalTwinSceneResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DigitalTwinSceneResponseBuilder b) =>
      b..sceneType = 'procedural_refinery';

  @BuiltValueSerializer(custom: true)
  static Serializer<DigitalTwinSceneResponse> get serializer =>
      _$DigitalTwinSceneResponseSerializer();
}

class _$DigitalTwinSceneResponseSerializer
    implements PrimitiveSerializer<DigitalTwinSceneResponse> {
  @override
  final Iterable<Type> types = const [
    DigitalTwinSceneResponse,
    _$DigitalTwinSceneResponse
  ];

  @override
  final String wireName = r'DigitalTwinSceneResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DigitalTwinSceneResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.cameraPresets != null) {
      yield r'camera_presets';
      yield serializers.serialize(
        object.cameraPresets,
        specifiedType: const FullType(BuiltList, [FullType(CameraPreset)]),
      );
    }
    yield r'facility_id';
    yield serializers.serialize(
      object.facilityId,
      specifiedType: const FullType(String),
    );
    yield r'facility_name';
    yield serializers.serialize(
      object.facilityName,
      specifiedType: const FullType(String),
    );
    if (object.hotspots != null) {
      yield r'hotspots';
      yield serializers.serialize(
        object.hotspots,
        specifiedType:
            const FullType(BuiltList, [FullType(DigitalTwinHotspotResponse)]),
      );
    }
    if (object.model3dUrl != null) {
      yield r'model_3d_url';
      yield serializers.serialize(
        object.model3dUrl,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.sceneType != null) {
      yield r'scene_type';
      yield serializers.serialize(
        object.sceneType,
        specifiedType: const FullType(String),
      );
    }
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DigitalTwinSceneResponse object, {
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
    required DigitalTwinSceneResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'camera_presets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CameraPreset)]),
          ) as BuiltList<CameraPreset>;
          result.cameraPresets.replace(valueDes);
          break;
        case r'facility_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.facilityId = valueDes;
          break;
        case r'facility_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.facilityName = valueDes;
          break;
        case r'hotspots':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(DigitalTwinHotspotResponse)]),
          ) as BuiltList<DigitalTwinHotspotResponse>;
          result.hotspots.replace(valueDes);
          break;
        case r'model_3d_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.model3dUrl = valueDes;
          break;
        case r'scene_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sceneType = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DigitalTwinSceneResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DigitalTwinSceneResponseBuilder();
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
