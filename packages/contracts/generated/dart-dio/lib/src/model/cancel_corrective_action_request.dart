//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cancel_corrective_action_request.g.dart';

/// CancelCorrectiveActionRequest
///
/// Properties:
/// * [reason]
@BuiltValue()
abstract class CancelCorrectiveActionRequest
    implements
        Built<CancelCorrectiveActionRequest,
            CancelCorrectiveActionRequestBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  CancelCorrectiveActionRequest._();

  factory CancelCorrectiveActionRequest(
          [void updates(CancelCorrectiveActionRequestBuilder b)]) =
      _$CancelCorrectiveActionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CancelCorrectiveActionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CancelCorrectiveActionRequest> get serializer =>
      _$CancelCorrectiveActionRequestSerializer();
}

class _$CancelCorrectiveActionRequestSerializer
    implements PrimitiveSerializer<CancelCorrectiveActionRequest> {
  @override
  final Iterable<Type> types = const [
    CancelCorrectiveActionRequest,
    _$CancelCorrectiveActionRequest
  ];

  @override
  final String wireName = r'CancelCorrectiveActionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CancelCorrectiveActionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CancelCorrectiveActionRequest object, {
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
    required CancelCorrectiveActionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  CancelCorrectiveActionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CancelCorrectiveActionRequestBuilder();
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
