//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/subscription_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout_confirm_response.g.dart';

/// `outcome` is `reconciled` once the purchase has been written to the company, or `pending` while Stripe has not yet attached a subscription to the session. `subscription` is the freshly resolved plan either way, so the completion screen never needs a second round trip to decide what to show.
///
/// Properties:
/// * [outcome]
/// * [subscription]
@BuiltValue()
abstract class CheckoutConfirmResponse
    implements Built<CheckoutConfirmResponse, CheckoutConfirmResponseBuilder> {
  @BuiltValueField(wireName: r'outcome')
  CheckoutConfirmResponseOutcomeEnum get outcome;
  // enum outcomeEnum {  reconciled,  pending,  };

  @BuiltValueField(wireName: r'subscription')
  SubscriptionResponse get subscription;

  CheckoutConfirmResponse._();

  factory CheckoutConfirmResponse(
          [void updates(CheckoutConfirmResponseBuilder b)]) =
      _$CheckoutConfirmResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckoutConfirmResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckoutConfirmResponse> get serializer =>
      _$CheckoutConfirmResponseSerializer();
}

class _$CheckoutConfirmResponseSerializer
    implements PrimitiveSerializer<CheckoutConfirmResponse> {
  @override
  final Iterable<Type> types = const [
    CheckoutConfirmResponse,
    _$CheckoutConfirmResponse
  ];

  @override
  final String wireName = r'CheckoutConfirmResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckoutConfirmResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'outcome';
    yield serializers.serialize(
      object.outcome,
      specifiedType: const FullType(CheckoutConfirmResponseOutcomeEnum),
    );
    yield r'subscription';
    yield serializers.serialize(
      object.subscription,
      specifiedType: const FullType(SubscriptionResponse),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckoutConfirmResponse object, {
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
    required CheckoutConfirmResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'outcome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CheckoutConfirmResponseOutcomeEnum),
          ) as CheckoutConfirmResponseOutcomeEnum;
          result.outcome = valueDes;
          break;
        case r'subscription':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SubscriptionResponse),
          ) as SubscriptionResponse;
          result.subscription.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckoutConfirmResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckoutConfirmResponseBuilder();
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

class CheckoutConfirmResponseOutcomeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'reconciled')
  static const CheckoutConfirmResponseOutcomeEnum reconciled =
      _$checkoutConfirmResponseOutcomeEnum_reconciled;
  @BuiltValueEnumConst(wireName: r'pending')
  static const CheckoutConfirmResponseOutcomeEnum pending =
      _$checkoutConfirmResponseOutcomeEnum_pending;

  static Serializer<CheckoutConfirmResponseOutcomeEnum> get serializer =>
      _$checkoutConfirmResponseOutcomeEnumSerializer;

  const CheckoutConfirmResponseOutcomeEnum._(String name) : super(name);

  static BuiltSet<CheckoutConfirmResponseOutcomeEnum> get values =>
      _$checkoutConfirmResponseOutcomeEnumValues;
  static CheckoutConfirmResponseOutcomeEnum valueOf(String name) =>
      _$checkoutConfirmResponseOutcomeEnumValueOf(name);
}
