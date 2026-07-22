// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_deleted.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AssetDeleted extends AssetDeleted {
  @override
  final bool? deleted;
  @override
  final String id;

  factory _$AssetDeleted([void Function(AssetDeletedBuilder)? updates]) =>
      (new AssetDeletedBuilder()..update(updates))._build();

  _$AssetDeleted._({this.deleted, required this.id}) : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'AssetDeleted', 'id');
  }

  @override
  AssetDeleted rebuild(void Function(AssetDeletedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssetDeletedBuilder toBuilder() => new AssetDeletedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssetDeleted && deleted == other.deleted && id == other.id;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, deleted.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssetDeleted')
          ..add('deleted', deleted)
          ..add('id', id))
        .toString();
  }
}

class AssetDeletedBuilder
    implements Builder<AssetDeleted, AssetDeletedBuilder> {
  _$AssetDeleted? _$v;

  bool? _deleted;
  bool? get deleted => _$this._deleted;
  set deleted(bool? deleted) => _$this._deleted = deleted;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AssetDeletedBuilder() {
    AssetDeleted._defaults(this);
  }

  AssetDeletedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deleted = $v.deleted;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssetDeleted other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AssetDeleted;
  }

  @override
  void update(void Function(AssetDeletedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssetDeleted build() => _build();

  _$AssetDeleted _build() {
    final _$result = _$v ??
        new _$AssetDeleted._(
            deleted: deleted,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AssetDeleted', 'id'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
