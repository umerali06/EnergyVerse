// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_media_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AssetMediaResponseKindEnum _$assetMediaResponseKindEnum_photo =
    const AssetMediaResponseKindEnum._('photo');
const AssetMediaResponseKindEnum _$assetMediaResponseKindEnum_document =
    const AssetMediaResponseKindEnum._('document');
const AssetMediaResponseKindEnum _$assetMediaResponseKindEnum_manual =
    const AssetMediaResponseKindEnum._('manual');

AssetMediaResponseKindEnum _$assetMediaResponseKindEnumValueOf(String name) {
  switch (name) {
    case 'photo':
      return _$assetMediaResponseKindEnum_photo;
    case 'document':
      return _$assetMediaResponseKindEnum_document;
    case 'manual':
      return _$assetMediaResponseKindEnum_manual;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<AssetMediaResponseKindEnum> _$assetMediaResponseKindEnumValues =
    new BuiltSet<AssetMediaResponseKindEnum>(const <AssetMediaResponseKindEnum>[
  _$assetMediaResponseKindEnum_photo,
  _$assetMediaResponseKindEnum_document,
  _$assetMediaResponseKindEnum_manual,
]);

Serializer<AssetMediaResponseKindEnum> _$assetMediaResponseKindEnumSerializer =
    new _$AssetMediaResponseKindEnumSerializer();

class _$AssetMediaResponseKindEnumSerializer
    implements PrimitiveSerializer<AssetMediaResponseKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'photo': 'photo',
    'document': 'document',
    'manual': 'manual',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'photo': 'photo',
    'document': 'document',
    'manual': 'manual',
  };

  @override
  final Iterable<Type> types = const <Type>[AssetMediaResponseKindEnum];
  @override
  final String wireName = 'AssetMediaResponseKindEnum';

  @override
  Object serialize(Serializers serializers, AssetMediaResponseKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AssetMediaResponseKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AssetMediaResponseKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AssetMediaResponse extends AssetMediaResponse {
  @override
  final String contentType;
  @override
  final String filename;
  @override
  final String id;
  @override
  final AssetMediaResponseKindEnum kind;
  @override
  final int size;
  @override
  final DateTime uploadedAt;
  @override
  final String uploadedBy;
  @override
  final String url;

  factory _$AssetMediaResponse(
          [void Function(AssetMediaResponseBuilder)? updates]) =>
      (new AssetMediaResponseBuilder()..update(updates))._build();

  _$AssetMediaResponse._(
      {required this.contentType,
      required this.filename,
      required this.id,
      required this.kind,
      required this.size,
      required this.uploadedAt,
      required this.uploadedBy,
      required this.url})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        contentType, r'AssetMediaResponse', 'contentType');
    BuiltValueNullFieldError.checkNotNull(
        filename, r'AssetMediaResponse', 'filename');
    BuiltValueNullFieldError.checkNotNull(id, r'AssetMediaResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(kind, r'AssetMediaResponse', 'kind');
    BuiltValueNullFieldError.checkNotNull(size, r'AssetMediaResponse', 'size');
    BuiltValueNullFieldError.checkNotNull(
        uploadedAt, r'AssetMediaResponse', 'uploadedAt');
    BuiltValueNullFieldError.checkNotNull(
        uploadedBy, r'AssetMediaResponse', 'uploadedBy');
    BuiltValueNullFieldError.checkNotNull(url, r'AssetMediaResponse', 'url');
  }

  @override
  AssetMediaResponse rebuild(
          void Function(AssetMediaResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssetMediaResponseBuilder toBuilder() =>
      new AssetMediaResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssetMediaResponse &&
        contentType == other.contentType &&
        filename == other.filename &&
        id == other.id &&
        kind == other.kind &&
        size == other.size &&
        uploadedAt == other.uploadedAt &&
        uploadedBy == other.uploadedBy &&
        url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, filename.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jc(_$hash, uploadedAt.hashCode);
    _$hash = $jc(_$hash, uploadedBy.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssetMediaResponse')
          ..add('contentType', contentType)
          ..add('filename', filename)
          ..add('id', id)
          ..add('kind', kind)
          ..add('size', size)
          ..add('uploadedAt', uploadedAt)
          ..add('uploadedBy', uploadedBy)
          ..add('url', url))
        .toString();
  }
}

class AssetMediaResponseBuilder
    implements Builder<AssetMediaResponse, AssetMediaResponseBuilder> {
  _$AssetMediaResponse? _$v;

  String? _contentType;
  String? get contentType => _$this._contentType;
  set contentType(String? contentType) => _$this._contentType = contentType;

  String? _filename;
  String? get filename => _$this._filename;
  set filename(String? filename) => _$this._filename = filename;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AssetMediaResponseKindEnum? _kind;
  AssetMediaResponseKindEnum? get kind => _$this._kind;
  set kind(AssetMediaResponseKindEnum? kind) => _$this._kind = kind;

  int? _size;
  int? get size => _$this._size;
  set size(int? size) => _$this._size = size;

  DateTime? _uploadedAt;
  DateTime? get uploadedAt => _$this._uploadedAt;
  set uploadedAt(DateTime? uploadedAt) => _$this._uploadedAt = uploadedAt;

  String? _uploadedBy;
  String? get uploadedBy => _$this._uploadedBy;
  set uploadedBy(String? uploadedBy) => _$this._uploadedBy = uploadedBy;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  AssetMediaResponseBuilder() {
    AssetMediaResponse._defaults(this);
  }

  AssetMediaResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contentType = $v.contentType;
      _filename = $v.filename;
      _id = $v.id;
      _kind = $v.kind;
      _size = $v.size;
      _uploadedAt = $v.uploadedAt;
      _uploadedBy = $v.uploadedBy;
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssetMediaResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AssetMediaResponse;
  }

  @override
  void update(void Function(AssetMediaResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssetMediaResponse build() => _build();

  _$AssetMediaResponse _build() {
    final _$result = _$v ??
        new _$AssetMediaResponse._(
            contentType: BuiltValueNullFieldError.checkNotNull(
                contentType, r'AssetMediaResponse', 'contentType'),
            filename: BuiltValueNullFieldError.checkNotNull(
                filename, r'AssetMediaResponse', 'filename'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AssetMediaResponse', 'id'),
            kind: BuiltValueNullFieldError.checkNotNull(
                kind, r'AssetMediaResponse', 'kind'),
            size: BuiltValueNullFieldError.checkNotNull(
                size, r'AssetMediaResponse', 'size'),
            uploadedAt: BuiltValueNullFieldError.checkNotNull(
                uploadedAt, r'AssetMediaResponse', 'uploadedAt'),
            uploadedBy: BuiltValueNullFieldError.checkNotNull(
                uploadedBy, r'AssetMediaResponse', 'uploadedBy'),
            url: BuiltValueNullFieldError.checkNotNull(
                url, r'AssetMediaResponse', 'url'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
