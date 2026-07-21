//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dashboard_summary.g.dart';

/// DashboardSummary
///
/// Properties:
/// * [auditEvents]
/// * [companyCreatedAt]
/// * [companyName]
/// * [rolesTotal]
/// * [subscriptionTier]
/// * [usersActive]
/// * [usersTotal]
/// * [windowDays]
@BuiltValue()
abstract class DashboardSummary
    implements Built<DashboardSummary, DashboardSummaryBuilder> {
  @BuiltValueField(wireName: r'audit_events')
  int get auditEvents;

  @BuiltValueField(wireName: r'company_created_at')
  DateTime get companyCreatedAt;

  @BuiltValueField(wireName: r'company_name')
  String get companyName;

  @BuiltValueField(wireName: r'roles_total')
  int get rolesTotal;

  @BuiltValueField(wireName: r'subscription_tier')
  String get subscriptionTier;

  @BuiltValueField(wireName: r'users_active')
  int get usersActive;

  @BuiltValueField(wireName: r'users_total')
  int get usersTotal;

  @BuiltValueField(wireName: r'window_days')
  int get windowDays;

  DashboardSummary._();

  factory DashboardSummary([void updates(DashboardSummaryBuilder b)]) =
      _$DashboardSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DashboardSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DashboardSummary> get serializer =>
      _$DashboardSummarySerializer();
}

class _$DashboardSummarySerializer
    implements PrimitiveSerializer<DashboardSummary> {
  @override
  final Iterable<Type> types = const [DashboardSummary, _$DashboardSummary];

  @override
  final String wireName = r'DashboardSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DashboardSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'audit_events';
    yield serializers.serialize(
      object.auditEvents,
      specifiedType: const FullType(int),
    );
    yield r'company_created_at';
    yield serializers.serialize(
      object.companyCreatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'company_name';
    yield serializers.serialize(
      object.companyName,
      specifiedType: const FullType(String),
    );
    yield r'roles_total';
    yield serializers.serialize(
      object.rolesTotal,
      specifiedType: const FullType(int),
    );
    yield r'subscription_tier';
    yield serializers.serialize(
      object.subscriptionTier,
      specifiedType: const FullType(String),
    );
    yield r'users_active';
    yield serializers.serialize(
      object.usersActive,
      specifiedType: const FullType(int),
    );
    yield r'users_total';
    yield serializers.serialize(
      object.usersTotal,
      specifiedType: const FullType(int),
    );
    yield r'window_days';
    yield serializers.serialize(
      object.windowDays,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DashboardSummary object, {
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
    required DashboardSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'audit_events':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.auditEvents = valueDes;
          break;
        case r'company_created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.companyCreatedAt = valueDes;
          break;
        case r'company_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyName = valueDes;
          break;
        case r'roles_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rolesTotal = valueDes;
          break;
        case r'subscription_tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subscriptionTier = valueDes;
          break;
        case r'users_active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.usersActive = valueDes;
          break;
        case r'users_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.usersTotal = valueDes;
          break;
        case r'window_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.windowDays = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DashboardSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DashboardSummaryBuilder();
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
