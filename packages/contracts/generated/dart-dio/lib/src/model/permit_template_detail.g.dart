// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permit_template_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PermitTemplateDetailPermitTypeEnum
    _$permitTemplateDetailPermitTypeEnum_hotWork =
    const PermitTemplateDetailPermitTypeEnum._('hotWork');
const PermitTemplateDetailPermitTypeEnum
    _$permitTemplateDetailPermitTypeEnum_confinedSpace =
    const PermitTemplateDetailPermitTypeEnum._('confinedSpace');
const PermitTemplateDetailPermitTypeEnum
    _$permitTemplateDetailPermitTypeEnum_electricalIsolationLoto =
    const PermitTemplateDetailPermitTypeEnum._('electricalIsolationLoto');
const PermitTemplateDetailPermitTypeEnum
    _$permitTemplateDetailPermitTypeEnum_excavation =
    const PermitTemplateDetailPermitTypeEnum._('excavation');
const PermitTemplateDetailPermitTypeEnum
    _$permitTemplateDetailPermitTypeEnum_workingAtHeight =
    const PermitTemplateDetailPermitTypeEnum._('workingAtHeight');
const PermitTemplateDetailPermitTypeEnum
    _$permitTemplateDetailPermitTypeEnum_generalMaintenance =
    const PermitTemplateDetailPermitTypeEnum._('generalMaintenance');

PermitTemplateDetailPermitTypeEnum _$permitTemplateDetailPermitTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'hotWork':
      return _$permitTemplateDetailPermitTypeEnum_hotWork;
    case 'confinedSpace':
      return _$permitTemplateDetailPermitTypeEnum_confinedSpace;
    case 'electricalIsolationLoto':
      return _$permitTemplateDetailPermitTypeEnum_electricalIsolationLoto;
    case 'excavation':
      return _$permitTemplateDetailPermitTypeEnum_excavation;
    case 'workingAtHeight':
      return _$permitTemplateDetailPermitTypeEnum_workingAtHeight;
    case 'generalMaintenance':
      return _$permitTemplateDetailPermitTypeEnum_generalMaintenance;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<PermitTemplateDetailPermitTypeEnum>
    _$permitTemplateDetailPermitTypeEnumValues = new BuiltSet<
        PermitTemplateDetailPermitTypeEnum>(const <PermitTemplateDetailPermitTypeEnum>[
  _$permitTemplateDetailPermitTypeEnum_hotWork,
  _$permitTemplateDetailPermitTypeEnum_confinedSpace,
  _$permitTemplateDetailPermitTypeEnum_electricalIsolationLoto,
  _$permitTemplateDetailPermitTypeEnum_excavation,
  _$permitTemplateDetailPermitTypeEnum_workingAtHeight,
  _$permitTemplateDetailPermitTypeEnum_generalMaintenance,
]);

Serializer<PermitTemplateDetailPermitTypeEnum>
    _$permitTemplateDetailPermitTypeEnumSerializer =
    new _$PermitTemplateDetailPermitTypeEnumSerializer();

