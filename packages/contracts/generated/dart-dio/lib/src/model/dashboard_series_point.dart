//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fev_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dashboard_series_point.g.dart';

/// DashboardSeriesPoint
///
/// Properties:
/// * [count]
/// * [date]
@BuiltValue()
abstract class DashboardSeriesPoint
    implements Built<DashboardSeriesPoint, DashboardSeriesPointBuilder> {
  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'date')
  Date get date;

  DashboardSeriesPoint._();

  factory DashboardSeriesPoint([void updates(DashboardSeriesPointBuilder b)]) =
      _$DashboardSeriesPoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DashboardSeriesPointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DashboardSeriesPoint> get serializer =>
      _$DashboardSeriesPointSerializer();
}

class _$DashboardSeriesPointSerializer
    implements PrimitiveSerializer<DashboardSeriesPoint> {
  @override
  final Iterable<Type> types = const [
    DashboardSeriesPoint,
    _$DashboardSeriesPoint
  ];

  @override
  final String wireName = r'DashboardSeriesPoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DashboardSeriesPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DashboardSeriesPoint object, {
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
    required DashboardSeriesPointBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.date = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DashboardSeriesPoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DashboardSeriesPointBuilder();
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
