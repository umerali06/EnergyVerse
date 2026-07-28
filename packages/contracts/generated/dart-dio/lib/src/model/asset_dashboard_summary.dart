//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/src/model/asset_facility_count.dart';
import 'package:fev_api_client/src/model/asset_category_count.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset_dashboard_summary.g.dart';

/// AssetDashboardSummary
///
/// Properties:
/// * [byCategory]
/// * [byFacility]
/// * [critical]
/// * [healthy]
/// * [total]
/// * [warning]
@BuiltValue()
abstract class AssetDashboardSummary
    implements Built<AssetDashboardSummary, AssetDashboardSummaryBuilder> {
  @BuiltValueField(wireName: r'by_category')
  BuiltList<AssetCategoryCount> get byCategory;

  @BuiltValueField(wireName: r'by_facility')
  BuiltList<AssetFacilityCount> get byFacility;

  @BuiltValueField(wireName: r'critical')
  int get critical;

  @BuiltValueField(wireName: r'healthy')
  int get healthy;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'warning')
  int get warning;

  AssetDashboardSummary._();

  factory AssetDashboardSummary(
      [void updates(AssetDashboardSummaryBuilder b)]) = _$AssetDashboardSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetDashboardSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetDashboardSummary> get serializer =>
      _$AssetDashboardSummarySerializer();
}

class _$AssetDashboardSummarySerializer
    implements PrimitiveSerializer<AssetDashboardSummary> {
  @override
  final Iterable<Type> types = const [
    AssetDashboardSummary,
    _$AssetDashboardSummary
  ];

  @override
  final String wireName = r'AssetDashboardSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetDashboardSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'by_category';
    yield serializers.serialize(
      object.byCategory,
      specifiedType: const FullType(BuiltList, [FullType(AssetCategoryCount)]),
    );
    yield r'by_facility';
    yield serializers.serialize(
      object.byFacility,
      specifiedType: const FullType(BuiltList, [FullType(AssetFacilityCount)]),
    );
    yield r'critical';
    yield serializers.serialize(
      object.critical,
      specifiedType: const FullType(int),
    );
    yield r'healthy';
    yield serializers.serialize(
      object.healthy,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'warning';
    yield serializers.serialize(
      object.warning,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetDashboardSummary object, {
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
    required AssetDashboardSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'by_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(AssetCategoryCount)]),
          ) as BuiltList<AssetCategoryCount>;
          result.byCategory.replace(valueDes);
          break;
        case r'by_facility':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(AssetFacilityCount)]),
          ) as BuiltList<AssetFacilityCount>;
          result.byFacility.replace(valueDes);
          break;
        case r'critical':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.critical = valueDes;
          break;
        case r'healthy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.healthy = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'warning':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.warning = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssetDashboardSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetDashboardSummaryBuilder();
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
