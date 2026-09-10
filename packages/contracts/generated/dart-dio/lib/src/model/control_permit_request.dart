//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'control_permit_request.g.dart';

/// ControlPermitRequest
///
/// Properties:
/// * [expectedRevision]
/// * [reason]
@BuiltValue()
abstract class ControlPermitRequest
    implements Built<ControlPermitRequest, ControlPermitRequestBuilder> {
  @BuiltValueField(wireName: r'expected_revision')
  int get expectedRevision;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  ControlPermitRequest._();

  factory ControlPermitRequest([void updates(ControlPermitRequestBuilder b)]) =
      _$ControlPermitRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ControlPermitRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ControlPermitRequest> get serializer =>
      _$ControlPermitRequestSerializer();
}

class _$ControlPermitRequestSerializer
    implements PrimitiveSerializer<ControlPermitRequest> {
  @override
  final Iterable<Type> types = const [
    ControlPermitRequest,
    _$ControlPermitRequest
  ];

  @override
  final String wireName = r'ControlPermitRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ControlPermitRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expected_revision';
    yield serializers.serialize(
      object.expectedRevision,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ControlPermitRequest object, {
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
    required ControlPermitRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'expected_revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expectedRevision = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ControlPermitRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ControlPermitRequestBuilder();
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
