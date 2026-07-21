// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_user_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InviteUserRequest extends InviteUserRequest {
  @override
  final String displayName;
  @override
  final String email;
  @override
  final String roleId;

  factory _$InviteUserRequest(
          [void Function(InviteUserRequestBuilder)? updates]) =>
      (new InviteUserRequestBuilder()..update(updates))._build();

  _$InviteUserRequest._(
      {required this.displayName, required this.email, required this.roleId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        displayName, r'InviteUserRequest', 'displayName');
    BuiltValueNullFieldError.checkNotNull(email, r'InviteUserRequest', 'email');
    BuiltValueNullFieldError.checkNotNull(
        roleId, r'InviteUserRequest', 'roleId');
  }

  @override
  InviteUserRequest rebuild(void Function(InviteUserRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InviteUserRequestBuilder toBuilder() =>
      new InviteUserRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InviteUserRequest &&
        displayName == other.displayName &&
        email == other.email &&
        roleId == other.roleId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, roleId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InviteUserRequest')
          ..add('displayName', displayName)
          ..add('email', email)
          ..add('roleId', roleId))
        .toString();
  }
}

class InviteUserRequestBuilder
    implements Builder<InviteUserRequest, InviteUserRequestBuilder> {
  _$InviteUserRequest? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _roleId;
  String? get roleId => _$this._roleId;
  set roleId(String? roleId) => _$this._roleId = roleId;

  InviteUserRequestBuilder() {
    InviteUserRequest._defaults(this);
  }

  InviteUserRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _email = $v.email;
      _roleId = $v.roleId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InviteUserRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$InviteUserRequest;
  }

  @override
  void update(void Function(InviteUserRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InviteUserRequest build() => _build();

  _$InviteUserRequest _build() {
    final _$result = _$v ??
        new _$InviteUserRequest._(
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'InviteUserRequest', 'displayName'),
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'InviteUserRequest', 'email'),
            roleId: BuiltValueNullFieldError.checkNotNull(
                roleId, r'InviteUserRequest', 'roleId'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
