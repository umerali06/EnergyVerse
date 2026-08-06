// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_annotation_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UpdateAnnotationRequestDamageTypeEnum
    _$updateAnnotationRequestDamageTypeEnum_corrosion =
    const UpdateAnnotationRequestDamageTypeEnum._('corrosion');
const UpdateAnnotationRequestDamageTypeEnum
    _$updateAnnotationRequestDamageTypeEnum_rust =
    const UpdateAnnotationRequestDamageTypeEnum._('rust');
const UpdateAnnotationRequestDamageTypeEnum
    _$updateAnnotationRequestDamageTypeEnum_crack =
    const UpdateAnnotationRequestDamageTypeEnum._('crack');
const UpdateAnnotationRequestDamageTypeEnum
    _$updateAnnotationRequestDamageTypeEnum_surfaceDamage =
    const UpdateAnnotationRequestDamageTypeEnum._('surfaceDamage');
const UpdateAnnotationRequestDamageTypeEnum
    _$updateAnnotationRequestDamageTypeEnum_paintDeterioration =
    const UpdateAnnotationRequestDamageTypeEnum._('paintDeterioration');
const UpdateAnnotationRequestDamageTypeEnum
    _$updateAnnotationRequestDamageTypeEnum_missingBolt =
    const UpdateAnnotationRequestDamageTypeEnum._('missingBolt');
const UpdateAnnotationRequestDamageTypeEnum
    _$updateAnnotationRequestDamageTypeEnum_brokenComponent =
    const UpdateAnnotationRequestDamageTypeEnum._('brokenComponent');
const UpdateAnnotationRequestDamageTypeEnum
    _$updateAnnotationRequestDamageTypeEnum_leak =
    const UpdateAnnotationRequestDamageTypeEnum._('leak');
const UpdateAnnotationRequestDamageTypeEnum
    _$updateAnnotationRequestDamageTypeEnum_wear =
    const UpdateAnnotationRequestDamageTypeEnum._('wear');
const UpdateAnnotationRequestDamageTypeEnum
    _$updateAnnotationRequestDamageTypeEnum_other =
    const UpdateAnnotationRequestDamageTypeEnum._('other');

