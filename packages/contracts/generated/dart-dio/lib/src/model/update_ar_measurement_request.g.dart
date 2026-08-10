// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_ar_measurement_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateArMeasurementRequest extends UpdateArMeasurementRequest {
  @override
  final String? checklistItemId;
  @override
  final String? label;
  @override
  final String? note;

  factory _$UpdateArMeasurementRequest(
          [void Function(UpdateArMeasurementRequestBuilder)? updates]) =>
      (new UpdateArMeasurementRequestBuilder()..update(updates))._build();

  _$UpdateArMeasurementRequest._({this.checklistItemId, this.label, this.note})
      : super._();

  @override
  UpdateArMeasurementRequest rebuild(
          void Function(UpdateArMeasurementRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateArMeasurementRequestBuilder toBuilder() =>
      new UpdateArMeasurementRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateArMeasurementRequest &&
        checklistItemId == other.checklistItemId &&
        label == other.label &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, checklistItemId.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateArMeasurementRequest')
          ..add('checklistItemId', checklistItemId)
          ..add('label', label)
          ..add('note', note))
        .toString();
  }
}

class UpdateArMeasurementRequestBuilder
    implements
        Builder<UpdateArMeasurementRequest, UpdateArMeasurementRequestBuilder> {
  _$UpdateArMeasurementRequest? _$v;

  String? _checklistItemId;
  String? get checklistItemId => _$this._checklistItemId;
  set checklistItemId(String? checklistItemId) =>
      _$this._checklistItemId = checklistItemId;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  UpdateArMeasurementRequestBuilder() {
    UpdateArMeasurementRequest._defaults(this);
  }

  UpdateArMeasurementRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _checklistItemId = $v.checklistItemId;
      _label = $v.label;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateArMeasurementRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateArMeasurementRequest;
  }

  @override
  void update(void Function(UpdateArMeasurementRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateArMeasurementRequest build() => _build();

  _$UpdateArMeasurementRequest _build() {
    final _$result = _$v ??
        new _$UpdateArMeasurementRequest._(
            checklistItemId: checklistItemId, label: label, note: note);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
