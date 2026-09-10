// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safety_evidence_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SafetyEvidenceResponseKindEnum _$safetyEvidenceResponseKindEnum_photo =
    const SafetyEvidenceResponseKindEnum._('photo');
const SafetyEvidenceResponseKindEnum _$safetyEvidenceResponseKindEnum_video =
    const SafetyEvidenceResponseKindEnum._('video');

SafetyEvidenceResponseKindEnum _$safetyEvidenceResponseKindEnumValueOf(
    String name) {
  switch (name) {
    case 'photo':
      return _$safetyEvidenceResponseKindEnum_photo;
    case 'video':
      return _$safetyEvidenceResponseKindEnum_video;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<SafetyEvidenceResponseKindEnum>
    _$safetyEvidenceResponseKindEnumValues = new BuiltSet<
        SafetyEvidenceResponseKindEnum>(const <SafetyEvidenceResponseKindEnum>[
  _$safetyEvidenceResponseKindEnum_photo,
  _$safetyEvidenceResponseKindEnum_video,
]);

Serializer<SafetyEvidenceResponseKindEnum>
    _$safetyEvidenceResponseKindEnumSerializer =
    new _$SafetyEvidenceResponseKindEnumSerializer();

class _$SafetyEvidenceResponseKindEnumSerializer
    implements PrimitiveSerializer<SafetyEvidenceResponseKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'photo': 'photo',
    'video': 'video',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'photo': 'photo',
    'video': 'video',
  };

  @override
  final Iterable<Type> types = const <Type>[SafetyEvidenceResponseKindEnum];
  @override
  final String wireName = 'SafetyEvidenceResponseKindEnum';

  @override
  Object serialize(
          Serializers serializers, SafetyEvidenceResponseKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SafetyEvidenceResponseKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SafetyEvidenceResponseKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SafetyEvidenceResponse extends SafetyEvidenceResponse {
  @override
  final String contentType;
  @override
  final String filename;
  @override
  final String id;
  @override
  final SafetyEvidenceResponseKindEnum kind;
  @override
  final int size;
  @override
  final DateTime uploadedAt;
  @override
  final String uploadedBy;
  @override
  final String url;

  factory _$SafetyEvidenceResponse(
          [void Function(SafetyEvidenceResponseBuilder)? updates]) =>
      (new SafetyEvidenceResponseBuilder()..update(updates))._build();

  _$SafetyEvidenceResponse._(
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
        contentType, r'SafetyEvidenceResponse', 'contentType');
    BuiltValueNullFieldError.checkNotNull(
        filename, r'SafetyEvidenceResponse', 'filename');
    BuiltValueNullFieldError.checkNotNull(id, r'SafetyEvidenceResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        kind, r'SafetyEvidenceResponse', 'kind');
    BuiltValueNullFieldError.checkNotNull(
        size, r'SafetyEvidenceResponse', 'size');
    BuiltValueNullFieldError.checkNotNull(
        uploadedAt, r'SafetyEvidenceResponse', 'uploadedAt');
    BuiltValueNullFieldError.checkNotNull(
        uploadedBy, r'SafetyEvidenceResponse', 'uploadedBy');
    BuiltValueNullFieldError.checkNotNull(
        url, r'SafetyEvidenceResponse', 'url');
  }

  @override
  SafetyEvidenceResponse rebuild(
          void Function(SafetyEvidenceResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SafetyEvidenceResponseBuilder toBuilder() =>
      new SafetyEvidenceResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SafetyEvidenceResponse &&
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
    return (newBuiltValueToStringHelper(r'SafetyEvidenceResponse')
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

class SafetyEvidenceResponseBuilder
    implements Builder<SafetyEvidenceResponse, SafetyEvidenceResponseBuilder> {
  _$SafetyEvidenceResponse? _$v;

  String? _contentType;
  String? get contentType => _$this._contentType;
  set contentType(String? contentType) => _$this._contentType = contentType;

  String? _filename;
  String? get filename => _$this._filename;
  set filename(String? filename) => _$this._filename = filename;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  SafetyEvidenceResponseKindEnum? _kind;
  SafetyEvidenceResponseKindEnum? get kind => _$this._kind;
  set kind(SafetyEvidenceResponseKindEnum? kind) => _$this._kind = kind;

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

  SafetyEvidenceResponseBuilder() {
    SafetyEvidenceResponse._defaults(this);
  }

  SafetyEvidenceResponseBuilder get _$this {
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
  void replace(SafetyEvidenceResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SafetyEvidenceResponse;
  }

  @override
  void update(void Function(SafetyEvidenceResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SafetyEvidenceResponse build() => _build();

  _$SafetyEvidenceResponse _build() {
    final _$result = _$v ??
        new _$SafetyEvidenceResponse._(
            contentType: BuiltValueNullFieldError.checkNotNull(
                contentType, r'SafetyEvidenceResponse', 'contentType'),
            filename: BuiltValueNullFieldError.checkNotNull(
                filename, r'SafetyEvidenceResponse', 'filename'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'SafetyEvidenceResponse', 'id'),
            kind: BuiltValueNullFieldError.checkNotNull(
                kind, r'SafetyEvidenceResponse', 'kind'),
            size: BuiltValueNullFieldError.checkNotNull(
                size, r'SafetyEvidenceResponse', 'size'),
            uploadedAt: BuiltValueNullFieldError.checkNotNull(
                uploadedAt, r'SafetyEvidenceResponse', 'uploadedAt'),
            uploadedBy: BuiltValueNullFieldError.checkNotNull(
                uploadedBy, r'SafetyEvidenceResponse', 'uploadedBy'),
            url: BuiltValueNullFieldError.checkNotNull(
                url, r'SafetyEvidenceResponse', 'url'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
