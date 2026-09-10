// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_plan_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BillingPlanResponse extends BillingPlanResponse {
  @override
  final int annualTotalCents;
  @override
  final String audience;
  @override
  final bool customQuoted;
  @override
  final String digitalTwinScope;
  @override
  final BuiltList<String> features;
  @override
  final int listMonthlyCents;
  @override
  final int monthlyCents;
  @override
  final String name;
  @override
  final BillingPlanQuotasResponse quotas;
  @override
  final String support;
  @override
  final String tier;

  factory _$BillingPlanResponse(
          [void Function(BillingPlanResponseBuilder)? updates]) =>
      (new BillingPlanResponseBuilder()..update(updates))._build();

  _$BillingPlanResponse._(
      {required this.annualTotalCents,
      required this.audience,
      required this.customQuoted,
      required this.digitalTwinScope,
      required this.features,
      required this.listMonthlyCents,
      required this.monthlyCents,
      required this.name,
      required this.quotas,
      required this.support,
      required this.tier})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        annualTotalCents, r'BillingPlanResponse', 'annualTotalCents');
    BuiltValueNullFieldError.checkNotNull(
        audience, r'BillingPlanResponse', 'audience');
    BuiltValueNullFieldError.checkNotNull(
        customQuoted, r'BillingPlanResponse', 'customQuoted');
    BuiltValueNullFieldError.checkNotNull(
        digitalTwinScope, r'BillingPlanResponse', 'digitalTwinScope');
    BuiltValueNullFieldError.checkNotNull(
        features, r'BillingPlanResponse', 'features');
    BuiltValueNullFieldError.checkNotNull(
        listMonthlyCents, r'BillingPlanResponse', 'listMonthlyCents');
    BuiltValueNullFieldError.checkNotNull(
        monthlyCents, r'BillingPlanResponse', 'monthlyCents');
    BuiltValueNullFieldError.checkNotNull(name, r'BillingPlanResponse', 'name');
    BuiltValueNullFieldError.checkNotNull(
        quotas, r'BillingPlanResponse', 'quotas');
    BuiltValueNullFieldError.checkNotNull(
        support, r'BillingPlanResponse', 'support');
    BuiltValueNullFieldError.checkNotNull(tier, r'BillingPlanResponse', 'tier');
  }

  @override
  BillingPlanResponse rebuild(
          void Function(BillingPlanResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BillingPlanResponseBuilder toBuilder() =>
      new BillingPlanResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BillingPlanResponse &&
        annualTotalCents == other.annualTotalCents &&
        audience == other.audience &&
        customQuoted == other.customQuoted &&
        digitalTwinScope == other.digitalTwinScope &&
        features == other.features &&
        listMonthlyCents == other.listMonthlyCents &&
        monthlyCents == other.monthlyCents &&
        name == other.name &&
        quotas == other.quotas &&
        support == other.support &&
        tier == other.tier;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, annualTotalCents.hashCode);
    _$hash = $jc(_$hash, audience.hashCode);
    _$hash = $jc(_$hash, customQuoted.hashCode);
    _$hash = $jc(_$hash, digitalTwinScope.hashCode);
    _$hash = $jc(_$hash, features.hashCode);
    _$hash = $jc(_$hash, listMonthlyCents.hashCode);
    _$hash = $jc(_$hash, monthlyCents.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, quotas.hashCode);
    _$hash = $jc(_$hash, support.hashCode);
    _$hash = $jc(_$hash, tier.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BillingPlanResponse')
          ..add('annualTotalCents', annualTotalCents)
          ..add('audience', audience)
          ..add('customQuoted', customQuoted)
          ..add('digitalTwinScope', digitalTwinScope)
          ..add('features', features)
          ..add('listMonthlyCents', listMonthlyCents)
          ..add('monthlyCents', monthlyCents)
          ..add('name', name)
          ..add('quotas', quotas)
          ..add('support', support)
          ..add('tier', tier))
        .toString();
  }
}