class _$PermitTemplateDetailPermitTypeEnumSerializer
    implements PrimitiveSerializer<PermitTemplateDetailPermitTypeEnum> {
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
  final Iterable<Type> types = const <Type>[PermitTemplateDetailPermitTypeEnum];
  @override
  final String wireName = 'PermitTemplateDetailPermitTypeEnum';

  @override
  Object serialize(
          Serializers serializers, PermitTemplateDetailPermitTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PermitTemplateDetailPermitTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PermitTemplateDetailPermitTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PermitTemplateDetail extends PermitTemplateDetail {
  @override
  final BuiltList<PermitApprovalTemplateStepResponse> approvalSteps;
  @override
  final BuiltList<PermitChecklistTemplateItemResponse> checklistItems;
  @override
  final DateTime createdAt;
  @override
  final String? description;
  @override
  final String id;
  @override
  final String name;
  @override
  final PermitTemplateDetailPermitTypeEnum permitType;
  @override
  final DateTime updatedAt;
  @override
  final int version;

  factory _$PermitTemplateDetail(
          [void Function(PermitTemplateDetailBuilder)? updates]) =>
      (new PermitTemplateDetailBuilder()..update(updates))._build();

  _$PermitTemplateDetail._(
      {required this.approvalSteps,
      required this.checklistItems,
      required this.createdAt,
      this.description,
      required this.id,
      required this.name,
      required this.permitType,
      required this.updatedAt,
      required this.version})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        approvalSteps, r'PermitTemplateDetail', 'approvalSteps');
    BuiltValueNullFieldError.checkNotNull(
        checklistItems, r'PermitTemplateDetail', 'checklistItems');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'PermitTemplateDetail', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(id, r'PermitTemplateDetail', 'id');
    BuiltValueNullFieldError.checkNotNull(
        name, r'PermitTemplateDetail', 'name');
    BuiltValueNullFieldError.checkNotNull(
        permitType, r'PermitTemplateDetail', 'permitType');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'PermitTemplateDetail', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        version, r'PermitTemplateDetail', 'version');
  }

  @override
  PermitTemplateDetail rebuild(
          void Function(PermitTemplateDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermitTemplateDetailBuilder toBuilder() =>
      new PermitTemplateDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermitTemplateDetail &&
        approvalSteps == other.approvalSteps &&
        checklistItems == other.checklistItems &&
        createdAt == other.createdAt &&
        description == other.description &&
        id == other.id &&
        name == other.name &&
        permitType == other.permitType &&
        updatedAt == other.updatedAt &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, approvalSteps.hashCode);
    _$hash = $jc(_$hash, checklistItems.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, permitType.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PermitTemplateDetail')
          ..add('approvalSteps', approvalSteps)
          ..add('checklistItems', checklistItems)
          ..add('createdAt', createdAt)
          ..add('description', description)
          ..add('id', id)
          ..add('name', name)
          ..add('permitType', permitType)
          ..add('updatedAt', updatedAt)
          ..add('version', version))
        .toString();
  }
}

class PermitTemplateDetailBuilder
    implements Builder<PermitTemplateDetail, PermitTemplateDetailBuilder> {
  _$PermitTemplateDetail? _$v;

  ListBuilder<PermitApprovalTemplateStepResponse>? _approvalSteps;
  ListBuilder<PermitApprovalTemplateStepResponse> get approvalSteps =>
      _$this._approvalSteps ??=
          new ListBuilder<PermitApprovalTemplateStepResponse>();
  set approvalSteps(
          ListBuilder<PermitApprovalTemplateStepResponse>? approvalSteps) =>
      _$this._approvalSteps = approvalSteps;

  ListBuilder<PermitChecklistTemplateItemResponse>? _checklistItems;
  ListBuilder<PermitChecklistTemplateItemResponse> get checklistItems =>
      _$this._checklistItems ??=
          new ListBuilder<PermitChecklistTemplateItemResponse>();
  set checklistItems(
          ListBuilder<PermitChecklistTemplateItemResponse>? checklistItems) =>
      _$this._checklistItems = checklistItems;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  PermitTemplateDetailPermitTypeEnum? _permitType;
  PermitTemplateDetailPermitTypeEnum? get permitType => _$this._permitType;
  set permitType(PermitTemplateDetailPermitTypeEnum? permitType) =>
      _$this._permitType = permitType;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  PermitTemplateDetailBuilder() {
    PermitTemplateDetail._defaults(this);
  }

  PermitTemplateDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _approvalSteps = $v.approvalSteps.toBuilder();
      _checklistItems = $v.checklistItems.toBuilder();
      _createdAt = $v.createdAt;
      _description = $v.description;
      _id = $v.id;
      _name = $v.name;
      _permitType = $v.permitType;
      _updatedAt = $v.updatedAt;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PermitTemplateDetail other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PermitTemplateDetail;
  }

  @override
  void update(void Function(PermitTemplateDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermitTemplateDetail build() => _build();

  _$PermitTemplateDetail _build() {
    _$PermitTemplateDetail _$result;
    try {
      _$result = _$v ??
          new _$PermitTemplateDetail._(
              approvalSteps: approvalSteps.build(),
              checklistItems: checklistItems.build(),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'PermitTemplateDetail', 'createdAt'),
              description: description,
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'PermitTemplateDetail', 'id'),
              name: BuiltValueNullFieldError.checkNotNull(
                  name, r'PermitTemplateDetail', 'name'),
              permitType: BuiltValueNullFieldError.checkNotNull(
                  permitType, r'PermitTemplateDetail', 'permitType'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, r'PermitTemplateDetail', 'updatedAt'),
              version: BuiltValueNullFieldError.checkNotNull(
                  version, r'PermitTemplateDetail', 'version'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'approvalSteps';
        approvalSteps.build();
        _$failedField = 'checklistItems';
        checklistItems.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PermitTemplateDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
