//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_platform_company_request.g.dart';

/// UpdatePlatformCompanyRequest
///
/// Properties:
/// * [subscriptionTier]
@BuiltValue()
abstract class UpdatePlatformCompanyRequest
    implements
        Built<UpdatePlatformCompanyRequest,
            UpdatePlatformCompanyRequestBuilder> {
  @BuiltValueField(wireName: r'subscription_tier')
  UpdatePlatformCompanyRequestSubscriptionTierEnum get subscriptionTier;
  // enum subscriptionTierEnum {  demo,  starter,  professional,  enterprise,  };

  UpdatePlatformCompanyRequest._();

  factory UpdatePlatformCompanyRequest(
          [void updates(UpdatePlatformCompanyRequestBuilder b)]) =
      _$UpdatePlatformCompanyRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdatePlatformCompanyRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdatePlatformCompanyRequest> get serializer =>
      _$UpdatePlatformCompanyRequestSerializer();
}

class _$UpdatePlatformCompanyRequestSerializer
    implements PrimitiveSerializer<UpdatePlatformCompanyRequest> {
  @override
  final Iterable<Type> types = const [
    UpdatePlatformCompanyRequest,
    _$UpdatePlatformCompanyRequest
  ];

  @override
  final String wireName = r'UpdatePlatformCompanyRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdatePlatformCompanyRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'subscription_tier';
    yield serializers.serialize(
      object.subscriptionTier,
      specifiedType:
          const FullType(UpdatePlatformCompanyRequestSubscriptionTierEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdatePlatformCompanyRequest object, {
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
    required UpdatePlatformCompanyRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'subscription_tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                UpdatePlatformCompanyRequestSubscriptionTierEnum),
          ) as UpdatePlatformCompanyRequestSubscriptionTierEnum;
          result.subscriptionTier = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdatePlatformCompanyRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdatePlatformCompanyRequestBuilder();
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

class UpdatePlatformCompanyRequestSubscriptionTierEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'demo')
  static const UpdatePlatformCompanyRequestSubscriptionTierEnum demo =
      _$updatePlatformCompanyRequestSubscriptionTierEnum_demo;
  @BuiltValueEnumConst(wireName: r'starter')
  static const UpdatePlatformCompanyRequestSubscriptionTierEnum starter =
      _$updatePlatformCompanyRequestSubscriptionTierEnum_starter;
  @BuiltValueEnumConst(wireName: r'professional')
  static const UpdatePlatformCompanyRequestSubscriptionTierEnum professional =
      _$updatePlatformCompanyRequestSubscriptionTierEnum_professional;
  @BuiltValueEnumConst(wireName: r'enterprise')
  static const UpdatePlatformCompanyRequestSubscriptionTierEnum enterprise =
      _$updatePlatformCompanyRequestSubscriptionTierEnum_enterprise;

  static Serializer<UpdatePlatformCompanyRequestSubscriptionTierEnum>
      get serializer =>
          _$updatePlatformCompanyRequestSubscriptionTierEnumSerializer;

  const UpdatePlatformCompanyRequestSubscriptionTierEnum._(String name)
      : super(name);

  static BuiltSet<UpdatePlatformCompanyRequestSubscriptionTierEnum>
      get values => _$updatePlatformCompanyRequestSubscriptionTierEnumValues;
  static UpdatePlatformCompanyRequestSubscriptionTierEnum valueOf(
          String name) =>
      _$updatePlatformCompanyRequestSubscriptionTierEnumValueOf(name);
}
