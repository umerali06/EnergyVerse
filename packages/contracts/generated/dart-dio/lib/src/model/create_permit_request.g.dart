// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_permit_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreatePermitRequestPermitTypeEnum
    _$createPermitRequestPermitTypeEnum_hotWork =
    const CreatePermitRequestPermitTypeEnum._('hotWork');
const CreatePermitRequestPermitTypeEnum
    _$createPermitRequestPermitTypeEnum_confinedSpace =
    const CreatePermitRequestPermitTypeEnum._('confinedSpace');
const CreatePermitRequestPermitTypeEnum
    _$createPermitRequestPermitTypeEnum_electricalIsolationLoto =
    const CreatePermitRequestPermitTypeEnum._('electricalIsolationLoto');
const CreatePermitRequestPermitTypeEnum
    _$createPermitRequestPermitTypeEnum_excavation =
    const CreatePermitRequestPermitTypeEnum._('excavation');
const CreatePermitRequestPermitTypeEnum
    _$createPermitRequestPermitTypeEnum_workingAtHeight =
    const CreatePermitRequestPermitTypeEnum._('workingAtHeight');
const CreatePermitRequestPermitTypeEnum
    _$createPermitRequestPermitTypeEnum_generalMaintenance =
    const CreatePermitRequestPermitTypeEnum._('generalMaintenance');

CreatePermitRequestPermitTypeEnum _$createPermitRequestPermitTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'hotWork':
      return _$createPermitRequestPermitTypeEnum_hotWork;
    case 'confinedSpace':
      return _$createPermitRequestPermitTypeEnum_confinedSpace;
    case 'electricalIsolationLoto':
      return _$createPermitRequestPermitTypeEnum_electricalIsolationLoto;
    case 'excavation':
      return _$createPermitRequestPermitTypeEnum_excavation;
    case 'workingAtHeight':
      return _$createPermitRequestPermitTypeEnum_workingAtHeight;
    case 'generalMaintenance':
      return _$createPermitRequestPermitTypeEnum_generalMaintenance;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CreatePermitRequestPermitTypeEnum>
    _$createPermitRequestPermitTypeEnumValues = new BuiltSet<
        CreatePermitRequestPermitTypeEnum>(const <CreatePermitRequestPermitTypeEnum>[
  _$createPermitRequestPermitTypeEnum_hotWork,
  _$createPermitRequestPermitTypeEnum_confinedSpace,
  _$createPermitRequestPermitTypeEnum_electricalIsolationLoto,
  _$createPermitRequestPermitTypeEnum_excavation,
  _$createPermitRequestPermitTypeEnum_workingAtHeight,
  _$createPermitRequestPermitTypeEnum_generalMaintenance,
]);

Serializer<CreatePermitRequestPermitTypeEnum>
    _$createPermitRequestPermitTypeEnumSerializer =
    new _$CreatePermitRequestPermitTypeEnumSerializer();

class _$CreatePermitRequestPermitTypeEnumSerializer
    implements PrimitiveSerializer<CreatePermitRequestPermitTypeEnum> {
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
  final Iterable<Type> types = const <Type>[CreatePermitRequestPermitTypeEnum];
  @override
  final String wireName = 'CreatePermitRequestPermitTypeEnum';

  @override
  Object serialize(
          Serializers serializers, CreatePermitRequestPermitTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreatePermitRequestPermitTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreatePermitRequestPermitTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreatePermitRequest extends CreatePermitRequest {
  @override
  final String? areaId;
  @override
  final String? assetId;
  @override
  final String description;
  @override
  final String facilityId;
  @override
  final CreatePermitRequestPermitTypeEnum permitType;
  @override
  final BuiltList<PermitRiskAssessmentInput> riskAssessment;
  @override
  final String templateId;
  @override
  final String title;
  @override
  final DateTime validFrom;
  @override
  final DateTime validUntil;
  @override
  final BuiltList<String> workerIds;

  factory _$CreatePermitRequest(
          [void Function(CreatePermitRequestBuilder)? updates]) =>
      (new CreatePermitRequestBuilder()..update(updates))._build();

  _$CreatePermitRequest._(
      {this.areaId,
      this.assetId,
      required this.description,
      required this.facilityId,
      required this.permitType,
      required this.riskAssessment,
      required this.templateId,
      required this.title,
      required this.validFrom,
      required this.validUntil,
      required this.workerIds})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        description, r'CreatePermitRequest', 'description');
    BuiltValueNullFieldError.checkNotNull(
        facilityId, r'CreatePermitRequest', 'facilityId');
    BuiltValueNullFieldError.checkNotNull(
        permitType, r'CreatePermitRequest', 'permitType');
    BuiltValueNullFieldError.checkNotNull(
        riskAssessment, r'CreatePermitRequest', 'riskAssessment');
    BuiltValueNullFieldError.checkNotNull(
        templateId, r'CreatePermitRequest', 'templateId');
    BuiltValueNullFieldError.checkNotNull(
        title, r'CreatePermitRequest', 'title');
    BuiltValueNullFieldError.checkNotNull(
        validFrom, r'CreatePermitRequest', 'validFrom');
    BuiltValueNullFieldError.checkNotNull(
        validUntil, r'CreatePermitRequest', 'validUntil');
    BuiltValueNullFieldError.checkNotNull(
        workerIds, r'CreatePermitRequest', 'workerIds');
  }

  @override
  CreatePermitRequest rebuild(
          void Function(CreatePermitRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreatePermitRequestBuilder toBuilder() =>
      new CreatePermitRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreatePermitRequest &&
        areaId == other.areaId &&
        assetId == other.assetId &&
        description == other.description &&
        facilityId == other.facilityId &&
        permitType == other.permitType &&
        riskAssessment == other.riskAssessment &&
        templateId == other.templateId &&
        title == other.title &&
        validFrom == other.validFrom &&
        validUntil == other.validUntil &&
        workerIds == other.workerIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, areaId.hashCode);
    _$hash = $jc(_$hash, assetId.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, facilityId.hashCode);
    _$hash = $jc(_$hash, permitType.hashCode);
    _$hash = $jc(_$hash, riskAssessment.hashCode);
    _$hash = $jc(_$hash, templateId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, validFrom.hashCode);
    _$hash = $jc(_$hash, validUntil.hashCode);
    _$hash = $jc(_$hash, workerIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreatePermitRequest')
          ..add('areaId', areaId)
          ..add('assetId', assetId)
          ..add('description', description)
          ..add('facilityId', facilityId)
          ..add('permitType', permitType)
          ..add('riskAssessment', riskAssessment)
          ..add('templateId', templateId)
          ..add('title', title)
          ..add('validFrom', validFrom)
          ..add('validUntil', validUntil)
          ..add('workerIds', workerIds))
        .toString();
  }
}

