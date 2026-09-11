// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_permit_template_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UpdatePermitTemplateRequestPermitTypeEnum
    _$updatePermitTemplateRequestPermitTypeEnum_hotWork =
    const UpdatePermitTemplateRequestPermitTypeEnum._('hotWork');
const UpdatePermitTemplateRequestPermitTypeEnum
    _$updatePermitTemplateRequestPermitTypeEnum_confinedSpace =
    const UpdatePermitTemplateRequestPermitTypeEnum._('confinedSpace');
const UpdatePermitTemplateRequestPermitTypeEnum
    _$updatePermitTemplateRequestPermitTypeEnum_electricalIsolationLoto =
    const UpdatePermitTemplateRequestPermitTypeEnum._(
        'electricalIsolationLoto');
const UpdatePermitTemplateRequestPermitTypeEnum
    _$updatePermitTemplateRequestPermitTypeEnum_excavation =
    const UpdatePermitTemplateRequestPermitTypeEnum._('excavation');
const UpdatePermitTemplateRequestPermitTypeEnum
    _$updatePermitTemplateRequestPermitTypeEnum_workingAtHeight =
    const UpdatePermitTemplateRequestPermitTypeEnum._('workingAtHeight');
const UpdatePermitTemplateRequestPermitTypeEnum
    _$updatePermitTemplateRequestPermitTypeEnum_generalMaintenance =
    const UpdatePermitTemplateRequestPermitTypeEnum._('generalMaintenance');

UpdatePermitTemplateRequestPermitTypeEnum
    _$updatePermitTemplateRequestPermitTypeEnumValueOf(String name) {
  switch (name) {
    case 'hotWork':
      return _$updatePermitTemplateRequestPermitTypeEnum_hotWork;
    case 'confinedSpace':
      return _$updatePermitTemplateRequestPermitTypeEnum_confinedSpace;
    case 'electricalIsolationLoto':
      return _$updatePermitTemplateRequestPermitTypeEnum_electricalIsolationLoto;
    case 'excavation':
      return _$updatePermitTemplateRequestPermitTypeEnum_excavation;
    case 'workingAtHeight':
      return _$updatePermitTemplateRequestPermitTypeEnum_workingAtHeight;
    case 'generalMaintenance':
      return _$updatePermitTemplateRequestPermitTypeEnum_generalMaintenance;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<UpdatePermitTemplateRequestPermitTypeEnum>
    _$updatePermitTemplateRequestPermitTypeEnumValues = new BuiltSet<
        UpdatePermitTemplateRequestPermitTypeEnum>(const <UpdatePermitTemplateRequestPermitTypeEnum>[
  _$updatePermitTemplateRequestPermitTypeEnum_hotWork,
  _$updatePermitTemplateRequestPermitTypeEnum_confinedSpace,
  _$updatePermitTemplateRequestPermitTypeEnum_electricalIsolationLoto,
  _$updatePermitTemplateRequestPermitTypeEnum_excavation,
  _$updatePermitTemplateRequestPermitTypeEnum_workingAtHeight,
  _$updatePermitTemplateRequestPermitTypeEnum_generalMaintenance,
]);

Serializer<UpdatePermitTemplateRequestPermitTypeEnum>
    _$updatePermitTemplateRequestPermitTypeEnumSerializer =
    new _$UpdatePermitTemplateRequestPermitTypeEnumSerializer();

class _$UpdatePermitTemplateRequestPermitTypeEnumSerializer
    implements PrimitiveSerializer<UpdatePermitTemplateRequestPermitTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'hotWork': 'hot_work',
    'confinedSpace': 'confined_space',
    'electricalIsolationLoto': 'electrical_isolation_loto',
    'excavation': 'excavation',
    'workingAtHeight': 'working_at_height',
    'generalMaintenance': 'general_maintenance',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'hot_work': 'hotWork',
    'confined_space': 'confinedSpace',
    'electrical_isolation_loto': 'electricalIsolationLoto',
    'excavation': 'excavation',
    'working_at_height': 'workingAtHeight',
    'general_maintenance': 'generalMaintenance',
  };

  @override
  final Iterable<Type> types = const <Type>[
    UpdatePermitTemplateRequestPermitTypeEnum
  ];
  @override
  final String wireName = 'UpdatePermitTemplateRequestPermitTypeEnum';

  @override
  Object serialize(Serializers serializers,
          UpdatePermitTemplateRequestPermitTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UpdatePermitTemplateRequestPermitTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UpdatePermitTemplateRequestPermitTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UpdatePermitTemplateRequest extends UpdatePermitTemplateRequest {
  @override
  final BuiltList<PermitApprovalTemplateStepInput>? approvalSteps;
  @override
  final BuiltList<PermitChecklistTemplateItemInput>? checklistItems;
  @override
  final String? description;
  @override
  final int expectedVersion;
  @override
  final String? name;
  @override
  final UpdatePermitTemplateRequestPermitTypeEnum? permitType;

  factory _$UpdatePermitTemplateRequest(
          [void Function(UpdatePermitTemplateRequestBuilder)? updates]) =>
      (new UpdatePermitTemplateRequestBuilder()..update(updates))._build();

  _$UpdatePermitTemplateRequest._(
      {this.approvalSteps,
      this.checklistItems,
      this.description,
      required this.expectedVersion,
      this.name,
      this.permitType})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        expectedVersion, r'UpdatePermitTemplateRequest', 'expectedVersion');
  }

  @override
  UpdatePermitTemplateRequest rebuild(
          void Function(UpdatePermitTemplateRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdatePermitTemplateRequestBuilder toBuilder() =>
      new UpdatePermitTemplateRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdatePermitTemplateRequest &&
        approvalSteps == other.approvalSteps &&
        checklistItems == other.checklistItems &&
        description == other.description &&
        expectedVersion == other.expectedVersion &&
        name == other.name &&
        permitType == other.permitType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, approvalSteps.hashCode);
    _$hash = $jc(_$hash, checklistItems.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, expectedVersion.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, permitType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdatePermitTemplateRequest')
          ..add('approvalSteps', approvalSteps)
          ..add('checklistItems', checklistItems)
          ..add('description', description)
          ..add('expectedVersion', expectedVersion)
          ..add('name', name)
          ..add('permitType', permitType))
        .toString();
  }
}

