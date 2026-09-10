//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'device_unregistered.g.dart';

/// DeviceUnregistered
///
/// Properties:
/// * [unregistered]
@BuiltValue()
abstract class DeviceUnregistered
    implements Built<DeviceUnregistered, DeviceUnregisteredBuilder> {
  @BuiltValueField(wireName: r'unregistered')
  bool get unregistered;

  DeviceUnregistered._();

  factory DeviceUnregistered([void updates(DeviceUnregisteredBuilder b)]) =
      _$DeviceUnregistered;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeviceUnregisteredBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeviceUnregistered> get serializer =>
      _$DeviceUnregisteredSerializer();
}

class _$DeviceUnregisteredSerializer
    implements PrimitiveSerializer<DeviceUnregistered> {
  @override
  final Iterable<Type> types = const [DeviceUnregistered, _$DeviceUnregistered];

  @override
  final String wireName = r'DeviceUnregistered';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeviceUnregistered object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'unregistered';
    yield serializers.serialize(
      object.unregistered,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeviceUnregistered object, {
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
    required DeviceUnregisteredBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'unregistered':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.unregistered = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeviceUnregistered deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeviceUnregisteredBuilder();
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
