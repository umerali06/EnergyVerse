// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_annotation_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateAnnotationRequestDamageTypeEnum
    _$createAnnotationRequestDamageTypeEnum_corrosion =
    const CreateAnnotationRequestDamageTypeEnum._('corrosion');
const CreateAnnotationRequestDamageTypeEnum
    _$createAnnotationRequestDamageTypeEnum_rust =
    const CreateAnnotationRequestDamageTypeEnum._('rust');
const CreateAnnotationRequestDamageTypeEnum
    _$createAnnotationRequestDamageTypeEnum_crack =
    const CreateAnnotationRequestDamageTypeEnum._('crack');
const CreateAnnotationRequestDamageTypeEnum
    _$createAnnotationRequestDamageTypeEnum_surfaceDamage =
    const CreateAnnotationRequestDamageTypeEnum._('surfaceDamage');
const CreateAnnotationRequestDamageTypeEnum
    _$createAnnotationRequestDamageTypeEnum_paintDeterioration =
    const CreateAnnotationRequestDamageTypeEnum._('paintDeterioration');
const CreateAnnotationRequestDamageTypeEnum
    _$createAnnotationRequestDamageTypeEnum_missingBolt =
    const CreateAnnotationRequestDamageTypeEnum._('missingBolt');
const CreateAnnotationRequestDamageTypeEnum
    _$createAnnotationRequestDamageTypeEnum_brokenComponent =
    const CreateAnnotationRequestDamageTypeEnum._('brokenComponent');
const CreateAnnotationRequestDamageTypeEnum
    _$createAnnotationRequestDamageTypeEnum_leak =
    const CreateAnnotationRequestDamageTypeEnum._('leak');
const CreateAnnotationRequestDamageTypeEnum
    _$createAnnotationRequestDamageTypeEnum_wear =
    const CreateAnnotationRequestDamageTypeEnum._('wear');
const CreateAnnotationRequestDamageTypeEnum
    _$createAnnotationRequestDamageTypeEnum_other =
    const CreateAnnotationRequestDamageTypeEnum._('other');

