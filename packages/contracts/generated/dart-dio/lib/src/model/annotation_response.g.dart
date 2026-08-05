// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annotation_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AnnotationResponseDamageTypeEnum
    _$annotationResponseDamageTypeEnum_corrosion =
    const AnnotationResponseDamageTypeEnum._('corrosion');
const AnnotationResponseDamageTypeEnum _$annotationResponseDamageTypeEnum_rust =
    const AnnotationResponseDamageTypeEnum._('rust');
const AnnotationResponseDamageTypeEnum
    _$annotationResponseDamageTypeEnum_crack =
    const AnnotationResponseDamageTypeEnum._('crack');
const AnnotationResponseDamageTypeEnum
    _$annotationResponseDamageTypeEnum_surfaceDamage =
    const AnnotationResponseDamageTypeEnum._('surfaceDamage');
const AnnotationResponseDamageTypeEnum
    _$annotationResponseDamageTypeEnum_paintDeterioration =
    const AnnotationResponseDamageTypeEnum._('paintDeterioration');
const AnnotationResponseDamageTypeEnum
    _$annotationResponseDamageTypeEnum_missingBolt =
    const AnnotationResponseDamageTypeEnum._('missingBolt');
const AnnotationResponseDamageTypeEnum
    _$annotationResponseDamageTypeEnum_brokenComponent =
    const AnnotationResponseDamageTypeEnum._('brokenComponent');
const AnnotationResponseDamageTypeEnum _$annotationResponseDamageTypeEnum_leak =
    const AnnotationResponseDamageTypeEnum._('leak');
const AnnotationResponseDamageTypeEnum _$annotationResponseDamageTypeEnum_wear =
    const AnnotationResponseDamageTypeEnum._('wear');
const AnnotationResponseDamageTypeEnum
    _$annotationResponseDamageTypeEnum_other =
    const AnnotationResponseDamageTypeEnum._('other');

AnnotationResponseDamageTypeEnum _$annotationResponseDamageTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'corrosion':
      return _$annotationResponseDamageTypeEnum_corrosion;
    case 'rust':
      return _$annotationResponseDamageTypeEnum_rust;
    case 'crack':
      return _$annotationResponseDamageTypeEnum_crack;
    case 'surfaceDamage':
      return _$annotationResponseDamageTypeEnum_surfaceDamage;
    case 'paintDeterioration':
      return _$annotationResponseDamageTypeEnum_paintDeterioration;
    case 'missingBolt':
      return _$annotationResponseDamageTypeEnum_missingBolt;
    case 'brokenComponent':
      return _$annotationResponseDamageTypeEnum_brokenComponent;
    case 'leak':
      return _$annotationResponseDamageTypeEnum_leak;
    case 'wear':
      return _$annotationResponseDamageTypeEnum_wear;
    case 'other':
      return _$annotationResponseDamageTypeEnum_other;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<AnnotationResponseDamageTypeEnum>
    _$annotationResponseDamageTypeEnumValues = new BuiltSet<
        AnnotationResponseDamageTypeEnum>(const <AnnotationResponseDamageTypeEnum>[
  _$annotationResponseDamageTypeEnum_corrosion,
  _$annotationResponseDamageTypeEnum_rust,
  _$annotationResponseDamageTypeEnum_crack,
  _$annotationResponseDamageTypeEnum_surfaceDamage,
  _$annotationResponseDamageTypeEnum_paintDeterioration,
  _$annotationResponseDamageTypeEnum_missingBolt,
  _$annotationResponseDamageTypeEnum_brokenComponent,
  _$annotationResponseDamageTypeEnum_leak,
  _$annotationResponseDamageTypeEnum_wear,
  _$annotationResponseDamageTypeEnum_other,
]);

const AnnotationResponseShapeEnum _$annotationResponseShapeEnum_freehand =
    const AnnotationResponseShapeEnum._('freehand');
const AnnotationResponseShapeEnum _$annotationResponseShapeEnum_rectangle =
    const AnnotationResponseShapeEnum._('rectangle');
const AnnotationResponseShapeEnum _$annotationResponseShapeEnum_circle =
    const AnnotationResponseShapeEnum._('circle');
const AnnotationResponseShapeEnum _$annotationResponseShapeEnum_arrow =
    const AnnotationResponseShapeEnum._('arrow');
const AnnotationResponseShapeEnum _$annotationResponseShapeEnum_point =
    const AnnotationResponseShapeEnum._('point');

