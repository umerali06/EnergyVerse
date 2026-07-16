// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demo_gate_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DemoGateResponseOkEnum _$demoGateResponseOkEnum_true_ =
    const DemoGateResponseOkEnum._('true_');

DemoGateResponseOkEnum _$demoGateResponseOkEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$demoGateResponseOkEnum_true_;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<DemoGateResponseOkEnum> _$demoGateResponseOkEnumValues =
    new BuiltSet<DemoGateResponseOkEnum>(const <DemoGateResponseOkEnum>[
  _$demoGateResponseOkEnum_true_,
]);

Serializer<DemoGateResponseOkEnum> _$demoGateResponseOkEnumSerializer =
    new _$DemoGateResponseOkEnumSerializer();

class _$DemoGateResponseOkEnumSerializer
    implements PrimitiveSerializer<DemoGateResponseOkEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[DemoGateResponseOkEnum];
  @override
  final String wireName = 'DemoGateResponseOkEnum';

  @override
  Object serialize(Serializers serializers, DemoGateResponseOkEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DemoGateResponseOkEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DemoGateResponseOkEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DemoGateResponse extends DemoGateResponse {
  @override
  final DemoGateResponseOkEnum ok;

  factory _$DemoGateResponse(
          [void Function(DemoGateResponseBuilder)? updates]) =>
      (new DemoGateResponseBuilder()..update(updates))._build();

  _$DemoGateResponse._({required this.ok}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ok, r'DemoGateResponse', 'ok');
  }

  @override
  DemoGateResponse rebuild(void Function(DemoGateResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DemoGateResponseBuilder toBuilder() =>
      new DemoGateResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DemoGateResponse && ok == other.ok;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ok.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DemoGateResponse')..add('ok', ok))
        .toString();
  }
}

class DemoGateResponseBuilder
    implements Builder<DemoGateResponse, DemoGateResponseBuilder> {
  _$DemoGateResponse? _$v;

  DemoGateResponseOkEnum? _ok;
  DemoGateResponseOkEnum? get ok => _$this._ok;
  set ok(DemoGateResponseOkEnum? ok) => _$this._ok = ok;

  DemoGateResponseBuilder() {
    DemoGateResponse._defaults(this);
  }

  DemoGateResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ok = $v.ok;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DemoGateResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DemoGateResponse;
  }

  @override
  void update(void Function(DemoGateResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DemoGateResponse build() => _build();

  _$DemoGateResponse _build() {
    final _$result = _$v ??
        new _$DemoGateResponse._(
            ok: BuiltValueNullFieldError.checkNotNull(
                ok, r'DemoGateResponse', 'ok'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
