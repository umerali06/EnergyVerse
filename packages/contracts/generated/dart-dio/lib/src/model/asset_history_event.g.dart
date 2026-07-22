// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_history_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AssetHistoryEvent extends AssetHistoryEvent {
  @override
  final String id;
  @override
  final DateTime occurredAt;
  @override
  final String summary;
  @override
  final String type;

  factory _$AssetHistoryEvent(
          [void Function(AssetHistoryEventBuilder)? updates]) =>
      (new AssetHistoryEventBuilder()..update(updates))._build();

  _$AssetHistoryEvent._(
      {required this.id,
      required this.occurredAt,
      required this.summary,
      required this.type})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'AssetHistoryEvent', 'id');
    BuiltValueNullFieldError.checkNotNull(
        occurredAt, r'AssetHistoryEvent', 'occurredAt');
    BuiltValueNullFieldError.checkNotNull(
        summary, r'AssetHistoryEvent', 'summary');
    BuiltValueNullFieldError.checkNotNull(type, r'AssetHistoryEvent', 'type');
  }

  @override
  AssetHistoryEvent rebuild(void Function(AssetHistoryEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssetHistoryEventBuilder toBuilder() =>
      new AssetHistoryEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssetHistoryEvent &&
        id == other.id &&
        occurredAt == other.occurredAt &&
        summary == other.summary &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssetHistoryEvent')
          ..add('id', id)
          ..add('occurredAt', occurredAt)
          ..add('summary', summary)
          ..add('type', type))
        .toString();
  }
}

class AssetHistoryEventBuilder
    implements Builder<AssetHistoryEvent, AssetHistoryEventBuilder> {
  _$AssetHistoryEvent? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  String? _summary;
  String? get summary => _$this._summary;
  set summary(String? summary) => _$this._summary = summary;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  AssetHistoryEventBuilder() {
    AssetHistoryEvent._defaults(this);
  }

  AssetHistoryEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _occurredAt = $v.occurredAt;
      _summary = $v.summary;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssetHistoryEvent other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AssetHistoryEvent;
  }

  @override
  void update(void Function(AssetHistoryEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssetHistoryEvent build() => _build();

  _$AssetHistoryEvent _build() {
    final _$result = _$v ??
        new _$AssetHistoryEvent._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AssetHistoryEvent', 'id'),
            occurredAt: BuiltValueNullFieldError.checkNotNull(
                occurredAt, r'AssetHistoryEvent', 'occurredAt'),
            summary: BuiltValueNullFieldError.checkNotNull(
                summary, r'AssetHistoryEvent', 'summary'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'AssetHistoryEvent', 'type'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
