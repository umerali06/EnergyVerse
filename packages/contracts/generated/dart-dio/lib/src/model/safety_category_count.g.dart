// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safety_category_count.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SafetyCategoryCountCategoryEnum
    _$safetyCategoryCountCategoryEnum_nearMiss =
    const SafetyCategoryCountCategoryEnum._('nearMiss');
const SafetyCategoryCountCategoryEnum
    _$safetyCategoryCountCategoryEnum_unsafeCondition =
    const SafetyCategoryCountCategoryEnum._('unsafeCondition');
const SafetyCategoryCountCategoryEnum
    _$safetyCategoryCountCategoryEnum_unsafeBehavior =
    const SafetyCategoryCountCategoryEnum._('unsafeBehavior');
const SafetyCategoryCountCategoryEnum _$safetyCategoryCountCategoryEnum_fire =
    const SafetyCategoryCountCategoryEnum._('fire');
const SafetyCategoryCountCategoryEnum
    _$safetyCategoryCountCategoryEnum_gasLeak =
    const SafetyCategoryCountCategoryEnum._('gasLeak');
const SafetyCategoryCountCategoryEnum
    _$safetyCategoryCountCategoryEnum_chemicalSpill =
    const SafetyCategoryCountCategoryEnum._('chemicalSpill');
const SafetyCategoryCountCategoryEnum
    _$safetyCategoryCountCategoryEnum_environmentalIncident =
    const SafetyCategoryCountCategoryEnum._('environmentalIncident');
const SafetyCategoryCountCategoryEnum
    _$safetyCategoryCountCategoryEnum_equipmentFailure =
    const SafetyCategoryCountCategoryEnum._('equipmentFailure');
const SafetyCategoryCountCategoryEnum _$safetyCategoryCountCategoryEnum_injury =
    const SafetyCategoryCountCategoryEnum._('injury');

SafetyCategoryCountCategoryEnum _$safetyCategoryCountCategoryEnumValueOf(
    String name) {
  switch (name) {
    case 'nearMiss':
      return _$safetyCategoryCountCategoryEnum_nearMiss;
    case 'unsafeCondition':
      return _$safetyCategoryCountCategoryEnum_unsafeCondition;
    case 'unsafeBehavior':
      return _$safetyCategoryCountCategoryEnum_unsafeBehavior;
    case 'fire':
      return _$safetyCategoryCountCategoryEnum_fire;
    case 'gasLeak':
      return _$safetyCategoryCountCategoryEnum_gasLeak;
    case 'chemicalSpill':
      return _$safetyCategoryCountCategoryEnum_chemicalSpill;
    case 'environmentalIncident':
      return _$safetyCategoryCountCategoryEnum_environmentalIncident;
    case 'equipmentFailure':
      return _$safetyCategoryCountCategoryEnum_equipmentFailure;
    case 'injury':
      return _$safetyCategoryCountCategoryEnum_injury;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<SafetyCategoryCountCategoryEnum>
    _$safetyCategoryCountCategoryEnumValues = new BuiltSet<
        SafetyCategoryCountCategoryEnum>(const <SafetyCategoryCountCategoryEnum>[
  _$safetyCategoryCountCategoryEnum_nearMiss,
  _$safetyCategoryCountCategoryEnum_unsafeCondition,
  _$safetyCategoryCountCategoryEnum_unsafeBehavior,
  _$safetyCategoryCountCategoryEnum_fire,
  _$safetyCategoryCountCategoryEnum_gasLeak,
  _$safetyCategoryCountCategoryEnum_chemicalSpill,
  _$safetyCategoryCountCategoryEnum_environmentalIncident,
  _$safetyCategoryCountCategoryEnum_equipmentFailure,
  _$safetyCategoryCountCategoryEnum_injury,
]);

Serializer<SafetyCategoryCountCategoryEnum>
    _$safetyCategoryCountCategoryEnumSerializer =
    new _$SafetyCategoryCountCategoryEnumSerializer();

class _$SafetyCategoryCountCategoryEnumSerializer
    implements PrimitiveSerializer<SafetyCategoryCountCategoryEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'nearMiss': 'near_miss',
    'unsafeCondition': 'unsafe_condition',
    'unsafeBehavior': 'unsafe_behavior',
    'fire': 'fire',
    'gasLeak': 'gas_leak',
    'chemicalSpill': 'chemical_spill',
    'environmentalIncident': 'environmental_incident',
    'equipmentFailure': 'equipment_failure',
    'injury': 'injury',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'near_miss': 'nearMiss',
    'unsafe_condition': 'unsafeCondition',
    'unsafe_behavior': 'unsafeBehavior',
    'fire': 'fire',
    'gas_leak': 'gasLeak',
    'chemical_spill': 'chemicalSpill',
    'environmental_incident': 'environmentalIncident',
    'equipment_failure': 'equipmentFailure',
    'injury': 'injury',
  };

  @override
  final Iterable<Type> types = const <Type>[SafetyCategoryCountCategoryEnum];
  @override
  final String wireName = 'SafetyCategoryCountCategoryEnum';

  @override
  Object serialize(
          Serializers serializers, SafetyCategoryCountCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SafetyCategoryCountCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SafetyCategoryCountCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SafetyCategoryCount extends SafetyCategoryCount {
  @override
  final SafetyCategoryCountCategoryEnum category;
  @override
  final int count;

  factory _$SafetyCategoryCount(
          [void Function(SafetyCategoryCountBuilder)? updates]) =>
      (new SafetyCategoryCountBuilder()..update(updates))._build();

  _$SafetyCategoryCount._({required this.category, required this.count})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        category, r'SafetyCategoryCount', 'category');
    BuiltValueNullFieldError.checkNotNull(
        count, r'SafetyCategoryCount', 'count');
  }

  @override
  SafetyCategoryCount rebuild(
          void Function(SafetyCategoryCountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SafetyCategoryCountBuilder toBuilder() =>
      new SafetyCategoryCountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SafetyCategoryCount &&
        category == other.category &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SafetyCategoryCount')
          ..add('category', category)
          ..add('count', count))
        .toString();
  }
}

class SafetyCategoryCountBuilder
    implements Builder<SafetyCategoryCount, SafetyCategoryCountBuilder> {
  _$SafetyCategoryCount? _$v;

  SafetyCategoryCountCategoryEnum? _category;
  SafetyCategoryCountCategoryEnum? get category => _$this._category;
  set category(SafetyCategoryCountCategoryEnum? category) =>
      _$this._category = category;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  SafetyCategoryCountBuilder() {
    SafetyCategoryCount._defaults(this);
  }

  SafetyCategoryCountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SafetyCategoryCount other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SafetyCategoryCount;
  }

  @override
  void update(void Function(SafetyCategoryCountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SafetyCategoryCount build() => _build();

  _$SafetyCategoryCount _build() {
    final _$result = _$v ??
        new _$SafetyCategoryCount._(
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'SafetyCategoryCount', 'category'),
            count: BuiltValueNullFieldError.checkNotNull(
                count, r'SafetyCategoryCount', 'count'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
