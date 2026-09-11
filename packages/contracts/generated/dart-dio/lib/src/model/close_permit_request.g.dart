// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'close_permit_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ClosePermitRequestCloseAttestationEnum
    _$closePermitRequestCloseAttestationEnum_true_ =
    const ClosePermitRequestCloseAttestationEnum._('true_');

ClosePermitRequestCloseAttestationEnum
    _$closePermitRequestCloseAttestationEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$closePermitRequestCloseAttestationEnum_true_;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ClosePermitRequestCloseAttestationEnum>
    _$closePermitRequestCloseAttestationEnumValues = new BuiltSet<
        ClosePermitRequestCloseAttestationEnum>(const <ClosePermitRequestCloseAttestationEnum>[
  _$closePermitRequestCloseAttestationEnum_true_,
]);

Serializer<ClosePermitRequestCloseAttestationEnum>
    _$closePermitRequestCloseAttestationEnumSerializer =
    new _$ClosePermitRequestCloseAttestationEnumSerializer();

class _$ClosePermitRequestCloseAttestationEnumSerializer
    implements PrimitiveSerializer<ClosePermitRequestCloseAttestationEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ClosePermitRequestCloseAttestationEnum
  ];
  @override
  final String wireName = 'ClosePermitRequestCloseAttestationEnum';

  @override
  Object serialize(Serializers serializers,
          ClosePermitRequestCloseAttestationEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ClosePermitRequestCloseAttestationEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ClosePermitRequestCloseAttestationEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ClosePermitRequest extends ClosePermitRequest {
  @override
  final ClosePermitRequestCloseAttestationEnum closeAttestation;
  @override
  final String closeoutNotes;
  @override
  final int expectedRevision;

  factory _$ClosePermitRequest(
          [void Function(ClosePermitRequestBuilder)? updates]) =>
      (new ClosePermitRequestBuilder()..update(updates))._build();

  _$ClosePermitRequest._(
      {required this.closeAttestation,
      required this.closeoutNotes,
      required this.expectedRevision})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        closeAttestation, r'ClosePermitRequest', 'closeAttestation');
    BuiltValueNullFieldError.checkNotNull(
        closeoutNotes, r'ClosePermitRequest', 'closeoutNotes');
    BuiltValueNullFieldError.checkNotNull(
        expectedRevision, r'ClosePermitRequest', 'expectedRevision');
  }

  @override
  ClosePermitRequest rebuild(
          void Function(ClosePermitRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClosePermitRequestBuilder toBuilder() =>
      new ClosePermitRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClosePermitRequest &&
        closeAttestation == other.closeAttestation &&
        closeoutNotes == other.closeoutNotes &&
        expectedRevision == other.expectedRevision;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, closeAttestation.hashCode);
    _$hash = $jc(_$hash, closeoutNotes.hashCode);
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ClosePermitRequest')
          ..add('closeAttestation', closeAttestation)
          ..add('closeoutNotes', closeoutNotes)
          ..add('expectedRevision', expectedRevision))
        .toString();
  }
}

class ClosePermitRequestBuilder
    implements Builder<ClosePermitRequest, ClosePermitRequestBuilder> {
  _$ClosePermitRequest? _$v;

  ClosePermitRequestCloseAttestationEnum? _closeAttestation;
  ClosePermitRequestCloseAttestationEnum? get closeAttestation =>
      _$this._closeAttestation;
  set closeAttestation(
          ClosePermitRequestCloseAttestationEnum? closeAttestation) =>
      _$this._closeAttestation = closeAttestation;

  String? _closeoutNotes;
  String? get closeoutNotes => _$this._closeoutNotes;
  set closeoutNotes(String? closeoutNotes) =>
      _$this._closeoutNotes = closeoutNotes;

  int? _expectedRevision;
  int? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(int? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  ClosePermitRequestBuilder() {
    ClosePermitRequest._defaults(this);
  }

  ClosePermitRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _closeAttestation = $v.closeAttestation;
      _closeoutNotes = $v.closeoutNotes;
      _expectedRevision = $v.expectedRevision;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClosePermitRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ClosePermitRequest;
  }

  @override
  void update(void Function(ClosePermitRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ClosePermitRequest build() => _build();

  _$ClosePermitRequest _build() {
    final _$result = _$v ??
        new _$ClosePermitRequest._(
            closeAttestation: BuiltValueNullFieldError.checkNotNull(
                closeAttestation, r'ClosePermitRequest', 'closeAttestation'),
            closeoutNotes: BuiltValueNullFieldError.checkNotNull(
                closeoutNotes, r'ClosePermitRequest', 'closeoutNotes'),
            expectedRevision: BuiltValueNullFieldError.checkNotNull(
                expectedRevision, r'ClosePermitRequest', 'expectedRevision'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
