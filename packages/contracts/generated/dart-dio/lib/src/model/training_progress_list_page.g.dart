// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_progress_list_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TrainingProgressListPage extends TrainingProgressListPage {
  @override
  final BuiltList<TrainingProgressResponse>? items;

  factory _$TrainingProgressListPage(
          [void Function(TrainingProgressListPageBuilder)? updates]) =>
      (new TrainingProgressListPageBuilder()..update(updates))._build();

  _$TrainingProgressListPage._({this.items}) : super._();

  @override
  TrainingProgressListPage rebuild(
          void Function(TrainingProgressListPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TrainingProgressListPageBuilder toBuilder() =>
      new TrainingProgressListPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TrainingProgressListPage && items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TrainingProgressListPage')
          ..add('items', items))
        .toString();
  }
}

class TrainingProgressListPageBuilder
    implements
        Builder<TrainingProgressListPage, TrainingProgressListPageBuilder> {
  _$TrainingProgressListPage? _$v;

  ListBuilder<TrainingProgressResponse>? _items;
  ListBuilder<TrainingProgressResponse> get items =>
      _$this._items ??= new ListBuilder<TrainingProgressResponse>();
  set items(ListBuilder<TrainingProgressResponse>? items) =>
      _$this._items = items;

  TrainingProgressListPageBuilder() {
    TrainingProgressListPage._defaults(this);
  }

  TrainingProgressListPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TrainingProgressListPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$TrainingProgressListPage;
  }

  @override
  void update(void Function(TrainingProgressListPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TrainingProgressListPage build() => _build();

  _$TrainingProgressListPage _build() {
    _$TrainingProgressListPage _$result;
    try {
      _$result =
          _$v ?? new _$TrainingProgressListPage._(items: _items?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        _items?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'TrainingProgressListPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
