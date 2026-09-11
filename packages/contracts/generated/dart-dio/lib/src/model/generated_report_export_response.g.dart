// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated_report_export_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GeneratedReportExportResponseFormatEnum
    _$generatedReportExportResponseFormatEnum_pdf =
    const GeneratedReportExportResponseFormatEnum._('pdf');
const GeneratedReportExportResponseFormatEnum
    _$generatedReportExportResponseFormatEnum_docx =
    const GeneratedReportExportResponseFormatEnum._('docx');
const GeneratedReportExportResponseFormatEnum
    _$generatedReportExportResponseFormatEnum_xlsx =
    const GeneratedReportExportResponseFormatEnum._('xlsx');

GeneratedReportExportResponseFormatEnum
    _$generatedReportExportResponseFormatEnumValueOf(String name) {
  switch (name) {
    case 'pdf':
      return _$generatedReportExportResponseFormatEnum_pdf;
    case 'docx':
      return _$generatedReportExportResponseFormatEnum_docx;
    case 'xlsx':
      return _$generatedReportExportResponseFormatEnum_xlsx;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<GeneratedReportExportResponseFormatEnum>
    _$generatedReportExportResponseFormatEnumValues = new BuiltSet<
        GeneratedReportExportResponseFormatEnum>(const <GeneratedReportExportResponseFormatEnum>[
  _$generatedReportExportResponseFormatEnum_pdf,
  _$generatedReportExportResponseFormatEnum_docx,
  _$generatedReportExportResponseFormatEnum_xlsx,
]);

Serializer<GeneratedReportExportResponseFormatEnum>
    _$generatedReportExportResponseFormatEnumSerializer =
    new _$GeneratedReportExportResponseFormatEnumSerializer();

class _$GeneratedReportExportResponseFormatEnumSerializer
    implements PrimitiveSerializer<GeneratedReportExportResponseFormatEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pdf': 'pdf',
    'docx': 'docx',
    'xlsx': 'xlsx',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pdf': 'pdf',
    'docx': 'docx',
    'xlsx': 'xlsx',
  };

  @override
  final Iterable<Type> types = const <Type>[
    GeneratedReportExportResponseFormatEnum
  ];
  @override
  final String wireName = 'GeneratedReportExportResponseFormatEnum';

  @override
  Object serialize(Serializers serializers,
          GeneratedReportExportResponseFormatEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GeneratedReportExportResponseFormatEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GeneratedReportExportResponseFormatEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GeneratedReportExportResponse extends GeneratedReportExportResponse {
  @override
  final String contentType;
  @override
  final String filename;
  @override
  final GeneratedReportExportResponseFormatEnum format;
  @override
  final DateTime generatedAt;
  @override
  final String generatedBy;
  @override
  final String reportId;
  @override
  final int size;
  @override
  final String url;

  factory _$GeneratedReportExportResponse(
          [void Function(GeneratedReportExportResponseBuilder)? updates]) =>
      (new GeneratedReportExportResponseBuilder()..update(updates))._build();

  _$GeneratedReportExportResponse._(
      {required this.contentType,
      required this.filename,
      required this.format,
      required this.generatedAt,
      required this.generatedBy,
      required this.reportId,
      required this.size,
      required this.url})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        contentType, r'GeneratedReportExportResponse', 'contentType');
    BuiltValueNullFieldError.checkNotNull(
        filename, r'GeneratedReportExportResponse', 'filename');
    BuiltValueNullFieldError.checkNotNull(
        format, r'GeneratedReportExportResponse', 'format');
    BuiltValueNullFieldError.checkNotNull(
        generatedAt, r'GeneratedReportExportResponse', 'generatedAt');
    BuiltValueNullFieldError.checkNotNull(
        generatedBy, r'GeneratedReportExportResponse', 'generatedBy');
    BuiltValueNullFieldError.checkNotNull(
        reportId, r'GeneratedReportExportResponse', 'reportId');
    BuiltValueNullFieldError.checkNotNull(
        size, r'GeneratedReportExportResponse', 'size');
    BuiltValueNullFieldError.checkNotNull(
        url, r'GeneratedReportExportResponse', 'url');
  }

  @override
  GeneratedReportExportResponse rebuild(
          void Function(GeneratedReportExportResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeneratedReportExportResponseBuilder toBuilder() =>
      new GeneratedReportExportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeneratedReportExportResponse &&
        contentType == other.contentType &&
        filename == other.filename &&
        format == other.format &&
        generatedAt == other.generatedAt &&
        generatedBy == other.generatedBy &&
        reportId == other.reportId &&
        size == other.size &&
        url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, filename.hashCode);
    _$hash = $jc(_$hash, format.hashCode);
    _$hash = $jc(_$hash, generatedAt.hashCode);
    _$hash = $jc(_$hash, generatedBy.hashCode);
    _$hash = $jc(_$hash, reportId.hashCode);
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeneratedReportExportResponse')
          ..add('contentType', contentType)
          ..add('filename', filename)
          ..add('format', format)
          ..add('generatedAt', generatedAt)
          ..add('generatedBy', generatedBy)
          ..add('reportId', reportId)
          ..add('size', size)
          ..add('url', url))
        .toString();
  }
}

