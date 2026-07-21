// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_status_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UpdateUserStatusRequestStatusEnum
    _$updateUserStatusRequestStatusEnum_active =
    const UpdateUserStatusRequestStatusEnum._('active');
const UpdateUserStatusRequestStatusEnum
    _$updateUserStatusRequestStatusEnum_inactive =
    const UpdateUserStatusRequestStatusEnum._('inactive');

UpdateUserStatusRequestStatusEnum _$updateUserStatusRequestStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'active':
      return _$updateUserStatusRequestStatusEnum_active;
    case 'inactive':
      return _$updateUserStatusRequestStatusEnum_inactive;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<UpdateUserStatusRequestStatusEnum>
    _$updateUserStatusRequestStatusEnumValues = new BuiltSet<
        UpdateUserStatusRequestStatusEnum>(const <UpdateUserStatusRequestStatusEnum>[
  _$updateUserStatusRequestStatusEnum_active,
  _$updateUserStatusRequestStatusEnum_inactive,
]);

Serializer<UpdateUserStatusRequestStatusEnum>
    _$updateUserStatusRequestStatusEnumSerializer =
    new _$UpdateUserStatusRequestStatusEnumSerializer();

class _$UpdateUserStatusRequestStatusEnumSerializer
    implements PrimitiveSerializer<UpdateUserStatusRequestStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'inactive': 'inactive',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'inactive': 'inactive',
  };

  @override
  final Iterable<Type> types = const <Type>[UpdateUserStatusRequestStatusEnum];
  @override
  final String wireName = 'UpdateUserStatusRequestStatusEnum';

  @override
  Object serialize(
          Serializers serializers, UpdateUserStatusRequestStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UpdateUserStatusRequestStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UpdateUserStatusRequestStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UpdateUserStatusRequest extends UpdateUserStatusRequest {
  @override
  final UpdateUserStatusRequestStatusEnum status;

  factory _$UpdateUserStatusRequest(
          [void Function(UpdateUserStatusRequestBuilder)? updates]) =>
      (new UpdateUserStatusRequestBuilder()..update(updates))._build();

  _$UpdateUserStatusRequest._({required this.status}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        status, r'UpdateUserStatusRequest', 'status');
  }

  @override
  UpdateUserStatusRequest rebuild(
          void Function(UpdateUserStatusRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateUserStatusRequestBuilder toBuilder() =>
      new UpdateUserStatusRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateUserStatusRequest && status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateUserStatusRequest')
          ..add('status', status))
        .toString();
  }
}

class UpdateUserStatusRequestBuilder
    implements
        Builder<UpdateUserStatusRequest, UpdateUserStatusRequestBuilder> {
  _$UpdateUserStatusRequest? _$v;

  UpdateUserStatusRequestStatusEnum? _status;
  UpdateUserStatusRequestStatusEnum? get status => _$this._status;
  set status(UpdateUserStatusRequestStatusEnum? status) =>
      _$this._status = status;

  UpdateUserStatusRequestBuilder() {
    UpdateUserStatusRequest._defaults(this);
  }

  UpdateUserStatusRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateUserStatusRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateUserStatusRequest;
  }

  @override
  void update(void Function(UpdateUserStatusRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateUserStatusRequest build() => _build();

  _$UpdateUserStatusRequest _build() {
    final _$result = _$v ??
        new _$UpdateUserStatusRequest._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'UpdateUserStatusRequest', 'status'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