CreateAnnotationRequestDamageTypeEnum
    _$createAnnotationRequestDamageTypeEnumValueOf(String name) {
  switch (name) {
    case 'corrosion':
      return _$createAnnotationRequestDamageTypeEnum_corrosion;
    case 'rust':
      return _$createAnnotationRequestDamageTypeEnum_rust;
    case 'crack':
      return _$createAnnotationRequestDamageTypeEnum_crack;
    case 'surfaceDamage':
      return _$createAnnotationRequestDamageTypeEnum_surfaceDamage;
    case 'paintDeterioration':
      return _$createAnnotationRequestDamageTypeEnum_paintDeterioration;
    case 'missingBolt':
      return _$createAnnotationRequestDamageTypeEnum_missingBolt;
    case 'brokenComponent':
      return _$createAnnotationRequestDamageTypeEnum_brokenComponent;
    case 'leak':
      return _$createAnnotationRequestDamageTypeEnum_leak;
    case 'wear':
      return _$createAnnotationRequestDamageTypeEnum_wear;
    case 'other':
      return _$createAnnotationRequestDamageTypeEnum_other;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CreateAnnotationRequestDamageTypeEnum>
    _$createAnnotationRequestDamageTypeEnumValues = new BuiltSet<
        CreateAnnotationRequestDamageTypeEnum>(const <CreateAnnotationRequestDamageTypeEnum>[
  _$createAnnotationRequestDamageTypeEnum_corrosion,
  _$createAnnotationRequestDamageTypeEnum_rust,
  _$createAnnotationRequestDamageTypeEnum_crack,
  _$createAnnotationRequestDamageTypeEnum_surfaceDamage,
  _$createAnnotationRequestDamageTypeEnum_paintDeterioration,
  _$createAnnotationRequestDamageTypeEnum_missingBolt,
  _$createAnnotationRequestDamageTypeEnum_brokenComponent,
  _$createAnnotationRequestDamageTypeEnum_leak,
  _$createAnnotationRequestDamageTypeEnum_wear,
  _$createAnnotationRequestDamageTypeEnum_other,
]);

const CreateAnnotationRequestShapeEnum
    _$createAnnotationRequestShapeEnum_freehand =
    const CreateAnnotationRequestShapeEnum._('freehand');
const CreateAnnotationRequestShapeEnum
    _$createAnnotationRequestShapeEnum_rectangle =
    const CreateAnnotationRequestShapeEnum._('rectangle');
const CreateAnnotationRequestShapeEnum
    _$createAnnotationRequestShapeEnum_circle =
    const CreateAnnotationRequestShapeEnum._('circle');
const CreateAnnotationRequestShapeEnum
    _$createAnnotationRequestShapeEnum_arrow =
    const CreateAnnotationRequestShapeEnum._('arrow');
const CreateAnnotationRequestShapeEnum
    _$createAnnotationRequestShapeEnum_point =
    const CreateAnnotationRequestShapeEnum._('point');

CreateAnnotationRequestShapeEnum _$createAnnotationRequestShapeEnumValueOf(
    String name) {
  switch (name) {
    case 'freehand':
      return _$createAnnotationRequestShapeEnum_freehand;
    case 'rectangle':
      return _$createAnnotationRequestShapeEnum_rectangle;
    case 'circle':
      return _$createAnnotationRequestShapeEnum_circle;
    case 'arrow':
      return _$createAnnotationRequestShapeEnum_arrow;
    case 'point':
      return _$createAnnotationRequestShapeEnum_point;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CreateAnnotationRequestShapeEnum>
    _$createAnnotationRequestShapeEnumValues = new BuiltSet<
        CreateAnnotationRequestShapeEnum>(const <CreateAnnotationRequestShapeEnum>[
  _$createAnnotationRequestShapeEnum_freehand,
  _$createAnnotationRequestShapeEnum_rectangle,
  _$createAnnotationRequestShapeEnum_circle,
  _$createAnnotationRequestShapeEnum_arrow,
  _$createAnnotationRequestShapeEnum_point,
]);

Serializer<CreateAnnotationRequestDamageTypeEnum>
    _$createAnnotationRequestDamageTypeEnumSerializer =
    new _$CreateAnnotationRequestDamageTypeEnumSerializer();
Serializer<CreateAnnotationRequestShapeEnum>
    _$createAnnotationRequestShapeEnumSerializer =
    new _$CreateAnnotationRequestShapeEnumSerializer();

class _$CreateAnnotationRequestDamageTypeEnumSerializer
    implements PrimitiveSerializer<CreateAnnotationRequestDamageTypeEnum> {
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
  final Iterable<Type> types = const <Type>[
    CreateAnnotationRequestDamageTypeEnum
  ];
  @override
  final String wireName = 'CreateAnnotationRequestDamageTypeEnum';

  @override
  Object serialize(
          Serializers serializers, CreateAnnotationRequestDamageTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateAnnotationRequestDamageTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateAnnotationRequestDamageTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateAnnotationRequestShapeEnumSerializer
    implements PrimitiveSerializer<CreateAnnotationRequestShapeEnum> {
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
  final Iterable<Type> types = const <Type>[CreateAnnotationRequestShapeEnum];
  @override
  final String wireName = 'CreateAnnotationRequestShapeEnum';

  @override
  Object serialize(
          Serializers serializers, CreateAnnotationRequestShapeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateAnnotationRequestShapeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateAnnotationRequestShapeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateAnnotationRequest extends CreateAnnotationRequest {
  @override
  final String color;
  @override
  final CreateAnnotationRequestDamageTypeEnum? damageType;
  @override
  final String id;
  @override
  final String mediaLocalId;
  @override
  final String? note;
  @override
  final BuiltList<AnnotationPointInput> points;
  @override
  final CreateAnnotationRequestShapeEnum shape;

  factory _$CreateAnnotationRequest(
          [void Function(CreateAnnotationRequestBuilder)? updates]) =>
      (new CreateAnnotationRequestBuilder()..update(updates))._build();

  _$CreateAnnotationRequest._(
      {required this.color,
      this.damageType,
      required this.id,
      required this.mediaLocalId,
      this.note,
      required this.points,
      required this.shape})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        color, r'CreateAnnotationRequest', 'color');
    BuiltValueNullFieldError.checkNotNull(id, r'CreateAnnotationRequest', 'id');
    BuiltValueNullFieldError.checkNotNull(
        mediaLocalId, r'CreateAnnotationRequest', 'mediaLocalId');
    BuiltValueNullFieldError.checkNotNull(
        points, r'CreateAnnotationRequest', 'points');
    BuiltValueNullFieldError.checkNotNull(
        shape, r'CreateAnnotationRequest', 'shape');
  }

  @override
  CreateAnnotationRequest rebuild(
          void Function(CreateAnnotationRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateAnnotationRequestBuilder toBuilder() =>
      new CreateAnnotationRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateAnnotationRequest &&
        color == other.color &&
        damageType == other.damageType &&
        id == other.id &&
        mediaLocalId == other.mediaLocalId &&
        note == other.note &&
        points == other.points &&
        shape == other.shape;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, color.hashCode);
    _$hash = $jc(_$hash, damageType.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, mediaLocalId.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jc(_$hash, shape.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateAnnotationRequest')
          ..add('color', color)
          ..add('damageType', damageType)
          ..add('id', id)
          ..add('mediaLocalId', mediaLocalId)
          ..add('note', note)
          ..add('points', points)
          ..add('shape', shape))
        .toString();
  }
}

class CreateAnnotationRequestBuilder
    implements
        Builder<CreateAnnotationRequest, CreateAnnotationRequestBuilder> {
  _$CreateAnnotationRequest? _$v;

  String? _color;
  String? get color => _$this._color;
  set color(String? color) => _$this._color = color;

  CreateAnnotationRequestDamageTypeEnum? _damageType;
  CreateAnnotationRequestDamageTypeEnum? get damageType => _$this._damageType;
  set damageType(CreateAnnotationRequestDamageTypeEnum? damageType) =>
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

  ListBuilder<AnnotationPointInput>? _points;
  ListBuilder<AnnotationPointInput> get points =>
      _$this._points ??= new ListBuilder<AnnotationPointInput>();
  set points(ListBuilder<AnnotationPointInput>? points) =>
      _$this._points = points;

  CreateAnnotationRequestShapeEnum? _shape;
  CreateAnnotationRequestShapeEnum? get shape => _$this._shape;
  set shape(CreateAnnotationRequestShapeEnum? shape) => _$this._shape = shape;

  CreateAnnotationRequestBuilder() {
    CreateAnnotationRequest._defaults(this);
  }

  CreateAnnotationRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _color = $v.color;
      _damageType = $v.damageType;
      _id = $v.id;
      _mediaLocalId = $v.mediaLocalId;
      _note = $v.note;
      _points = $v.points.toBuilder();
      _shape = $v.shape;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateAnnotationRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreateAnnotationRequest;
  }

  @override
  void update(void Function(CreateAnnotationRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateAnnotationRequest build() => _build();

  _$CreateAnnotationRequest _build() {
    _$CreateAnnotationRequest _$result;
    try {
      _$result = _$v ??
          new _$CreateAnnotationRequest._(
              color: BuiltValueNullFieldError.checkNotNull(
                  color, r'CreateAnnotationRequest', 'color'),
              damageType: damageType,
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'CreateAnnotationRequest', 'id'),
              mediaLocalId: BuiltValueNullFieldError.checkNotNull(
                  mediaLocalId, r'CreateAnnotationRequest', 'mediaLocalId'),
              note: note,
              points: points.build(),
              shape: BuiltValueNullFieldError.checkNotNull(
                  shape, r'CreateAnnotationRequest', 'shape'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'points';
        points.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CreateAnnotationRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