UpdateAnnotationRequestDamageTypeEnum
    _$updateAnnotationRequestDamageTypeEnumValueOf(String name) {
  switch (name) {
    case 'corrosion':
      return _$updateAnnotationRequestDamageTypeEnum_corrosion;
    case 'rust':
      return _$updateAnnotationRequestDamageTypeEnum_rust;
    case 'crack':
      return _$updateAnnotationRequestDamageTypeEnum_crack;
    case 'surfaceDamage':
      return _$updateAnnotationRequestDamageTypeEnum_surfaceDamage;
    case 'paintDeterioration':
      return _$updateAnnotationRequestDamageTypeEnum_paintDeterioration;
    case 'missingBolt':
      return _$updateAnnotationRequestDamageTypeEnum_missingBolt;
    case 'brokenComponent':
      return _$updateAnnotationRequestDamageTypeEnum_brokenComponent;
    case 'leak':
      return _$updateAnnotationRequestDamageTypeEnum_leak;
    case 'wear':
      return _$updateAnnotationRequestDamageTypeEnum_wear;
    case 'other':
      return _$updateAnnotationRequestDamageTypeEnum_other;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<UpdateAnnotationRequestDamageTypeEnum>
    _$updateAnnotationRequestDamageTypeEnumValues = new BuiltSet<
        UpdateAnnotationRequestDamageTypeEnum>(const <UpdateAnnotationRequestDamageTypeEnum>[
  _$updateAnnotationRequestDamageTypeEnum_corrosion,
  _$updateAnnotationRequestDamageTypeEnum_rust,
  _$updateAnnotationRequestDamageTypeEnum_crack,
  _$updateAnnotationRequestDamageTypeEnum_surfaceDamage,
  _$updateAnnotationRequestDamageTypeEnum_paintDeterioration,
  _$updateAnnotationRequestDamageTypeEnum_missingBolt,
  _$updateAnnotationRequestDamageTypeEnum_brokenComponent,
  _$updateAnnotationRequestDamageTypeEnum_leak,
  _$updateAnnotationRequestDamageTypeEnum_wear,
  _$updateAnnotationRequestDamageTypeEnum_other,
]);

Serializer<UpdateAnnotationRequestDamageTypeEnum>
    _$updateAnnotationRequestDamageTypeEnumSerializer =
    new _$UpdateAnnotationRequestDamageTypeEnumSerializer();

class _$UpdateAnnotationRequestDamageTypeEnumSerializer
    implements PrimitiveSerializer<UpdateAnnotationRequestDamageTypeEnum> {
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
    UpdateAnnotationRequestDamageTypeEnum
  ];
  @override
  final String wireName = 'UpdateAnnotationRequestDamageTypeEnum';

  @override
  Object serialize(
          Serializers serializers, UpdateAnnotationRequestDamageTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UpdateAnnotationRequestDamageTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UpdateAnnotationRequestDamageTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UpdateAnnotationRequest extends UpdateAnnotationRequest {
  @override
  final String? color;
  @override
  final UpdateAnnotationRequestDamageTypeEnum? damageType;
  @override
  final String? note;
  @override
  final BuiltList<AnnotationPointInput>? points;

  factory _$UpdateAnnotationRequest(
          [void Function(UpdateAnnotationRequestBuilder)? updates]) =>
      (new UpdateAnnotationRequestBuilder()..update(updates))._build();

  _$UpdateAnnotationRequest._(
      {this.color, this.damageType, this.note, this.points})
      : super._();

  @override
  UpdateAnnotationRequest rebuild(
          void Function(UpdateAnnotationRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateAnnotationRequestBuilder toBuilder() =>
      new UpdateAnnotationRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateAnnotationRequest &&
        color == other.color &&
        damageType == other.damageType &&
        note == other.note &&
        points == other.points;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, color.hashCode);
    _$hash = $jc(_$hash, damageType.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateAnnotationRequest')
          ..add('color', color)
          ..add('damageType', damageType)
          ..add('note', note)
          ..add('points', points))
        .toString();
  }
}

class UpdateAnnotationRequestBuilder
    implements
        Builder<UpdateAnnotationRequest, UpdateAnnotationRequestBuilder> {
  _$UpdateAnnotationRequest? _$v;

  String? _color;
  String? get color => _$this._color;
  set color(String? color) => _$this._color = color;

  UpdateAnnotationRequestDamageTypeEnum? _damageType;
  UpdateAnnotationRequestDamageTypeEnum? get damageType => _$this._damageType;
  set damageType(UpdateAnnotationRequestDamageTypeEnum? damageType) =>
      _$this._damageType = damageType;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  ListBuilder<AnnotationPointInput>? _points;
  ListBuilder<AnnotationPointInput> get points =>
      _$this._points ??= new ListBuilder<AnnotationPointInput>();
  set points(ListBuilder<AnnotationPointInput>? points) =>
      _$this._points = points;

  UpdateAnnotationRequestBuilder() {
    UpdateAnnotationRequest._defaults(this);
  }

  UpdateAnnotationRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _color = $v.color;
      _damageType = $v.damageType;
      _note = $v.note;
      _points = $v.points?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateAnnotationRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateAnnotationRequest;
  }

  @override
  void update(void Function(UpdateAnnotationRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateAnnotationRequest build() => _build();

  _$UpdateAnnotationRequest _build() {
    _$UpdateAnnotationRequest _$result;
    try {
      _$result = _$v ??
          new _$UpdateAnnotationRequest._(
              color: color,
              damageType: damageType,
              note: note,
              points: _points?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'points';
        _points?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UpdateAnnotationRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
