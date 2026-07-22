// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuditLogPage extends AuditLogPage {
  @override
  final BuiltList<AuditLogEntry> items;
  @override
  final String? nextCursor;
  @override
  final bool truncated;

  factory _$AuditLogPage([void Function(AuditLogPageBuilder)? updates]) =>
      (new AuditLogPageBuilder()..update(updates))._build();

  _$AuditLogPage._(
      {required this.items, this.nextCursor, required this.truncated})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(items, r'AuditLogPage', 'items');
    BuiltValueNullFieldError.checkNotNull(
        truncated, r'AuditLogPage', 'truncated');
  }

  @override
  AuditLogPage rebuild(void Function(AuditLogPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuditLogPageBuilder toBuilder() => new AuditLogPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuditLogPage &&
        items == other.items &&
        nextCursor == other.nextCursor &&
        truncated == other.truncated;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, truncated.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuditLogPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('truncated', truncated))
        .toString();
  }
}

class AuditLogPageBuilder
    implements Builder<AuditLogPage, AuditLogPageBuilder> {
  _$AuditLogPage? _$v;

  ListBuilder<AuditLogEntry>? _items;
  ListBuilder<AuditLogEntry> get items =>
      _$this._items ??= new ListBuilder<AuditLogEntry>();
  set items(ListBuilder<AuditLogEntry>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  bool? _truncated;
  bool? get truncated => _$this._truncated;
  set truncated(bool? truncated) => _$this._truncated = truncated;

  AuditLogPageBuilder() {
    AuditLogPage._defaults(this);
  }

  AuditLogPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _truncated = $v.truncated;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuditLogPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AuditLogPage;
  }

  @override
  void update(void Function(AuditLogPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuditLogPage build() => _build();

  _$AuditLogPage _build() {
    _$AuditLogPage _$result;
    try {
      _$result = _$v ??
          new _$AuditLogPage._(
              items: items.build(),
              nextCursor: nextCursor,
              truncated: BuiltValueNullFieldError.checkNotNull(
                  truncated, r'AuditLogPage', 'truncated'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AuditLogPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
