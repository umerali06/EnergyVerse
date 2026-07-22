// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AreaDetail extends AreaDetail {
  @override
  final String? code;
  @override
  final DateTime createdAt;
  @override
  final String? description;
  @override
  final String facilityId;
  @override
  final String id;
  @override
  final String name;
  @override
  final DateTime updatedAt;

  factory _$AreaDetail([void Function(AreaDetailBuilder)? updates]) =>
      (new AreaDetailBuilder()..update(updates))._build();

  _$AreaDetail._(
      {this.code,
      required this.createdAt,
      this.description,
      required this.facilityId,
      required this.id,
      required this.name,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'AreaDetail', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        facilityId, r'AreaDetail', 'facilityId');
    BuiltValueNullFieldError.checkNotNull(id, r'AreaDetail', 'id');
    BuiltValueNullFieldError.checkNotNull(name, r'AreaDetail', 'name');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'AreaDetail', 'updatedAt');
  }

  @override
  AreaDetail rebuild(void Function(AreaDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AreaDetailBuilder toBuilder() => new AreaDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AreaDetail &&
        code == other.code &&
        createdAt == other.createdAt &&
        description == other.description &&
        facilityId == other.facilityId &&
        id == other.id &&
        name == other.name &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, facilityId.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AreaDetail')
          ..add('code', code)
          ..add('createdAt', createdAt)
          ..add('description', description)
          ..add('facilityId', facilityId)
          ..add('id', id)
          ..add('name', name)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class AreaDetailBuilder implements Builder<AreaDetail, AreaDetailBuilder> {
  _$AreaDetail? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _facilityId;
  String? get facilityId => _$this._facilityId;
  set facilityId(String? facilityId) => _$this._facilityId = facilityId;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  AreaDetailBuilder() {
    AreaDetail._defaults(this);
  }

  AreaDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _createdAt = $v.createdAt;
      _description = $v.description;
      _facilityId = $v.facilityId;
      _id = $v.id;
      _name = $v.name;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AreaDetail other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AreaDetail;
  }

  @override
  void update(void Function(AreaDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AreaDetail build() => _build();

  _$AreaDetail _build() {
    final _$result = _$v ??
        new _$AreaDetail._(
            code: code,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'AreaDetail', 'createdAt'),
            description: description,
            facilityId: BuiltValueNullFieldError.checkNotNull(
                facilityId, r'AreaDetail', 'facilityId'),
            id: BuiltValueNullFieldError.checkNotNull(id, r'AreaDetail', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'AreaDetail', 'name'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'AreaDetail', 'updatedAt'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
