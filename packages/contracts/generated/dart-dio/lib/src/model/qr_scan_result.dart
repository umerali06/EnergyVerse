//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fev_api_client/src/model/asset_detail.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'qr_scan_result.g.dart';

/// The scan surface: the full asset plus reserved, honestly-empty counts for sections later phases (7/11) will populate.
///
/// Properties:
/// * [asset]
/// * [inspectionsTotal]
/// * [maintenanceTotal]
/// * [workOrdersTotal]
@BuiltValue()
abstract class QrScanResult
    implements Built<QrScanResult, QrScanResultBuilder> {
  @BuiltValueField(wireName: r'asset')
  AssetDetail get asset;

  @BuiltValueField(wireName: r'inspections_total')
  int? get inspectionsTotal;

  @BuiltValueField(wireName: r'maintenance_total')
  int? get maintenanceTotal;

  @BuiltValueField(wireName: r'work_orders_total')
  int? get workOrdersTotal;

  QrScanResult._();

  factory QrScanResult([void updates(QrScanResultBuilder b)]) = _$QrScanResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QrScanResultBuilder b) => b
    ..inspectionsTotal = 0
    ..maintenanceTotal = 0
    ..workOrdersTotal = 0;

  @BuiltValueSerializer(custom: true)
  static Serializer<QrScanResult> get serializer => _$QrScanResultSerializer();
}

class _$QrScanResultSerializer implements PrimitiveSerializer<QrScanResult> {
  @override
  final Iterable<Type> types = const [QrScanResult, _$QrScanResult];

  @override
  final String wireName = r'QrScanResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QrScanResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'asset';
    yield serializers.serialize(
      object.asset,
      specifiedType: const FullType(AssetDetail),
    );
    if (object.inspectionsTotal != null) {
      yield r'inspections_total';
      yield serializers.serialize(
        object.inspectionsTotal,
        specifiedType: const FullType(int),
      );
    }
    if (object.maintenanceTotal != null) {
      yield r'maintenance_total';
      yield serializers.serialize(
        object.maintenanceTotal,
        specifiedType: const FullType(int),
      );
    }
    if (object.workOrdersTotal != null) {
      yield r'work_orders_total';
      yield serializers.serialize(
        object.workOrdersTotal,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    QrScanResult object, {
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
    required QrScanResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'asset':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AssetDetail),
          ) as AssetDetail;
          result.asset.replace(valueDes);
          break;
        case r'inspections_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.inspectionsTotal = valueDes;
          break;
        case r'maintenance_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.maintenanceTotal = valueDes;
          break;
        case r'work_orders_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.workOrdersTotal = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QrScanResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QrScanResultBuilder();
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
