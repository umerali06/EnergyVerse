//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fev_api_client/src/model/billing_plan_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'billing_catalog_response.g.dart';

/// BillingCatalogResponse
///
/// Properties:
/// * [plans]
/// * [trialDays]
@BuiltValue()
abstract class BillingCatalogResponse
    implements Built<BillingCatalogResponse, BillingCatalogResponseBuilder> {
  @BuiltValueField(wireName: r'plans')
  BuiltList<BillingPlanResponse> get plans;

  @BuiltValueField(wireName: r'trial_days')
  int get trialDays;

  BillingCatalogResponse._();

  factory BillingCatalogResponse(
          [void updates(BillingCatalogResponseBuilder b)]) =
      _$BillingCatalogResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BillingCatalogResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BillingCatalogResponse> get serializer =>
      _$BillingCatalogResponseSerializer();
}

class _$BillingCatalogResponseSerializer
    implements PrimitiveSerializer<BillingCatalogResponse> {
  @override
  final Iterable<Type> types = const [
    BillingCatalogResponse,
    _$BillingCatalogResponse
  ];

  @override
  final String wireName = r'BillingCatalogResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BillingCatalogResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'plans';
    yield serializers.serialize(
      object.plans,
      specifiedType: const FullType(BuiltList, [FullType(BillingPlanResponse)]),
    );
    yield r'trial_days';
    yield serializers.serialize(
      object.trialDays,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BillingCatalogResponse object, {
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
    required BillingCatalogResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'plans':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(BillingPlanResponse)]),
          ) as BuiltList<BillingPlanResponse>;
          result.plans.replace(valueDes);
          break;
        case r'trial_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.trialDays = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BillingCatalogResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BillingCatalogResponseBuilder();
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
