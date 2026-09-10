// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_module_list_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TrainingModuleListPage extends TrainingModuleListPage {
  @override
  final BuiltList<TrainingModuleResponse>? items;

  factory _$TrainingModuleListPage(
          [void Function(TrainingModuleListPageBuilder)? updates]) =>
      (new TrainingModuleListPageBuilder()..update(updates))._build();

  _$TrainingModuleListPage._({this.items}) : super._();

  @override
  TrainingModuleListPage rebuild(
          void Function(TrainingModuleListPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TrainingModuleListPageBuilder toBuilder() =>
      new TrainingModuleListPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TrainingModuleListPage && items == other.items;
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
    return (newBuiltValueToStringHelper(r'TrainingModuleListPage')
          ..add('items', items))
        .toString();
  }
}

class TrainingModuleListPageBuilder
    implements Builder<TrainingModuleListPage, TrainingModuleListPageBuilder> {
  _$TrainingModuleListPage? _$v;

  ListBuilder<TrainingModuleResponse>? _items;
  ListBuilder<TrainingModuleResponse> get items =>
      _$this._items ??= new ListBuilder<TrainingModuleResponse>();
  set items(ListBuilder<TrainingModuleResponse>? items) =>
      _$this._items = items;

  TrainingModuleListPageBuilder() {
    TrainingModuleListPage._defaults(this);
  }

  TrainingModuleListPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TrainingModuleListPage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$TrainingModuleListPage;
  }

  @override
  void update(void Function(TrainingModuleListPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TrainingModuleListPage build() => _build();

  _$TrainingModuleListPage _build() {
    _$TrainingModuleListPage _$result;
    try {
      _$result = _$v ?? new _$TrainingModuleListPage._(items: _items?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        _items?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'TrainingModuleListPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
