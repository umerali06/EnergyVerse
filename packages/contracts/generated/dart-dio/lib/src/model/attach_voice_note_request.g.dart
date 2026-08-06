// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attach_voice_note_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AttachVoiceNoteRequest extends AttachVoiceNoteRequest {
  @override
  final String? checklistItemId;
  @override
  final String contentType;
  @override
  final int durationMs;
  @override
  final String filename;
  @override
  final String localId;
  @override
  final int size;

  factory _$AttachVoiceNoteRequest(
          [void Function(AttachVoiceNoteRequestBuilder)? updates]) =>
      (new AttachVoiceNoteRequestBuilder()..update(updates))._build();

  _$AttachVoiceNoteRequest._(
      {this.checklistItemId,
      required this.contentType,
      required this.durationMs,
      required this.filename,
      required this.localId,
      required this.size})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        contentType, r'AttachVoiceNoteRequest', 'contentType');
    BuiltValueNullFieldError.checkNotNull(
        durationMs, r'AttachVoiceNoteRequest', 'durationMs');
    BuiltValueNullFieldError.checkNotNull(
        filename, r'AttachVoiceNoteRequest', 'filename');
    BuiltValueNullFieldError.checkNotNull(
        localId, r'AttachVoiceNoteRequest', 'localId');
    BuiltValueNullFieldError.checkNotNull(
        size, r'AttachVoiceNoteRequest', 'size');
  }

  @override
  AttachVoiceNoteRequest rebuild(
          void Function(AttachVoiceNoteRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AttachVoiceNoteRequestBuilder toBuilder() =>
      new AttachVoiceNoteRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AttachVoiceNoteRequest &&
        checklistItemId == other.checklistItemId &&
        contentType == other.contentType &&
        durationMs == other.durationMs &&
        filename == other.filename &&
        localId == other.localId &&
        size == other.size;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, checklistItemId.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, durationMs.hashCode);
    _$hash = $jc(_$hash, filename.hashCode);
    _$hash = $jc(_$hash, localId.hashCode);
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AttachVoiceNoteRequest')
          ..add('checklistItemId', checklistItemId)
          ..add('contentType', contentType)
          ..add('durationMs', durationMs)
          ..add('filename', filename)
          ..add('localId', localId)
          ..add('size', size))
        .toString();
  }
}

class AttachVoiceNoteRequestBuilder
    implements Builder<AttachVoiceNoteRequest, AttachVoiceNoteRequestBuilder> {
  _$AttachVoiceNoteRequest? _$v;

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

  String? _localId;
  String? get localId => _$this._localId;
  set localId(String? localId) => _$this._localId = localId;

  int? _size;
  int? get size => _$this._size;
  set size(int? size) => _$this._size = size;

  AttachVoiceNoteRequestBuilder() {
    AttachVoiceNoteRequest._defaults(this);
  }

  AttachVoiceNoteRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _checklistItemId = $v.checklistItemId;
      _contentType = $v.contentType;
      _durationMs = $v.durationMs;
      _filename = $v.filename;
      _localId = $v.localId;
      _size = $v.size;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AttachVoiceNoteRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AttachVoiceNoteRequest;
  }

  @override
  void update(void Function(AttachVoiceNoteRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AttachVoiceNoteRequest build() => _build();

  _$AttachVoiceNoteRequest _build() {
    final _$result = _$v ??
        new _$AttachVoiceNoteRequest._(
            checklistItemId: checklistItemId,
            contentType: BuiltValueNullFieldError.checkNotNull(
                contentType, r'AttachVoiceNoteRequest', 'contentType'),
            durationMs: BuiltValueNullFieldError.checkNotNull(
                durationMs, r'AttachVoiceNoteRequest', 'durationMs'),
            filename: BuiltValueNullFieldError.checkNotNull(
                filename, r'AttachVoiceNoteRequest', 'filename'),
            localId: BuiltValueNullFieldError.checkNotNull(
                localId, r'AttachVoiceNoteRequest', 'localId'),
            size: BuiltValueNullFieldError.checkNotNull(
                size, r'AttachVoiceNoteRequest', 'size'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
