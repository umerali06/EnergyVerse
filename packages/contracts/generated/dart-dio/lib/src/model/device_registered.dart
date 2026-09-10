//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'device_registered.g.dart';

/// DeviceRegistered
///
/// Properties:
/// * [registered]
@BuiltValue()
abstract class DeviceRegistered
    implements Built<DeviceRegistered, DeviceRegisteredBuilder> {
  @BuiltValueField(wireName: r'registered')
  bool get registered;

  DeviceRegistered._();

  factory DeviceRegistered([void updates(DeviceRegisteredBuilder b)]) =
      _$DeviceRegistered;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeviceRegisteredBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeviceRegistered> get serializer =>
      _$DeviceRegisteredSerializer();
}

class _$DeviceRegisteredSerializer
    implements PrimitiveSerializer<DeviceRegistered> {
  @override
  final Iterable<Type> types = const [DeviceRegistered, _$DeviceRegistered];

  @override
  final String wireName = r'DeviceRegistered';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeviceRegistered object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'registered';
    yield serializers.serialize(
      object.registered,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeviceRegistered object, {
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
    required DeviceRegisteredBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'registered':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.registered = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeviceRegistered deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeviceRegisteredBuilder();
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
