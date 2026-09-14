// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_acceptance_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LegalAcceptanceResponse extends LegalAcceptanceResponse {
  @override
  final String? acceptanceSource;
  @override
  final DateTime? acceptedAt;
  @override
  final String? acceptedVersion;
  @override
  final String currentVersion;
  @override
  final bool privacyAccepted;
  @override
  final bool requiresAcceptance;
  @override
  final bool safetyDisclaimerAccepted;
  @override
  final bool termsAccepted;

  factory _$LegalAcceptanceResponse(
          [void Function(LegalAcceptanceResponseBuilder)? updates]) =>
      (new LegalAcceptanceResponseBuilder()..update(updates))._build();

  _$LegalAcceptanceResponse._(
      {this.acceptanceSource,
      this.acceptedAt,
      this.acceptedVersion,
      required this.currentVersion,
      required this.privacyAccepted,
      required this.requiresAcceptance,
      required this.safetyDisclaimerAccepted,
      required this.termsAccepted})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        currentVersion, r'LegalAcceptanceResponse', 'currentVersion');
    BuiltValueNullFieldError.checkNotNull(
        privacyAccepted, r'LegalAcceptanceResponse', 'privacyAccepted');
    BuiltValueNullFieldError.checkNotNull(
        requiresAcceptance, r'LegalAcceptanceResponse', 'requiresAcceptance');
    BuiltValueNullFieldError.checkNotNull(safetyDisclaimerAccepted,
        r'LegalAcceptanceResponse', 'safetyDisclaimerAccepted');
    BuiltValueNullFieldError.checkNotNull(
        termsAccepted, r'LegalAcceptanceResponse', 'termsAccepted');
  }

  @override
  LegalAcceptanceResponse rebuild(
          void Function(LegalAcceptanceResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LegalAcceptanceResponseBuilder toBuilder() =>
      new LegalAcceptanceResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LegalAcceptanceResponse &&
        acceptanceSource == other.acceptanceSource &&
        acceptedAt == other.acceptedAt &&
        acceptedVersion == other.acceptedVersion &&
        currentVersion == other.currentVersion &&
        privacyAccepted == other.privacyAccepted &&
        requiresAcceptance == other.requiresAcceptance &&
        safetyDisclaimerAccepted == other.safetyDisclaimerAccepted &&
        termsAccepted == other.termsAccepted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, acceptanceSource.hashCode);
    _$hash = $jc(_$hash, acceptedAt.hashCode);
    _$hash = $jc(_$hash, acceptedVersion.hashCode);
    _$hash = $jc(_$hash, currentVersion.hashCode);
    _$hash = $jc(_$hash, privacyAccepted.hashCode);
    _$hash = $jc(_$hash, requiresAcceptance.hashCode);
    _$hash = $jc(_$hash, safetyDisclaimerAccepted.hashCode);
    _$hash = $jc(_$hash, termsAccepted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LegalAcceptanceResponse')
          ..add('acceptanceSource', acceptanceSource)
          ..add('acceptedAt', acceptedAt)
          ..add('acceptedVersion', acceptedVersion)
          ..add('currentVersion', currentVersion)
          ..add('privacyAccepted', privacyAccepted)
          ..add('requiresAcceptance', requiresAcceptance)
          ..add('safetyDisclaimerAccepted', safetyDisclaimerAccepted)
          ..add('termsAccepted', termsAccepted))
        .toString();
  }
}

class LegalAcceptanceResponseBuilder
    implements
        Builder<LegalAcceptanceResponse, LegalAcceptanceResponseBuilder> {
  _$LegalAcceptanceResponse? _$v;

  String? _acceptanceSource;
  String? get acceptanceSource => _$this._acceptanceSource;
  set acceptanceSource(String? acceptanceSource) =>
      _$this._acceptanceSource = acceptanceSource;

  DateTime? _acceptedAt;
  DateTime? get acceptedAt => _$this._acceptedAt;
  set acceptedAt(DateTime? acceptedAt) => _$this._acceptedAt = acceptedAt;

  String? _acceptedVersion;
  String? get acceptedVersion => _$this._acceptedVersion;
  set acceptedVersion(String? acceptedVersion) =>
      _$this._acceptedVersion = acceptedVersion;

  String? _currentVersion;
  String? get currentVersion => _$this._currentVersion;
  set currentVersion(String? currentVersion) =>
      _$this._currentVersion = currentVersion;

  bool? _privacyAccepted;
  bool? get privacyAccepted => _$this._privacyAccepted;
  set privacyAccepted(bool? privacyAccepted) =>
      _$this._privacyAccepted = privacyAccepted;

  bool? _requiresAcceptance;
  bool? get requiresAcceptance => _$this._requiresAcceptance;
  set requiresAcceptance(bool? requiresAcceptance) =>
      _$this._requiresAcceptance = requiresAcceptance;

  bool? _safetyDisclaimerAccepted;
  bool? get safetyDisclaimerAccepted => _$this._safetyDisclaimerAccepted;
  set safetyDisclaimerAccepted(bool? safetyDisclaimerAccepted) =>
      _$this._safetyDisclaimerAccepted = safetyDisclaimerAccepted;

  bool? _termsAccepted;
  bool? get termsAccepted => _$this._termsAccepted;
  set termsAccepted(bool? termsAccepted) =>
      _$this._termsAccepted = termsAccepted;

  LegalAcceptanceResponseBuilder() {
    LegalAcceptanceResponse._defaults(this);
  }

  LegalAcceptanceResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _acceptanceSource = $v.acceptanceSource;
      _acceptedAt = $v.acceptedAt;
      _acceptedVersion = $v.acceptedVersion;
      _currentVersion = $v.currentVersion;
      _privacyAccepted = $v.privacyAccepted;
      _requiresAcceptance = $v.requiresAcceptance;
      _safetyDisclaimerAccepted = $v.safetyDisclaimerAccepted;
      _termsAccepted = $v.termsAccepted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LegalAcceptanceResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$LegalAcceptanceResponse;
  }

  @override
  void update(void Function(LegalAcceptanceResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LegalAcceptanceResponse build() => _build();

  _$LegalAcceptanceResponse _build() {
    final _$result = _$v ??
        new _$LegalAcceptanceResponse._(
            acceptanceSource: acceptanceSource,
            acceptedAt: acceptedAt,
            acceptedVersion: acceptedVersion,
            currentVersion: BuiltValueNullFieldError.checkNotNull(
                currentVersion, r'LegalAcceptanceResponse', 'currentVersion'),
            privacyAccepted: BuiltValueNullFieldError.checkNotNull(
                privacyAccepted, r'LegalAcceptanceResponse', 'privacyAccepted'),
            requiresAcceptance: BuiltValueNullFieldError.checkNotNull(
                requiresAcceptance,
                r'LegalAcceptanceResponse',
                'requiresAcceptance'),
            safetyDisclaimerAccepted: BuiltValueNullFieldError.checkNotNull(
                safetyDisclaimerAccepted,
                r'LegalAcceptanceResponse',
                'safetyDisclaimerAccepted'),
            termsAccepted: BuiltValueNullFieldError.checkNotNull(
                termsAccepted, r'LegalAcceptanceResponse', 'termsAccepted'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