class UpdatePermitTemplateRequestBuilder
    implements
        Builder<UpdatePermitTemplateRequest,
            UpdatePermitTemplateRequestBuilder> {
  _$UpdatePermitTemplateRequest? _$v;

  ListBuilder<PermitApprovalTemplateStepInput>? _approvalSteps;
  ListBuilder<PermitApprovalTemplateStepInput> get approvalSteps =>
      _$this._approvalSteps ??=
          new ListBuilder<PermitApprovalTemplateStepInput>();
  set approvalSteps(
          ListBuilder<PermitApprovalTemplateStepInput>? approvalSteps) =>
      _$this._approvalSteps = approvalSteps;

  ListBuilder<PermitChecklistTemplateItemInput>? _checklistItems;
  ListBuilder<PermitChecklistTemplateItemInput> get checklistItems =>
      _$this._checklistItems ??=
          new ListBuilder<PermitChecklistTemplateItemInput>();
  set checklistItems(
          ListBuilder<PermitChecklistTemplateItemInput>? checklistItems) =>
      _$this._checklistItems = checklistItems;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _expectedVersion;
  int? get expectedVersion => _$this._expectedVersion;
  set expectedVersion(int? expectedVersion) =>
      _$this._expectedVersion = expectedVersion;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  UpdatePermitTemplateRequestPermitTypeEnum? _permitType;
  UpdatePermitTemplateRequestPermitTypeEnum? get permitType =>
      _$this._permitType;
  set permitType(UpdatePermitTemplateRequestPermitTypeEnum? permitType) =>
      _$this._permitType = permitType;

  UpdatePermitTemplateRequestBuilder() {
    UpdatePermitTemplateRequest._defaults(this);
  }

  UpdatePermitTemplateRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _approvalSteps = $v.approvalSteps?.toBuilder();
      _checklistItems = $v.checklistItems?.toBuilder();
      _description = $v.description;
      _expectedVersion = $v.expectedVersion;
      _name = $v.name;
      _permitType = $v.permitType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdatePermitTemplateRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdatePermitTemplateRequest;
  }

  @override
  void update(void Function(UpdatePermitTemplateRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdatePermitTemplateRequest build() => _build();

  _$UpdatePermitTemplateRequest _build() {
    _$UpdatePermitTemplateRequest _$result;
    try {
      _$result = _$v ??
          new _$UpdatePermitTemplateRequest._(
              approvalSteps: _approvalSteps?.build(),
              checklistItems: _checklistItems?.build(),
              description: description,
              expectedVersion: BuiltValueNullFieldError.checkNotNull(
                  expectedVersion,
                  r'UpdatePermitTemplateRequest',
                  'expectedVersion'),
              name: name,
              permitType: permitType);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'approvalSteps';
        _approvalSteps?.build();
        _$failedField = 'checklistItems';
        _checklistItems?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UpdatePermitTemplateRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
