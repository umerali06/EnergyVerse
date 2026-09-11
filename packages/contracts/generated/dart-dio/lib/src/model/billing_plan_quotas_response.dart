//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'billing_plan_quotas_response.g.dart';

/// `None` means unlimited. An unentitled company reports 0, not None.
///
/// Properties:
/// * [assets]
/// * [facilities]
/// * [seats]
@BuiltValue()
abstract class BillingPlanQuotasResponse
    implements
        Built<BillingPlanQuotasResponse, BillingPlanQuotasResponseBuilder> {
  @BuiltValueField(wireName: r'assets')
  int? get assets;

  @BuiltValueField(wireName: r'facilities')
  int? get facilities;

  @BuiltValueField(wireName: r'seats')
  int? get seats;

  BillingPlanQuotasResponse._();

  factory BillingPlanQuotasResponse(
          [void updates(BillingPlanQuotasResponseBuilder b)]) =
      _$BillingPlanQuotasResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BillingPlanQuotasResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BillingPlanQuotasResponse> get serializer =>
      _$BillingPlanQuotasResponseSerializer();
}

class _$BillingPlanQuotasResponseSerializer
    implements PrimitiveSerializer<BillingPlanQuotasResponse> {
  @override
  final Iterable<Type> types = const [
    BillingPlanQuotasResponse,
    _$BillingPlanQuotasResponse
  ];

  @override
  final String wireName = r'BillingPlanQuotasResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BillingPlanQuotasResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assets';
    yield object.assets == null
        ? null
        : serializers.serialize(
            object.assets,
            specifiedType: const FullType.nullable(int),
          );
    yield r'facilities';
    yield object.facilities == null
        ? null
        : serializers.serialize(
            object.facilities,
            specifiedType: const FullType.nullable(int),
          );
    yield r'seats';
    yield object.seats == null
        ? null
        : serializers.serialize(
            object.seats,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    BillingPlanQuotasResponse object, {
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
    required BillingPlanQuotasResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.assets = valueDes;
          break;
        case r'facilities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.facilities = valueDes;
          break;
        case r'seats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.seats = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BillingPlanQuotasResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BillingPlanQuotasResponseBuilder();
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
