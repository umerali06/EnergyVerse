//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_corrective_action_request.g.dart';

/// UpdateCorrectiveActionRequest
///
/// Properties:
/// * [completionNotes]
/// * [status]
@BuiltValue()
abstract class UpdateCorrectiveActionRequest
    implements
        Built<UpdateCorrectiveActionRequest,
            UpdateCorrectiveActionRequestBuilder> {
  @BuiltValueField(wireName: r'completion_notes')
  String? get completionNotes;

  @BuiltValueField(wireName: r'status')
  UpdateCorrectiveActionRequestStatusEnum get status;
  // enum statusEnum {  in_progress,  completed,  };

  UpdateCorrectiveActionRequest._();

  factory UpdateCorrectiveActionRequest(
          [void updates(UpdateCorrectiveActionRequestBuilder b)]) =
      _$UpdateCorrectiveActionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateCorrectiveActionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateCorrectiveActionRequest> get serializer =>
      _$UpdateCorrectiveActionRequestSerializer();
}

class _$UpdateCorrectiveActionRequestSerializer
    implements PrimitiveSerializer<UpdateCorrectiveActionRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateCorrectiveActionRequest,
    _$UpdateCorrectiveActionRequest
  ];

  @override
  final String wireName = r'UpdateCorrectiveActionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateCorrectiveActionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.completionNotes != null) {
      yield r'completion_notes';
      yield serializers.serialize(
        object.completionNotes,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(UpdateCorrectiveActionRequestStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateCorrectiveActionRequest object, {
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
    required UpdateCorrectiveActionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'completion_notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.completionNotes = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(UpdateCorrectiveActionRequestStatusEnum),
          ) as UpdateCorrectiveActionRequestStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateCorrectiveActionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateCorrectiveActionRequestBuilder();
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

class UpdateCorrectiveActionRequestStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const UpdateCorrectiveActionRequestStatusEnum inProgress =
      _$updateCorrectiveActionRequestStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'completed')
  static const UpdateCorrectiveActionRequestStatusEnum completed =
      _$updateCorrectiveActionRequestStatusEnum_completed;

  static Serializer<UpdateCorrectiveActionRequestStatusEnum> get serializer =>
      _$updateCorrectiveActionRequestStatusEnumSerializer;

  const UpdateCorrectiveActionRequestStatusEnum._(String name) : super(name);

  static BuiltSet<UpdateCorrectiveActionRequestStatusEnum> get values =>
      _$updateCorrectiveActionRequestStatusEnumValues;
  static UpdateCorrectiveActionRequestStatusEnum valueOf(String name) =>
      _$updateCorrectiveActionRequestStatusEnumValueOf(name);
}
