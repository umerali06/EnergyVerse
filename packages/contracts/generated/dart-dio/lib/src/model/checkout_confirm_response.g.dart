// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_confirm_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CheckoutConfirmResponseOutcomeEnum
    _$checkoutConfirmResponseOutcomeEnum_reconciled =
    const CheckoutConfirmResponseOutcomeEnum._('reconciled');
const CheckoutConfirmResponseOutcomeEnum
    _$checkoutConfirmResponseOutcomeEnum_pending =
    const CheckoutConfirmResponseOutcomeEnum._('pending');

CheckoutConfirmResponseOutcomeEnum _$checkoutConfirmResponseOutcomeEnumValueOf(
    String name) {
  switch (name) {
    case 'reconciled':
      return _$checkoutConfirmResponseOutcomeEnum_reconciled;
    case 'pending':
      return _$checkoutConfirmResponseOutcomeEnum_pending;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CheckoutConfirmResponseOutcomeEnum>
    _$checkoutConfirmResponseOutcomeEnumValues = new BuiltSet<
        CheckoutConfirmResponseOutcomeEnum>(const <CheckoutConfirmResponseOutcomeEnum>[
  _$checkoutConfirmResponseOutcomeEnum_reconciled,
  _$checkoutConfirmResponseOutcomeEnum_pending,
]);

Serializer<CheckoutConfirmResponseOutcomeEnum>
    _$checkoutConfirmResponseOutcomeEnumSerializer =
    new _$CheckoutConfirmResponseOutcomeEnumSerializer();

class _$CheckoutConfirmResponseOutcomeEnumSerializer
    implements PrimitiveSerializer<CheckoutConfirmResponseOutcomeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'reconciled': 'reconciled',
    'pending': 'pending',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'reconciled': 'reconciled',
    'pending': 'pending',
  };

  @override
  final Iterable<Type> types = const <Type>[CheckoutConfirmResponseOutcomeEnum];
  @override
  final String wireName = 'CheckoutConfirmResponseOutcomeEnum';

  @override
  Object serialize(
          Serializers serializers, CheckoutConfirmResponseOutcomeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CheckoutConfirmResponseOutcomeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CheckoutConfirmResponseOutcomeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CheckoutConfirmResponse extends CheckoutConfirmResponse {
  @override
  final CheckoutConfirmResponseOutcomeEnum outcome;
  @override
  final SubscriptionResponse subscription;

  factory _$CheckoutConfirmResponse(
          [void Function(CheckoutConfirmResponseBuilder)? updates]) =>
      (new CheckoutConfirmResponseBuilder()..update(updates))._build();

  _$CheckoutConfirmResponse._(
      {required this.outcome, required this.subscription})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        outcome, r'CheckoutConfirmResponse', 'outcome');
    BuiltValueNullFieldError.checkNotNull(
        subscription, r'CheckoutConfirmResponse', 'subscription');
  }

  @override
  CheckoutConfirmResponse rebuild(
          void Function(CheckoutConfirmResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckoutConfirmResponseBuilder toBuilder() =>
      new CheckoutConfirmResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutConfirmResponse &&
        outcome == other.outcome &&
        subscription == other.subscription;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, outcome.hashCode);
    _$hash = $jc(_$hash, subscription.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckoutConfirmResponse')
          ..add('outcome', outcome)
          ..add('subscription', subscription))
        .toString();
  }
}

class CheckoutConfirmResponseBuilder
    implements
        Builder<CheckoutConfirmResponse, CheckoutConfirmResponseBuilder> {
  _$CheckoutConfirmResponse? _$v;

  CheckoutConfirmResponseOutcomeEnum? _outcome;
  CheckoutConfirmResponseOutcomeEnum? get outcome => _$this._outcome;
  set outcome(CheckoutConfirmResponseOutcomeEnum? outcome) =>
      _$this._outcome = outcome;

  SubscriptionResponseBuilder? _subscription;
  SubscriptionResponseBuilder get subscription =>
      _$this._subscription ??= new SubscriptionResponseBuilder();
  set subscription(SubscriptionResponseBuilder? subscription) =>
      _$this._subscription = subscription;

  CheckoutConfirmResponseBuilder() {
    CheckoutConfirmResponse._defaults(this);
  }

  CheckoutConfirmResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _outcome = $v.outcome;
      _subscription = $v.subscription.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckoutConfirmResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CheckoutConfirmResponse;
  }

  @override
  void update(void Function(CheckoutConfirmResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutConfirmResponse build() => _build();

  _$CheckoutConfirmResponse _build() {
    _$CheckoutConfirmResponse _$result;
    try {
      _$result = _$v ??
          new _$CheckoutConfirmResponse._(
              outcome: BuiltValueNullFieldError.checkNotNull(
                  outcome, r'CheckoutConfirmResponse', 'outcome'),
              subscription: subscription.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'subscription';
        subscription.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CheckoutConfirmResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