AnnotationResponseShapeEnum _$annotationResponseShapeEnumValueOf(String name) {
  switch (name) {
    case 'freehand':
      return _$annotationResponseShapeEnum_freehand;
    case 'rectangle':
      return _$annotationResponseShapeEnum_rectangle;
    case 'circle':
      return _$annotationResponseShapeEnum_circle;
    case 'arrow':
      return _$annotationResponseShapeEnum_arrow;
    case 'point':
      return _$annotationResponseShapeEnum_point;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<AnnotationResponseShapeEnum>
    _$annotationResponseShapeEnumValues = new BuiltSet<
        AnnotationResponseShapeEnum>(const <AnnotationResponseShapeEnum>[
  _$annotationResponseShapeEnum_freehand,
  _$annotationResponseShapeEnum_rectangle,
  _$annotationResponseShapeEnum_circle,
  _$annotationResponseShapeEnum_arrow,
  _$annotationResponseShapeEnum_point,
]);

const AnnotationResponseSource_Enum _$annotationResponseSourceEnum_manual =
    const AnnotationResponseSource_Enum._('manual');
const AnnotationResponseSource_Enum _$annotationResponseSourceEnum_ai =
    const AnnotationResponseSource_Enum._('ai');

AnnotationResponseSource_Enum _$annotationResponseSourceEnumValueOf(
    String name) {
  switch (name) {
    case 'manual':
      return _$annotationResponseSourceEnum_manual;
    case 'ai':
      return _$annotationResponseSourceEnum_ai;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<AnnotationResponseSource_Enum>
    _$annotationResponseSourceEnumValues = new BuiltSet<
        AnnotationResponseSource_Enum>(const <AnnotationResponseSource_Enum>[
  _$annotationResponseSourceEnum_manual,
  _$annotationResponseSourceEnum_ai,
]);

Serializer<AnnotationResponseDamageTypeEnum>
    _$annotationResponseDamageTypeEnumSerializer =
    new _$AnnotationResponseDamageTypeEnumSerializer();
Serializer<AnnotationResponseShapeEnum>
    _$annotationResponseShapeEnumSerializer =
    new _$AnnotationResponseShapeEnumSerializer();
Serializer<AnnotationResponseSource_Enum>
    _$annotationResponseSourceEnumSerializer =
    new _$AnnotationResponseSource_EnumSerializer();

class _$AnnotationResponseDamageTypeEnumSerializer
    implements PrimitiveSerializer<AnnotationResponseDamageTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'corrosion': 'corrosion',
    'rust': 'rust',
    'crack': 'crack',
    'surfaceDamage': 'surface_damage',
    'paintDeterioration': 'paint_deterioration',
    'missingBolt': 'missing_bolt',
    'brokenComponent': 'broken_component',
    'leak': 'leak',
    'wear': 'wear',
    'other': 'other',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'corrosion': 'corrosion',
    'rust': 'rust',
    'crack': 'crack',
    'surface_damage': 'surfaceDamage',
    'paint_deterioration': 'paintDeterioration',
    'missing_bolt': 'missingBolt',
    'broken_component': 'brokenComponent',
    'leak': 'leak',
    'wear': 'wear',
    'other': 'other',
  };

  @override
  final Iterable<Type> types = const <Type>[AnnotationResponseDamageTypeEnum];
  @override
  final String wireName = 'AnnotationResponseDamageTypeEnum';

  @override
  Object serialize(
          Serializers serializers, AnnotationResponseDamageTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AnnotationResponseDamageTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AnnotationResponseDamageTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AnnotationResponseShapeEnumSerializer
    implements PrimitiveSerializer<AnnotationResponseShapeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'freehand': 'freehand',
    'rectangle': 'rectangle',
    'circle': 'circle',
    'arrow': 'arrow',
    'point': 'point',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'freehand': 'freehand',
    'rectangle': 'rectangle',
    'circle': 'circle',
    'arrow': 'arrow',
    'point': 'point',
  };

  @override
  final Iterable<Type> types = const <Type>[AnnotationResponseShapeEnum];
  @override
  final String wireName = 'AnnotationResponseShapeEnum';

  @override
  Object serialize(Serializers serializers, AnnotationResponseShapeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AnnotationResponseShapeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AnnotationResponseShapeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AnnotationResponseSource_EnumSerializer
    implements PrimitiveSerializer<AnnotationResponseSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'manual': 'manual',
    'ai': 'ai',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'manual': 'manual',
    'ai': 'ai',
  };

  @override
  final Iterable<Type> types = const <Type>[AnnotationResponseSource_Enum];
  @override
  final String wireName = 'AnnotationResponseSource_Enum';

  @override
  Object serialize(
          Serializers serializers, AnnotationResponseSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AnnotationResponseSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AnnotationResponseSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AnnotationResponse extends AnnotationResponse {
  @override
  final String color;
  @override
  final num? confidence;
  @override
  final DateTime createdAt;
  @override
  final String createdBy;
  @override
  final AnnotationResponseDamageTypeEnum? damageType;
  @override
  final String id;
  @override
  final String mediaLocalId;
  @override
  final String? note;
  @override
  final BuiltList<AnnotationPointResponse> points;
  @override
  final AnnotationResponseShapeEnum shape;
  @override
  final AnnotationResponseSource_Enum? source_;

  factory _$AnnotationResponse(
          [void Function(AnnotationResponseBuilder)? updates]) =>
      (new AnnotationResponseBuilder()..update(updates))._build();

  _$AnnotationResponse._(
      {required this.color,
      this.confidence,
      required this.createdAt,
      required this.createdBy,
      this.damageType,
      required this.id,
      required this.mediaLocalId,
      this.note,
      required this.points,
      required this.shape,
      this.source_})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        color, r'AnnotationResponse', 'color');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'AnnotationResponse', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        createdBy, r'AnnotationResponse', 'createdBy');
    BuiltValueNullFieldError.checkNotNull(id, r'AnnotationResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        mediaLocalId, r'AnnotationResponse', 'mediaLocalId');
    BuiltValueNullFieldError.checkNotNull(
        points, r'AnnotationResponse', 'points');
    BuiltValueNullFieldError.checkNotNull(
        shape, r'AnnotationResponse', 'shape');
  }

  @override
  AnnotationResponse rebuild(
          void Function(AnnotationResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnnotationResponseBuilder toBuilder() =>
      new AnnotationResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnnotationResponse &&
        color == other.color &&
        confidence == other.confidence &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        damageType == other.damageType &&
        id == other.id &&
        mediaLocalId == other.mediaLocalId &&
        note == other.note &&
        points == other.points &&
        shape == other.shape &&
        source_ == other.source_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, color.hashCode);
    _$hash = $jc(_$hash, confidence.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, damageType.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, mediaLocalId.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jc(_$hash, shape.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AnnotationResponse')
          ..add('color', color)
          ..add('confidence', confidence)
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('damageType', damageType)
          ..add('id', id)
          ..add('mediaLocalId', mediaLocalId)
          ..add('note', note)
          ..add('points', points)
          ..add('shape', shape)
          ..add('source_', source_))
        .toString();
  }
}

class AnnotationResponseBuilder
    implements Builder<AnnotationResponse, AnnotationResponseBuilder> {
  _$AnnotationResponse? _$v;

  String? _color;
  String? get color => _$this._color;
  set color(String? color) => _$this._color = color;

  num? _confidence;
  num? get confidence => _$this._confidence;
  set confidence(num? confidence) => _$this._confidence = confidence;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _createdBy;
  String? get createdBy => _$this._createdBy;
  set createdBy(String? createdBy) => _$this._createdBy = createdBy;

  AnnotationResponseDamageTypeEnum? _damageType;
  AnnotationResponseDamageTypeEnum? get damageType => _$this._damageType;
  set damageType(AnnotationResponseDamageTypeEnum? damageType) =>
      _$this._damageType = damageType;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _mediaLocalId;
  String? get mediaLocalId => _$this._mediaLocalId;
  set mediaLocalId(String? mediaLocalId) => _$this._mediaLocalId = mediaLocalId;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  ListBuilder<AnnotationPointResponse>? _points;
  ListBuilder<AnnotationPointResponse> get points =>
      _$this._points ??= new ListBuilder<AnnotationPointResponse>();
  set points(ListBuilder<AnnotationPointResponse>? points) =>
      _$this._points = points;

  AnnotationResponseShapeEnum? _shape;
  AnnotationResponseShapeEnum? get shape => _$this._shape;
  set shape(AnnotationResponseShapeEnum? shape) => _$this._shape = shape;

  AnnotationResponseSource_Enum? _source_;
  AnnotationResponseSource_Enum? get source_ => _$this._source_;
  set source_(AnnotationResponseSource_Enum? source_) =>
      _$this._source_ = source_;

  AnnotationResponseBuilder() {
    AnnotationResponse._defaults(this);
  }

  AnnotationResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _color = $v.color;
      _confidence = $v.confidence;
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy;
      _damageType = $v.damageType;
      _id = $v.id;
      _mediaLocalId = $v.mediaLocalId;
      _note = $v.note;
      _points = $v.points.toBuilder();
      _shape = $v.shape;
      _source_ = $v.source_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnnotationResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AnnotationResponse;
  }

  @override
  void update(void Function(AnnotationResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnnotationResponse build() => _build();

  _$AnnotationResponse _build() {
    _$AnnotationResponse _$result;
    try {
      _$result = _$v ??
          new _$AnnotationResponse._(
              color: BuiltValueNullFieldError.checkNotNull(
                  color, r'AnnotationResponse', 'color'),
              confidence: confidence,
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'AnnotationResponse', 'createdAt'),
              createdBy: BuiltValueNullFieldError.checkNotNull(
                  createdBy, r'AnnotationResponse', 'createdBy'),
              damageType: damageType,
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'AnnotationResponse', 'id'),
              mediaLocalId: BuiltValueNullFieldError.checkNotNull(
                  mediaLocalId, r'AnnotationResponse', 'mediaLocalId'),
              note: note,
              points: points.build(),
              shape: BuiltValueNullFieldError.checkNotNull(
                  shape, r'AnnotationResponse', 'shape'),
              source_: source_);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'points';
        points.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AnnotationResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
