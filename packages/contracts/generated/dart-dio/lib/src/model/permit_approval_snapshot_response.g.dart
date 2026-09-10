// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permit_approval_snapshot_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PermitApprovalSnapshotResponseStatusEnum
    _$permitApprovalSnapshotResponseStatusEnum_pending =
    const PermitApprovalSnapshotResponseStatusEnum._('pending');
const PermitApprovalSnapshotResponseStatusEnum
    _$permitApprovalSnapshotResponseStatusEnum_approved =
    const PermitApprovalSnapshotResponseStatusEnum._('approved');
const PermitApprovalSnapshotResponseStatusEnum
    _$permitApprovalSnapshotResponseStatusEnum_rejected =
    const PermitApprovalSnapshotResponseStatusEnum._('rejected');

PermitApprovalSnapshotResponseStatusEnum
    _$permitApprovalSnapshotResponseStatusEnumValueOf(String name) {
  switch (name) {
    case 'pending':
      return _$permitApprovalSnapshotResponseStatusEnum_pending;
    case 'approved':
      return _$permitApprovalSnapshotResponseStatusEnum_approved;
    case 'rejected':
      return _$permitApprovalSnapshotResponseStatusEnum_rejected;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<PermitApprovalSnapshotResponseStatusEnum>
    _$permitApprovalSnapshotResponseStatusEnumValues = new BuiltSet<
        PermitApprovalSnapshotResponseStatusEnum>(const <PermitApprovalSnapshotResponseStatusEnum>[
  _$permitApprovalSnapshotResponseStatusEnum_pending,
  _$permitApprovalSnapshotResponseStatusEnum_approved,
  _$permitApprovalSnapshotResponseStatusEnum_rejected,
]);

Serializer<PermitApprovalSnapshotResponseStatusEnum>
    _$permitApprovalSnapshotResponseStatusEnumSerializer =
    new _$PermitApprovalSnapshotResponseStatusEnumSerializer();

class _$PermitApprovalSnapshotResponseStatusEnumSerializer
    implements PrimitiveSerializer<PermitApprovalSnapshotResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pending': 'pending',
    'approved': 'approved',
    'rejected': 'rejected',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pending': 'pending',
    'approved': 'approved',
    'rejected': 'rejected',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PermitApprovalSnapshotResponseStatusEnum
  ];
  @override
  final String wireName = 'PermitApprovalSnapshotResponseStatusEnum';

  @override
  Object serialize(Serializers serializers,
          PermitApprovalSnapshotResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PermitApprovalSnapshotResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PermitApprovalSnapshotResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PermitApprovalSnapshotResponse extends PermitApprovalSnapshotResponse {
  @override
  final String approverRoleId;
  @override
  final String id;
  @override
  final String label;
  @override
  final String? rejectionReason;
  @override
  final bool required_;
  @override
  final DateTime? signedAt;
  @override
  final String? signedBy;
  @override
  final PermitApprovalSnapshotResponseStatusEnum status;
  @override
  final String templateStepId;

  factory _$PermitApprovalSnapshotResponse(
          [void Function(PermitApprovalSnapshotResponseBuilder)? updates]) =>
      (new PermitApprovalSnapshotResponseBuilder()..update(updates))._build();

  _$PermitApprovalSnapshotResponse._(
      {required this.approverRoleId,
      required this.id,
      required this.label,
      this.rejectionReason,
      required this.required_,
      this.signedAt,
      this.signedBy,
      required this.status,
      required this.templateStepId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        approverRoleId, r'PermitApprovalSnapshotResponse', 'approverRoleId');
    BuiltValueNullFieldError.checkNotNull(
        id, r'PermitApprovalSnapshotResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        label, r'PermitApprovalSnapshotResponse', 'label');
    BuiltValueNullFieldError.checkNotNull(
        required_, r'PermitApprovalSnapshotResponse', 'required_');
    BuiltValueNullFieldError.checkNotNull(
        status, r'PermitApprovalSnapshotResponse', 'status');
    BuiltValueNullFieldError.checkNotNull(
        templateStepId, r'PermitApprovalSnapshotResponse', 'templateStepId');
  }

  @override
  PermitApprovalSnapshotResponse rebuild(
          void Function(PermitApprovalSnapshotResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermitApprovalSnapshotResponseBuilder toBuilder() =>
      new PermitApprovalSnapshotResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermitApprovalSnapshotResponse &&
        approverRoleId == other.approverRoleId &&
        id == other.id &&
        label == other.label &&
        rejectionReason == other.rejectionReason &&
        required_ == other.required_ &&
        signedAt == other.signedAt &&
        signedBy == other.signedBy &&
        status == other.status &&
        templateStepId == other.templateStepId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, approverRoleId.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, rejectionReason.hashCode);
    _$hash = $jc(_$hash, required_.hashCode);
    _$hash = $jc(_$hash, signedAt.hashCode);
    _$hash = $jc(_$hash, signedBy.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, templateStepId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PermitApprovalSnapshotResponse')
          ..add('approverRoleId', approverRoleId)
          ..add('id', id)
          ..add('label', label)
          ..add('rejectionReason', rejectionReason)
          ..add('required_', required_)
          ..add('signedAt', signedAt)
          ..add('signedBy', signedBy)
          ..add('status', status)
          ..add('templateStepId', templateStepId))
        .toString();
  }
}

class PermitApprovalSnapshotResponseBuilder
    implements
        Builder<PermitApprovalSnapshotResponse,
            PermitApprovalSnapshotResponseBuilder> {
  _$PermitApprovalSnapshotResponse? _$v;

  String? _approverRoleId;
  String? get approverRoleId => _$this._approverRoleId;
  set approverRoleId(String? approverRoleId) =>
      _$this._approverRoleId = approverRoleId;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _rejectionReason;
  String? get rejectionReason => _$this._rejectionReason;
  set rejectionReason(String? rejectionReason) =>
      _$this._rejectionReason = rejectionReason;

  bool? _required_;
  bool? get required_ => _$this._required_;
  set required_(bool? required_) => _$this._required_ = required_;

  DateTime? _signedAt;
  DateTime? get signedAt => _$this._signedAt;
  set signedAt(DateTime? signedAt) => _$this._signedAt = signedAt;

  String? _signedBy;
  String? get signedBy => _$this._signedBy;
  set signedBy(String? signedBy) => _$this._signedBy = signedBy;

  PermitApprovalSnapshotResponseStatusEnum? _status;
  PermitApprovalSnapshotResponseStatusEnum? get status => _$this._status;
  set status(PermitApprovalSnapshotResponseStatusEnum? status) =>
      _$this._status = status;

  String? _templateStepId;
  String? get templateStepId => _$this._templateStepId;
  set templateStepId(String? templateStepId) =>
      _$this._templateStepId = templateStepId;

  PermitApprovalSnapshotResponseBuilder() {
    PermitApprovalSnapshotResponse._defaults(this);
  }

  PermitApprovalSnapshotResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _approverRoleId = $v.approverRoleId;
      _id = $v.id;
      _label = $v.label;
      _rejectionReason = $v.rejectionReason;
      _required_ = $v.required_;
      _signedAt = $v.signedAt;
      _signedBy = $v.signedBy;
      _status = $v.status;
      _templateStepId = $v.templateStepId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermitApprovalSnapshotResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermitApprovalSnapshotResponse;
  }

  @override
  void update(void Function(PermitApprovalSnapshotResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermitApprovalSnapshotResponse build() => _build();

  _$PermitApprovalSnapshotResponse _build() {
    final _$result = _$v ??
        new _$PermitApprovalSnapshotResponse._(
            approverRoleId: BuiltValueNullFieldError.checkNotNull(
                approverRoleId,
                r'PermitApprovalSnapshotResponse',
                'approverRoleId'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PermitApprovalSnapshotResponse', 'id'),
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'PermitApprovalSnapshotResponse', 'label'),
            rejectionReason: rejectionReason,
            required_: BuiltValueNullFieldError.checkNotNull(
                required_, r'PermitApprovalSnapshotResponse', 'required_'),
            signedAt: signedAt,
            signedBy: signedBy,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'PermitApprovalSnapshotResponse', 'status'),
            templateStepId: BuiltValueNullFieldError.checkNotNull(
                templateStepId,
                r'PermitApprovalSnapshotResponse',
                'templateStepId'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
