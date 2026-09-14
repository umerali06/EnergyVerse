// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContactResponse extends ContactResponse {
  @override
  final bool received;

  factory _$ContactResponse([void Function(ContactResponseBuilder)? updates]) =>
      (new ContactResponseBuilder()..update(updates))._build();

  _$ContactResponse._({required this.received}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        received, r'ContactResponse', 'received');
  }

  @override
  ContactResponse rebuild(void Function(ContactResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContactResponseBuilder toBuilder() =>
      new ContactResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContactResponse && received == other.received;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, received.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContactResponse')
          ..add('received', received))
        .toString();
  }
}

class ContactResponseBuilder
    implements Builder<ContactResponse, ContactResponseBuilder> {
  _$ContactResponse? _$v;

  bool? _received;
  bool? get received => _$this._received;
  set received(bool? received) => _$this._received = received;

  ContactResponseBuilder() {
    ContactResponse._defaults(this);
  }

  ContactResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _received = $v.received;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContactResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ContactResponse;
  }

  @override
  void update(void Function(ContactResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContactResponse build() => _build();

  _$ContactResponse _build() {
    final _$result = _$v ??
        new _$ContactResponse._(
            received: BuiltValueNullFieldError.checkNotNull(
                received, r'ContactResponse', 'received'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
