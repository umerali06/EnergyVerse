// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_company_status_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UpdateCompanyStatusRequestStatusEnum
    _$updateCompanyStatusRequestStatusEnum_active =
    const UpdateCompanyStatusRequestStatusEnum._('active');
const UpdateCompanyStatusRequestStatusEnum
    _$updateCompanyStatusRequestStatusEnum_suspended =
    const UpdateCompanyStatusRequestStatusEnum._('suspended');

UpdateCompanyStatusRequestStatusEnum
    _$updateCompanyStatusRequestStatusEnumValueOf(String name) {
  switch (name) {
    case 'active':
      return _$updateCompanyStatusRequestStatusEnum_active;
    case 'suspended':
      return _$updateCompanyStatusRequestStatusEnum_suspended;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<UpdateCompanyStatusRequestStatusEnum>
    _$updateCompanyStatusRequestStatusEnumValues = new BuiltSet<
        UpdateCompanyStatusRequestStatusEnum>(const <UpdateCompanyStatusRequestStatusEnum>[
  _$updateCompanyStatusRequestStatusEnum_active,
  _$updateCompanyStatusRequestStatusEnum_suspended,
]);

Serializer<UpdateCompanyStatusRequestStatusEnum>
    _$updateCompanyStatusRequestStatusEnumSerializer =
    new _$UpdateCompanyStatusRequestStatusEnumSerializer();

class _$UpdateCompanyStatusRequestStatusEnumSerializer
    implements PrimitiveSerializer<UpdateCompanyStatusRequestStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'suspended': 'suspended',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'suspended': 'suspended',
  };

  @override
  final Iterable<Type> types = const <Type>[
    UpdateCompanyStatusRequestStatusEnum
  ];
  @override
  final String wireName = 'UpdateCompanyStatusRequestStatusEnum';

  @override
  Object serialize(
          Serializers serializers, UpdateCompanyStatusRequestStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UpdateCompanyStatusRequestStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UpdateCompanyStatusRequestStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UpdateCompanyStatusRequest extends UpdateCompanyStatusRequest {
  @override
  final UpdateCompanyStatusRequestStatusEnum status;

  factory _$UpdateCompanyStatusRequest(
          [void Function(UpdateCompanyStatusRequestBuilder)? updates]) =>
      (new UpdateCompanyStatusRequestBuilder()..update(updates))._build();

  _$UpdateCompanyStatusRequest._({required this.status}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        status, r'UpdateCompanyStatusRequest', 'status');
  }

  @override
  UpdateCompanyStatusRequest rebuild(
          void Function(UpdateCompanyStatusRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateCompanyStatusRequestBuilder toBuilder() =>
      new UpdateCompanyStatusRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateCompanyStatusRequest && status == other.status;
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
    return (newBuiltValueToStringHelper(r'UpdateCompanyStatusRequest')
          ..add('status', status))
        .toString();
  }
}

class UpdateCompanyStatusRequestBuilder
    implements
        Builder<UpdateCompanyStatusRequest, UpdateCompanyStatusRequestBuilder> {
  _$UpdateCompanyStatusRequest? _$v;

  UpdateCompanyStatusRequestStatusEnum? _status;
  UpdateCompanyStatusRequestStatusEnum? get status => _$this._status;
  set status(UpdateCompanyStatusRequestStatusEnum? status) =>
      _$this._status = status;

  UpdateCompanyStatusRequestBuilder() {
    UpdateCompanyStatusRequest._defaults(this);
  }

  UpdateCompanyStatusRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateCompanyStatusRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateCompanyStatusRequest;
  }

  @override
  void update(void Function(UpdateCompanyStatusRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateCompanyStatusRequest build() => _build();

  _$UpdateCompanyStatusRequest _build() {
    final _$result = _$v ??
        new _$UpdateCompanyStatusRequest._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'UpdateCompanyStatusRequest', 'status'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
