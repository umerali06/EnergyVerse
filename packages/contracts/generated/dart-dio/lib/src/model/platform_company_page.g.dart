// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_company_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PlatformCompanyPage extends PlatformCompanyPage {
  @override
  final BuiltList<PlatformCompanySummary> items;
  @override
  final String? nextCursor;

  factory _$PlatformCompanyPage(
          [void Function(PlatformCompanyPageBuilder)? updates]) =>
      (new PlatformCompanyPageBuilder()..update(updates))._build();

  _$PlatformCompanyPage._({required this.items, this.nextCursor}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        items, r'PlatformCompanyPage', 'items');
  }

  @override
  PlatformCompanyPage rebuild(
          void Function(PlatformCompanyPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlatformCompanyPageBuilder toBuilder() =>
      new PlatformCompanyPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlatformCompanyPage &&
        items == other.items &&
        nextCursor == other.nextCursor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlatformCompanyPage')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class PlatformCompanyPageBuilder
    implements Builder<PlatformCompanyPage, PlatformCompanyPageBuilder> {
  _$PlatformCompanyPage? _$v;

  ListBuilder<PlatformCompanySummary>? _items;
  ListBuilder<PlatformCompanySummary> get items =>
      _$this._items ??= new ListBuilder<PlatformCompanySummary>();
  set items(ListBuilder<PlatformCompanySummary>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  PlatformCompanyPageBuilder() {
    PlatformCompanyPage._defaults(this);
  }

  PlatformCompanyPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlatformCompanyPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PlatformCompanyPage;
  }

  @override
  void update(void Function(PlatformCompanyPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlatformCompanyPage build() => _build();

  _$PlatformCompanyPage _build() {
    _$PlatformCompanyPage _$result;
    try {
      _$result = _$v ??
          new _$PlatformCompanyPage._(
              items: items.build(), nextCursor: nextCursor);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PlatformCompanyPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
