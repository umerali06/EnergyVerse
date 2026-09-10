//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permit_worker_acknowledgement_response.g.dart';

/// PermitWorkerAcknowledgementResponse
///
/// Properties:
/// * [clientMutationId]
/// * [clientSignedAt]
/// * [deviceId]
/// * [meaning]
/// * [receivedAt]
/// * [signedAt]
/// * [workerId]
@BuiltValue()
abstract class PermitWorkerAcknowledgementResponse
    implements
        Built<PermitWorkerAcknowledgementResponse,
            PermitWorkerAcknowledgementResponseBuilder> {
  @BuiltValueField(wireName: r'client_mutation_id')
  String get clientMutationId;

  @BuiltValueField(wireName: r'client_signed_at')
  DateTime get clientSignedAt;

  @BuiltValueField(wireName: r'device_id')
  String? get deviceId;

  @BuiltValueField(wireName: r'meaning')
  String get meaning;

  @BuiltValueField(wireName: r'received_at')
  DateTime get receivedAt;

  @BuiltValueField(wireName: r'signed_at')
  DateTime get signedAt;

  @BuiltValueField(wireName: r'worker_id')
  String get workerId;

  PermitWorkerAcknowledgementResponse._();

  factory PermitWorkerAcknowledgementResponse(
          [void updates(PermitWorkerAcknowledgementResponseBuilder b)]) =
      _$PermitWorkerAcknowledgementResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PermitWorkerAcknowledgementResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PermitWorkerAcknowledgementResponse> get serializer =>
      _$PermitWorkerAcknowledgementResponseSerializer();
}

class _$PermitWorkerAcknowledgementResponseSerializer
    implements PrimitiveSerializer<PermitWorkerAcknowledgementResponse> {
  @override
  final Iterable<Type> types = const [
    PermitWorkerAcknowledgementResponse,
    _$PermitWorkerAcknowledgementResponse
  ];

  @override
  final String wireName = r'PermitWorkerAcknowledgementResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PermitWorkerAcknowledgementResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'client_mutation_id';
    yield serializers.serialize(
      object.clientMutationId,
      specifiedType: const FullType(String),
    );
    yield r'client_signed_at';
    yield serializers.serialize(
      object.clientSignedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.deviceId != null) {
      yield r'device_id';
      yield serializers.serialize(
        object.deviceId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'meaning';
    yield serializers.serialize(
      object.meaning,
      specifiedType: const FullType(String),
    );
    yield r'received_at';
    yield serializers.serialize(
      object.receivedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'signed_at';
    yield serializers.serialize(
      object.signedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'worker_id';
    yield serializers.serialize(
      object.workerId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PermitWorkerAcknowledgementResponse object, {
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
    required PermitWorkerAcknowledgementResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'client_mutation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientMutationId = valueDes;
          break;
        case r'client_signed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.clientSignedAt = valueDes;
          break;
        case r'device_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.deviceId = valueDes;
          break;
        case r'meaning':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.meaning = valueDes;
          break;
        case r'received_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.receivedAt = valueDes;
          break;
        case r'signed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.signedAt = valueDes;
          break;
        case r'worker_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.workerId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PermitWorkerAcknowledgementResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PermitWorkerAcknowledgementResponseBuilder();
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
