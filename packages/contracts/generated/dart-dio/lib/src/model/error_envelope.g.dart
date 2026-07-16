// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ErrorEnvelope extends ErrorEnvelope {
  @override
  final BuiltMap<String, JsonObject?>? details;
  @override
  final String error;
  @override
  final String message;
  @override
  final String requestId;

  factory _$ErrorEnvelope([void Function(ErrorEnvelopeBuilder)? updates]) =>
      (new ErrorEnvelopeBuilder()..update(updates))._build();

  _$ErrorEnvelope._(
      {this.details,
      required this.error,
      required this.message,
      required this.requestId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(error, r'ErrorEnvelope', 'error');
    BuiltValueNullFieldError.checkNotNull(message, r'ErrorEnvelope', 'message');
    BuiltValueNullFieldError.checkNotNull(
        requestId, r'ErrorEnvelope', 'requestId');
  }

  @override
  ErrorEnvelope rebuild(void Function(ErrorEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ErrorEnvelopeBuilder toBuilder() => new ErrorEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ErrorEnvelope &&
        details == other.details &&
        error == other.error &&
        message == other.message &&
        requestId == other.requestId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, requestId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ErrorEnvelope')
          ..add('details', details)
          ..add('error', error)
          ..add('message', message)
          ..add('requestId', requestId))
        .toString();
  }
}

class ErrorEnvelopeBuilder
    implements Builder<ErrorEnvelope, ErrorEnvelopeBuilder> {
  _$ErrorEnvelope? _$v;

  MapBuilder<String, JsonObject?>? _details;
  MapBuilder<String, JsonObject?> get details =>
      _$this._details ??= new MapBuilder<String, JsonObject?>();
  set details(MapBuilder<String, JsonObject?>? details) =>
      _$this._details = details;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _requestId;
  String? get requestId => _$this._requestId;
  set requestId(String? requestId) => _$this._requestId = requestId;

  ErrorEnvelopeBuilder() {
    ErrorEnvelope._defaults(this);
  }

  ErrorEnvelopeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _details = $v.details?.toBuilder();
      _error = $v.error;
      _message = $v.message;
      _requestId = $v.requestId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ErrorEnvelope other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ErrorEnvelope;
  }

  @override
  void update(void Function(ErrorEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ErrorEnvelope build() => _build();

  _$ErrorEnvelope _build() {
    _$ErrorEnvelope _$result;
    try {
      _$result = _$v ??
          new _$ErrorEnvelope._(
              details: _details?.build(),
              error: BuiltValueNullFieldError.checkNotNull(
                  error, r'ErrorEnvelope', 'error'),
              message: BuiltValueNullFieldError.checkNotNull(
                  message, r'ErrorEnvelope', 'message'),
              requestId: BuiltValueNullFieldError.checkNotNull(
                  requestId, r'ErrorEnvelope', 'requestId'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'details';
        _details?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ErrorEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
