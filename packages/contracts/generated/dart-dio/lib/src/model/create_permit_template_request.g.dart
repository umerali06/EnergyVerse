// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_permit_template_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreatePermitTemplateRequestPermitTypeEnum
    _$createPermitTemplateRequestPermitTypeEnum_hotWork =
    const CreatePermitTemplateRequestPermitTypeEnum._('hotWork');
const CreatePermitTemplateRequestPermitTypeEnum
    _$createPermitTemplateRequestPermitTypeEnum_confinedSpace =
    const CreatePermitTemplateRequestPermitTypeEnum._('confinedSpace');
const CreatePermitTemplateRequestPermitTypeEnum
    _$createPermitTemplateRequestPermitTypeEnum_electricalIsolationLoto =
    const CreatePermitTemplateRequestPermitTypeEnum._(
        'electricalIsolationLoto');
const CreatePermitTemplateRequestPermitTypeEnum
    _$createPermitTemplateRequestPermitTypeEnum_excavation =
    const CreatePermitTemplateRequestPermitTypeEnum._('excavation');
const CreatePermitTemplateRequestPermitTypeEnum
    _$createPermitTemplateRequestPermitTypeEnum_workingAtHeight =
    const CreatePermitTemplateRequestPermitTypeEnum._('workingAtHeight');
const CreatePermitTemplateRequestPermitTypeEnum
    _$createPermitTemplateRequestPermitTypeEnum_generalMaintenance =
    const CreatePermitTemplateRequestPermitTypeEnum._('generalMaintenance');

CreatePermitTemplateRequestPermitTypeEnum
    _$createPermitTemplateRequestPermitTypeEnumValueOf(String name) {
  switch (name) {
    case 'hotWork':
      return _$createPermitTemplateRequestPermitTypeEnum_hotWork;
    case 'confinedSpace':
      return _$createPermitTemplateRequestPermitTypeEnum_confinedSpace;
    case 'electricalIsolationLoto':
      return _$createPermitTemplateRequestPermitTypeEnum_electricalIsolationLoto;
    case 'excavation':
      return _$createPermitTemplateRequestPermitTypeEnum_excavation;
    case 'workingAtHeight':
      return _$createPermitTemplateRequestPermitTypeEnum_workingAtHeight;
    case 'generalMaintenance':
      return _$createPermitTemplateRequestPermitTypeEnum_generalMaintenance;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CreatePermitTemplateRequestPermitTypeEnum>
    _$createPermitTemplateRequestPermitTypeEnumValues = new BuiltSet<
        CreatePermitTemplateRequestPermitTypeEnum>(const <CreatePermitTemplateRequestPermitTypeEnum>[
  _$createPermitTemplateRequestPermitTypeEnum_hotWork,
  _$createPermitTemplateRequestPermitTypeEnum_confinedSpace,
  _$createPermitTemplateRequestPermitTypeEnum_electricalIsolationLoto,
  _$createPermitTemplateRequestPermitTypeEnum_excavation,
  _$createPermitTemplateRequestPermitTypeEnum_workingAtHeight,
  _$createPermitTemplateRequestPermitTypeEnum_generalMaintenance,
]);

Serializer<CreatePermitTemplateRequestPermitTypeEnum>
    _$createPermitTemplateRequestPermitTypeEnumSerializer =
    new _$CreatePermitTemplateRequestPermitTypeEnumSerializer();

class _$CreatePermitTemplateRequestPermitTypeEnumSerializer
    implements PrimitiveSerializer<CreatePermitTemplateRequestPermitTypeEnum> {
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
    CreatePermitTemplateRequestPermitTypeEnum
  ];
  @override
  final String wireName = 'CreatePermitTemplateRequestPermitTypeEnum';

  @override
  Object serialize(Serializers serializers,
          CreatePermitTemplateRequestPermitTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreatePermitTemplateRequestPermitTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreatePermitTemplateRequestPermitTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreatePermitTemplateRequest extends CreatePermitTemplateRequest {
  @override
  final BuiltList<PermitApprovalTemplateStepInput> approvalSteps;
  @override
  final BuiltList<PermitChecklistTemplateItemInput> checklistItems;
  @override
  final String? description;
  @override
  final String name;
  @override
  final CreatePermitTemplateRequestPermitTypeEnum permitType;

  factory _$CreatePermitTemplateRequest(
          [void Function(CreatePermitTemplateRequestBuilder)? updates]) =>
      (new CreatePermitTemplateRequestBuilder()..update(updates))._build();

  _$CreatePermitTemplateRequest._(
      {required this.approvalSteps,
      required this.checklistItems,
      this.description,
      required this.name,
      required this.permitType})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        approvalSteps, r'CreatePermitTemplateRequest', 'approvalSteps');
    BuiltValueNullFieldError.checkNotNull(
        checklistItems, r'CreatePermitTemplateRequest', 'checklistItems');
    BuiltValueNullFieldError.checkNotNull(
        name, r'CreatePermitTemplateRequest', 'name');
    BuiltValueNullFieldError.checkNotNull(
        permitType, r'CreatePermitTemplateRequest', 'permitType');
  }

  @override
  CreatePermitTemplateRequest rebuild(
          void Function(CreatePermitTemplateRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreatePermitTemplateRequestBuilder toBuilder() =>
      new CreatePermitTemplateRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreatePermitTemplateRequest &&
        approvalSteps == other.approvalSteps &&
        checklistItems == other.checklistItems &&
        description == other.description &&
        name == other.name &&
        permitType == other.permitType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, approvalSteps.hashCode);
    _$hash = $jc(_$hash, checklistItems.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, permitType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreatePermitTemplateRequest')
          ..add('approvalSteps', approvalSteps)
          ..add('checklistItems', checklistItems)
          ..add('description', description)
          ..add('name', name)
          ..add('permitType', permitType))
        .toString();
  }
}

class CreatePermitTemplateRequestBuilder
    implements
        Builder<CreatePermitTemplateRequest,
            CreatePermitTemplateRequestBuilder> {
  _$CreatePermitTemplateRequest? _$v;

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

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  CreatePermitTemplateRequestPermitTypeEnum? _permitType;
  CreatePermitTemplateRequestPermitTypeEnum? get permitType =>
      _$this._permitType;
  set permitType(CreatePermitTemplateRequestPermitTypeEnum? permitType) =>
      _$this._permitType = permitType;

  CreatePermitTemplateRequestBuilder() {
    CreatePermitTemplateRequest._defaults(this);
  }

  CreatePermitTemplateRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _approvalSteps = $v.approvalSteps.toBuilder();
      _checklistItems = $v.checklistItems.toBuilder();
      _description = $v.description;
      _name = $v.name;
      _permitType = $v.permitType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreatePermitTemplateRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreatePermitTemplateRequest;
  }

  @override
  void update(void Function(CreatePermitTemplateRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreatePermitTemplateRequest build() => _build();

  _$CreatePermitTemplateRequest _build() {
    _$CreatePermitTemplateRequest _$result;
    try {
      _$result = _$v ??
          new _$CreatePermitTemplateRequest._(
              approvalSteps: approvalSteps.build(),
              checklistItems: checklistItems.build(),
              description: description,
              name: BuiltValueNullFieldError.checkNotNull(
                  name, r'CreatePermitTemplateRequest', 'name'),
              permitType: BuiltValueNullFieldError.checkNotNull(
                  permitType, r'CreatePermitTemplateRequest', 'permitType'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'approvalSteps';
        approvalSteps.build();
        _$failedField = 'checklistItems';
        checklistItems.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CreatePermitTemplateRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
