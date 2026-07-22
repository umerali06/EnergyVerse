// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_platform_company_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UpdatePlatformCompanyRequestSubscriptionTierEnum
    _$updatePlatformCompanyRequestSubscriptionTierEnum_demo =
    const UpdatePlatformCompanyRequestSubscriptionTierEnum._('demo');
const UpdatePlatformCompanyRequestSubscriptionTierEnum
    _$updatePlatformCompanyRequestSubscriptionTierEnum_starter =
    const UpdatePlatformCompanyRequestSubscriptionTierEnum._('starter');
const UpdatePlatformCompanyRequestSubscriptionTierEnum
    _$updatePlatformCompanyRequestSubscriptionTierEnum_professional =
    const UpdatePlatformCompanyRequestSubscriptionTierEnum._('professional');
const UpdatePlatformCompanyRequestSubscriptionTierEnum
    _$updatePlatformCompanyRequestSubscriptionTierEnum_enterprise =
    const UpdatePlatformCompanyRequestSubscriptionTierEnum._('enterprise');

UpdatePlatformCompanyRequestSubscriptionTierEnum
    _$updatePlatformCompanyRequestSubscriptionTierEnumValueOf(String name) {
  switch (name) {
    case 'demo':
      return _$updatePlatformCompanyRequestSubscriptionTierEnum_demo;
    case 'starter':
      return _$updatePlatformCompanyRequestSubscriptionTierEnum_starter;
    case 'professional':
      return _$updatePlatformCompanyRequestSubscriptionTierEnum_professional;
    case 'enterprise':
      return _$updatePlatformCompanyRequestSubscriptionTierEnum_enterprise;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<UpdatePlatformCompanyRequestSubscriptionTierEnum>
    _$updatePlatformCompanyRequestSubscriptionTierEnumValues = new BuiltSet<
        UpdatePlatformCompanyRequestSubscriptionTierEnum>(const <UpdatePlatformCompanyRequestSubscriptionTierEnum>[
  _$updatePlatformCompanyRequestSubscriptionTierEnum_demo,
  _$updatePlatformCompanyRequestSubscriptionTierEnum_starter,
  _$updatePlatformCompanyRequestSubscriptionTierEnum_professional,
  _$updatePlatformCompanyRequestSubscriptionTierEnum_enterprise,
]);

Serializer<UpdatePlatformCompanyRequestSubscriptionTierEnum>
    _$updatePlatformCompanyRequestSubscriptionTierEnumSerializer =
    new _$UpdatePlatformCompanyRequestSubscriptionTierEnumSerializer();

class _$UpdatePlatformCompanyRequestSubscriptionTierEnumSerializer
    implements
        PrimitiveSerializer<UpdatePlatformCompanyRequestSubscriptionTierEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'demo': 'demo',
    'starter': 'starter',
    'professional': 'professional',
    'enterprise': 'enterprise',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'demo': 'demo',
    'starter': 'starter',
    'professional': 'professional',
    'enterprise': 'enterprise',
  };

  @override
  final Iterable<Type> types = const <Type>[
    UpdatePlatformCompanyRequestSubscriptionTierEnum
  ];
  @override
  final String wireName = 'UpdatePlatformCompanyRequestSubscriptionTierEnum';

  @override
  Object serialize(Serializers serializers,
          UpdatePlatformCompanyRequestSubscriptionTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UpdatePlatformCompanyRequestSubscriptionTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UpdatePlatformCompanyRequestSubscriptionTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UpdatePlatformCompanyRequest extends UpdatePlatformCompanyRequest {
  @override
  final UpdatePlatformCompanyRequestSubscriptionTierEnum subscriptionTier;

  factory _$UpdatePlatformCompanyRequest(
          [void Function(UpdatePlatformCompanyRequestBuilder)? updates]) =>
      (new UpdatePlatformCompanyRequestBuilder()..update(updates))._build();

  _$UpdatePlatformCompanyRequest._({required this.subscriptionTier})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        subscriptionTier, r'UpdatePlatformCompanyRequest', 'subscriptionTier');
  }

  @override
  UpdatePlatformCompanyRequest rebuild(
          void Function(UpdatePlatformCompanyRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdatePlatformCompanyRequestBuilder toBuilder() =>
      new UpdatePlatformCompanyRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdatePlatformCompanyRequest &&
        subscriptionTier == other.subscriptionTier;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, subscriptionTier.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdatePlatformCompanyRequest')
          ..add('subscriptionTier', subscriptionTier))
        .toString();
  }
}

class UpdatePlatformCompanyRequestBuilder
    implements
        Builder<UpdatePlatformCompanyRequest,
            UpdatePlatformCompanyRequestBuilder> {
  _$UpdatePlatformCompanyRequest? _$v;

  UpdatePlatformCompanyRequestSubscriptionTierEnum? _subscriptionTier;
  UpdatePlatformCompanyRequestSubscriptionTierEnum? get subscriptionTier =>
      _$this._subscriptionTier;
  set subscriptionTier(
          UpdatePlatformCompanyRequestSubscriptionTierEnum? subscriptionTier) =>
      _$this._subscriptionTier = subscriptionTier;

  UpdatePlatformCompanyRequestBuilder() {
    UpdatePlatformCompanyRequest._defaults(this);
  }

  UpdatePlatformCompanyRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _subscriptionTier = $v.subscriptionTier;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdatePlatformCompanyRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdatePlatformCompanyRequest;
  }

  @override
  void update(void Function(UpdatePlatformCompanyRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdatePlatformCompanyRequest build() => _build();

  _$UpdatePlatformCompanyRequest _build() {
    final _$result = _$v ??
        new _$UpdatePlatformCompanyRequest._(
            subscriptionTier: BuiltValueNullFieldError.checkNotNull(
                subscriptionTier,
                r'UpdatePlatformCompanyRequest',
                'subscriptionTier'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
