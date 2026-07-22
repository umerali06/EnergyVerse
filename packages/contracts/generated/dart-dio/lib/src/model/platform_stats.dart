//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'platform_stats.g.dart';

/// PlatformStats
///
/// Properties:
/// * [activeTenants]
/// * [recentSignups]
/// * [totalCompanies]
/// * [totalUsers]
/// * [windowDays]
@BuiltValue()
abstract class PlatformStats
    implements Built<PlatformStats, PlatformStatsBuilder> {
  @BuiltValueField(wireName: r'active_tenants')
  int get activeTenants;

  @BuiltValueField(wireName: r'recent_signups')
  int get recentSignups;

  @BuiltValueField(wireName: r'total_companies')
  int get totalCompanies;

  @BuiltValueField(wireName: r'total_users')
  int get totalUsers;

  @BuiltValueField(wireName: r'window_days')
  int get windowDays;

  PlatformStats._();

  factory PlatformStats([void updates(PlatformStatsBuilder b)]) =
      _$PlatformStats;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlatformStatsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlatformStats> get serializer =>
      _$PlatformStatsSerializer();
}

class _$PlatformStatsSerializer implements PrimitiveSerializer<PlatformStats> {
  @override
  final Iterable<Type> types = const [PlatformStats, _$PlatformStats];

  @override
  final String wireName = r'PlatformStats';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlatformStats object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'active_tenants';
    yield serializers.serialize(
      object.activeTenants,
      specifiedType: const FullType(int),
    );
    yield r'recent_signups';
    yield serializers.serialize(
      object.recentSignups,
      specifiedType: const FullType(int),
    );
    yield r'total_companies';
    yield serializers.serialize(
      object.totalCompanies,
      specifiedType: const FullType(int),
    );
    yield r'total_users';
    yield serializers.serialize(
      object.totalUsers,
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
    PlatformStats object, {
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
    required PlatformStatsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'active_tenants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.activeTenants = valueDes;
          break;
        case r'recent_signups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.recentSignups = valueDes;
          break;
        case r'total_companies':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalCompanies = valueDes;
          break;
        case r'total_users':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalUsers = valueDes;
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
  PlatformStats deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlatformStatsBuilder();
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
