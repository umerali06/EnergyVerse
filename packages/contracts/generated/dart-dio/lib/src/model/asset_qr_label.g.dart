// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_qr_label.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AssetQrLabel extends AssetQrLabel {
  @override
  final String assetTag;
  @override
  final String name;
  @override
  final String? qrCodeId;
  @override
  final String? url;

  factory _$AssetQrLabel([void Function(AssetQrLabelBuilder)? updates]) =>
      (new AssetQrLabelBuilder()..update(updates))._build();

  _$AssetQrLabel._(
      {required this.assetTag, required this.name, this.qrCodeId, this.url})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        assetTag, r'AssetQrLabel', 'assetTag');
    BuiltValueNullFieldError.checkNotNull(name, r'AssetQrLabel', 'name');
  }

  @override
  AssetQrLabel rebuild(void Function(AssetQrLabelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssetQrLabelBuilder toBuilder() => new AssetQrLabelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssetQrLabel &&
        assetTag == other.assetTag &&
        name == other.name &&
        qrCodeId == other.qrCodeId &&
        url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assetTag.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, qrCodeId.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssetQrLabel')
          ..add('assetTag', assetTag)
          ..add('name', name)
          ..add('qrCodeId', qrCodeId)
          ..add('url', url))
        .toString();
  }
}

class AssetQrLabelBuilder
    implements Builder<AssetQrLabel, AssetQrLabelBuilder> {
  _$AssetQrLabel? _$v;

  String? _assetTag;
  String? get assetTag => _$this._assetTag;
  set assetTag(String? assetTag) => _$this._assetTag = assetTag;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _qrCodeId;
  String? get qrCodeId => _$this._qrCodeId;
  set qrCodeId(String? qrCodeId) => _$this._qrCodeId = qrCodeId;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  AssetQrLabelBuilder() {
    AssetQrLabel._defaults(this);
  }

  AssetQrLabelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assetTag = $v.assetTag;
      _name = $v.name;
      _qrCodeId = $v.qrCodeId;
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssetQrLabel other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AssetQrLabel;
  }

  @override
  void update(void Function(AssetQrLabelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssetQrLabel build() => _build();

  _$AssetQrLabel _build() {
    final _$result = _$v ??
        new _$AssetQrLabel._(
            assetTag: BuiltValueNullFieldError.checkNotNull(
                assetTag, r'AssetQrLabel', 'assetTag'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'AssetQrLabel', 'name'),
            qrCodeId: qrCodeId,
            url: url);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
