//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/billing_plan_quotas_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscription_response.g.dart';

/// What the shell needs to decide which modules to render. `features` is the authoritative list -- the client must not derive it from `tier` itself.
///
/// Properties:
/// * [currentPeriodEnd]
/// * [features]
/// * [isEntitled]
/// * [planName]
/// * [quotas]
/// * [status]
/// * [tier]
/// * [trialDaysRemaining]
/// * [trialEndsAt]
@BuiltValue()
abstract class SubscriptionResponse
    implements Built<SubscriptionResponse, SubscriptionResponseBuilder> {
  @BuiltValueField(wireName: r'current_period_end')
  DateTime? get currentPeriodEnd;

  @BuiltValueField(wireName: r'features')
  BuiltList<String> get features;

  @BuiltValueField(wireName: r'is_entitled')
  bool get isEntitled;

  @BuiltValueField(wireName: r'plan_name')
  String? get planName;

  @BuiltValueField(wireName: r'quotas')
  BillingPlanQuotasResponse get quotas;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'tier')
  String get tier;

  @BuiltValueField(wireName: r'trial_days_remaining')
  int? get trialDaysRemaining;

  @BuiltValueField(wireName: r'trial_ends_at')
  DateTime? get trialEndsAt;

  SubscriptionResponse._();

  factory SubscriptionResponse([void updates(SubscriptionResponseBuilder b)]) =
      _$SubscriptionResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubscriptionResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubscriptionResponse> get serializer =>
      _$SubscriptionResponseSerializer();
}

class _$SubscriptionResponseSerializer
    implements PrimitiveSerializer<SubscriptionResponse> {
  @override
  final Iterable<Type> types = const [
    SubscriptionResponse,
    _$SubscriptionResponse
  ];

  @override
  final String wireName = r'SubscriptionResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubscriptionResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'current_period_end';
    yield object.currentPeriodEnd == null
        ? null
        : serializers.serialize(
            object.currentPeriodEnd,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'features';
    yield serializers.serialize(
      object.features,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'is_entitled';
    yield serializers.serialize(
      object.isEntitled,
      specifiedType: const FullType(bool),
    );
    yield r'plan_name';
    yield object.planName == null
        ? null
        : serializers.serialize(
            object.planName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'quotas';
    yield serializers.serialize(
      object.quotas,
      specifiedType: const FullType(BillingPlanQuotasResponse),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(String),
    );
    yield r'trial_days_remaining';
    yield object.trialDaysRemaining == null
        ? null
        : serializers.serialize(
            object.trialDaysRemaining,
            specifiedType: const FullType.nullable(int),
          );
    yield r'trial_ends_at';
    yield object.trialEndsAt == null
        ? null
        : serializers.serialize(
            object.trialEndsAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    SubscriptionResponse object, {
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
    required SubscriptionResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'current_period_end':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.currentPeriodEnd = valueDes;
          break;
        case r'features':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.features.replace(valueDes);
          break;
        case r'is_entitled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isEntitled = valueDes;
          break;
        case r'plan_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.planName = valueDes;
          break;
        case r'quotas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BillingPlanQuotasResponse),
          ) as BillingPlanQuotasResponse;
          result.quotas.replace(valueDes);
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tier = valueDes;
          break;
        case r'trial_days_remaining':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.trialDaysRemaining = valueDes;
          break;
        case r'trial_ends_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.trialEndsAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubscriptionResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubscriptionResponseBuilder();
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