class CreatePermitRequestBuilder
    implements Builder<CreatePermitRequest, CreatePermitRequestBuilder> {
  _$CreatePermitRequest? _$v;

  String? _areaId;
  String? get areaId => _$this._areaId;
  set areaId(String? areaId) => _$this._areaId = areaId;

  String? _assetId;
  String? get assetId => _$this._assetId;
  set assetId(String? assetId) => _$this._assetId = assetId;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _facilityId;
  String? get facilityId => _$this._facilityId;
  set facilityId(String? facilityId) => _$this._facilityId = facilityId;

  CreatePermitRequestPermitTypeEnum? _permitType;
  CreatePermitRequestPermitTypeEnum? get permitType => _$this._permitType;
  set permitType(CreatePermitRequestPermitTypeEnum? permitType) =>
      _$this._permitType = permitType;

  ListBuilder<PermitRiskAssessmentInput>? _riskAssessment;
  ListBuilder<PermitRiskAssessmentInput> get riskAssessment =>
      _$this._riskAssessment ??= new ListBuilder<PermitRiskAssessmentInput>();
  set riskAssessment(ListBuilder<PermitRiskAssessmentInput>? riskAssessment) =>
      _$this._riskAssessment = riskAssessment;

  String? _templateId;
  String? get templateId => _$this._templateId;
  set templateId(String? templateId) => _$this._templateId = templateId;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  DateTime? _validFrom;
  DateTime? get validFrom => _$this._validFrom;
  set validFrom(DateTime? validFrom) => _$this._validFrom = validFrom;

  DateTime? _validUntil;
  DateTime? get validUntil => _$this._validUntil;
  set validUntil(DateTime? validUntil) => _$this._validUntil = validUntil;

  ListBuilder<String>? _workerIds;
  ListBuilder<String> get workerIds =>
      _$this._workerIds ??= new ListBuilder<String>();
  set workerIds(ListBuilder<String>? workerIds) =>
      _$this._workerIds = workerIds;

  CreatePermitRequestBuilder() {
    CreatePermitRequest._defaults(this);
  }

  CreatePermitRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _areaId = $v.areaId;
      _assetId = $v.assetId;
      _description = $v.description;
      _facilityId = $v.facilityId;
      _permitType = $v.permitType;
      _riskAssessment = $v.riskAssessment.toBuilder();
      _templateId = $v.templateId;
      _title = $v.title;
      _validFrom = $v.validFrom;
      _validUntil = $v.validUntil;
      _workerIds = $v.workerIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreatePermitRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreatePermitRequest;
  }

  @override
  void update(void Function(CreatePermitRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreatePermitRequest build() => _build();

  _$CreatePermitRequest _build() {
    _$CreatePermitRequest _$result;
    try {
      _$result = _$v ??
          new _$CreatePermitRequest._(
              areaId: areaId,
              assetId: assetId,
              description: BuiltValueNullFieldError.checkNotNull(
                  description, r'CreatePermitRequest', 'description'),
              facilityId: BuiltValueNullFieldError.checkNotNull(
                  facilityId, r'CreatePermitRequest', 'facilityId'),
              permitType: BuiltValueNullFieldError.checkNotNull(
                  permitType, r'CreatePermitRequest', 'permitType'),
              riskAssessment: riskAssessment.build(),
              templateId: BuiltValueNullFieldError.checkNotNull(
                  templateId, r'CreatePermitRequest', 'templateId'),
              title: BuiltValueNullFieldError.checkNotNull(
                  title, r'CreatePermitRequest', 'title'),
              validFrom: BuiltValueNullFieldError.checkNotNull(
                  validFrom, r'CreatePermitRequest', 'validFrom'),
              validUntil: BuiltValueNullFieldError.checkNotNull(
                  validUntil, r'CreatePermitRequest', 'validUntil'),
              workerIds: workerIds.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'riskAssessment';
        riskAssessment.build();

        _$failedField = 'workerIds';
        workerIds.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CreatePermitRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