class BillingPlanResponseBuilder
    implements Builder<BillingPlanResponse, BillingPlanResponseBuilder> {
  _$BillingPlanResponse? _$v;

  int? _annualTotalCents;
  int? get annualTotalCents => _$this._annualTotalCents;
  set annualTotalCents(int? annualTotalCents) =>
      _$this._annualTotalCents = annualTotalCents;

  String? _audience;
  String? get audience => _$this._audience;
  set audience(String? audience) => _$this._audience = audience;

  bool? _customQuoted;
  bool? get customQuoted => _$this._customQuoted;
  set customQuoted(bool? customQuoted) => _$this._customQuoted = customQuoted;

  String? _digitalTwinScope;
  String? get digitalTwinScope => _$this._digitalTwinScope;
  set digitalTwinScope(String? digitalTwinScope) =>
      _$this._digitalTwinScope = digitalTwinScope;

  ListBuilder<String>? _features;
  ListBuilder<String> get features =>
      _$this._features ??= new ListBuilder<String>();
  set features(ListBuilder<String>? features) => _$this._features = features;

  int? _listMonthlyCents;
  int? get listMonthlyCents => _$this._listMonthlyCents;
  set listMonthlyCents(int? listMonthlyCents) =>
      _$this._listMonthlyCents = listMonthlyCents;

  int? _monthlyCents;
  int? get monthlyCents => _$this._monthlyCents;
  set monthlyCents(int? monthlyCents) => _$this._monthlyCents = monthlyCents;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  BillingPlanQuotasResponseBuilder? _quotas;
  BillingPlanQuotasResponseBuilder get quotas =>
      _$this._quotas ??= new BillingPlanQuotasResponseBuilder();
  set quotas(BillingPlanQuotasResponseBuilder? quotas) =>
      _$this._quotas = quotas;

  String? _support;
  String? get support => _$this._support;
  set support(String? support) => _$this._support = support;

  String? _tier;
  String? get tier => _$this._tier;
  set tier(String? tier) => _$this._tier = tier;

  BillingPlanResponseBuilder() {
    BillingPlanResponse._defaults(this);
  }

  BillingPlanResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _annualTotalCents = $v.annualTotalCents;
      _audience = $v.audience;
      _customQuoted = $v.customQuoted;
      _digitalTwinScope = $v.digitalTwinScope;
      _features = $v.features.toBuilder();
      _listMonthlyCents = $v.listMonthlyCents;
      _monthlyCents = $v.monthlyCents;
      _name = $v.name;
      _quotas = $v.quotas.toBuilder();
      _support = $v.support;
      _tier = $v.tier;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BillingPlanResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BillingPlanResponse;
  }

  @override
  void update(void Function(BillingPlanResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BillingPlanResponse build() => _build();

  _$BillingPlanResponse _build() {
    _$BillingPlanResponse _$result;
    try {
      _$result = _$v ??
          new _$BillingPlanResponse._(
              annualTotalCents: BuiltValueNullFieldError.checkNotNull(
                  annualTotalCents, r'BillingPlanResponse', 'annualTotalCents'),
              audience: BuiltValueNullFieldError.checkNotNull(
                  audience, r'BillingPlanResponse', 'audience'),
              customQuoted: BuiltValueNullFieldError.checkNotNull(
                  customQuoted, r'BillingPlanResponse', 'customQuoted'),
              digitalTwinScope: BuiltValueNullFieldError.checkNotNull(
                  digitalTwinScope, r'BillingPlanResponse', 'digitalTwinScope'),
              features: features.build(),
              listMonthlyCents: BuiltValueNullFieldError.checkNotNull(
                  listMonthlyCents, r'BillingPlanResponse', 'listMonthlyCents'),
              monthlyCents: BuiltValueNullFieldError.checkNotNull(
                  monthlyCents, r'BillingPlanResponse', 'monthlyCents'),
              name: BuiltValueNullFieldError.checkNotNull(
                  name, r'BillingPlanResponse', 'name'),
              quotas: quotas.build(),
              support:
                  BuiltValueNullFieldError.checkNotNull(support, r'BillingPlanResponse', 'support'),
              tier: BuiltValueNullFieldError.checkNotNull(tier, r'BillingPlanResponse', 'tier'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'features';
        features.build();

        _$failedField = 'quotas';
        quotas.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'BillingPlanResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
