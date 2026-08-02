// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_media_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InspectionMediaResponseBeforeAfterTagEnum
    _$inspectionMediaResponseBeforeAfterTagEnum_before =
    const InspectionMediaResponseBeforeAfterTagEnum._('before');
const InspectionMediaResponseBeforeAfterTagEnum
    _$inspectionMediaResponseBeforeAfterTagEnum_after =
    const InspectionMediaResponseBeforeAfterTagEnum._('after');

InspectionMediaResponseBeforeAfterTagEnum
    _$inspectionMediaResponseBeforeAfterTagEnumValueOf(String name) {
  switch (name) {
    case 'before':
      return _$inspectionMediaResponseBeforeAfterTagEnum_before;
    case 'after':
      return _$inspectionMediaResponseBeforeAfterTagEnum_after;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<InspectionMediaResponseBeforeAfterTagEnum>
    _$inspectionMediaResponseBeforeAfterTagEnumValues = new BuiltSet<
        InspectionMediaResponseBeforeAfterTagEnum>(const <InspectionMediaResponseBeforeAfterTagEnum>[
  _$inspectionMediaResponseBeforeAfterTagEnum_before,
  _$inspectionMediaResponseBeforeAfterTagEnum_after,
]);

const InspectionMediaResponseKindEnum _$inspectionMediaResponseKindEnum_photo =
    const InspectionMediaResponseKindEnum._('photo');
const InspectionMediaResponseKindEnum _$inspectionMediaResponseKindEnum_video =
    const InspectionMediaResponseKindEnum._('video');

InspectionMediaResponseKindEnum _$inspectionMediaResponseKindEnumValueOf(
    String name) {
  switch (name) {
    case 'photo':
      return _$inspectionMediaResponseKindEnum_photo;
    case 'video':
      return _$inspectionMediaResponseKindEnum_video;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<InspectionMediaResponseKindEnum>
    _$inspectionMediaResponseKindEnumValues = new BuiltSet<
        InspectionMediaResponseKindEnum>(const <InspectionMediaResponseKindEnum>[
  _$inspectionMediaResponseKindEnum_photo,
  _$inspectionMediaResponseKindEnum_video,
]);

Serializer<InspectionMediaResponseBeforeAfterTagEnum>
    _$inspectionMediaResponseBeforeAfterTagEnumSerializer =
    new _$InspectionMediaResponseBeforeAfterTagEnumSerializer();
Serializer<InspectionMediaResponseKindEnum>
    _$inspectionMediaResponseKindEnumSerializer =
    new _$InspectionMediaResponseKindEnumSerializer();

class _$InspectionMediaResponseBeforeAfterTagEnumSerializer
    implements PrimitiveSerializer<InspectionMediaResponseBeforeAfterTagEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'before': 'before',
    'after': 'after',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'before': 'before',
    'after': 'after',
  };

  @override
  final Iterable<Type> types = const <Type>[
    InspectionMediaResponseBeforeAfterTagEnum
  ];
  @override
  final String wireName = 'InspectionMediaResponseBeforeAfterTagEnum';

  @override
  Object serialize(Serializers serializers,
          InspectionMediaResponseBeforeAfterTagEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InspectionMediaResponseBeforeAfterTagEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InspectionMediaResponseBeforeAfterTagEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InspectionMediaResponseKindEnumSerializer
    implements PrimitiveSerializer<InspectionMediaResponseKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'photo': 'photo',
    'video': 'video',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'photo': 'photo',
    'video': 'video',
  };

  @override
  final Iterable<Type> types = const <Type>[InspectionMediaResponseKindEnum];
  @override
  final String wireName = 'InspectionMediaResponseKindEnum';

  @override
  Object serialize(
          Serializers serializers, InspectionMediaResponseKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InspectionMediaResponseKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InspectionMediaResponseKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InspectionMediaResponse extends InspectionMediaResponse {
  @override
  final InspectionMediaResponseBeforeAfterTagEnum? beforeAfterTag;
  @override
  final DateTime capturedAt;
  @override
  final String? checklistItemId;
  @override
  final String contentType;
  @override
  final String filename;
  @override
  final num? gpsLat;
  @override
  final num? gpsLng;
  @override
  final String id;
  @override
  final InspectionMediaResponseKindEnum kind;
  @override
  final String localId;
  @override
  final int size;
  @override
  final DateTime uploadedAt;
  @override
  final String uploadedBy;
  @override
  final String url;

  factory _$InspectionMediaResponse(
          [void Function(InspectionMediaResponseBuilder)? updates]) =>
      (new InspectionMediaResponseBuilder()..update(updates))._build();

  _$InspectionMediaResponse._(
      {this.beforeAfterTag,
      required this.capturedAt,
      this.checklistItemId,
      required this.contentType,
      required this.filename,
      this.gpsLat,
      this.gpsLng,
      required this.id,
      required this.kind,
      required this.localId,
      required this.size,
      required this.uploadedAt,
      required this.uploadedBy,
      required this.url})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        capturedAt, r'InspectionMediaResponse', 'capturedAt');
    BuiltValueNullFieldError.checkNotNull(
        contentType, r'InspectionMediaResponse', 'contentType');
    BuiltValueNullFieldError.checkNotNull(
        filename, r'InspectionMediaResponse', 'filename');
    BuiltValueNullFieldError.checkNotNull(id, r'InspectionMediaResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        kind, r'InspectionMediaResponse', 'kind');
    BuiltValueNullFieldError.checkNotNull(
        localId, r'InspectionMediaResponse', 'localId');
    BuiltValueNullFieldError.checkNotNull(
        size, r'InspectionMediaResponse', 'size');
    BuiltValueNullFieldError.checkNotNull(
        uploadedAt, r'InspectionMediaResponse', 'uploadedAt');
    BuiltValueNullFieldError.checkNotNull(
        uploadedBy, r'InspectionMediaResponse', 'uploadedBy');
    BuiltValueNullFieldError.checkNotNull(
        url, r'InspectionMediaResponse', 'url');
  }

  @override
  InspectionMediaResponse rebuild(
          void Function(InspectionMediaResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InspectionMediaResponseBuilder toBuilder() =>
      new InspectionMediaResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InspectionMediaResponse &&
        beforeAfterTag == other.beforeAfterTag &&
        capturedAt == other.capturedAt &&
        checklistItemId == other.checklistItemId &&
        contentType == other.contentType &&
        filename == other.filename &&
        gpsLat == other.gpsLat &&
        gpsLng == other.gpsLng &&
        id == other.id &&
        kind == other.kind &&
        localId == other.localId &&
        size == other.size &&
        uploadedAt == other.uploadedAt &&
        uploadedBy == other.uploadedBy &&
        url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, beforeAfterTag.hashCode);
    _$hash = $jc(_$hash, capturedAt.hashCode);
    _$hash = $jc(_$hash, checklistItemId.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, filename.hashCode);
    _$hash = $jc(_$hash, gpsLat.hashCode);
    _$hash = $jc(_$hash, gpsLng.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, localId.hashCode);
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jc(_$hash, uploadedAt.hashCode);
    _$hash = $jc(_$hash, uploadedBy.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InspectionMediaResponse')
          ..add('beforeAfterTag', beforeAfterTag)
          ..add('capturedAt', capturedAt)
          ..add('checklistItemId', checklistItemId)
          ..add('contentType', contentType)
          ..add('filename', filename)
          ..add('gpsLat', gpsLat)
          ..add('gpsLng', gpsLng)
          ..add('id', id)
          ..add('kind', kind)
          ..add('localId', localId)
          ..add('size', size)
          ..add('uploadedAt', uploadedAt)
          ..add('uploadedBy', uploadedBy)
          ..add('url', url))
        .toString();
  }
}

class InspectionMediaResponseBuilder
    implements
        Builder<InspectionMediaResponse, InspectionMediaResponseBuilder> {
  _$InspectionMediaResponse? _$v;

  InspectionMediaResponseBeforeAfterTagEnum? _beforeAfterTag;
  InspectionMediaResponseBeforeAfterTagEnum? get beforeAfterTag =>
      _$this._beforeAfterTag;
  set beforeAfterTag(
          InspectionMediaResponseBeforeAfterTagEnum? beforeAfterTag) =>
      _$this._beforeAfterTag = beforeAfterTag;

  DateTime? _capturedAt;
  DateTime? get capturedAt => _$this._capturedAt;
  set capturedAt(DateTime? capturedAt) => _$this._capturedAt = capturedAt;

  String? _checklistItemId;
  String? get checklistItemId => _$this._checklistItemId;
  set checklistItemId(String? checklistItemId) =>
      _$this._checklistItemId = checklistItemId;

  String? _contentType;
  String? get contentType => _$this._contentType;
  set contentType(String? contentType) => _$this._contentType = contentType;

  String? _filename;
  String? get filename => _$this._filename;
  set filename(String? filename) => _$this._filename = filename;

  num? _gpsLat;
  num? get gpsLat => _$this._gpsLat;
  set gpsLat(num? gpsLat) => _$this._gpsLat = gpsLat;

  num? _gpsLng;
  num? get gpsLng => _$this._gpsLng;
  set gpsLng(num? gpsLng) => _$this._gpsLng = gpsLng;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  InspectionMediaResponseKindEnum? _kind;
  InspectionMediaResponseKindEnum? get kind => _$this._kind;
  set kind(InspectionMediaResponseKindEnum? kind) => _$this._kind = kind;

  String? _localId;
  String? get localId => _$this._localId;
  set localId(String? localId) => _$this._localId = localId;

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

  InspectionMediaResponseBuilder() {
    InspectionMediaResponse._defaults(this);
  }

  InspectionMediaResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _beforeAfterTag = $v.beforeAfterTag;
      _capturedAt = $v.capturedAt;
      _checklistItemId = $v.checklistItemId;
      _contentType = $v.contentType;
      _filename = $v.filename;
      _gpsLat = $v.gpsLat;
      _gpsLng = $v.gpsLng;
      _id = $v.id;
      _kind = $v.kind;
      _localId = $v.localId;
      _size = $v.size;
      _uploadedAt = $v.uploadedAt;
      _uploadedBy = $v.uploadedBy;
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InspectionMediaResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$InspectionMediaResponse;
  }

  @override
  void update(void Function(InspectionMediaResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InspectionMediaResponse build() => _build();

  _$InspectionMediaResponse _build() {
    final _$result = _$v ??
        new _$InspectionMediaResponse._(
            beforeAfterTag: beforeAfterTag,
            capturedAt: BuiltValueNullFieldError.checkNotNull(
                capturedAt, r'InspectionMediaResponse', 'capturedAt'),
            checklistItemId: checklistItemId,
            contentType: BuiltValueNullFieldError.checkNotNull(
                contentType, r'InspectionMediaResponse', 'contentType'),
            filename: BuiltValueNullFieldError.checkNotNull(
                filename, r'InspectionMediaResponse', 'filename'),
            gpsLat: gpsLat,
            gpsLng: gpsLng,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'InspectionMediaResponse', 'id'),
            kind: BuiltValueNullFieldError.checkNotNull(
                kind, r'InspectionMediaResponse', 'kind'),
            localId: BuiltValueNullFieldError.checkNotNull(
                localId, r'InspectionMediaResponse', 'localId'),
            size: BuiltValueNullFieldError.checkNotNull(
                size, r'InspectionMediaResponse', 'size'),
            uploadedAt: BuiltValueNullFieldError.checkNotNull(
                uploadedAt, r'InspectionMediaResponse', 'uploadedAt'),
            uploadedBy:
                BuiltValueNullFieldError.checkNotNull(uploadedBy, r'InspectionMediaResponse', 'uploadedBy'),
            url: BuiltValueNullFieldError.checkNotNull(url, r'InspectionMediaResponse', 'url'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
