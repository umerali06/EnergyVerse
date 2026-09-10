// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_module_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TrainingModuleResponse extends TrainingModuleResponse {
  @override
  final String description;
  @override
  final int estimatedMinutes;
  @override
  final String facilityId;
  @override
  final String id;
  @override
  final String kind;
  @override
  final int passThreshold;
  @override
  final BuiltList<TrainingStepResponse>? steps;
  @override
  final String title;

  factory _$TrainingModuleResponse(
          [void Function(TrainingModuleResponseBuilder)? updates]) =>
      (new TrainingModuleResponseBuilder()..update(updates))._build();

  _$TrainingModuleResponse._(
      {required this.description,
      required this.estimatedMinutes,
      required this.facilityId,
      required this.id,
      required this.kind,
      required this.passThreshold,
      this.steps,
      required this.title})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        description, r'TrainingModuleResponse', 'description');
    BuiltValueNullFieldError.checkNotNull(
        estimatedMinutes, r'TrainingModuleResponse', 'estimatedMinutes');
    BuiltValueNullFieldError.checkNotNull(
        facilityId, r'TrainingModuleResponse', 'facilityId');
    BuiltValueNullFieldError.checkNotNull(id, r'TrainingModuleResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        kind, r'TrainingModuleResponse', 'kind');
    BuiltValueNullFieldError.checkNotNull(
        passThreshold, r'TrainingModuleResponse', 'passThreshold');
    BuiltValueNullFieldError.checkNotNull(
        title, r'TrainingModuleResponse', 'title');
  }

  @override
  TrainingModuleResponse rebuild(
          void Function(TrainingModuleResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TrainingModuleResponseBuilder toBuilder() =>
      new TrainingModuleResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TrainingModuleResponse &&
        description == other.description &&
        estimatedMinutes == other.estimatedMinutes &&
        facilityId == other.facilityId &&
        id == other.id &&
        kind == other.kind &&
        passThreshold == other.passThreshold &&
        steps == other.steps &&
        title == other.title;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, estimatedMinutes.hashCode);
    _$hash = $jc(_$hash, facilityId.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, passThreshold.hashCode);
    _$hash = $jc(_$hash, steps.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TrainingModuleResponse')
          ..add('description', description)
          ..add('estimatedMinutes', estimatedMinutes)
          ..add('facilityId', facilityId)
          ..add('id', id)
          ..add('kind', kind)
          ..add('passThreshold', passThreshold)
          ..add('steps', steps)
          ..add('title', title))
        .toString();
  }
}

class TrainingModuleResponseBuilder
    implements Builder<TrainingModuleResponse, TrainingModuleResponseBuilder> {
  _$TrainingModuleResponse? _$v;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _estimatedMinutes;
  int? get estimatedMinutes => _$this._estimatedMinutes;
  set estimatedMinutes(int? estimatedMinutes) =>
      _$this._estimatedMinutes = estimatedMinutes;

  String? _facilityId;
  String? get facilityId => _$this._facilityId;
  set facilityId(String? facilityId) => _$this._facilityId = facilityId;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _kind;
  String? get kind => _$this._kind;
  set kind(String? kind) => _$this._kind = kind;

  int? _passThreshold;
  int? get passThreshold => _$this._passThreshold;
  set passThreshold(int? passThreshold) =>
      _$this._passThreshold = passThreshold;

  ListBuilder<TrainingStepResponse>? _steps;
  ListBuilder<TrainingStepResponse> get steps =>
      _$this._steps ??= new ListBuilder<TrainingStepResponse>();
  set steps(ListBuilder<TrainingStepResponse>? steps) => _$this._steps = steps;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  TrainingModuleResponseBuilder() {
    TrainingModuleResponse._defaults(this);
  }

  TrainingModuleResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _description = $v.description;
      _estimatedMinutes = $v.estimatedMinutes;
      _facilityId = $v.facilityId;
      _id = $v.id;
      _kind = $v.kind;
      _passThreshold = $v.passThreshold;
      _steps = $v.steps?.toBuilder();
      _title = $v.title;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TrainingModuleResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$TrainingModuleResponse;
  }

  @override
  void update(void Function(TrainingModuleResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TrainingModuleResponse build() => _build();

  _$TrainingModuleResponse _build() {
    _$TrainingModuleResponse _$result;
    try {
      _$result = _$v ??
          new _$TrainingModuleResponse._(
              description: BuiltValueNullFieldError.checkNotNull(
                  description, r'TrainingModuleResponse', 'description'),
              estimatedMinutes: BuiltValueNullFieldError.checkNotNull(
                  estimatedMinutes,
                  r'TrainingModuleResponse',
                  'estimatedMinutes'),
              facilityId: BuiltValueNullFieldError.checkNotNull(
                  facilityId, r'TrainingModuleResponse', 'facilityId'),
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'TrainingModuleResponse', 'id'),
              kind: BuiltValueNullFieldError.checkNotNull(
                  kind, r'TrainingModuleResponse', 'kind'),
              passThreshold: BuiltValueNullFieldError.checkNotNull(
                  passThreshold, r'TrainingModuleResponse', 'passThreshold'),
              steps: _steps?.build(),
              title: BuiltValueNullFieldError.checkNotNull(
                  title, r'TrainingModuleResponse', 'title'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'steps';
        _steps?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'TrainingModuleResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
