// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transition_safety_report_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TransitionSafetyReportRequestStatusEnum
    _$transitionSafetyReportRequestStatusEnum_underReview =
    const TransitionSafetyReportRequestStatusEnum._('underReview');
const TransitionSafetyReportRequestStatusEnum
    _$transitionSafetyReportRequestStatusEnum_correctiveAction =
    const TransitionSafetyReportRequestStatusEnum._('correctiveAction');
const TransitionSafetyReportRequestStatusEnum
    _$transitionSafetyReportRequestStatusEnum_resolved =
    const TransitionSafetyReportRequestStatusEnum._('resolved');
const TransitionSafetyReportRequestStatusEnum
    _$transitionSafetyReportRequestStatusEnum_cancelled =
    const TransitionSafetyReportRequestStatusEnum._('cancelled');

TransitionSafetyReportRequestStatusEnum
    _$transitionSafetyReportRequestStatusEnumValueOf(String name) {
  switch (name) {
    case 'underReview':
      return _$transitionSafetyReportRequestStatusEnum_underReview;
    case 'correctiveAction':
      return _$transitionSafetyReportRequestStatusEnum_correctiveAction;
    case 'resolved':
      return _$transitionSafetyReportRequestStatusEnum_resolved;
    case 'cancelled':
      return _$transitionSafetyReportRequestStatusEnum_cancelled;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<TransitionSafetyReportRequestStatusEnum>
    _$transitionSafetyReportRequestStatusEnumValues = new BuiltSet<
        TransitionSafetyReportRequestStatusEnum>(const <TransitionSafetyReportRequestStatusEnum>[
  _$transitionSafetyReportRequestStatusEnum_underReview,
  _$transitionSafetyReportRequestStatusEnum_correctiveAction,
  _$transitionSafetyReportRequestStatusEnum_resolved,
  _$transitionSafetyReportRequestStatusEnum_cancelled,
]);

Serializer<TransitionSafetyReportRequestStatusEnum>
    _$transitionSafetyReportRequestStatusEnumSerializer =
    new _$TransitionSafetyReportRequestStatusEnumSerializer();

class _$TransitionSafetyReportRequestStatusEnumSerializer
    implements PrimitiveSerializer<TransitionSafetyReportRequestStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'underReview': 'under_review',
    'correctiveAction': 'corrective_action',
    'resolved': 'resolved',
    'cancelled': 'cancelled',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'under_review': 'underReview',
    'corrective_action': 'correctiveAction',
    'resolved': 'resolved',
    'cancelled': 'cancelled',
  };

  @override
  final Iterable<Type> types = const <Type>[
    TransitionSafetyReportRequestStatusEnum
  ];
  @override
  final String wireName = 'TransitionSafetyReportRequestStatusEnum';

  @override
  Object serialize(Serializers serializers,
          TransitionSafetyReportRequestStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TransitionSafetyReportRequestStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TransitionSafetyReportRequestStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TransitionSafetyReportRequest extends TransitionSafetyReportRequest {
  @override
  final int? expectedRevision;
  @override
  final TransitionSafetyReportRequestStatusEnum status;

  factory _$TransitionSafetyReportRequest(
          [void Function(TransitionSafetyReportRequestBuilder)? updates]) =>
      (new TransitionSafetyReportRequestBuilder()..update(updates))._build();

  _$TransitionSafetyReportRequest._(
      {this.expectedRevision, required this.status})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        status, r'TransitionSafetyReportRequest', 'status');
  }

  @override
  TransitionSafetyReportRequest rebuild(
          void Function(TransitionSafetyReportRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TransitionSafetyReportRequestBuilder toBuilder() =>
      new TransitionSafetyReportRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TransitionSafetyReportRequest &&
        expectedRevision == other.expectedRevision &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TransitionSafetyReportRequest')
          ..add('expectedRevision', expectedRevision)
          ..add('status', status))
        .toString();
  }
}

class TransitionSafetyReportRequestBuilder
    implements
        Builder<TransitionSafetyReportRequest,
            TransitionSafetyReportRequestBuilder> {
  _$TransitionSafetyReportRequest? _$v;

  int? _expectedRevision;
  int? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(int? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  TransitionSafetyReportRequestStatusEnum? _status;
  TransitionSafetyReportRequestStatusEnum? get status => _$this._status;
  set status(TransitionSafetyReportRequestStatusEnum? status) =>
      _$this._status = status;

  TransitionSafetyReportRequestBuilder() {
    TransitionSafetyReportRequest._defaults(this);
  }

  TransitionSafetyReportRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedRevision = $v.expectedRevision;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TransitionSafetyReportRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$TransitionSafetyReportRequest;
  }

  @override
  void update(void Function(TransitionSafetyReportRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TransitionSafetyReportRequest build() => _build();

  _$TransitionSafetyReportRequest _build() {
    final _$result = _$v ??
        new _$TransitionSafetyReportRequest._(
            expectedRevision: expectedRevision,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'TransitionSafetyReportRequest', 'status'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
