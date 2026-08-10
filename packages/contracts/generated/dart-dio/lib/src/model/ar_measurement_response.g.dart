// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ar_measurement_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ArMeasurementResponseMethodEnum _$arMeasurementResponseMethodEnum_ar =
    const ArMeasurementResponseMethodEnum._('ar');
const ArMeasurementResponseMethodEnum _$arMeasurementResponseMethodEnum_manual =
    const ArMeasurementResponseMethodEnum._('manual');

ArMeasurementResponseMethodEnum _$arMeasurementResponseMethodEnumValueOf(
    String name) {
  switch (name) {
    case 'ar':
      return _$arMeasurementResponseMethodEnum_ar;
    case 'manual':
      return _$arMeasurementResponseMethodEnum_manual;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ArMeasurementResponseMethodEnum>
    _$arMeasurementResponseMethodEnumValues = new BuiltSet<
        ArMeasurementResponseMethodEnum>(const <ArMeasurementResponseMethodEnum>[
  _$arMeasurementResponseMethodEnum_ar,
  _$arMeasurementResponseMethodEnum_manual,
]);

Serializer<ArMeasurementResponseMethodEnum>
    _$arMeasurementResponseMethodEnumSerializer =
    new _$ArMeasurementResponseMethodEnumSerializer();

class _$ArMeasurementResponseMethodEnumSerializer
    implements PrimitiveSerializer<ArMeasurementResponseMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ar': 'ar',
    'manual': 'manual',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ar': 'ar',
    'manual': 'manual',
  };

  @override
  final Iterable<Type> types = const <Type>[ArMeasurementResponseMethodEnum];
  @override
  final String wireName = 'ArMeasurementResponseMethodEnum';

  @override
  Object serialize(
          Serializers serializers, ArMeasurementResponseMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ArMeasurementResponseMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ArMeasurementResponseMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ArMeasurementResponse extends ArMeasurementResponse {
  @override
  final String? checklistItemId;
  @override
  final DateTime createdAt;
  @override
  final String createdBy;
  @override
  final num distanceMeters;
  @override
  final String id;
  @override
  final String? label;
  @override
  final String? mediaLocalId;
  @override
  final ArMeasurementResponseMethodEnum method;
  @override
  final String? note;
  @override
  final BuiltList<AnnotationPointResponse>? points;

  factory _$ArMeasurementResponse(
          [void Function(ArMeasurementResponseBuilder)? updates]) =>
      (new ArMeasurementResponseBuilder()..update(updates))._build();

  _$ArMeasurementResponse._(
      {this.checklistItemId,
      required this.createdAt,
      required this.createdBy,
      required this.distanceMeters,
      required this.id,
      this.label,
      this.mediaLocalId,
      required this.method,
      this.note,
      this.points})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'ArMeasurementResponse', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        createdBy, r'ArMeasurementResponse', 'createdBy');
    BuiltValueNullFieldError.checkNotNull(
        distanceMeters, r'ArMeasurementResponse', 'distanceMeters');
    BuiltValueNullFieldError.checkNotNull(id, r'ArMeasurementResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        method, r'ArMeasurementResponse', 'method');
  }

  @override
  ArMeasurementResponse rebuild(
          void Function(ArMeasurementResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ArMeasurementResponseBuilder toBuilder() =>
      new ArMeasurementResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ArMeasurementResponse &&
        checklistItemId == other.checklistItemId &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
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
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
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
    return (newBuiltValueToStringHelper(r'ArMeasurementResponse')
          ..add('checklistItemId', checklistItemId)
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
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

class ArMeasurementResponseBuilder
    implements Builder<ArMeasurementResponse, ArMeasurementResponseBuilder> {
  _$ArMeasurementResponse? _$v;

  String? _checklistItemId;
  String? get checklistItemId => _$this._checklistItemId;
  set checklistItemId(String? checklistItemId) =>
      _$this._checklistItemId = checklistItemId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _createdBy;
  String? get createdBy => _$this._createdBy;
  set createdBy(String? createdBy) => _$this._createdBy = createdBy;

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

  ArMeasurementResponseMethodEnum? _method;
  ArMeasurementResponseMethodEnum? get method => _$this._method;
  set method(ArMeasurementResponseMethodEnum? method) =>
      _$this._method = method;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  ListBuilder<AnnotationPointResponse>? _points;
  ListBuilder<AnnotationPointResponse> get points =>
      _$this._points ??= new ListBuilder<AnnotationPointResponse>();
  set points(ListBuilder<AnnotationPointResponse>? points) =>
      _$this._points = points;

  ArMeasurementResponseBuilder() {
    ArMeasurementResponse._defaults(this);
  }

  ArMeasurementResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _checklistItemId = $v.checklistItemId;
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy;
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
  void replace(ArMeasurementResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ArMeasurementResponse;
  }

  @override
  void update(void Function(ArMeasurementResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ArMeasurementResponse build() => _build();

  _$ArMeasurementResponse _build() {
    _$ArMeasurementResponse _$result;
    try {
      _$result = _$v ??
          new _$ArMeasurementResponse._(
              checklistItemId: checklistItemId,
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'ArMeasurementResponse', 'createdAt'),
              createdBy: BuiltValueNullFieldError.checkNotNull(
                  createdBy, r'ArMeasurementResponse', 'createdBy'),
              distanceMeters: BuiltValueNullFieldError.checkNotNull(
                  distanceMeters, r'ArMeasurementResponse', 'distanceMeters'),
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'ArMeasurementResponse', 'id'),
              label: label,
              mediaLocalId: mediaLocalId,
              method: BuiltValueNullFieldError.checkNotNull(
                  method, r'ArMeasurementResponse', 'method'),
              note: note,
              points: _points?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'points';
        _points?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ArMeasurementResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
