//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_company_status_request.g.dart';

/// UpdateCompanyStatusRequest
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class UpdateCompanyStatusRequest
    implements
        Built<UpdateCompanyStatusRequest, UpdateCompanyStatusRequestBuilder> {
  @BuiltValueField(wireName: r'status')
  UpdateCompanyStatusRequestStatusEnum get status;
  // enum statusEnum {  active,  suspended,  };

  UpdateCompanyStatusRequest._();

  factory UpdateCompanyStatusRequest(
          [void updates(UpdateCompanyStatusRequestBuilder b)]) =
      _$UpdateCompanyStatusRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateCompanyStatusRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateCompanyStatusRequest> get serializer =>
      _$UpdateCompanyStatusRequestSerializer();
}

class _$UpdateCompanyStatusRequestSerializer
    implements PrimitiveSerializer<UpdateCompanyStatusRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateCompanyStatusRequest,
    _$UpdateCompanyStatusRequest
  ];

  @override
  final String wireName = r'UpdateCompanyStatusRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateCompanyStatusRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(UpdateCompanyStatusRequestStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateCompanyStatusRequest object, {
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
    required UpdateCompanyStatusRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UpdateCompanyStatusRequestStatusEnum),
          ) as UpdateCompanyStatusRequestStatusEnum;
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
  UpdateCompanyStatusRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateCompanyStatusRequestBuilder();
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

class UpdateCompanyStatusRequestStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const UpdateCompanyStatusRequestStatusEnum active =
      _$updateCompanyStatusRequestStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const UpdateCompanyStatusRequestStatusEnum suspended =
      _$updateCompanyStatusRequestStatusEnum_suspended;

  static Serializer<UpdateCompanyStatusRequestStatusEnum> get serializer =>
      _$updateCompanyStatusRequestStatusEnumSerializer;

  const UpdateCompanyStatusRequestStatusEnum._(String name) : super(name);

  static BuiltSet<UpdateCompanyStatusRequestStatusEnum> get values =>
      _$updateCompanyStatusRequestStatusEnumValues;
  static UpdateCompanyStatusRequestStatusEnum valueOf(String name) =>
      _$updateCompanyStatusRequestStatusEnumValueOf(name);
}
