//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/billing_plan_quotas_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'billing_plan_response.g.dart';

/// BillingPlanResponse
///
/// Properties:
/// * [annualTotalCents]
/// * [audience]
/// * [customQuoted]
/// * [digitalTwinScope]
/// * [features]
/// * [listMonthlyCents]
/// * [monthlyCents]
/// * [name]
/// * [quotas]
/// * [support]
/// * [tier]
@BuiltValue()
abstract class BillingPlanResponse
    implements Built<BillingPlanResponse, BillingPlanResponseBuilder> {
  @BuiltValueField(wireName: r'annual_total_cents')
  int get annualTotalCents;

  @BuiltValueField(wireName: r'audience')
  String get audience;

  @BuiltValueField(wireName: r'custom_quoted')
  bool get customQuoted;

  @BuiltValueField(wireName: r'digital_twin_scope')
  String get digitalTwinScope;

  @BuiltValueField(wireName: r'features')
  BuiltList<String> get features;

  @BuiltValueField(wireName: r'list_monthly_cents')
  int get listMonthlyCents;

  @BuiltValueField(wireName: r'monthly_cents')
  int get monthlyCents;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'quotas')
  BillingPlanQuotasResponse get quotas;

  @BuiltValueField(wireName: r'support')
  String get support;

  @BuiltValueField(wireName: r'tier')
  String get tier;

  BillingPlanResponse._();

  factory BillingPlanResponse([void updates(BillingPlanResponseBuilder b)]) =
      _$BillingPlanResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BillingPlanResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BillingPlanResponse> get serializer =>
      _$BillingPlanResponseSerializer();
}

class _$BillingPlanResponseSerializer
    implements PrimitiveSerializer<BillingPlanResponse> {
  @override
  final Iterable<Type> types = const [
    BillingPlanResponse,
    _$BillingPlanResponse
  ];

  @override
  final String wireName = r'BillingPlanResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BillingPlanResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'annual_total_cents';
    yield serializers.serialize(
      object.annualTotalCents,
      specifiedType: const FullType(int),
    );
    yield r'audience';
    yield serializers.serialize(
      object.audience,
      specifiedType: const FullType(String),
    );
    yield r'custom_quoted';
    yield serializers.serialize(
      object.customQuoted,
      specifiedType: const FullType(bool),
    );
    yield r'digital_twin_scope';
    yield serializers.serialize(
      object.digitalTwinScope,
      specifiedType: const FullType(String),
    );
    yield r'features';
    yield serializers.serialize(
      object.features,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'list_monthly_cents';
    yield serializers.serialize(
      object.listMonthlyCents,
      specifiedType: const FullType(int),
    );
    yield r'monthly_cents';
    yield serializers.serialize(
      object.monthlyCents,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'quotas';
    yield serializers.serialize(
      object.quotas,
      specifiedType: const FullType(BillingPlanQuotasResponse),
    );
    yield r'support';
    yield serializers.serialize(
      object.support,
      specifiedType: const FullType(String),
    );
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BillingPlanResponse object, {
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
    required BillingPlanResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'annual_total_cents':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.annualTotalCents = valueDes;
          break;
        case r'audience':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.audience = valueDes;
          break;
        case r'custom_quoted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.customQuoted = valueDes;
          break;
        case r'digital_twin_scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.digitalTwinScope = valueDes;
          break;
        case r'features':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.features.replace(valueDes);
          break;
        case r'list_monthly_cents':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.listMonthlyCents = valueDes;
          break;
        case r'monthly_cents':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.monthlyCents = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'quotas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BillingPlanQuotasResponse),
          ) as BillingPlanQuotasResponse;
          result.quotas.replace(valueDes);
          break;
        case r'support':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.support = valueDes;
          break;
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tier = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BillingPlanResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BillingPlanResponseBuilder();
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
