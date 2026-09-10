//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'digital_twin_hotspot_response.g.dart';

/// DigitalTwinHotspotResponse
///
/// Properties:
/// * [assetId]
/// * [assetName]
/// * [assetTag]
/// * [category]
/// * [currentStatus]
/// * [id]
/// * [label]
/// * [position]
/// * [radius]
@BuiltValue()
abstract class DigitalTwinHotspotResponse
    implements
        Built<DigitalTwinHotspotResponse, DigitalTwinHotspotResponseBuilder> {
  @BuiltValueField(wireName: r'asset_id')
  String get assetId;

  @BuiltValueField(wireName: r'asset_name')
  String get assetName;

  @BuiltValueField(wireName: r'asset_tag')
  String get assetTag;

  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'current_status')
  DigitalTwinHotspotResponseCurrentStatusEnum get currentStatus;
  // enum currentStatusEnum {  Healthy,  Warning,  Critical,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'position')
  BuiltList<num> get position;

  @BuiltValueField(wireName: r'radius')
  num? get radius;

  DigitalTwinHotspotResponse._();

  factory DigitalTwinHotspotResponse(
          [void updates(DigitalTwinHotspotResponseBuilder b)]) =
      _$DigitalTwinHotspotResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DigitalTwinHotspotResponseBuilder b) => b..radius = 1.0;

  @BuiltValueSerializer(custom: true)
  static Serializer<DigitalTwinHotspotResponse> get serializer =>
      _$DigitalTwinHotspotResponseSerializer();
}

class _$DigitalTwinHotspotResponseSerializer
    implements PrimitiveSerializer<DigitalTwinHotspotResponse> {
  @override
  final Iterable<Type> types = const [
    DigitalTwinHotspotResponse,
    _$DigitalTwinHotspotResponse
  ];

  @override
  final String wireName = r'DigitalTwinHotspotResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DigitalTwinHotspotResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'asset_id';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    yield r'asset_name';
    yield serializers.serialize(
      object.assetName,
      specifiedType: const FullType(String),
    );
    yield r'asset_tag';
    yield serializers.serialize(
      object.assetTag,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    yield r'current_status';
    yield serializers.serialize(
      object.currentStatus,
      specifiedType:
          const FullType(DigitalTwinHotspotResponseCurrentStatusEnum),
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
    DigitalTwinHotspotResponse object, {
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
    required DigitalTwinHotspotResponseBuilder result,
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
        case r'asset_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assetName = valueDes;
          break;
        case r'asset_tag':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assetTag = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'current_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(DigitalTwinHotspotResponseCurrentStatusEnum),
          ) as DigitalTwinHotspotResponseCurrentStatusEnum;
          result.currentStatus = valueDes;
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
  DigitalTwinHotspotResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DigitalTwinHotspotResponseBuilder();
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

class DigitalTwinHotspotResponseCurrentStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'Healthy')
  static const DigitalTwinHotspotResponseCurrentStatusEnum healthy =
      _$digitalTwinHotspotResponseCurrentStatusEnum_healthy;
  @BuiltValueEnumConst(wireName: r'Warning')
  static const DigitalTwinHotspotResponseCurrentStatusEnum warning =
      _$digitalTwinHotspotResponseCurrentStatusEnum_warning;
  @BuiltValueEnumConst(wireName: r'Critical')
  static const DigitalTwinHotspotResponseCurrentStatusEnum critical =
      _$digitalTwinHotspotResponseCurrentStatusEnum_critical;

  static Serializer<DigitalTwinHotspotResponseCurrentStatusEnum>
      get serializer => _$digitalTwinHotspotResponseCurrentStatusEnumSerializer;

  const DigitalTwinHotspotResponseCurrentStatusEnum._(String name)
      : super(name);

  static BuiltSet<DigitalTwinHotspotResponseCurrentStatusEnum> get values =>
      _$digitalTwinHotspotResponseCurrentStatusEnumValues;
  static DigitalTwinHotspotResponseCurrentStatusEnum valueOf(String name) =>
      _$digitalTwinHotspotResponseCurrentStatusEnumValueOf(name);
}
