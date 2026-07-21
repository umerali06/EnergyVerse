//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_user_status_request.g.dart';

/// UpdateUserStatusRequest
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class UpdateUserStatusRequest
    implements Built<UpdateUserStatusRequest, UpdateUserStatusRequestBuilder> {
  @BuiltValueField(wireName: r'status')
  UpdateUserStatusRequestStatusEnum get status;
  // enum statusEnum {  active,  inactive,  };

  UpdateUserStatusRequest._();

  factory UpdateUserStatusRequest(
          [void updates(UpdateUserStatusRequestBuilder b)]) =
      _$UpdateUserStatusRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateUserStatusRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateUserStatusRequest> get serializer =>
      _$UpdateUserStatusRequestSerializer();
}

class _$UpdateUserStatusRequestSerializer
    implements PrimitiveSerializer<UpdateUserStatusRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateUserStatusRequest,
    _$UpdateUserStatusRequest
  ];

  @override
  final String wireName = r'UpdateUserStatusRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateUserStatusRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(UpdateUserStatusRequestStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateUserStatusRequest object, {
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
    required UpdateUserStatusRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UpdateUserStatusRequestStatusEnum),
          ) as UpdateUserStatusRequestStatusEnum;
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
  UpdateUserStatusRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateUserStatusRequestBuilder();
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

class UpdateUserStatusRequestStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const UpdateUserStatusRequestStatusEnum active =
      _$updateUserStatusRequestStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'inactive')
  static const UpdateUserStatusRequestStatusEnum inactive =
      _$updateUserStatusRequestStatusEnum_inactive;

  static Serializer<UpdateUserStatusRequestStatusEnum> get serializer =>
      _$updateUserStatusRequestStatusEnumSerializer;

  const UpdateUserStatusRequestStatusEnum._(String name) : super(name);

  static BuiltSet<UpdateUserStatusRequestStatusEnum> get values =>
      _$updateUserStatusRequestStatusEnumValues;
  static UpdateUserStatusRequestStatusEnum valueOf(String name) =>
      _$updateUserStatusRequestStatusEnumValueOf(name);
}
