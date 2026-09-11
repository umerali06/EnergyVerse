// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_document_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateDocumentRequestCategoryEnum
    _$createDocumentRequestCategoryEnum_sop =
    const CreateDocumentRequestCategoryEnum._('sop');
const CreateDocumentRequestCategoryEnum
    _$createDocumentRequestCategoryEnum_manual =
    const CreateDocumentRequestCategoryEnum._('manual');
const CreateDocumentRequestCategoryEnum
    _$createDocumentRequestCategoryEnum_safetyPolicy =
    const CreateDocumentRequestCategoryEnum._('safetyPolicy');
const CreateDocumentRequestCategoryEnum
    _$createDocumentRequestCategoryEnum_certificate =
    const CreateDocumentRequestCategoryEnum._('certificate');
const CreateDocumentRequestCategoryEnum
    _$createDocumentRequestCategoryEnum_drawing =
    const CreateDocumentRequestCategoryEnum._('drawing');
const CreateDocumentRequestCategoryEnum
    _$createDocumentRequestCategoryEnum_report =
    const CreateDocumentRequestCategoryEnum._('report');

CreateDocumentRequestCategoryEnum _$createDocumentRequestCategoryEnumValueOf(
    String name) {
  switch (name) {
    case 'sop':
      return _$createDocumentRequestCategoryEnum_sop;
    case 'manual':
      return _$createDocumentRequestCategoryEnum_manual;
    case 'safetyPolicy':
      return _$createDocumentRequestCategoryEnum_safetyPolicy;
    case 'certificate':
      return _$createDocumentRequestCategoryEnum_certificate;
    case 'drawing':
      return _$createDocumentRequestCategoryEnum_drawing;
    case 'report':
      return _$createDocumentRequestCategoryEnum_report;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CreateDocumentRequestCategoryEnum>
    _$createDocumentRequestCategoryEnumValues = new BuiltSet<
        CreateDocumentRequestCategoryEnum>(const <CreateDocumentRequestCategoryEnum>[
  _$createDocumentRequestCategoryEnum_sop,
  _$createDocumentRequestCategoryEnum_manual,
  _$createDocumentRequestCategoryEnum_safetyPolicy,
  _$createDocumentRequestCategoryEnum_certificate,
  _$createDocumentRequestCategoryEnum_drawing,
  _$createDocumentRequestCategoryEnum_report,
]);

const CreateDocumentRequestFileFormatEnum
    _$createDocumentRequestFileFormatEnum_pdf =
    const CreateDocumentRequestFileFormatEnum._('pdf');
const CreateDocumentRequestFileFormatEnum
    _$createDocumentRequestFileFormatEnum_docx =
    const CreateDocumentRequestFileFormatEnum._('docx');
const CreateDocumentRequestFileFormatEnum
    _$createDocumentRequestFileFormatEnum_png =
    const CreateDocumentRequestFileFormatEnum._('png');
const CreateDocumentRequestFileFormatEnum
    _$createDocumentRequestFileFormatEnum_xlsx =
    const CreateDocumentRequestFileFormatEnum._('xlsx');
const CreateDocumentRequestFileFormatEnum
    _$createDocumentRequestFileFormatEnum_txt =
    const CreateDocumentRequestFileFormatEnum._('txt');

CreateDocumentRequestFileFormatEnum
    _$createDocumentRequestFileFormatEnumValueOf(String name) {
  switch (name) {
    case 'pdf':
      return _$createDocumentRequestFileFormatEnum_pdf;
    case 'docx':
      return _$createDocumentRequestFileFormatEnum_docx;
    case 'png':
      return _$createDocumentRequestFileFormatEnum_png;
    case 'xlsx':
      return _$createDocumentRequestFileFormatEnum_xlsx;
    case 'txt':
      return _$createDocumentRequestFileFormatEnum_txt;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CreateDocumentRequestFileFormatEnum>
    _$createDocumentRequestFileFormatEnumValues = new BuiltSet<
        CreateDocumentRequestFileFormatEnum>(const <CreateDocumentRequestFileFormatEnum>[
  _$createDocumentRequestFileFormatEnum_pdf,
  _$createDocumentRequestFileFormatEnum_docx,
  _$createDocumentRequestFileFormatEnum_png,
  _$createDocumentRequestFileFormatEnum_xlsx,
  _$createDocumentRequestFileFormatEnum_txt,
]);

const CreateDocumentRequestStatusEnum _$createDocumentRequestStatusEnum_active =
    const CreateDocumentRequestStatusEnum._('active');
const CreateDocumentRequestStatusEnum
    _$createDocumentRequestStatusEnum_archived =
    const CreateDocumentRequestStatusEnum._('archived');
const CreateDocumentRequestStatusEnum
    _$createDocumentRequestStatusEnum_underReview =
    const CreateDocumentRequestStatusEnum._('underReview');

CreateDocumentRequestStatusEnum _$createDocumentRequestStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'active':
      return _$createDocumentRequestStatusEnum_active;
    case 'archived':
      return _$createDocumentRequestStatusEnum_archived;
    case 'underReview':
      return _$createDocumentRequestStatusEnum_underReview;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CreateDocumentRequestStatusEnum>
    _$createDocumentRequestStatusEnumValues = new BuiltSet<
        CreateDocumentRequestStatusEnum>(const <CreateDocumentRequestStatusEnum>[
  _$createDocumentRequestStatusEnum_active,
  _$createDocumentRequestStatusEnum_archived,
  _$createDocumentRequestStatusEnum_underReview,
]);

Serializer<CreateDocumentRequestCategoryEnum>
    _$createDocumentRequestCategoryEnumSerializer =
    new _$CreateDocumentRequestCategoryEnumSerializer();
Serializer<CreateDocumentRequestFileFormatEnum>
    _$createDocumentRequestFileFormatEnumSerializer =
    new _$CreateDocumentRequestFileFormatEnumSerializer();
Serializer<CreateDocumentRequestStatusEnum>
    _$createDocumentRequestStatusEnumSerializer =
    new _$CreateDocumentRequestStatusEnumSerializer();

class _$CreateDocumentRequestCategoryEnumSerializer
    implements PrimitiveSerializer<CreateDocumentRequestCategoryEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'sop': 'sop',
    'manual': 'manual',
    'safetyPolicy': 'safety_policy',
    'certificate': 'certificate',
    'drawing': 'drawing',
    'report': 'report',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'sop': 'sop',
    'manual': 'manual',
    'safety_policy': 'safetyPolicy',
    'certificate': 'certificate',
    'drawing': 'drawing',
    'report': 'report',
  };

  @override
  final Iterable<Type> types = const <Type>[CreateDocumentRequestCategoryEnum];
  @override
  final String wireName = 'CreateDocumentRequestCategoryEnum';

  @override
  Object serialize(
          Serializers serializers, CreateDocumentRequestCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateDocumentRequestCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateDocumentRequestCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateDocumentRequestFileFormatEnumSerializer
    implements PrimitiveSerializer<CreateDocumentRequestFileFormatEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pdf': 'pdf',
    'docx': 'docx',
    'png': 'png',
    'xlsx': 'xlsx',
    'txt': 'txt',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pdf': 'pdf',
    'docx': 'docx',
    'png': 'png',
    'xlsx': 'xlsx',
    'txt': 'txt',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CreateDocumentRequestFileFormatEnum
  ];
  @override
  final String wireName = 'CreateDocumentRequestFileFormatEnum';

  @override
  Object serialize(
          Serializers serializers, CreateDocumentRequestFileFormatEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateDocumentRequestFileFormatEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateDocumentRequestFileFormatEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateDocumentRequestStatusEnumSerializer
    implements PrimitiveSerializer<CreateDocumentRequestStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'archived': 'archived',
    'underReview': 'under_review',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'archived': 'archived',
    'under_review': 'underReview',
  };

  @override
  final Iterable<Type> types = const <Type>[CreateDocumentRequestStatusEnum];
  @override
  final String wireName = 'CreateDocumentRequestStatusEnum';

  @override
  Object serialize(
          Serializers serializers, CreateDocumentRequestStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateDocumentRequestStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateDocumentRequestStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateDocumentRequest extends CreateDocumentRequest {
  @override
  final String? assetId;
  @override
  final CreateDocumentRequestCategoryEnum category;
  @override
  final String? description;
  @override
  final String documentCode;
  @override
  final String? facilityId;
  @override
  final CreateDocumentRequestFileFormatEnum? fileFormat;
  @override
  final String filePath;
  @override
  final int fileSizeBytes;
  @override
  final String filename;
  @override
  final String id;
  @override
  final CreateDocumentRequestStatusEnum? status;
  @override
  final BuiltList<String>? tags;
  @override
  final String title;

  factory _$CreateDocumentRequest(
          [void Function(CreateDocumentRequestBuilder)? updates]) =>
      (new CreateDocumentRequestBuilder()..update(updates))._build();

  _$CreateDocumentRequest._(
      {this.assetId,
      required this.category,
      this.description,
      required this.documentCode,
      this.facilityId,
      this.fileFormat,
      required this.filePath,
      required this.fileSizeBytes,
      required this.filename,
      required this.id,
      this.status,
      this.tags,
      required this.title})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        category, r'CreateDocumentRequest', 'category');
    BuiltValueNullFieldError.checkNotNull(
        documentCode, r'CreateDocumentRequest', 'documentCode');
    BuiltValueNullFieldError.checkNotNull(
        filePath, r'CreateDocumentRequest', 'filePath');
    BuiltValueNullFieldError.checkNotNull(
        fileSizeBytes, r'CreateDocumentRequest', 'fileSizeBytes');
    BuiltValueNullFieldError.checkNotNull(
        filename, r'CreateDocumentRequest', 'filename');
    BuiltValueNullFieldError.checkNotNull(id, r'CreateDocumentRequest', 'id');
    BuiltValueNullFieldError.checkNotNull(
        title, r'CreateDocumentRequest', 'title');
  }

  @override
  CreateDocumentRequest rebuild(
          void Function(CreateDocumentRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateDocumentRequestBuilder toBuilder() =>
      new CreateDocumentRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateDocumentRequest &&
        assetId == other.assetId &&
        category == other.category &&
        description == other.description &&
        documentCode == other.documentCode &&
        facilityId == other.facilityId &&
        fileFormat == other.fileFormat &&
        filePath == other.filePath &&
        fileSizeBytes == other.fileSizeBytes &&
        filename == other.filename &&
        id == other.id &&
        status == other.status &&
        tags == other.tags &&
        title == other.title;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assetId.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, documentCode.hashCode);
    _$hash = $jc(_$hash, facilityId.hashCode);
    _$hash = $jc(_$hash, fileFormat.hashCode);
    _$hash = $jc(_$hash, filePath.hashCode);
    _$hash = $jc(_$hash, fileSizeBytes.hashCode);
    _$hash = $jc(_$hash, filename.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateDocumentRequest')
          ..add('assetId', assetId)
          ..add('category', category)
          ..add('description', description)
          ..add('documentCode', documentCode)
          ..add('facilityId', facilityId)
          ..add('fileFormat', fileFormat)
          ..add('filePath', filePath)
          ..add('fileSizeBytes', fileSizeBytes)
          ..add('filename', filename)
          ..add('id', id)
          ..add('status', status)
          ..add('tags', tags)
          ..add('title', title))
        .toString();
  }
}

class CreateDocumentRequestBuilder
    implements Builder<CreateDocumentRequest, CreateDocumentRequestBuilder> {
  _$CreateDocumentRequest? _$v;

  String? _assetId;
  String? get assetId => _$this._assetId;
  set assetId(String? assetId) => _$this._assetId = assetId;

  CreateDocumentRequestCategoryEnum? _category;
  CreateDocumentRequestCategoryEnum? get category => _$this._category;
  set category(CreateDocumentRequestCategoryEnum? category) =>
      _$this._category = category;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _documentCode;
  String? get documentCode => _$this._documentCode;
  set documentCode(String? documentCode) => _$this._documentCode = documentCode;

  String? _facilityId;
  String? get facilityId => _$this._facilityId;
  set facilityId(String? facilityId) => _$this._facilityId = facilityId;

  CreateDocumentRequestFileFormatEnum? _fileFormat;
  CreateDocumentRequestFileFormatEnum? get fileFormat => _$this._fileFormat;
  set fileFormat(CreateDocumentRequestFileFormatEnum? fileFormat) =>
      _$this._fileFormat = fileFormat;

  String? _filePath;
  String? get filePath => _$this._filePath;
  set filePath(String? filePath) => _$this._filePath = filePath;

  int? _fileSizeBytes;
  int? get fileSizeBytes => _$this._fileSizeBytes;
  set fileSizeBytes(int? fileSizeBytes) =>
      _$this._fileSizeBytes = fileSizeBytes;

  String? _filename;
  String? get filename => _$this._filename;
  set filename(String? filename) => _$this._filename = filename;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CreateDocumentRequestStatusEnum? _status;
  CreateDocumentRequestStatusEnum? get status => _$this._status;
  set status(CreateDocumentRequestStatusEnum? status) =>
      _$this._status = status;

  ListBuilder<String>? _tags;
  ListBuilder<String> get tags => _$this._tags ??= new ListBuilder<String>();
  set tags(ListBuilder<String>? tags) => _$this._tags = tags;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  CreateDocumentRequestBuilder() {
    CreateDocumentRequest._defaults(this);
  }

  CreateDocumentRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assetId = $v.assetId;
      _category = $v.category;
      _description = $v.description;
      _documentCode = $v.documentCode;
      _facilityId = $v.facilityId;
      _fileFormat = $v.fileFormat;
      _filePath = $v.filePath;
      _fileSizeBytes = $v.fileSizeBytes;
      _filename = $v.filename;
      _id = $v.id;
      _status = $v.status;
      _tags = $v.tags?.toBuilder();
      _title = $v.title;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateDocumentRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreateDocumentRequest;
  }

  @override
  void update(void Function(CreateDocumentRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateDocumentRequest build() => _build();

  _$CreateDocumentRequest _build() {
    _$CreateDocumentRequest _$result;
    try {
      _$result = _$v ??
          new _$CreateDocumentRequest._(
              assetId: assetId,
              category: BuiltValueNullFieldError.checkNotNull(
                  category, r'CreateDocumentRequest', 'category'),
              description: description,
              documentCode: BuiltValueNullFieldError.checkNotNull(
                  documentCode, r'CreateDocumentRequest', 'documentCode'),
              facilityId: facilityId,
              fileFormat: fileFormat,
              filePath: BuiltValueNullFieldError.checkNotNull(
                  filePath, r'CreateDocumentRequest', 'filePath'),
              fileSizeBytes: BuiltValueNullFieldError.checkNotNull(
                  fileSizeBytes, r'CreateDocumentRequest', 'fileSizeBytes'),
              filename: BuiltValueNullFieldError.checkNotNull(
                  filename, r'CreateDocumentRequest', 'filename'),
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'CreateDocumentRequest', 'id'),
              status: status,
              tags: _tags?.build(),
              title: BuiltValueNullFieldError.checkNotNull(
                  title, r'CreateDocumentRequest', 'title'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tags';
        _tags?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CreateDocumentRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
