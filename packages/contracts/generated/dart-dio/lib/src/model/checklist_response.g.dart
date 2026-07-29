// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChecklistResponse extends ChecklistResponse {
  @override
  final DateTime? answeredAt;
  @override
  final String? answeredBy;
  @override
  final String itemId;
  @override
  final String? note;
  @override
  final Value? value;

  factory _$ChecklistResponse(
          [void Function(ChecklistResponseBuilder)? updates]) =>
      (new ChecklistResponseBuilder()..update(updates))._build();

  _$ChecklistResponse._(
      {this.answeredAt,
      this.answeredBy,
      required this.itemId,
      this.note,
      this.value})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        itemId, r'ChecklistResponse', 'itemId');
  }

  @override
  ChecklistResponse rebuild(void Function(ChecklistResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChecklistResponseBuilder toBuilder() =>
      new ChecklistResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChecklistResponse &&
        answeredAt == other.answeredAt &&
        answeredBy == other.answeredBy &&
        itemId == other.itemId &&
        note == other.note &&
        value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, answeredAt.hashCode);
    _$hash = $jc(_$hash, answeredBy.hashCode);
    _$hash = $jc(_$hash, itemId.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChecklistResponse')
          ..add('answeredAt', answeredAt)
          ..add('answeredBy', answeredBy)
          ..add('itemId', itemId)
          ..add('note', note)
          ..add('value', value))
        .toString();
  }
}

class ChecklistResponseBuilder
    implements Builder<ChecklistResponse, ChecklistResponseBuilder> {
  _$ChecklistResponse? _$v;

  DateTime? _answeredAt;
  DateTime? get answeredAt => _$this._answeredAt;
  set answeredAt(DateTime? answeredAt) => _$this._answeredAt = answeredAt;

  String? _answeredBy;
  String? get answeredBy => _$this._answeredBy;
  set answeredBy(String? answeredBy) => _$this._answeredBy = answeredBy;

  String? _itemId;
  String? get itemId => _$this._itemId;
  set itemId(String? itemId) => _$this._itemId = itemId;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  ValueBuilder? _value;
  ValueBuilder get value => _$this._value ??= new ValueBuilder();
  set value(ValueBuilder? value) => _$this._value = value;

  ChecklistResponseBuilder() {
    ChecklistResponse._defaults(this);
  }

  ChecklistResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _answeredAt = $v.answeredAt;
      _answeredBy = $v.answeredBy;
      _itemId = $v.itemId;
      _note = $v.note;
      _value = $v.value?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChecklistResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChecklistResponse;
  }

  @override
  void update(void Function(ChecklistResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChecklistResponse build() => _build();

  _$ChecklistResponse _build() {
    _$ChecklistResponse _$result;
    try {
      _$result = _$v ??
          new _$ChecklistResponse._(
              answeredAt: answeredAt,
              answeredBy: answeredBy,
              itemId: BuiltValueNullFieldError.checkNotNull(
                  itemId, r'ChecklistResponse', 'itemId'),
              note: note,
              value: _value?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'value';
        _value?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ChecklistResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
