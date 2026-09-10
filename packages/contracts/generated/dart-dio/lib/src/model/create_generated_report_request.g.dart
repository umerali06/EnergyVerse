// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_generated_report_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateGeneratedReportRequestReportTypeEnum
    _$createGeneratedReportRequestReportTypeEnum_inspection =
    const CreateGeneratedReportRequestReportTypeEnum._('inspection');
const CreateGeneratedReportRequestReportTypeEnum
    _$createGeneratedReportRequestReportTypeEnum_maintenance =
    const CreateGeneratedReportRequestReportTypeEnum._('maintenance');
const CreateGeneratedReportRequestReportTypeEnum
    _$createGeneratedReportRequestReportTypeEnum_safety =
    const CreateGeneratedReportRequestReportTypeEnum._('safety');
const CreateGeneratedReportRequestReportTypeEnum
    _$createGeneratedReportRequestReportTypeEnum_executiveSummary =
    const CreateGeneratedReportRequestReportTypeEnum._('executiveSummary');
const CreateGeneratedReportRequestReportTypeEnum
    _$createGeneratedReportRequestReportTypeEnum_assetHealth =
    const CreateGeneratedReportRequestReportTypeEnum._('assetHealth');

CreateGeneratedReportRequestReportTypeEnum
    _$createGeneratedReportRequestReportTypeEnumValueOf(String name) {
  switch (name) {
    case 'inspection':
      return _$createGeneratedReportRequestReportTypeEnum_inspection;
    case 'maintenance':
      return _$createGeneratedReportRequestReportTypeEnum_maintenance;
    case 'safety':
      return _$createGeneratedReportRequestReportTypeEnum_safety;
    case 'executiveSummary':
      return _$createGeneratedReportRequestReportTypeEnum_executiveSummary;
    case 'assetHealth':
      return _$createGeneratedReportRequestReportTypeEnum_assetHealth;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CreateGeneratedReportRequestReportTypeEnum>
    _$createGeneratedReportRequestReportTypeEnumValues = new BuiltSet<
        CreateGeneratedReportRequestReportTypeEnum>(const <CreateGeneratedReportRequestReportTypeEnum>[
  _$createGeneratedReportRequestReportTypeEnum_inspection,
  _$createGeneratedReportRequestReportTypeEnum_maintenance,
  _$createGeneratedReportRequestReportTypeEnum_safety,
  _$createGeneratedReportRequestReportTypeEnum_executiveSummary,
  _$createGeneratedReportRequestReportTypeEnum_assetHealth,
]);

Serializer<CreateGeneratedReportRequestReportTypeEnum>
    _$createGeneratedReportRequestReportTypeEnumSerializer =
    new _$CreateGeneratedReportRequestReportTypeEnumSerializer();

class _$CreateGeneratedReportRequestReportTypeEnumSerializer
    implements PrimitiveSerializer<CreateGeneratedReportRequestReportTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'inspection': 'inspection',
    'maintenance': 'maintenance',
    'safety': 'safety',
    'executiveSummary': 'executive_summary',
    'assetHealth': 'asset_health',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'inspection': 'inspection',
    'maintenance': 'maintenance',
    'safety': 'safety',
    'executive_summary': 'executiveSummary',
    'asset_health': 'assetHealth',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CreateGeneratedReportRequestReportTypeEnum
  ];
  @override
  final String wireName = 'CreateGeneratedReportRequestReportTypeEnum';

  @override
  Object serialize(Serializers serializers,
          CreateGeneratedReportRequestReportTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateGeneratedReportRequestReportTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateGeneratedReportRequestReportTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateGeneratedReportRequest extends CreateGeneratedReportRequest {
  @override
  final String id;
  @override
  final CreateGeneratedReportRequestReportTypeEnum reportType;
  @override
  final String? sourceId;
  @override
  final String? title;

  factory _$CreateGeneratedReportRequest(
          [void Function(CreateGeneratedReportRequestBuilder)? updates]) =>
      (new CreateGeneratedReportRequestBuilder()..update(updates))._build();

  _$CreateGeneratedReportRequest._(
      {required this.id, required this.reportType, this.sourceId, this.title})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        id, r'CreateGeneratedReportRequest', 'id');
    BuiltValueNullFieldError.checkNotNull(
        reportType, r'CreateGeneratedReportRequest', 'reportType');
  }

  @override
  CreateGeneratedReportRequest rebuild(
          void Function(CreateGeneratedReportRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateGeneratedReportRequestBuilder toBuilder() =>
      new CreateGeneratedReportRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateGeneratedReportRequest &&
        id == other.id &&
        reportType == other.reportType &&
        sourceId == other.sourceId &&
        title == other.title;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reportType.hashCode);
    _$hash = $jc(_$hash, sourceId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateGeneratedReportRequest')
          ..add('id', id)
          ..add('reportType', reportType)
          ..add('sourceId', sourceId)
          ..add('title', title))
        .toString();
  }
}

class CreateGeneratedReportRequestBuilder
    implements
        Builder<CreateGeneratedReportRequest,
            CreateGeneratedReportRequestBuilder> {
  _$CreateGeneratedReportRequest? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CreateGeneratedReportRequestReportTypeEnum? _reportType;
  CreateGeneratedReportRequestReportTypeEnum? get reportType =>
      _$this._reportType;
  set reportType(CreateGeneratedReportRequestReportTypeEnum? reportType) =>
      _$this._reportType = reportType;

  String? _sourceId;
  String? get sourceId => _$this._sourceId;
  set sourceId(String? sourceId) => _$this._sourceId = sourceId;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  CreateGeneratedReportRequestBuilder() {
    CreateGeneratedReportRequest._defaults(this);
  }

  CreateGeneratedReportRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reportType = $v.reportType;
      _sourceId = $v.sourceId;
      _title = $v.title;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateGeneratedReportRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreateGeneratedReportRequest;
  }

  @override
  void update(void Function(CreateGeneratedReportRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateGeneratedReportRequest build() => _build();

  _$CreateGeneratedReportRequest _build() {
    final _$result = _$v ??
        new _$CreateGeneratedReportRequest._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CreateGeneratedReportRequest', 'id'),
            reportType: BuiltValueNullFieldError.checkNotNull(
                reportType, r'CreateGeneratedReportRequest', 'reportType'),
            sourceId: sourceId,
            title: title);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
