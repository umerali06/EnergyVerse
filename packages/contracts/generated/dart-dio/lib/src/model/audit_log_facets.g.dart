// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_facets.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuditLogFacets extends AuditLogFacets {
  @override
  final BuiltList<String> actions;
  @override
  final BuiltList<String> targetTypes;

  factory _$AuditLogFacets([void Function(AuditLogFacetsBuilder)? updates]) =>
      (new AuditLogFacetsBuilder()..update(updates))._build();

  _$AuditLogFacets._({required this.actions, required this.targetTypes})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        actions, r'AuditLogFacets', 'actions');
    BuiltValueNullFieldError.checkNotNull(
        targetTypes, r'AuditLogFacets', 'targetTypes');
  }

  @override
  AuditLogFacets rebuild(void Function(AuditLogFacetsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuditLogFacetsBuilder toBuilder() =>
      new AuditLogFacetsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuditLogFacets &&
        actions == other.actions &&
        targetTypes == other.targetTypes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, actions.hashCode);
    _$hash = $jc(_$hash, targetTypes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuditLogFacets')
          ..add('actions', actions)
          ..add('targetTypes', targetTypes))
        .toString();
  }
}

class AuditLogFacetsBuilder
    implements Builder<AuditLogFacets, AuditLogFacetsBuilder> {
  _$AuditLogFacets? _$v;

  ListBuilder<String>? _actions;
  ListBuilder<String> get actions =>
      _$this._actions ??= new ListBuilder<String>();
  set actions(ListBuilder<String>? actions) => _$this._actions = actions;

  ListBuilder<String>? _targetTypes;
  ListBuilder<String> get targetTypes =>
      _$this._targetTypes ??= new ListBuilder<String>();
  set targetTypes(ListBuilder<String>? targetTypes) =>
      _$this._targetTypes = targetTypes;

  AuditLogFacetsBuilder() {
    AuditLogFacets._defaults(this);
  }

  AuditLogFacetsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _actions = $v.actions.toBuilder();
      _targetTypes = $v.targetTypes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuditLogFacets other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AuditLogFacets;
  }

  @override
  void update(void Function(AuditLogFacetsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuditLogFacets build() => _build();

  _$AuditLogFacets _build() {
    _$AuditLogFacets _$result;
    try {
      _$result = _$v ??
          new _$AuditLogFacets._(
              actions: actions.build(), targetTypes: targetTypes.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'actions';
        actions.build();
        _$failedField = 'targetTypes';
        targetTypes.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AuditLogFacets', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
