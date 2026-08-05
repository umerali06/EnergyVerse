// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attach_inspection_media_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AttachInspectionMediaRequestBeforeAfterTagEnum
    _$attachInspectionMediaRequestBeforeAfterTagEnum_before =
    const AttachInspectionMediaRequestBeforeAfterTagEnum._('before');
const AttachInspectionMediaRequestBeforeAfterTagEnum
    _$attachInspectionMediaRequestBeforeAfterTagEnum_after =
    const AttachInspectionMediaRequestBeforeAfterTagEnum._('after');

AttachInspectionMediaRequestBeforeAfterTagEnum
    _$attachInspectionMediaRequestBeforeAfterTagEnumValueOf(String name) {
  switch (name) {
    case 'before':
      return _$attachInspectionMediaRequestBeforeAfterTagEnum_before;
    case 'after':
      return _$attachInspectionMediaRequestBeforeAfterTagEnum_after;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<AttachInspectionMediaRequestBeforeAfterTagEnum>
    _$attachInspectionMediaRequestBeforeAfterTagEnumValues = new BuiltSet<
        AttachInspectionMediaRequestBeforeAfterTagEnum>(const <AttachInspectionMediaRequestBeforeAfterTagEnum>[
  _$attachInspectionMediaRequestBeforeAfterTagEnum_before,
  _$attachInspectionMediaRequestBeforeAfterTagEnum_after,
]);

const AttachInspectionMediaRequestKindEnum
    _$attachInspectionMediaRequestKindEnum_photo =
    const AttachInspectionMediaRequestKindEnum._('photo');
const AttachInspectionMediaRequestKindEnum
    _$attachInspectionMediaRequestKindEnum_video =
    const AttachInspectionMediaRequestKindEnum._('video');

AttachInspectionMediaRequestKindEnum
    _$attachInspectionMediaRequestKindEnumValueOf(String name) {
  switch (name) {
    case 'photo':
      return _$attachInspectionMediaRequestKindEnum_photo;
    case 'video':
      return _$attachInspectionMediaRequestKindEnum_video;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<AttachInspectionMediaRequestKindEnum>
    _$attachInspectionMediaRequestKindEnumValues = new BuiltSet<
        AttachInspectionMediaRequestKindEnum>(const <AttachInspectionMediaRequestKindEnum>[
  _$attachInspectionMediaRequestKindEnum_photo,
  _$attachInspectionMediaRequestKindEnum_video,
]);

Serializer<AttachInspectionMediaRequestBeforeAfterTagEnum>
    _$attachInspectionMediaRequestBeforeAfterTagEnumSerializer =
    new _$AttachInspectionMediaRequestBeforeAfterTagEnumSerializer();
Serializer<AttachInspectionMediaRequestKindEnum>
    _$attachInspectionMediaRequestKindEnumSerializer =
    new _$AttachInspectionMediaRequestKindEnumSerializer();

class _$AttachInspectionMediaRequestBeforeAfterTagEnumSerializer
    implements
        PrimitiveSerializer<AttachInspectionMediaRequestBeforeAfterTagEnum> {
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
    AttachInspectionMediaRequestBeforeAfterTagEnum
  ];
  @override
  final String wireName = 'AttachInspectionMediaRequestBeforeAfterTagEnum';

  @override
  Object serialize(Serializers serializers,
          AttachInspectionMediaRequestBeforeAfterTagEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AttachInspectionMediaRequestBeforeAfterTagEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AttachInspectionMediaRequestBeforeAfterTagEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AttachInspectionMediaRequestKindEnumSerializer
    implements PrimitiveSerializer<AttachInspectionMediaRequestKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'photo': 'photo',
    'video': 'video',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'photo': 'photo',
    'video': 'video',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AttachInspectionMediaRequestKindEnum
  ];
  @override
  final String wireName = 'AttachInspectionMediaRequestKindEnum';

  @override
  Object serialize(
          Serializers serializers, AttachInspectionMediaRequestKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AttachInspectionMediaRequestKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AttachInspectionMediaRequestKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AttachInspectionMediaRequest extends AttachInspectionMediaRequest {
  @override
  final AttachInspectionMediaRequestBeforeAfterTagEnum? beforeAfterTag;
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
  final AttachInspectionMediaRequestKindEnum kind;
  @override
  final String localId;
  @override
  final int size;

  factory _$AttachInspectionMediaRequest(
          [void Function(AttachInspectionMediaRequestBuilder)? updates]) =>
      (new AttachInspectionMediaRequestBuilder()..update(updates))._build();

  _$AttachInspectionMediaRequest._(
      {this.beforeAfterTag,
      required this.capturedAt,
      this.checklistItemId,
      required this.contentType,
      required this.filename,
      this.gpsLat,
      this.gpsLng,
      required this.kind,
      required this.localId,
      required this.size})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        capturedAt, r'AttachInspectionMediaRequest', 'capturedAt');
    BuiltValueNullFieldError.checkNotNull(
        contentType, r'AttachInspectionMediaRequest', 'contentType');
    BuiltValueNullFieldError.checkNotNull(
        filename, r'AttachInspectionMediaRequest', 'filename');
    BuiltValueNullFieldError.checkNotNull(
        kind, r'AttachInspectionMediaRequest', 'kind');
    BuiltValueNullFieldError.checkNotNull(
        localId, r'AttachInspectionMediaRequest', 'localId');
    BuiltValueNullFieldError.checkNotNull(
        size, r'AttachInspectionMediaRequest', 'size');
  }

  @override
  AttachInspectionMediaRequest rebuild(
          void Function(AttachInspectionMediaRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AttachInspectionMediaRequestBuilder toBuilder() =>
      new AttachInspectionMediaRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AttachInspectionMediaRequest &&
        beforeAfterTag == other.beforeAfterTag &&
        capturedAt == other.capturedAt &&
        checklistItemId == other.checklistItemId &&
        contentType == other.contentType &&
        filename == other.filename &&
        gpsLat == other.gpsLat &&
        gpsLng == other.gpsLng &&
        kind == other.kind &&
        localId == other.localId &&
        size == other.size;
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
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, localId.hashCode);
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AttachInspectionMediaRequest')
          ..add('beforeAfterTag', beforeAfterTag)
          ..add('capturedAt', capturedAt)
          ..add('checklistItemId', checklistItemId)
          ..add('contentType', contentType)
          ..add('filename', filename)
          ..add('gpsLat', gpsLat)
          ..add('gpsLng', gpsLng)
          ..add('kind', kind)
          ..add('localId', localId)
          ..add('size', size))
        .toString();
  }
}

class AttachInspectionMediaRequestBuilder
    implements
        Builder<AttachInspectionMediaRequest,
            AttachInspectionMediaRequestBuilder> {
  _$AttachInspectionMediaRequest? _$v;

  AttachInspectionMediaRequestBeforeAfterTagEnum? _beforeAfterTag;
  AttachInspectionMediaRequestBeforeAfterTagEnum? get beforeAfterTag =>
      _$this._beforeAfterTag;
  set beforeAfterTag(
          AttachInspectionMediaRequestBeforeAfterTagEnum? beforeAfterTag) =>
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

  AttachInspectionMediaRequestKindEnum? _kind;
  AttachInspectionMediaRequestKindEnum? get kind => _$this._kind;
  set kind(AttachInspectionMediaRequestKindEnum? kind) => _$this._kind = kind;

  String? _localId;
  String? get localId => _$this._localId;
  set localId(String? localId) => _$this._localId = localId;

  int? _size;
  int? get size => _$this._size;
  set size(int? size) => _$this._size = size;

  AttachInspectionMediaRequestBuilder() {
    AttachInspectionMediaRequest._defaults(this);
  }

  AttachInspectionMediaRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _beforeAfterTag = $v.beforeAfterTag;
      _capturedAt = $v.capturedAt;
      _checklistItemId = $v.checklistItemId;
      _contentType = $v.contentType;
      _filename = $v.filename;
      _gpsLat = $v.gpsLat;
      _gpsLng = $v.gpsLng;
      _kind = $v.kind;
      _localId = $v.localId;
      _size = $v.size;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AttachInspectionMediaRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AttachInspectionMediaRequest;
  }

  @override
  void update(void Function(AttachInspectionMediaRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AttachInspectionMediaRequest build() => _build();

  _$AttachInspectionMediaRequest _build() {
    final _$result = _$v ??
        new _$AttachInspectionMediaRequest._(
            beforeAfterTag: beforeAfterTag,
            capturedAt: BuiltValueNullFieldError.checkNotNull(
                capturedAt, r'AttachInspectionMediaRequest', 'capturedAt'),
            checklistItemId: checklistItemId,
            contentType: BuiltValueNullFieldError.checkNotNull(
                contentType, r'AttachInspectionMediaRequest', 'contentType'),
            filename: BuiltValueNullFieldError.checkNotNull(
                filename, r'AttachInspectionMediaRequest', 'filename'),
            gpsLat: gpsLat,
            gpsLng: gpsLng,
            kind: BuiltValueNullFieldError.checkNotNull(
                kind, r'AttachInspectionMediaRequest', 'kind'),
            localId: BuiltValueNullFieldError.checkNotNull(
                localId, r'AttachInspectionMediaRequest', 'localId'),
            size: BuiltValueNullFieldError.checkNotNull(
                size, r'AttachInspectionMediaRequest', 'size'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
