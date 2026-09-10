// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_step_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TrainingStepResponse extends TrainingStepResponse {
  @override
  final String action;
  @override
  final String id;
  @override
  final String instruction;
  @override
  final BuiltList<String>? options;
  @override
  final int order;
  @override
  final String? targetAssetId;
  @override
  final BuiltList<num>? targetPosition;
  @override
  final int? timeLimitSeconds;
  @override
  final String title;

  factory _$TrainingStepResponse(
          [void Function(TrainingStepResponseBuilder)? updates]) =>
      (new TrainingStepResponseBuilder()..update(updates))._build();

  _$TrainingStepResponse._(
      {required this.action,
      required this.id,
      required this.instruction,
      this.options,
      required this.order,
      this.targetAssetId,
      this.targetPosition,
      this.timeLimitSeconds,
      required this.title})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        action, r'TrainingStepResponse', 'action');
    BuiltValueNullFieldError.checkNotNull(id, r'TrainingStepResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        instruction, r'TrainingStepResponse', 'instruction');
    BuiltValueNullFieldError.checkNotNull(
        order, r'TrainingStepResponse', 'order');
    BuiltValueNullFieldError.checkNotNull(
        title, r'TrainingStepResponse', 'title');
  }

  @override
  TrainingStepResponse rebuild(
          void Function(TrainingStepResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TrainingStepResponseBuilder toBuilder() =>
      new TrainingStepResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TrainingStepResponse &&
        action == other.action &&
        id == other.id &&
        instruction == other.instruction &&
        options == other.options &&
        order == other.order &&
        targetAssetId == other.targetAssetId &&
        targetPosition == other.targetPosition &&
        timeLimitSeconds == other.timeLimitSeconds &&
        title == other.title;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, instruction.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jc(_$hash, order.hashCode);
    _$hash = $jc(_$hash, targetAssetId.hashCode);
    _$hash = $jc(_$hash, targetPosition.hashCode);
    _$hash = $jc(_$hash, timeLimitSeconds.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TrainingStepResponse')
          ..add('action', action)
          ..add('id', id)
          ..add('instruction', instruction)
          ..add('options', options)
          ..add('order', order)
          ..add('targetAssetId', targetAssetId)
          ..add('targetPosition', targetPosition)
          ..add('timeLimitSeconds', timeLimitSeconds)
          ..add('title', title))
        .toString();
  }
}

class TrainingStepResponseBuilder
    implements Builder<TrainingStepResponse, TrainingStepResponseBuilder> {
  _$TrainingStepResponse? _$v;

  String? _action;
  String? get action => _$this._action;
  set action(String? action) => _$this._action = action;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _instruction;
  String? get instruction => _$this._instruction;
  set instruction(String? instruction) => _$this._instruction = instruction;

  ListBuilder<String>? _options;
  ListBuilder<String> get options =>
      _$this._options ??= new ListBuilder<String>();
  set options(ListBuilder<String>? options) => _$this._options = options;

  int? _order;
  int? get order => _$this._order;
  set order(int? order) => _$this._order = order;

  String? _targetAssetId;
  String? get targetAssetId => _$this._targetAssetId;
  set targetAssetId(String? targetAssetId) =>
      _$this._targetAssetId = targetAssetId;

  ListBuilder<num>? _targetPosition;
  ListBuilder<num> get targetPosition =>
      _$this._targetPosition ??= new ListBuilder<num>();
  set targetPosition(ListBuilder<num>? targetPosition) =>
      _$this._targetPosition = targetPosition;

  int? _timeLimitSeconds;
  int? get timeLimitSeconds => _$this._timeLimitSeconds;
  set timeLimitSeconds(int? timeLimitSeconds) =>
      _$this._timeLimitSeconds = timeLimitSeconds;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  TrainingStepResponseBuilder() {
    TrainingStepResponse._defaults(this);
  }

  TrainingStepResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _action = $v.action;
      _id = $v.id;
      _instruction = $v.instruction;
      _options = $v.options?.toBuilder();
      _order = $v.order;
      _targetAssetId = $v.targetAssetId;
      _targetPosition = $v.targetPosition?.toBuilder();
      _timeLimitSeconds = $v.timeLimitSeconds;
      _title = $v.title;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TrainingStepResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$TrainingStepResponse;
  }

  @override
  void update(void Function(TrainingStepResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TrainingStepResponse build() => _build();

  _$TrainingStepResponse _build() {
    _$TrainingStepResponse _$result;
    try {
      _$result = _$v ??
          new _$TrainingStepResponse._(
              action: BuiltValueNullFieldError.checkNotNull(
                  action, r'TrainingStepResponse', 'action'),
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'TrainingStepResponse', 'id'),
              instruction: BuiltValueNullFieldError.checkNotNull(
                  instruction, r'TrainingStepResponse', 'instruction'),
              options: _options?.build(),
              order: BuiltValueNullFieldError.checkNotNull(
                  order, r'TrainingStepResponse', 'order'),
              targetAssetId: targetAssetId,
              targetPosition: _targetPosition?.build(),
              timeLimitSeconds: timeLimitSeconds,
              title: BuiltValueNullFieldError.checkNotNull(
                  title, r'TrainingStepResponse', 'title'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'options';
        _options?.build();

        _$failedField = 'targetPosition';
        _targetPosition?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'TrainingStepResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
