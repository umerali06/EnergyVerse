// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_document_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UpdateDocumentRequestCategoryEnum
    _$updateDocumentRequestCategoryEnum_sop =
    const UpdateDocumentRequestCategoryEnum._('sop');
const UpdateDocumentRequestCategoryEnum
    _$updateDocumentRequestCategoryEnum_manual =
    const UpdateDocumentRequestCategoryEnum._('manual');
const UpdateDocumentRequestCategoryEnum
    _$updateDocumentRequestCategoryEnum_safetyPolicy =
    const UpdateDocumentRequestCategoryEnum._('safetyPolicy');
const UpdateDocumentRequestCategoryEnum
    _$updateDocumentRequestCategoryEnum_certificate =
    const UpdateDocumentRequestCategoryEnum._('certificate');
const UpdateDocumentRequestCategoryEnum
    _$updateDocumentRequestCategoryEnum_drawing =
    const UpdateDocumentRequestCategoryEnum._('drawing');
const UpdateDocumentRequestCategoryEnum
    _$updateDocumentRequestCategoryEnum_report =
    const UpdateDocumentRequestCategoryEnum._('report');

UpdateDocumentRequestCategoryEnum _$updateDocumentRequestCategoryEnumValueOf(
    String name) {
  switch (name) {
    case 'sop':
      return _$updateDocumentRequestCategoryEnum_sop;
    case 'manual':
      return _$updateDocumentRequestCategoryEnum_manual;
    case 'safetyPolicy':
      return _$updateDocumentRequestCategoryEnum_safetyPolicy;
    case 'certificate':
      return _$updateDocumentRequestCategoryEnum_certificate;
    case 'drawing':
      return _$updateDocumentRequestCategoryEnum_drawing;
    case 'report':
      return _$updateDocumentRequestCategoryEnum_report;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<UpdateDocumentRequestCategoryEnum>
    _$updateDocumentRequestCategoryEnumValues = new BuiltSet<
        UpdateDocumentRequestCategoryEnum>(const <UpdateDocumentRequestCategoryEnum>[
  _$updateDocumentRequestCategoryEnum_sop,
  _$updateDocumentRequestCategoryEnum_manual,
  _$updateDocumentRequestCategoryEnum_safetyPolicy,
  _$updateDocumentRequestCategoryEnum_certificate,
  _$updateDocumentRequestCategoryEnum_drawing,
  _$updateDocumentRequestCategoryEnum_report,
]);

const UpdateDocumentRequestStatusEnum _$updateDocumentRequestStatusEnum_active =
    const UpdateDocumentRequestStatusEnum._('active');
const UpdateDocumentRequestStatusEnum
    _$updateDocumentRequestStatusEnum_archived =
    const UpdateDocumentRequestStatusEnum._('archived');
const UpdateDocumentRequestStatusEnum
    _$updateDocumentRequestStatusEnum_underReview =
    const UpdateDocumentRequestStatusEnum._('underReview');

UpdateDocumentRequestStatusEnum _$updateDocumentRequestStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'active':
      return _$updateDocumentRequestStatusEnum_active;
    case 'archived':
      return _$updateDocumentRequestStatusEnum_archived;
    case 'underReview':
      return _$updateDocumentRequestStatusEnum_underReview;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<UpdateDocumentRequestStatusEnum>
    _$updateDocumentRequestStatusEnumValues = new BuiltSet<
        UpdateDocumentRequestStatusEnum>(const <UpdateDocumentRequestStatusEnum>[
  _$updateDocumentRequestStatusEnum_active,
  _$updateDocumentRequestStatusEnum_archived,
  _$updateDocumentRequestStatusEnum_underReview,
]);

Serializer<UpdateDocumentRequestCategoryEnum>
    _$updateDocumentRequestCategoryEnumSerializer =
    new _$UpdateDocumentRequestCategoryEnumSerializer();
Serializer<UpdateDocumentRequestStatusEnum>
    _$updateDocumentRequestStatusEnumSerializer =
    new _$UpdateDocumentRequestStatusEnumSerializer();

class _$UpdateDocumentRequestCategoryEnumSerializer
    implements PrimitiveSerializer<UpdateDocumentRequestCategoryEnum> {
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
  final Iterable<Type> types = const <Type>[UpdateDocumentRequestCategoryEnum];
  @override
  final String wireName = 'UpdateDocumentRequestCategoryEnum';

  @override
  Object serialize(
          Serializers serializers, UpdateDocumentRequestCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UpdateDocumentRequestCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UpdateDocumentRequestCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UpdateDocumentRequestStatusEnumSerializer
    implements PrimitiveSerializer<UpdateDocumentRequestStatusEnum> {
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
  final Iterable<Type> types = const <Type>[UpdateDocumentRequestStatusEnum];
  @override
  final String wireName = 'UpdateDocumentRequestStatusEnum';

  @override
  Object serialize(
          Serializers serializers, UpdateDocumentRequestStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UpdateDocumentRequestStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UpdateDocumentRequestStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UpdateDocumentRequest extends UpdateDocumentRequest {
  @override
  final String? assetId;
  @override
  final UpdateDocumentRequestCategoryEnum? category;
  @override
  final String? description;
  @override
  final String? documentCode;
  @override
  final String? facilityId;
  @override
  final UpdateDocumentRequestStatusEnum? status;
  @override
  final BuiltList<String>? tags;
  @override
  final String? title;

  factory _$UpdateDocumentRequest(
          [void Function(UpdateDocumentRequestBuilder)? updates]) =>
      (new UpdateDocumentRequestBuilder()..update(updates))._build();

  _$UpdateDocumentRequest._(
      {this.assetId,
      this.category,
      this.description,
      this.documentCode,
      this.facilityId,
      this.status,
      this.tags,
      this.title})
      : super._();

  @override
  UpdateDocumentRequest rebuild(
          void Function(UpdateDocumentRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateDocumentRequestBuilder toBuilder() =>
      new UpdateDocumentRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateDocumentRequest &&
        assetId == other.assetId &&
        category == other.category &&
        description == other.description &&
        documentCode == other.documentCode &&
        facilityId == other.facilityId &&
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
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateDocumentRequest')
          ..add('assetId', assetId)
          ..add('category', category)
          ..add('description', description)
          ..add('documentCode', documentCode)
          ..add('facilityId', facilityId)
          ..add('status', status)
          ..add('tags', tags)
          ..add('title', title))
        .toString();
  }
}

class UpdateDocumentRequestBuilder
    implements Builder<UpdateDocumentRequest, UpdateDocumentRequestBuilder> {
  _$UpdateDocumentRequest? _$v;

  String? _assetId;
  String? get assetId => _$this._assetId;
  set assetId(String? assetId) => _$this._assetId = assetId;

  UpdateDocumentRequestCategoryEnum? _category;
  UpdateDocumentRequestCategoryEnum? get category => _$this._category;
  set category(UpdateDocumentRequestCategoryEnum? category) =>
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

  UpdateDocumentRequestStatusEnum? _status;
  UpdateDocumentRequestStatusEnum? get status => _$this._status;
  set status(UpdateDocumentRequestStatusEnum? status) =>
      _$this._status = status;

  ListBuilder<String>? _tags;
  ListBuilder<String> get tags => _$this._tags ??= new ListBuilder<String>();
  set tags(ListBuilder<String>? tags) => _$this._tags = tags;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  UpdateDocumentRequestBuilder() {
    UpdateDocumentRequest._defaults(this);
  }

  UpdateDocumentRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assetId = $v.assetId;
      _category = $v.category;
      _description = $v.description;
      _documentCode = $v.documentCode;
      _facilityId = $v.facilityId;
      _status = $v.status;
      _tags = $v.tags?.toBuilder();
      _title = $v.title;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateDocumentRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateDocumentRequest;
  }

  @override
  void update(void Function(UpdateDocumentRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateDocumentRequest build() => _build();

  _$UpdateDocumentRequest _build() {
    _$UpdateDocumentRequest _$result;
    try {
      _$result = _$v ??
          new _$UpdateDocumentRequest._(
              assetId: assetId,
              category: category,
              description: description,
              documentCode: documentCode,
              facilityId: facilityId,
              status: status,
              tags: _tags?.build(),
              title: title);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tags';
        _tags?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UpdateDocumentRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
