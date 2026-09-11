//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/update_digital_twin_hotspot_request.dart';
import 'package:fev_api_client/src/model/camera_preset.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_digital_twin_scene_request.g.dart';

/// UpdateDigitalTwinSceneRequest
///
/// Properties:
/// * [cameraPresets]
/// * [hotspots]
/// * [model3dUrl]
/// * [sceneType]
@BuiltValue()
abstract class UpdateDigitalTwinSceneRequest
    implements
        Built<UpdateDigitalTwinSceneRequest,
            UpdateDigitalTwinSceneRequestBuilder> {
  @BuiltValueField(wireName: r'camera_presets')
  BuiltList<CameraPreset>? get cameraPresets;

  @BuiltValueField(wireName: r'hotspots')
  BuiltList<UpdateDigitalTwinHotspotRequest>? get hotspots;

  @BuiltValueField(wireName: r'model_3d_url')
  String? get model3dUrl;

  @BuiltValueField(wireName: r'scene_type')
  String? get sceneType;

  UpdateDigitalTwinSceneRequest._();

  factory UpdateDigitalTwinSceneRequest(
          [void updates(UpdateDigitalTwinSceneRequestBuilder b)]) =
      _$UpdateDigitalTwinSceneRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateDigitalTwinSceneRequestBuilder b) =>
      b..sceneType = 'procedural_refinery';

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateDigitalTwinSceneRequest> get serializer =>
      _$UpdateDigitalTwinSceneRequestSerializer();
}

class _$UpdateDigitalTwinSceneRequestSerializer
    implements PrimitiveSerializer<UpdateDigitalTwinSceneRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateDigitalTwinSceneRequest,
    _$UpdateDigitalTwinSceneRequest
  ];

  @override
  final String wireName = r'UpdateDigitalTwinSceneRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateDigitalTwinSceneRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.cameraPresets != null) {
      yield r'camera_presets';
      yield serializers.serialize(
        object.cameraPresets,
        specifiedType:
            const FullType.nullable(BuiltList, [FullType(CameraPreset)]),
      );
    }
    if (object.hotspots != null) {
      yield r'hotspots';
      yield serializers.serialize(
        object.hotspots,
        specifiedType: const FullType.nullable(
            BuiltList, [FullType(UpdateDigitalTwinHotspotRequest)]),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateDigitalTwinSceneRequest object, {
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
    required UpdateDigitalTwinSceneRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'camera_presets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(BuiltList, [FullType(CameraPreset)]),
          ) as BuiltList<CameraPreset>?;
          if (valueDes == null) continue;
          result.cameraPresets.replace(valueDes);
          break;
        case r'hotspots':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
                BuiltList, [FullType(UpdateDigitalTwinHotspotRequest)]),
          ) as BuiltList<UpdateDigitalTwinHotspotRequest>?;
          if (valueDes == null) continue;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateDigitalTwinSceneRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateDigitalTwinSceneRequestBuilder();
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
