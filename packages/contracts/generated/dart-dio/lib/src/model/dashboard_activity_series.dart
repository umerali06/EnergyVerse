//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/dashboard_series_point.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dashboard_activity_series.g.dart';

/// DashboardActivitySeries
///
/// Properties:
/// * [points]
/// * [windowDays]
@BuiltValue()
abstract class DashboardActivitySeries
    implements Built<DashboardActivitySeries, DashboardActivitySeriesBuilder> {
  @BuiltValueField(wireName: r'points')
  BuiltList<DashboardSeriesPoint> get points;

  @BuiltValueField(wireName: r'window_days')
  int get windowDays;

  DashboardActivitySeries._();

  factory DashboardActivitySeries(
          [void updates(DashboardActivitySeriesBuilder b)]) =
      _$DashboardActivitySeries;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DashboardActivitySeriesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DashboardActivitySeries> get serializer =>
      _$DashboardActivitySeriesSerializer();
}

class _$DashboardActivitySeriesSerializer
    implements PrimitiveSerializer<DashboardActivitySeries> {
  @override
  final Iterable<Type> types = const [
    DashboardActivitySeries,
    _$DashboardActivitySeries
  ];

  @override
  final String wireName = r'DashboardActivitySeries';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DashboardActivitySeries object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'points';
    yield serializers.serialize(
      object.points,
      specifiedType:
          const FullType(BuiltList, [FullType(DashboardSeriesPoint)]),
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
    DashboardActivitySeries object, {
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
    required DashboardActivitySeriesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(DashboardSeriesPoint)]),
          ) as BuiltList<DashboardSeriesPoint>;
          result.points.replace(valueDes);
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
  DashboardActivitySeries deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DashboardActivitySeriesBuilder();
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
