// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_scan_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$QrScanResult extends QrScanResult {
  @override
  final AssetDetail asset;
  @override
  final int? inspectionsTotal;
  @override
  final int? maintenanceTotal;
  @override
  final int? workOrdersTotal;

  factory _$QrScanResult([void Function(QrScanResultBuilder)? updates]) =>
      (new QrScanResultBuilder()..update(updates))._build();

  _$QrScanResult._(
      {required this.asset,
      this.inspectionsTotal,
      this.maintenanceTotal,
      this.workOrdersTotal})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(asset, r'QrScanResult', 'asset');
  }

  @override
  QrScanResult rebuild(void Function(QrScanResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QrScanResultBuilder toBuilder() => new QrScanResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QrScanResult &&
        asset == other.asset &&
        inspectionsTotal == other.inspectionsTotal &&
        maintenanceTotal == other.maintenanceTotal &&
        workOrdersTotal == other.workOrdersTotal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, asset.hashCode);
    _$hash = $jc(_$hash, inspectionsTotal.hashCode);
    _$hash = $jc(_$hash, maintenanceTotal.hashCode);
    _$hash = $jc(_$hash, workOrdersTotal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QrScanResult')
          ..add('asset', asset)
          ..add('inspectionsTotal', inspectionsTotal)
          ..add('maintenanceTotal', maintenanceTotal)
          ..add('workOrdersTotal', workOrdersTotal))
        .toString();
  }
}

class QrScanResultBuilder
    implements Builder<QrScanResult, QrScanResultBuilder> {
  _$QrScanResult? _$v;

  AssetDetailBuilder? _asset;
  AssetDetailBuilder get asset => _$this._asset ??= new AssetDetailBuilder();
  set asset(AssetDetailBuilder? asset) => _$this._asset = asset;

  int? _inspectionsTotal;
  int? get inspectionsTotal => _$this._inspectionsTotal;
  set inspectionsTotal(int? inspectionsTotal) =>
      _$this._inspectionsTotal = inspectionsTotal;

  int? _maintenanceTotal;
  int? get maintenanceTotal => _$this._maintenanceTotal;
  set maintenanceTotal(int? maintenanceTotal) =>
      _$this._maintenanceTotal = maintenanceTotal;

  int? _workOrdersTotal;
  int? get workOrdersTotal => _$this._workOrdersTotal;
  set workOrdersTotal(int? workOrdersTotal) =>
      _$this._workOrdersTotal = workOrdersTotal;

  QrScanResultBuilder() {
    QrScanResult._defaults(this);
  }

  QrScanResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _asset = $v.asset.toBuilder();
      _inspectionsTotal = $v.inspectionsTotal;
      _maintenanceTotal = $v.maintenanceTotal;
      _workOrdersTotal = $v.workOrdersTotal;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QrScanResult other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$QrScanResult;
  }

  @override
  void update(void Function(QrScanResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QrScanResult build() => _build();

  _$QrScanResult _build() {
    _$QrScanResult _$result;
    try {
      _$result = _$v ??
          new _$QrScanResult._(
              asset: asset.build(),
              inspectionsTotal: inspectionsTotal,
              maintenanceTotal: maintenanceTotal,
              workOrdersTotal: workOrdersTotal);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'asset';
        asset.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'QrScanResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
