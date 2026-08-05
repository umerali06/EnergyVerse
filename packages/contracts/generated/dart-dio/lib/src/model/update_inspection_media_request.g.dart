// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_inspection_media_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UpdateInspectionMediaRequestBeforeAfterTagEnum
    _$updateInspectionMediaRequestBeforeAfterTagEnum_before =
    const UpdateInspectionMediaRequestBeforeAfterTagEnum._('before');
const UpdateInspectionMediaRequestBeforeAfterTagEnum
    _$updateInspectionMediaRequestBeforeAfterTagEnum_after =
    const UpdateInspectionMediaRequestBeforeAfterTagEnum._('after');

UpdateInspectionMediaRequestBeforeAfterTagEnum
    _$updateInspectionMediaRequestBeforeAfterTagEnumValueOf(String name) {
  switch (name) {
    case 'before':
      return _$updateInspectionMediaRequestBeforeAfterTagEnum_before;
    case 'after':
      return _$updateInspectionMediaRequestBeforeAfterTagEnum_after;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<UpdateInspectionMediaRequestBeforeAfterTagEnum>
    _$updateInspectionMediaRequestBeforeAfterTagEnumValues = new BuiltSet<
        UpdateInspectionMediaRequestBeforeAfterTagEnum>(const <UpdateInspectionMediaRequestBeforeAfterTagEnum>[
  _$updateInspectionMediaRequestBeforeAfterTagEnum_before,
  _$updateInspectionMediaRequestBeforeAfterTagEnum_after,
]);

Serializer<UpdateInspectionMediaRequestBeforeAfterTagEnum>
    _$updateInspectionMediaRequestBeforeAfterTagEnumSerializer =
    new _$UpdateInspectionMediaRequestBeforeAfterTagEnumSerializer();

class _$UpdateInspectionMediaRequestBeforeAfterTagEnumSerializer
    implements
        PrimitiveSerializer<UpdateInspectionMediaRequestBeforeAfterTagEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'before': 'before',
    'after': 'after',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'before': 'before',
    'after': 'after',
  };

  @override
  final Iterable<Type> types = const <Type>[
    UpdateInspectionMediaRequestBeforeAfterTagEnum
  ];
  @override
  final String wireName = 'UpdateInspectionMediaRequestBeforeAfterTagEnum';

  @override
  Object serialize(Serializers serializers,
          UpdateInspectionMediaRequestBeforeAfterTagEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UpdateInspectionMediaRequestBeforeAfterTagEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UpdateInspectionMediaRequestBeforeAfterTagEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UpdateInspectionMediaRequest extends UpdateInspectionMediaRequest {
  @override
  final UpdateInspectionMediaRequestBeforeAfterTagEnum? beforeAfterTag;
  @override
  final String? checklistItemId;

  factory _$UpdateInspectionMediaRequest(
          [void Function(UpdateInspectionMediaRequestBuilder)? updates]) =>
      (new UpdateInspectionMediaRequestBuilder()..update(updates))._build();

  _$UpdateInspectionMediaRequest._({this.beforeAfterTag, this.checklistItemId})
      : super._();

  @override
  UpdateInspectionMediaRequest rebuild(
          void Function(UpdateInspectionMediaRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateInspectionMediaRequestBuilder toBuilder() =>
      new UpdateInspectionMediaRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateInspectionMediaRequest &&
        beforeAfterTag == other.beforeAfterTag &&
        checklistItemId == other.checklistItemId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, beforeAfterTag.hashCode);
    _$hash = $jc(_$hash, checklistItemId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateInspectionMediaRequest')
          ..add('beforeAfterTag', beforeAfterTag)
          ..add('checklistItemId', checklistItemId))
        .toString();
  }
}

class UpdateInspectionMediaRequestBuilder
    implements
        Builder<UpdateInspectionMediaRequest,
            UpdateInspectionMediaRequestBuilder> {
  _$UpdateInspectionMediaRequest? _$v;

  UpdateInspectionMediaRequestBeforeAfterTagEnum? _beforeAfterTag;
  UpdateInspectionMediaRequestBeforeAfterTagEnum? get beforeAfterTag =>
      _$this._beforeAfterTag;
  set beforeAfterTag(
          UpdateInspectionMediaRequestBeforeAfterTagEnum? beforeAfterTag) =>
      _$this._beforeAfterTag = beforeAfterTag;

  String? _checklistItemId;
  String? get checklistItemId => _$this._checklistItemId;
  set checklistItemId(String? checklistItemId) =>
      _$this._checklistItemId = checklistItemId;

  UpdateInspectionMediaRequestBuilder() {
    UpdateInspectionMediaRequest._defaults(this);
  }

  UpdateInspectionMediaRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _beforeAfterTag = $v.beforeAfterTag;
      _checklistItemId = $v.checklistItemId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateInspectionMediaRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateInspectionMediaRequest;
  }

  @override
  void update(void Function(UpdateInspectionMediaRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateInspectionMediaRequest build() => _build();

  _$UpdateInspectionMediaRequest _build() {
    final _$result = _$v ??
        new _$UpdateInspectionMediaRequest._(
            beforeAfterTag: beforeAfterTag, checklistItemId: checklistItemId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
