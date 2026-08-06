// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_note_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VoiceNoteResponse extends VoiceNoteResponse {
  @override
  final String? checklistItemId;
  @override
  final String contentType;
  @override
  final int durationMs;
  @override
  final String filename;
  @override
  final String id;
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

  factory _$VoiceNoteResponse(
          [void Function(VoiceNoteResponseBuilder)? updates]) =>
      (new VoiceNoteResponseBuilder()..update(updates))._build();

  _$VoiceNoteResponse._(
      {this.checklistItemId,
      required this.contentType,
      required this.durationMs,
      required this.filename,
      required this.id,
      required this.localId,
      required this.size,
      required this.uploadedAt,
      required this.uploadedBy,
      required this.url})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        contentType, r'VoiceNoteResponse', 'contentType');
    BuiltValueNullFieldError.checkNotNull(
        durationMs, r'VoiceNoteResponse', 'durationMs');
    BuiltValueNullFieldError.checkNotNull(
        filename, r'VoiceNoteResponse', 'filename');
    BuiltValueNullFieldError.checkNotNull(id, r'VoiceNoteResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        localId, r'VoiceNoteResponse', 'localId');
    BuiltValueNullFieldError.checkNotNull(size, r'VoiceNoteResponse', 'size');
    BuiltValueNullFieldError.checkNotNull(
        uploadedAt, r'VoiceNoteResponse', 'uploadedAt');
    BuiltValueNullFieldError.checkNotNull(
        uploadedBy, r'VoiceNoteResponse', 'uploadedBy');
    BuiltValueNullFieldError.checkNotNull(url, r'VoiceNoteResponse', 'url');
  }

  @override
  VoiceNoteResponse rebuild(void Function(VoiceNoteResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VoiceNoteResponseBuilder toBuilder() =>
      new VoiceNoteResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VoiceNoteResponse &&
        checklistItemId == other.checklistItemId &&
        contentType == other.contentType &&
        durationMs == other.durationMs &&
        filename == other.filename &&
        id == other.id &&
        localId == other.localId &&
        size == other.size &&
        uploadedAt == other.uploadedAt &&
        uploadedBy == other.uploadedBy &&
        url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, checklistItemId.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, durationMs.hashCode);
    _$hash = $jc(_$hash, filename.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
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
    return (newBuiltValueToStringHelper(r'VoiceNoteResponse')
          ..add('checklistItemId', checklistItemId)
          ..add('contentType', contentType)
          ..add('durationMs', durationMs)
          ..add('filename', filename)
          ..add('id', id)
          ..add('localId', localId)
          ..add('size', size)
          ..add('uploadedAt', uploadedAt)
          ..add('uploadedBy', uploadedBy)
          ..add('url', url))
        .toString();
  }
}

class VoiceNoteResponseBuilder
    implements Builder<VoiceNoteResponse, VoiceNoteResponseBuilder> {
  _$VoiceNoteResponse? _$v;

  String? _checklistItemId;
  String? get checklistItemId => _$this._checklistItemId;
  set checklistItemId(String? checklistItemId) =>
      _$this._checklistItemId = checklistItemId;

  String? _contentType;
  String? get contentType => _$this._contentType;
  set contentType(String? contentType) => _$this._contentType = contentType;

  int? _durationMs;
  int? get durationMs => _$this._durationMs;
  set durationMs(int? durationMs) => _$this._durationMs = durationMs;

  String? _filename;
  String? get filename => _$this._filename;
  set filename(String? filename) => _$this._filename = filename;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  VoiceNoteResponseBuilder() {
    VoiceNoteResponse._defaults(this);
  }

  VoiceNoteResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _checklistItemId = $v.checklistItemId;
      _contentType = $v.contentType;
      _durationMs = $v.durationMs;
      _filename = $v.filename;
      _id = $v.id;
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
  void replace(VoiceNoteResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$VoiceNoteResponse;
  }

  @override
  void update(void Function(VoiceNoteResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VoiceNoteResponse build() => _build();

  _$VoiceNoteResponse _build() {
    final _$result = _$v ??
        new _$VoiceNoteResponse._(
            checklistItemId: checklistItemId,
            contentType: BuiltValueNullFieldError.checkNotNull(
                contentType, r'VoiceNoteResponse', 'contentType'),
            durationMs: BuiltValueNullFieldError.checkNotNull(
                durationMs, r'VoiceNoteResponse', 'durationMs'),
            filename: BuiltValueNullFieldError.checkNotNull(
                filename, r'VoiceNoteResponse', 'filename'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'VoiceNoteResponse', 'id'),
            localId: BuiltValueNullFieldError.checkNotNull(
                localId, r'VoiceNoteResponse', 'localId'),
            size: BuiltValueNullFieldError.checkNotNull(
                size, r'VoiceNoteResponse', 'size'),
            uploadedAt: BuiltValueNullFieldError.checkNotNull(
                uploadedAt, r'VoiceNoteResponse', 'uploadedAt'),
            uploadedBy: BuiltValueNullFieldError.checkNotNull(
                uploadedBy, r'VoiceNoteResponse', 'uploadedBy'),
            url: BuiltValueNullFieldError.checkNotNull(
                url, r'VoiceNoteResponse', 'url'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
