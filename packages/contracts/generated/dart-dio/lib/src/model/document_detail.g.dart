// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DocumentDetailCategoryEnum _$documentDetailCategoryEnum_sop =
    const DocumentDetailCategoryEnum._('sop');
const DocumentDetailCategoryEnum _$documentDetailCategoryEnum_manual =
    const DocumentDetailCategoryEnum._('manual');
const DocumentDetailCategoryEnum _$documentDetailCategoryEnum_safetyPolicy =
    const DocumentDetailCategoryEnum._('safetyPolicy');
const DocumentDetailCategoryEnum _$documentDetailCategoryEnum_certificate =
    const DocumentDetailCategoryEnum._('certificate');
const DocumentDetailCategoryEnum _$documentDetailCategoryEnum_drawing =
    const DocumentDetailCategoryEnum._('drawing');
const DocumentDetailCategoryEnum _$documentDetailCategoryEnum_report =
    const DocumentDetailCategoryEnum._('report');

DocumentDetailCategoryEnum _$documentDetailCategoryEnumValueOf(String name) {
  switch (name) {
    case 'sop':
      return _$documentDetailCategoryEnum_sop;
    case 'manual':
      return _$documentDetailCategoryEnum_manual;
    case 'safetyPolicy':
      return _$documentDetailCategoryEnum_safetyPolicy;
    case 'certificate':
      return _$documentDetailCategoryEnum_certificate;
    case 'drawing':
      return _$documentDetailCategoryEnum_drawing;
    case 'report':
      return _$documentDetailCategoryEnum_report;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<DocumentDetailCategoryEnum> _$documentDetailCategoryEnumValues =
    new BuiltSet<DocumentDetailCategoryEnum>(const <DocumentDetailCategoryEnum>[
  _$documentDetailCategoryEnum_sop,
  _$documentDetailCategoryEnum_manual,
  _$documentDetailCategoryEnum_safetyPolicy,
  _$documentDetailCategoryEnum_certificate,
  _$documentDetailCategoryEnum_drawing,
  _$documentDetailCategoryEnum_report,
]);

const DocumentDetailFileFormatEnum _$documentDetailFileFormatEnum_pdf =
    const DocumentDetailFileFormatEnum._('pdf');
const DocumentDetailFileFormatEnum _$documentDetailFileFormatEnum_docx =
    const DocumentDetailFileFormatEnum._('docx');
const DocumentDetailFileFormatEnum _$documentDetailFileFormatEnum_png =
    const DocumentDetailFileFormatEnum._('png');
const DocumentDetailFileFormatEnum _$documentDetailFileFormatEnum_xlsx =
    const DocumentDetailFileFormatEnum._('xlsx');
const DocumentDetailFileFormatEnum _$documentDetailFileFormatEnum_txt =
    const DocumentDetailFileFormatEnum._('txt');

DocumentDetailFileFormatEnum _$documentDetailFileFormatEnumValueOf(
    String name) {
  switch (name) {
    case 'pdf':
      return _$documentDetailFileFormatEnum_pdf;
    case 'docx':
      return _$documentDetailFileFormatEnum_docx;
    case 'png':
      return _$documentDetailFileFormatEnum_png;
    case 'xlsx':
      return _$documentDetailFileFormatEnum_xlsx;
    case 'txt':
      return _$documentDetailFileFormatEnum_txt;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<DocumentDetailFileFormatEnum>
    _$documentDetailFileFormatEnumValues = new BuiltSet<
        DocumentDetailFileFormatEnum>(const <DocumentDetailFileFormatEnum>[
  _$documentDetailFileFormatEnum_pdf,
  _$documentDetailFileFormatEnum_docx,
  _$documentDetailFileFormatEnum_png,
  _$documentDetailFileFormatEnum_xlsx,
  _$documentDetailFileFormatEnum_txt,
]);

const DocumentDetailStatusEnum _$documentDetailStatusEnum_active =
    const DocumentDetailStatusEnum._('active');
const DocumentDetailStatusEnum _$documentDetailStatusEnum_archived =
    const DocumentDetailStatusEnum._('archived');
const DocumentDetailStatusEnum _$documentDetailStatusEnum_underReview =
    const DocumentDetailStatusEnum._('underReview');

DocumentDetailStatusEnum _$documentDetailStatusEnumValueOf(String name) {
  switch (name) {
    case 'active':
      return _$documentDetailStatusEnum_active;
    case 'archived':
      return _$documentDetailStatusEnum_archived;
    case 'underReview':
      return _$documentDetailStatusEnum_underReview;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<DocumentDetailStatusEnum> _$documentDetailStatusEnumValues =
    new BuiltSet<DocumentDetailStatusEnum>(const <DocumentDetailStatusEnum>[
  _$documentDetailStatusEnum_active,
  _$documentDetailStatusEnum_archived,
  _$documentDetailStatusEnum_underReview,
]);

Serializer<DocumentDetailCategoryEnum> _$documentDetailCategoryEnumSerializer =
    new _$DocumentDetailCategoryEnumSerializer();
Serializer<DocumentDetailFileFormatEnum>
    _$documentDetailFileFormatEnumSerializer =
    new _$DocumentDetailFileFormatEnumSerializer();
Serializer<DocumentDetailStatusEnum> _$documentDetailStatusEnumSerializer =
    new _$DocumentDetailStatusEnumSerializer();

class _$DocumentDetailCategoryEnumSerializer
    implements PrimitiveSerializer<DocumentDetailCategoryEnum> {
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
  final Iterable<Type> types = const <Type>[DocumentDetailCategoryEnum];
  @override
  final String wireName = 'DocumentDetailCategoryEnum';

  @override
  Object serialize(Serializers serializers, DocumentDetailCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DocumentDetailCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DocumentDetailCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DocumentDetailFileFormatEnumSerializer
    implements PrimitiveSerializer<DocumentDetailFileFormatEnum> {
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
  final Iterable<Type> types = const <Type>[DocumentDetailFileFormatEnum];
  @override
  final String wireName = 'DocumentDetailFileFormatEnum';

  @override
  Object serialize(Serializers serializers, DocumentDetailFileFormatEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DocumentDetailFileFormatEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DocumentDetailFileFormatEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DocumentDetailStatusEnumSerializer
    implements PrimitiveSerializer<DocumentDetailStatusEnum> {
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
  final Iterable<Type> types = const <Type>[DocumentDetailStatusEnum];
  @override
  final String wireName = 'DocumentDetailStatusEnum';

  @override
  Object serialize(Serializers serializers, DocumentDetailStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DocumentDetailStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DocumentDetailStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DocumentDetail extends DocumentDetail {
  @override
  final String? assetId;
  @override
  final DocumentDetailCategoryEnum category;
  @override
  final DateTime createdAt;
  @override
  final String createdBy;
  @override
  final String? description;
  @override
  final String documentCode;
  @override
  final String? downloadUrl;
  @override
  final String? facilityId;
  @override
  final DocumentDetailFileFormatEnum fileFormat;
  @override
  final String filePath;
  @override
  final int fileSizeBytes;
  @override
  final String filename;
  @override
  final String id;
  @override
  final DocumentDetailStatusEnum status;
  @override
  final BuiltList<String>? tags;
  @override
  final String title;
  @override
  final DateTime updatedAt;
  @override
  final int version;

  factory _$DocumentDetail([void Function(DocumentDetailBuilder)? updates]) =>
      (new DocumentDetailBuilder()..update(updates))._build();

  _$DocumentDetail._(
      {this.assetId,
      required this.category,
      required this.createdAt,
      required this.createdBy,
      this.description,
      required this.documentCode,
      this.downloadUrl,
      this.facilityId,
      required this.fileFormat,
      required this.filePath,
      required this.fileSizeBytes,
      required this.filename,
      required this.id,
      required this.status,
      this.tags,
      required this.title,
      required this.updatedAt,
      required this.version})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        category, r'DocumentDetail', 'category');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'DocumentDetail', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        createdBy, r'DocumentDetail', 'createdBy');
    BuiltValueNullFieldError.checkNotNull(
        documentCode, r'DocumentDetail', 'documentCode');
    BuiltValueNullFieldError.checkNotNull(
        fileFormat, r'DocumentDetail', 'fileFormat');
    BuiltValueNullFieldError.checkNotNull(
        filePath, r'DocumentDetail', 'filePath');
    BuiltValueNullFieldError.checkNotNull(
        fileSizeBytes, r'DocumentDetail', 'fileSizeBytes');
    BuiltValueNullFieldError.checkNotNull(
        filename, r'DocumentDetail', 'filename');
    BuiltValueNullFieldError.checkNotNull(id, r'DocumentDetail', 'id');
    BuiltValueNullFieldError.checkNotNull(status, r'DocumentDetail', 'status');
    BuiltValueNullFieldError.checkNotNull(title, r'DocumentDetail', 'title');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'DocumentDetail', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        version, r'DocumentDetail', 'version');
  }

  @override
  DocumentDetail rebuild(void Function(DocumentDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DocumentDetailBuilder toBuilder() =>
      new DocumentDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DocumentDetail &&
        assetId == other.assetId &&
        category == other.category &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        description == other.description &&
        documentCode == other.documentCode &&
        downloadUrl == other.downloadUrl &&
        facilityId == other.facilityId &&
        fileFormat == other.fileFormat &&
        filePath == other.filePath &&
        fileSizeBytes == other.fileSizeBytes &&
        filename == other.filename &&
        id == other.id &&
        status == other.status &&
        tags == other.tags &&
        title == other.title &&
        updatedAt == other.updatedAt &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assetId.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, documentCode.hashCode);
    _$hash = $jc(_$hash, downloadUrl.hashCode);
    _$hash = $jc(_$hash, facilityId.hashCode);
    _$hash = $jc(_$hash, fileFormat.hashCode);
    _$hash = $jc(_$hash, filePath.hashCode);
    _$hash = $jc(_$hash, fileSizeBytes.hashCode);
    _$hash = $jc(_$hash, filename.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DocumentDetail')
          ..add('assetId', assetId)
          ..add('category', category)
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('description', description)
          ..add('documentCode', documentCode)
          ..add('downloadUrl', downloadUrl)
          ..add('facilityId', facilityId)
          ..add('fileFormat', fileFormat)
          ..add('filePath', filePath)
          ..add('fileSizeBytes', fileSizeBytes)
          ..add('filename', filename)
          ..add('id', id)
          ..add('status', status)
          ..add('tags', tags)
          ..add('title', title)
          ..add('updatedAt', updatedAt)
          ..add('version', version))
        .toString();
  }
}

class DocumentDetailBuilder
    implements Builder<DocumentDetail, DocumentDetailBuilder> {
  _$DocumentDetail? _$v;

  String? _assetId;
  String? get assetId => _$this._assetId;
  set assetId(String? assetId) => _$this._assetId = assetId;

  DocumentDetailCategoryEnum? _category;
  DocumentDetailCategoryEnum? get category => _$this._category;
  set category(DocumentDetailCategoryEnum? category) =>
      _$this._category = category;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _createdBy;
  String? get createdBy => _$this._createdBy;
  set createdBy(String? createdBy) => _$this._createdBy = createdBy;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _documentCode;
  String? get documentCode => _$this._documentCode;
  set documentCode(String? documentCode) => _$this._documentCode = documentCode;

  String? _downloadUrl;
  String? get downloadUrl => _$this._downloadUrl;
  set downloadUrl(String? downloadUrl) => _$this._downloadUrl = downloadUrl;

  String? _facilityId;
  String? get facilityId => _$this._facilityId;
  set facilityId(String? facilityId) => _$this._facilityId = facilityId;

  DocumentDetailFileFormatEnum? _fileFormat;
  DocumentDetailFileFormatEnum? get fileFormat => _$this._fileFormat;
  set fileFormat(DocumentDetailFileFormatEnum? fileFormat) =>
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

  DocumentDetailStatusEnum? _status;
  DocumentDetailStatusEnum? get status => _$this._status;
  set status(DocumentDetailStatusEnum? status) => _$this._status = status;

  ListBuilder<String>? _tags;
  ListBuilder<String> get tags => _$this._tags ??= new ListBuilder<String>();
  set tags(ListBuilder<String>? tags) => _$this._tags = tags;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  DocumentDetailBuilder() {
    DocumentDetail._defaults(this);
  }

  DocumentDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assetId = $v.assetId;
      _category = $v.category;
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy;
      _description = $v.description;
      _documentCode = $v.documentCode;
      _downloadUrl = $v.downloadUrl;
      _facilityId = $v.facilityId;
      _fileFormat = $v.fileFormat;
      _filePath = $v.filePath;
      _fileSizeBytes = $v.fileSizeBytes;
      _filename = $v.filename;
      _id = $v.id;
      _status = $v.status;
      _tags = $v.tags?.toBuilder();
      _title = $v.title;
      _updatedAt = $v.updatedAt;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DocumentDetail other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DocumentDetail;
  }

  @override
  void update(void Function(DocumentDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DocumentDetail build() => _build();

  _$DocumentDetail _build() {
    _$DocumentDetail _$result;
    try {
      _$result = _$v ??
          new _$DocumentDetail._(
              assetId: assetId,
              category: BuiltValueNullFieldError.checkNotNull(
                  category, r'DocumentDetail', 'category'),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'DocumentDetail', 'createdAt'),
              createdBy: BuiltValueNullFieldError.checkNotNull(
                  createdBy, r'DocumentDetail', 'createdBy'),
              description: description,
              documentCode: BuiltValueNullFieldError.checkNotNull(
                  documentCode, r'DocumentDetail', 'documentCode'),
              downloadUrl: downloadUrl,
              facilityId: facilityId,
              fileFormat: BuiltValueNullFieldError.checkNotNull(
                  fileFormat, r'DocumentDetail', 'fileFormat'),
              filePath: BuiltValueNullFieldError.checkNotNull(
                  filePath, r'DocumentDetail', 'filePath'),
              fileSizeBytes: BuiltValueNullFieldError.checkNotNull(
                  fileSizeBytes, r'DocumentDetail', 'fileSizeBytes'),
              filename: BuiltValueNullFieldError.checkNotNull(
                  filename, r'DocumentDetail', 'filename'),
              id: BuiltValueNullFieldError.checkNotNull(id, r'DocumentDetail', 'id'),
              status: BuiltValueNullFieldError.checkNotNull(status, r'DocumentDetail', 'status'),
              tags: _tags?.build(),
              title: BuiltValueNullFieldError.checkNotNull(title, r'DocumentDetail', 'title'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt, r'DocumentDetail', 'updatedAt'),
              version: BuiltValueNullFieldError.checkNotNull(version, r'DocumentDetail', 'version'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tags';
        _tags?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'DocumentDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
