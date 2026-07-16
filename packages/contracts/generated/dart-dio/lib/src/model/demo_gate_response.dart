//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'demo_gate_response.g.dart';

/// DemoGateResponse
///
/// Properties:
/// * [ok]
@BuiltValue()
abstract class DemoGateResponse
    implements Built<DemoGateResponse, DemoGateResponseBuilder> {
  @BuiltValueField(wireName: r'ok')
  DemoGateResponseOkEnum get ok;
  // enum okEnum {  true,  };

  DemoGateResponse._();

  factory DemoGateResponse([void updates(DemoGateResponseBuilder b)]) =
      _$DemoGateResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DemoGateResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DemoGateResponse> get serializer =>
      _$DemoGateResponseSerializer();
}

class _$DemoGateResponseSerializer
    implements PrimitiveSerializer<DemoGateResponse> {
  @override
  final Iterable<Type> types = const [DemoGateResponse, _$DemoGateResponse];

  @override
  final String wireName = r'DemoGateResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DemoGateResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ok';
    yield serializers.serialize(
      object.ok,
      specifiedType: const FullType(DemoGateResponseOkEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DemoGateResponse object, {
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
    required DemoGateResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ok':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DemoGateResponseOkEnum),
          ) as DemoGateResponseOkEnum;
          result.ok = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DemoGateResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DemoGateResponseBuilder();
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

class DemoGateResponseOkEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'true')
  static const DemoGateResponseOkEnum true_ = _$demoGateResponseOkEnum_true_;

  static Serializer<DemoGateResponseOkEnum> get serializer =>
      _$demoGateResponseOkEnumSerializer;

  const DemoGateResponseOkEnum._(String name) : super(name);

  static BuiltSet<DemoGateResponseOkEnum> get values =>
      _$demoGateResponseOkEnumValues;
  static DemoGateResponseOkEnum valueOf(String name) =>
      _$demoGateResponseOkEnumValueOf(name);
}