class GeneratedReportExportResponseBuilder
    implements
        Builder<GeneratedReportExportResponse,
            GeneratedReportExportResponseBuilder> {
  _$GeneratedReportExportResponse? _$v;

  String? _contentType;
  String? get contentType => _$this._contentType;
  set contentType(String? contentType) => _$this._contentType = contentType;

  String? _filename;
  String? get filename => _$this._filename;
  set filename(String? filename) => _$this._filename = filename;

  GeneratedReportExportResponseFormatEnum? _format;
  GeneratedReportExportResponseFormatEnum? get format => _$this._format;
  set format(GeneratedReportExportResponseFormatEnum? format) =>
      _$this._format = format;

  DateTime? _generatedAt;
  DateTime? get generatedAt => _$this._generatedAt;
  set generatedAt(DateTime? generatedAt) => _$this._generatedAt = generatedAt;

  String? _generatedBy;
  String? get generatedBy => _$this._generatedBy;
  set generatedBy(String? generatedBy) => _$this._generatedBy = generatedBy;

  String? _reportId;
  String? get reportId => _$this._reportId;
  set reportId(String? reportId) => _$this._reportId = reportId;

  int? _size;
  int? get size => _$this._size;
  set size(int? size) => _$this._size = size;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  GeneratedReportExportResponseBuilder() {
    GeneratedReportExportResponse._defaults(this);
  }

  GeneratedReportExportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contentType = $v.contentType;
      _filename = $v.filename;
      _format = $v.format;
      _generatedAt = $v.generatedAt;
      _generatedBy = $v.generatedBy;
      _reportId = $v.reportId;
      _size = $v.size;
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeneratedReportExportResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GeneratedReportExportResponse;
  }

  @override
  void update(void Function(GeneratedReportExportResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeneratedReportExportResponse build() => _build();

  _$GeneratedReportExportResponse _build() {
    final _$result = _$v ??
        new _$GeneratedReportExportResponse._(
            contentType: BuiltValueNullFieldError.checkNotNull(
                contentType, r'GeneratedReportExportResponse', 'contentType'),
            filename: BuiltValueNullFieldError.checkNotNull(
                filename, r'GeneratedReportExportResponse', 'filename'),
            format: BuiltValueNullFieldError.checkNotNull(
                format, r'GeneratedReportExportResponse', 'format'),
            generatedAt: BuiltValueNullFieldError.checkNotNull(
                generatedAt, r'GeneratedReportExportResponse', 'generatedAt'),
            generatedBy: BuiltValueNullFieldError.checkNotNull(
                generatedBy, r'GeneratedReportExportResponse', 'generatedBy'),
            reportId: BuiltValueNullFieldError.checkNotNull(
                reportId, r'GeneratedReportExportResponse', 'reportId'),
            size: BuiltValueNullFieldError.checkNotNull(
                size, r'GeneratedReportExportResponse', 'size'),
            url:
                BuiltValueNullFieldError.checkNotNull(url, r'GeneratedReportExportResponse', 'url'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
