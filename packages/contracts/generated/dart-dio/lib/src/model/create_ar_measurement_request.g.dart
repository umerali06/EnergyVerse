// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_ar_measurement_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateArMeasurementRequestMethodEnum
    _$createArMeasurementRequestMethodEnum_ar =
    const CreateArMeasurementRequestMethodEnum._('ar');
const CreateArMeasurementRequestMethodEnum
    _$createArMeasurementRequestMethodEnum_manual =
    const CreateArMeasurementRequestMethodEnum._('manual');

CreateArMeasurementRequestMethodEnum
    _$createArMeasurementRequestMethodEnumValueOf(String name) {
  switch (name) {
    case 'ar':
      return _$createArMeasurementRequestMethodEnum_ar;
    case 'manual':
      return _$createArMeasurementRequestMethodEnum_manual;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CreateArMeasurementRequestMethodEnum>
    _$createArMeasurementRequestMethodEnumValues = new BuiltSet<
        CreateArMeasurementRequestMethodEnum>(const <CreateArMeasurementRequestMethodEnum>[
  _$createArMeasurementRequestMethodEnum_ar,
  _$createArMeasurementRequestMethodEnum_manual,
]);

Serializer<CreateArMeasurementRequestMethodEnum>
    _$createArMeasurementRequestMethodEnumSerializer =
    new _$CreateArMeasurementRequestMethodEnumSerializer();

class _$CreateArMeasurementRequestMethodEnumSerializer
    implements PrimitiveSerializer<CreateArMeasurementRequestMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ar': 'ar',
    'manual': 'manual',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ar': 'ar',
    'manual': 'manual',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CreateArMeasurementRequestMethodEnum
  ];
  @override
  final String wireName = 'CreateArMeasurementRequestMethodEnum';

  @override
  Object serialize(
          Serializers serializers, CreateArMeasurementRequestMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateArMeasurementRequestMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateArMeasurementRequestMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateArMeasurementRequest extends CreateArMeasurementRequest {
  @override
  final String? checklistItemId;
  @override
  final num distanceMeters;
  @override
  final String id;
  @override
  final String? label;
  @override
  final String? mediaLocalId;
  @override
  final CreateArMeasurementRequestMethodEnum method;
  @override
  final String? note;
  @override
  final BuiltList<AnnotationPointInput>? points;

  factory _$CreateArMeasurementRequest(
          [void Function(CreateArMeasurementRequestBuilder)? updates]) =>
      (new CreateArMeasurementRequestBuilder()..update(updates))._build();

  _$CreateArMeasurementRequest._(
      {this.checklistItemId,
      required this.distanceMeters,
      required this.id,
      this.label,
      this.mediaLocalId,
      required this.method,
      this.note,
      this.points})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        distanceMeters, r'CreateArMeasurementRequest', 'distanceMeters');
    BuiltValueNullFieldError.checkNotNull(
        id, r'CreateArMeasurementRequest', 'id');
    BuiltValueNullFieldError.checkNotNull(
        method, r'CreateArMeasurementRequest', 'method');
  }

  @override
  CreateArMeasurementRequest rebuild(
          void Function(CreateArMeasurementRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateArMeasurementRequestBuilder toBuilder() =>
      new CreateArMeasurementRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateArMeasurementRequest &&
        checklistItemId == other.checklistItemId &&
        distanceMeters == other.distanceMeters &&
        id == other.id &&
        label == other.label &&
        mediaLocalId == other.mediaLocalId &&
        method == other.method &&
        note == other.note &&
        points == other.points;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, checklistItemId.hashCode);
    _$hash = $jc(_$hash, distanceMeters.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, mediaLocalId.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateArMeasurementRequest')
          ..add('checklistItemId', checklistItemId)
          ..add('distanceMeters', distanceMeters)
          ..add('id', id)
          ..add('label', label)
          ..add('mediaLocalId', mediaLocalId)
          ..add('method', method)
          ..add('note', note)
          ..add('points', points))
        .toString();
  }
}

class CreateArMeasurementRequestBuilder
    implements
        Builder<CreateArMeasurementRequest, CreateArMeasurementRequestBuilder> {
  _$CreateArMeasurementRequest? _$v;

  String? _checklistItemId;
  String? get checklistItemId => _$this._checklistItemId;
  set checklistItemId(String? checklistItemId) =>
      _$this._checklistItemId = checklistItemId;

  num? _distanceMeters;
  num? get distanceMeters => _$this._distanceMeters;
  set distanceMeters(num? distanceMeters) =>
      _$this._distanceMeters = distanceMeters;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _mediaLocalId;
  String? get mediaLocalId => _$this._mediaLocalId;
  set mediaLocalId(String? mediaLocalId) => _$this._mediaLocalId = mediaLocalId;

  CreateArMeasurementRequestMethodEnum? _method;
  CreateArMeasurementRequestMethodEnum? get method => _$this._method;
  set method(CreateArMeasurementRequestMethodEnum? method) =>
      _$this._method = method;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  ListBuilder<AnnotationPointInput>? _points;
  ListBuilder<AnnotationPointInput> get points =>
      _$this._points ??= new ListBuilder<AnnotationPointInput>();
  set points(ListBuilder<AnnotationPointInput>? points) =>
      _$this._points = points;

  CreateArMeasurementRequestBuilder() {
    CreateArMeasurementRequest._defaults(this);
  }

  CreateArMeasurementRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _checklistItemId = $v.checklistItemId;
      _distanceMeters = $v.distanceMeters;
      _id = $v.id;
      _label = $v.label;
      _mediaLocalId = $v.mediaLocalId;
      _method = $v.method;
      _note = $v.note;
      _points = $v.points?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateArMeasurementRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreateArMeasurementRequest;
  }

  @override
  void update(void Function(CreateArMeasurementRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateArMeasurementRequest build() => _build();

  _$CreateArMeasurementRequest _build() {
    _$CreateArMeasurementRequest _$result;
    try {
      _$result = _$v ??
          new _$CreateArMeasurementRequest._(
              checklistItemId: checklistItemId,
              distanceMeters: BuiltValueNullFieldError.checkNotNull(
                  distanceMeters,
                  r'CreateArMeasurementRequest',
                  'distanceMeters'),
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'CreateArMeasurementRequest', 'id'),
              label: label,
              mediaLocalId: mediaLocalId,
              method: BuiltValueNullFieldError.checkNotNull(
                  method, r'CreateArMeasurementRequest', 'method'),
              note: note,
              points: _points?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'points';
        _points?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CreateArMeasurementRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
