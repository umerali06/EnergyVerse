// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_voice_note_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateVoiceNoteRequest extends UpdateVoiceNoteRequest {
  @override
  final String? checklistItemId;

  factory _$UpdateVoiceNoteRequest(
          [void Function(UpdateVoiceNoteRequestBuilder)? updates]) =>
      (new UpdateVoiceNoteRequestBuilder()..update(updates))._build();

  _$UpdateVoiceNoteRequest._({this.checklistItemId}) : super._();

  @override
  UpdateVoiceNoteRequest rebuild(
          void Function(UpdateVoiceNoteRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateVoiceNoteRequestBuilder toBuilder() =>
      new UpdateVoiceNoteRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateVoiceNoteRequest &&
        checklistItemId == other.checklistItemId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, checklistItemId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateVoiceNoteRequest')
          ..add('checklistItemId', checklistItemId))
        .toString();
  }
}

class UpdateVoiceNoteRequestBuilder
    implements Builder<UpdateVoiceNoteRequest, UpdateVoiceNoteRequestBuilder> {
  _$UpdateVoiceNoteRequest? _$v;

  String? _checklistItemId;
  String? get checklistItemId => _$this._checklistItemId;
  set checklistItemId(String? checklistItemId) =>
      _$this._checklistItemId = checklistItemId;

  UpdateVoiceNoteRequestBuilder() {
    UpdateVoiceNoteRequest._defaults(this);
  }

  UpdateVoiceNoteRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _checklistItemId = $v.checklistItemId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateVoiceNoteRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateVoiceNoteRequest;
  }

  @override
  void update(void Function(UpdateVoiceNoteRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateVoiceNoteRequest build() => _build();

  _$UpdateVoiceNoteRequest _build() {
    final _$result =
        _$v ?? new _$UpdateVoiceNoteRequest._(checklistItemId: checklistItemId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
