// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permit_checklist_snapshot_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermitChecklistSnapshotResponse
    extends PermitChecklistSnapshotResponse {
  @override
  final bool completed;
  @override
  final DateTime? completedAt;
  @override
  final String? completedBy;
  @override
  final String? helpText;
  @override
  final String id;
  @override
  final String label;
  @override
  final bool required_;
  @override
  final String templateItemId;

  factory _$PermitChecklistSnapshotResponse(
          [void Function(PermitChecklistSnapshotResponseBuilder)? updates]) =>
      (new PermitChecklistSnapshotResponseBuilder()..update(updates))._build();

  _$PermitChecklistSnapshotResponse._(
      {required this.completed,
      this.completedAt,
      this.completedBy,
      this.helpText,
      required this.id,
      required this.label,
      required this.required_,
      required this.templateItemId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        completed, r'PermitChecklistSnapshotResponse', 'completed');
    BuiltValueNullFieldError.checkNotNull(
        id, r'PermitChecklistSnapshotResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        label, r'PermitChecklistSnapshotResponse', 'label');
    BuiltValueNullFieldError.checkNotNull(
        required_, r'PermitChecklistSnapshotResponse', 'required_');
    BuiltValueNullFieldError.checkNotNull(
        templateItemId, r'PermitChecklistSnapshotResponse', 'templateItemId');
  }

  @override
  PermitChecklistSnapshotResponse rebuild(
          void Function(PermitChecklistSnapshotResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermitChecklistSnapshotResponseBuilder toBuilder() =>
      new PermitChecklistSnapshotResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermitChecklistSnapshotResponse &&
        completed == other.completed &&
        completedAt == other.completedAt &&
        completedBy == other.completedBy &&
        helpText == other.helpText &&
        id == other.id &&
        label == other.label &&
        required_ == other.required_ &&
        templateItemId == other.templateItemId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, completed.hashCode);
    _$hash = $jc(_$hash, completedAt.hashCode);
    _$hash = $jc(_$hash, completedBy.hashCode);
    _$hash = $jc(_$hash, helpText.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, required_.hashCode);
    _$hash = $jc(_$hash, templateItemId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PermitChecklistSnapshotResponse')
          ..add('completed', completed)
          ..add('completedAt', completedAt)
          ..add('completedBy', completedBy)
          ..add('helpText', helpText)
          ..add('id', id)
          ..add('label', label)
          ..add('required_', required_)
          ..add('templateItemId', templateItemId))
        .toString();
  }
}

class PermitChecklistSnapshotResponseBuilder
    implements
        Builder<PermitChecklistSnapshotResponse,
            PermitChecklistSnapshotResponseBuilder> {
  _$PermitChecklistSnapshotResponse? _$v;

  bool? _completed;
  bool? get completed => _$this._completed;
  set completed(bool? completed) => _$this._completed = completed;

  DateTime? _completedAt;
  DateTime? get completedAt => _$this._completedAt;
  set completedAt(DateTime? completedAt) => _$this._completedAt = completedAt;

  String? _completedBy;
  String? get completedBy => _$this._completedBy;
  set completedBy(String? completedBy) => _$this._completedBy = completedBy;

  String? _helpText;
  String? get helpText => _$this._helpText;
  set helpText(String? helpText) => _$this._helpText = helpText;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  bool? _required_;
  bool? get required_ => _$this._required_;
  set required_(bool? required_) => _$this._required_ = required_;

  String? _templateItemId;
  String? get templateItemId => _$this._templateItemId;
  set templateItemId(String? templateItemId) =>
      _$this._templateItemId = templateItemId;

  PermitChecklistSnapshotResponseBuilder() {
    PermitChecklistSnapshotResponse._defaults(this);
  }

  PermitChecklistSnapshotResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _completed = $v.completed;
      _completedAt = $v.completedAt;
      _completedBy = $v.completedBy;
      _helpText = $v.helpText;
      _id = $v.id;
      _label = $v.label;
      _required_ = $v.required_;
      _templateItemId = $v.templateItemId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermitChecklistSnapshotResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermitChecklistSnapshotResponse;
  }

  @override
  void update(void Function(PermitChecklistSnapshotResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermitChecklistSnapshotResponse build() => _build();

  _$PermitChecklistSnapshotResponse _build() {
    final _$result = _$v ??
        new _$PermitChecklistSnapshotResponse._(
            completed: BuiltValueNullFieldError.checkNotNull(
                completed, r'PermitChecklistSnapshotResponse', 'completed'),
            completedAt: completedAt,
            completedBy: completedBy,
            helpText: helpText,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PermitChecklistSnapshotResponse', 'id'),
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'PermitChecklistSnapshotResponse', 'label'),
            required_: BuiltValueNullFieldError.checkNotNull(
                required_, r'PermitChecklistSnapshotResponse', 'required_'),
            templateItemId: BuiltValueNullFieldError.checkNotNull(
                templateItemId,
                r'PermitChecklistSnapshotResponse',
                'templateItemId'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
