// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decide_permit_approval_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DecidePermitApprovalRequestDecisionEnum
    _$decidePermitApprovalRequestDecisionEnum_approve =
    const DecidePermitApprovalRequestDecisionEnum._('approve');
const DecidePermitApprovalRequestDecisionEnum
    _$decidePermitApprovalRequestDecisionEnum_reject =
    const DecidePermitApprovalRequestDecisionEnum._('reject');

DecidePermitApprovalRequestDecisionEnum
    _$decidePermitApprovalRequestDecisionEnumValueOf(String name) {
  switch (name) {
    case 'approve':
      return _$decidePermitApprovalRequestDecisionEnum_approve;
    case 'reject':
      return _$decidePermitApprovalRequestDecisionEnum_reject;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<DecidePermitApprovalRequestDecisionEnum>
    _$decidePermitApprovalRequestDecisionEnumValues = new BuiltSet<
        DecidePermitApprovalRequestDecisionEnum>(const <DecidePermitApprovalRequestDecisionEnum>[
  _$decidePermitApprovalRequestDecisionEnum_approve,
  _$decidePermitApprovalRequestDecisionEnum_reject,
]);

const DecidePermitApprovalRequestDigitalSignatureAttestationEnum
    _$decidePermitApprovalRequestDigitalSignatureAttestationEnum_true_ =
    const DecidePermitApprovalRequestDigitalSignatureAttestationEnum._('true_');

DecidePermitApprovalRequestDigitalSignatureAttestationEnum
    _$decidePermitApprovalRequestDigitalSignatureAttestationEnumValueOf(
        String name) {
  switch (name) {
    case 'true_':
      return _$decidePermitApprovalRequestDigitalSignatureAttestationEnum_true_;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<DecidePermitApprovalRequestDigitalSignatureAttestationEnum>
    _$decidePermitApprovalRequestDigitalSignatureAttestationEnumValues =
    new BuiltSet<
        DecidePermitApprovalRequestDigitalSignatureAttestationEnum>(const <DecidePermitApprovalRequestDigitalSignatureAttestationEnum>[
  _$decidePermitApprovalRequestDigitalSignatureAttestationEnum_true_,
]);

Serializer<DecidePermitApprovalRequestDecisionEnum>
    _$decidePermitApprovalRequestDecisionEnumSerializer =
    new _$DecidePermitApprovalRequestDecisionEnumSerializer();
Serializer<DecidePermitApprovalRequestDigitalSignatureAttestationEnum>
    _$decidePermitApprovalRequestDigitalSignatureAttestationEnumSerializer =
    new _$DecidePermitApprovalRequestDigitalSignatureAttestationEnumSerializer();

class _$DecidePermitApprovalRequestDecisionEnumSerializer
    implements PrimitiveSerializer<DecidePermitApprovalRequestDecisionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'approve': 'approve',
    'reject': 'reject',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'approve': 'approve',
    'reject': 'reject',
  };

  @override
  final Iterable<Type> types = const <Type>[
    DecidePermitApprovalRequestDecisionEnum
  ];
  @override
  final String wireName = 'DecidePermitApprovalRequestDecisionEnum';

  @override
  Object serialize(Serializers serializers,
          DecidePermitApprovalRequestDecisionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DecidePermitApprovalRequestDecisionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DecidePermitApprovalRequestDecisionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DecidePermitApprovalRequestDigitalSignatureAttestationEnumSerializer
    implements
        PrimitiveSerializer<
            DecidePermitApprovalRequestDigitalSignatureAttestationEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    DecidePermitApprovalRequestDigitalSignatureAttestationEnum
  ];
  @override
  final String wireName =
      'DecidePermitApprovalRequestDigitalSignatureAttestationEnum';

  @override
  Object serialize(Serializers serializers,
          DecidePermitApprovalRequestDigitalSignatureAttestationEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DecidePermitApprovalRequestDigitalSignatureAttestationEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DecidePermitApprovalRequestDigitalSignatureAttestationEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DecidePermitApprovalRequest extends DecidePermitApprovalRequest {
  @override
  final DecidePermitApprovalRequestDecisionEnum decision;
  @override
  final DecidePermitApprovalRequestDigitalSignatureAttestationEnum
      digitalSignatureAttestation;
  @override
  final int expectedRevision;
  @override
  final String? rejectionReason;

  factory _$DecidePermitApprovalRequest(
          [void Function(DecidePermitApprovalRequestBuilder)? updates]) =>
      (new DecidePermitApprovalRequestBuilder()..update(updates))._build();

  _$DecidePermitApprovalRequest._(
      {required this.decision,
      required this.digitalSignatureAttestation,
      required this.expectedRevision,
      this.rejectionReason})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        decision, r'DecidePermitApprovalRequest', 'decision');
    BuiltValueNullFieldError.checkNotNull(digitalSignatureAttestation,
        r'DecidePermitApprovalRequest', 'digitalSignatureAttestation');
    BuiltValueNullFieldError.checkNotNull(
        expectedRevision, r'DecidePermitApprovalRequest', 'expectedRevision');
  }

  @override
  DecidePermitApprovalRequest rebuild(
          void Function(DecidePermitApprovalRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DecidePermitApprovalRequestBuilder toBuilder() =>
      new DecidePermitApprovalRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DecidePermitApprovalRequest &&
        decision == other.decision &&
        digitalSignatureAttestation == other.digitalSignatureAttestation &&
        expectedRevision == other.expectedRevision &&
        rejectionReason == other.rejectionReason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, decision.hashCode);
    _$hash = $jc(_$hash, digitalSignatureAttestation.hashCode);
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jc(_$hash, rejectionReason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DecidePermitApprovalRequest')
          ..add('decision', decision)
          ..add('digitalSignatureAttestation', digitalSignatureAttestation)
          ..add('expectedRevision', expectedRevision)
          ..add('rejectionReason', rejectionReason))
        .toString();
  }
}

class DecidePermitApprovalRequestBuilder
    implements
        Builder<DecidePermitApprovalRequest,
            DecidePermitApprovalRequestBuilder> {
  _$DecidePermitApprovalRequest? _$v;

  DecidePermitApprovalRequestDecisionEnum? _decision;
  DecidePermitApprovalRequestDecisionEnum? get decision => _$this._decision;
  set decision(DecidePermitApprovalRequestDecisionEnum? decision) =>
      _$this._decision = decision;

  DecidePermitApprovalRequestDigitalSignatureAttestationEnum?
      _digitalSignatureAttestation;
  DecidePermitApprovalRequestDigitalSignatureAttestationEnum?
      get digitalSignatureAttestation => _$this._digitalSignatureAttestation;
  set digitalSignatureAttestation(
          DecidePermitApprovalRequestDigitalSignatureAttestationEnum?
              digitalSignatureAttestation) =>
      _$this._digitalSignatureAttestation = digitalSignatureAttestation;

  int? _expectedRevision;
  int? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(int? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  String? _rejectionReason;
  String? get rejectionReason => _$this._rejectionReason;
  set rejectionReason(String? rejectionReason) =>
      _$this._rejectionReason = rejectionReason;

  DecidePermitApprovalRequestBuilder() {
    DecidePermitApprovalRequest._defaults(this);
  }

  DecidePermitApprovalRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _decision = $v.decision;
      _digitalSignatureAttestation = $v.digitalSignatureAttestation;
      _expectedRevision = $v.expectedRevision;
      _rejectionReason = $v.rejectionReason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DecidePermitApprovalRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DecidePermitApprovalRequest;
  }

  @override
  void update(void Function(DecidePermitApprovalRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DecidePermitApprovalRequest build() => _build();

  _$DecidePermitApprovalRequest _build() {
    final _$result = _$v ??
        new _$DecidePermitApprovalRequest._(
            decision: BuiltValueNullFieldError.checkNotNull(
                decision, r'DecidePermitApprovalRequest', 'decision'),
            digitalSignatureAttestation: BuiltValueNullFieldError.checkNotNull(
                digitalSignatureAttestation,
                r'DecidePermitApprovalRequest',
                'digitalSignatureAttestation'),
            expectedRevision: BuiltValueNullFieldError.checkNotNull(
                expectedRevision,
                r'DecidePermitApprovalRequest',
                'expectedRevision'),
            rejectionReason: rejectionReason);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
