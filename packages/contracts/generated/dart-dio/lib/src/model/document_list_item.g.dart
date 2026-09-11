// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_list_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DocumentListItemCategoryEnum _$documentListItemCategoryEnum_sop =
    const DocumentListItemCategoryEnum._('sop');
const DocumentListItemCategoryEnum _$documentListItemCategoryEnum_manual =
    const DocumentListItemCategoryEnum._('manual');
const DocumentListItemCategoryEnum _$documentListItemCategoryEnum_safetyPolicy =
    const DocumentListItemCategoryEnum._('safetyPolicy');
const DocumentListItemCategoryEnum _$documentListItemCategoryEnum_certificate =
    const DocumentListItemCategoryEnum._('certificate');
const DocumentListItemCategoryEnum _$documentListItemCategoryEnum_drawing =
    const DocumentListItemCategoryEnum._('drawing');
const DocumentListItemCategoryEnum _$documentListItemCategoryEnum_report =
    const DocumentListItemCategoryEnum._('report');

DocumentListItemCategoryEnum _$documentListItemCategoryEnumValueOf(
    String name) {
  switch (name) {
    case 'sop':
      return _$documentListItemCategoryEnum_sop;
    case 'manual':
      return _$documentListItemCategoryEnum_manual;
    case 'safetyPolicy':
      return _$documentListItemCategoryEnum_safetyPolicy;
    case 'certificate':
      return _$documentListItemCategoryEnum_certificate;
    case 'drawing':
      return _$documentListItemCategoryEnum_drawing;
    case 'report':
      return _$documentListItemCategoryEnum_report;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<DocumentListItemCategoryEnum>
    _$documentListItemCategoryEnumValues = new BuiltSet<
        DocumentListItemCategoryEnum>(const <DocumentListItemCategoryEnum>[
  _$documentListItemCategoryEnum_sop,
  _$documentListItemCategoryEnum_manual,
  _$documentListItemCategoryEnum_safetyPolicy,
  _$documentListItemCategoryEnum_certificate,
  _$documentListItemCategoryEnum_drawing,
  _$documentListItemCategoryEnum_report,
]);

const DocumentListItemFileFormatEnum _$documentListItemFileFormatEnum_pdf =
    const DocumentListItemFileFormatEnum._('pdf');
const DocumentListItemFileFormatEnum _$documentListItemFileFormatEnum_docx =
    const DocumentListItemFileFormatEnum._('docx');
const DocumentListItemFileFormatEnum _$documentListItemFileFormatEnum_png =
    const DocumentListItemFileFormatEnum._('png');
const DocumentListItemFileFormatEnum _$documentListItemFileFormatEnum_xlsx =
    const DocumentListItemFileFormatEnum._('xlsx');
const DocumentListItemFileFormatEnum _$documentListItemFileFormatEnum_txt =
    const DocumentListItemFileFormatEnum._('txt');

DocumentListItemFileFormatEnum _$documentListItemFileFormatEnumValueOf(
    String name) {
  switch (name) {
    case 'pdf':
      return _$documentListItemFileFormatEnum_pdf;
    case 'docx':
      return _$documentListItemFileFormatEnum_docx;
    case 'png':
      return _$documentListItemFileFormatEnum_png;
    case 'xlsx':
      return _$documentListItemFileFormatEnum_xlsx;
    case 'txt':
      return _$documentListItemFileFormatEnum_txt;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<DocumentListItemFileFormatEnum>
    _$documentListItemFileFormatEnumValues = new BuiltSet<
        DocumentListItemFileFormatEnum>(const <DocumentListItemFileFormatEnum>[
  _$documentListItemFileFormatEnum_pdf,
  _$documentListItemFileFormatEnum_docx,
  _$documentListItemFileFormatEnum_png,
  _$documentListItemFileFormatEnum_xlsx,
  _$documentListItemFileFormatEnum_txt,
]);

const DocumentListItemStatusEnum _$documentListItemStatusEnum_active =
    const DocumentListItemStatusEnum._('active');
const DocumentListItemStatusEnum _$documentListItemStatusEnum_archived =
    const DocumentListItemStatusEnum._('archived');
const DocumentListItemStatusEnum _$documentListItemStatusEnum_underReview =
    const DocumentListItemStatusEnum._('underReview');

DocumentListItemStatusEnum _$documentListItemStatusEnumValueOf(String name) {
  switch (name) {
    case 'active':
      return _$documentListItemStatusEnum_active;
    case 'archived':
      return _$documentListItemStatusEnum_archived;
    case 'underReview':
      return _$documentListItemStatusEnum_underReview;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<DocumentListItemStatusEnum> _$documentListItemStatusEnumValues =
    new BuiltSet<DocumentListItemStatusEnum>(const <DocumentListItemStatusEnum>[
  _$documentListItemStatusEnum_active,
  _$documentListItemStatusEnum_archived,
  _$documentListItemStatusEnum_underReview,
]);

Serializer<DocumentListItemCategoryEnum>
    _$documentListItemCategoryEnumSerializer =
    new _$DocumentListItemCategoryEnumSerializer();
Serializer<DocumentListItemFileFormatEnum>
    _$documentListItemFileFormatEnumSerializer =
    new _$DocumentListItemFileFormatEnumSerializer();
Serializer<DocumentListItemStatusEnum> _$documentListItemStatusEnumSerializer =
    new _$DocumentListItemStatusEnumSerializer();

class _$DocumentListItemCategoryEnumSerializer
    implements PrimitiveSerializer<DocumentListItemCategoryEnum> {
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
  final Iterable<Type> types = const <Type>[DocumentListItemCategoryEnum];
  @override
  final String wireName = 'DocumentListItemCategoryEnum';

  @override
  Object serialize(Serializers serializers, DocumentListItemCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DocumentListItemCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DocumentListItemCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DocumentListItemFileFormatEnumSerializer
    implements PrimitiveSerializer<DocumentListItemFileFormatEnum> {
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
  final Iterable<Type> types = const <Type>[DocumentListItemFileFormatEnum];
  @override
  final String wireName = 'DocumentListItemFileFormatEnum';

  @override
  Object serialize(
          Serializers serializers, DocumentListItemFileFormatEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DocumentListItemFileFormatEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DocumentListItemFileFormatEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DocumentListItemStatusEnumSerializer
    implements PrimitiveSerializer<DocumentListItemStatusEnum> {
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
  final Iterable<Type> types = const <Type>[DocumentListItemStatusEnum];
  @override
  final String wireName = 'DocumentListItemStatusEnum';

  @override
  Object serialize(Serializers serializers, DocumentListItemStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DocumentListItemStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DocumentListItemStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DocumentListItem extends DocumentListItem {
  @override
  final String? assetId;
  @override
  final DocumentListItemCategoryEnum category;
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
  final DocumentListItemFileFormatEnum fileFormat;
  @override
  final String filePath;
  @override
  final int fileSizeBytes;
  @override
  final String filename;
  @override
  final String id;
  @override
  final DocumentListItemStatusEnum status;
  @override
  final BuiltList<String>? tags;
  @override
  final String title;
  @override
  final DateTime updatedAt;
  @override
  final int version;

  factory _$DocumentListItem(
          [void Function(DocumentListItemBuilder)? updates]) =>
      (new DocumentListItemBuilder()..update(updates))._build();

  _$DocumentListItem._(
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
        category, r'DocumentListItem', 'category');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'DocumentListItem', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        createdBy, r'DocumentListItem', 'createdBy');
    BuiltValueNullFieldError.checkNotNull(
        documentCode, r'DocumentListItem', 'documentCode');
    BuiltValueNullFieldError.checkNotNull(
        fileFormat, r'DocumentListItem', 'fileFormat');
    BuiltValueNullFieldError.checkNotNull(
        filePath, r'DocumentListItem', 'filePath');
    BuiltValueNullFieldError.checkNotNull(
        fileSizeBytes, r'DocumentListItem', 'fileSizeBytes');
    BuiltValueNullFieldError.checkNotNull(
        filename, r'DocumentListItem', 'filename');
    BuiltValueNullFieldError.checkNotNull(id, r'DocumentListItem', 'id');
    BuiltValueNullFieldError.checkNotNull(
        status, r'DocumentListItem', 'status');
    BuiltValueNullFieldError.checkNotNull(title, r'DocumentListItem', 'title');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, r'DocumentListItem', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        version, r'DocumentListItem', 'version');
  }

  @override
  DocumentListItem rebuild(void Function(DocumentListItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DocumentListItemBuilder toBuilder() =>
      new DocumentListItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DocumentListItem &&
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
    return (newBuiltValueToStringHelper(r'DocumentListItem')
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

class DocumentListItemBuilder
    implements Builder<DocumentListItem, DocumentListItemBuilder> {
  _$DocumentListItem? _$v;

  String? _assetId;
  String? get assetId => _$this._assetId;
  set assetId(String? assetId) => _$this._assetId = assetId;

  DocumentListItemCategoryEnum? _category;
  DocumentListItemCategoryEnum? get category => _$this._category;
  set category(DocumentListItemCategoryEnum? category) =>
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

  DocumentListItemFileFormatEnum? _fileFormat;
  DocumentListItemFileFormatEnum? get fileFormat => _$this._fileFormat;
  set fileFormat(DocumentListItemFileFormatEnum? fileFormat) =>
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

  DocumentListItemStatusEnum? _status;
  DocumentListItemStatusEnum? get status => _$this._status;
  set status(DocumentListItemStatusEnum? status) => _$this._status = status;

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

  DocumentListItemBuilder() {
    DocumentListItem._defaults(this);
  }

  DocumentListItemBuilder get _$this {
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
  void replace(DocumentListItem other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DocumentListItem;
  }

  @override
  void update(void Function(DocumentListItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DocumentListItem build() => _build();

  _$DocumentListItem _build() {
    _$DocumentListItem _$result;
    try {
      _$result = _$v ??
          new _$DocumentListItem._(
              assetId: assetId,
              category: BuiltValueNullFieldError.checkNotNull(
                  category, r'DocumentListItem', 'category'),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'DocumentListItem', 'createdAt'),
              createdBy: BuiltValueNullFieldError.checkNotNull(
                  createdBy, r'DocumentListItem', 'createdBy'),
              description: description,
              documentCode: BuiltValueNullFieldError.checkNotNull(
                  documentCode, r'DocumentListItem', 'documentCode'),
              downloadUrl: downloadUrl,
              facilityId: facilityId,
              fileFormat: BuiltValueNullFieldError.checkNotNull(
                  fileFormat, r'DocumentListItem', 'fileFormat'),
              filePath: BuiltValueNullFieldError.checkNotNull(
                  filePath, r'DocumentListItem', 'filePath'),
              fileSizeBytes: BuiltValueNullFieldError.checkNotNull(
                  fileSizeBytes, r'DocumentListItem', 'fileSizeBytes'),
              filename: BuiltValueNullFieldError.checkNotNull(
                  filename, r'DocumentListItem', 'filename'),
              id: BuiltValueNullFieldError.checkNotNull(id, r'DocumentListItem', 'id'),
              status: BuiltValueNullFieldError.checkNotNull(status, r'DocumentListItem', 'status'),
              tags: _tags?.build(),
              title: BuiltValueNullFieldError.checkNotNull(title, r'DocumentListItem', 'title'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt, r'DocumentListItem', 'updatedAt'),
              version: BuiltValueNullFieldError.checkNotNull(version, r'DocumentListItem', 'version'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tags';
        _tags?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'DocumentListItem', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
