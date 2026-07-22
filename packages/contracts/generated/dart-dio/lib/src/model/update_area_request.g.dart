// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_area_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateAreaRequest extends UpdateAreaRequest {
  @override
  final String? code;
  @override
  final String? description;
  @override
  final String? name;

  factory _$UpdateAreaRequest(
          [void Function(UpdateAreaRequestBuilder)? updates]) =>
      (new UpdateAreaRequestBuilder()..update(updates))._build();

  _$UpdateAreaRequest._({this.code, this.description, this.name}) : super._();

  @override
  UpdateAreaRequest rebuild(void Function(UpdateAreaRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateAreaRequestBuilder toBuilder() =>
      new UpdateAreaRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateAreaRequest &&
        code == other.code &&
        description == other.description &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateAreaRequest')
          ..add('code', code)
          ..add('description', description)
          ..add('name', name))
        .toString();
  }
}

class UpdateAreaRequestBuilder
    implements Builder<UpdateAreaRequest, UpdateAreaRequestBuilder> {
  _$UpdateAreaRequest? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  UpdateAreaRequestBuilder() {
    UpdateAreaRequest._defaults(this);
  }

  UpdateAreaRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _description = $v.description;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateAreaRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateAreaRequest;
  }

  @override
  void update(void Function(UpdateAreaRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateAreaRequest build() => _build();

  _$UpdateAreaRequest _build() {
    final _$result = _$v ??
        new _$UpdateAreaRequest._(
            code: code, description: description, name: name);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
