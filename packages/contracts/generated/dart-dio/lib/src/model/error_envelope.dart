//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'error_envelope.g.dart';

/// Stable error contract returned by every API failure.
///
/// Properties:
/// * [details]
/// * [error] - Stable machine-readable error code
/// * [message] - Human-readable error summary
/// * [requestId] - Request correlation identifier
@BuiltValue()
abstract class ErrorEnvelope
    implements Built<ErrorEnvelope, ErrorEnvelopeBuilder> {
  @BuiltValueField(wireName: r'details')
  BuiltMap<String, JsonObject?>? get details;

  /// Stable machine-readable error code
  @BuiltValueField(wireName: r'error')
  String get error;

  /// Human-readable error summary
  @BuiltValueField(wireName: r'message')
  String get message;

  /// Request correlation identifier
  @BuiltValueField(wireName: r'request_id')
  String get requestId;

  ErrorEnvelope._();

  factory ErrorEnvelope([void updates(ErrorEnvelopeBuilder b)]) =
      _$ErrorEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ErrorEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ErrorEnvelope> get serializer =>
      _$ErrorEnvelopeSerializer();
}

class _$ErrorEnvelopeSerializer implements PrimitiveSerializer<ErrorEnvelope> {
  @override
  final Iterable<Type> types = const [ErrorEnvelope, _$ErrorEnvelope];

  @override
  final String wireName = r'ErrorEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ErrorEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.details != null) {
      yield r'details';
      yield serializers.serialize(
        object.details,
        specifiedType: const FullType.nullable(
            BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    yield r'error';
    yield serializers.serialize(
      object.error,
      specifiedType: const FullType(String),
    );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
    yield r'request_id';
    yield serializers.serialize(
      object.requestId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ErrorEnvelope object, {
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
    required ErrorEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.details.replace(valueDes);
          break;
        case r'error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.error = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'request_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.requestId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ErrorEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ErrorEnvelopeBuilder();
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
