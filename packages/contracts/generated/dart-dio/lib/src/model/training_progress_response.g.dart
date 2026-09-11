// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_progress_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TrainingProgressResponse extends TrainingProgressResponse {
  @override
  final int? attempts;
  @override
  final DateTime? completedAt;
  @override
  final BuiltList<String>? completedStepIds;
  @override
  final int? correctCount;
  @override
  final String id;
  @override
  final String moduleId;
  @override
  final int? score;
  @override
  final int? scoredCount;
  @override
  final DateTime startedAt;
  @override
  final String status;

  factory _$TrainingProgressResponse(
          [void Function(TrainingProgressResponseBuilder)? updates]) =>
      (new TrainingProgressResponseBuilder()..update(updates))._build();

  _$TrainingProgressResponse._(
      {this.attempts,
      this.completedAt,
      this.completedStepIds,
      this.correctCount,
      required this.id,
      required this.moduleId,
      this.score,
      this.scoredCount,
      required this.startedAt,
      required this.status})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        id, r'TrainingProgressResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        moduleId, r'TrainingProgressResponse', 'moduleId');
    BuiltValueNullFieldError.checkNotNull(
        startedAt, r'TrainingProgressResponse', 'startedAt');
    BuiltValueNullFieldError.checkNotNull(
        status, r'TrainingProgressResponse', 'status');
  }

  @override
  TrainingProgressResponse rebuild(
          void Function(TrainingProgressResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TrainingProgressResponseBuilder toBuilder() =>
      new TrainingProgressResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TrainingProgressResponse &&
        attempts == other.attempts &&
        completedAt == other.completedAt &&
        completedStepIds == other.completedStepIds &&
        correctCount == other.correctCount &&
        id == other.id &&
        moduleId == other.moduleId &&
        score == other.score &&
        scoredCount == other.scoredCount &&
        startedAt == other.startedAt &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attempts.hashCode);
    _$hash = $jc(_$hash, completedAt.hashCode);
    _$hash = $jc(_$hash, completedStepIds.hashCode);
    _$hash = $jc(_$hash, correctCount.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, moduleId.hashCode);
    _$hash = $jc(_$hash, score.hashCode);
    _$hash = $jc(_$hash, scoredCount.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TrainingProgressResponse')
          ..add('attempts', attempts)
          ..add('completedAt', completedAt)
          ..add('completedStepIds', completedStepIds)
          ..add('correctCount', correctCount)
          ..add('id', id)
          ..add('moduleId', moduleId)
          ..add('score', score)
          ..add('scoredCount', scoredCount)
          ..add('startedAt', startedAt)
          ..add('status', status))
        .toString();
  }
}

class TrainingProgressResponseBuilder
    implements
        Builder<TrainingProgressResponse, TrainingProgressResponseBuilder> {
  _$TrainingProgressResponse? _$v;

  int? _attempts;
  int? get attempts => _$this._attempts;
  set attempts(int? attempts) => _$this._attempts = attempts;

  DateTime? _completedAt;
  DateTime? get completedAt => _$this._completedAt;
  set completedAt(DateTime? completedAt) => _$this._completedAt = completedAt;

  ListBuilder<String>? _completedStepIds;
  ListBuilder<String> get completedStepIds =>
      _$this._completedStepIds ??= new ListBuilder<String>();
  set completedStepIds(ListBuilder<String>? completedStepIds) =>
      _$this._completedStepIds = completedStepIds;

  int? _correctCount;
  int? get correctCount => _$this._correctCount;
  set correctCount(int? correctCount) => _$this._correctCount = correctCount;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _moduleId;
  String? get moduleId => _$this._moduleId;
  set moduleId(String? moduleId) => _$this._moduleId = moduleId;

  int? _score;
  int? get score => _$this._score;
  set score(int? score) => _$this._score = score;

  int? _scoredCount;
  int? get scoredCount => _$this._scoredCount;
  set scoredCount(int? scoredCount) => _$this._scoredCount = scoredCount;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  TrainingProgressResponseBuilder() {
    TrainingProgressResponse._defaults(this);
  }

  TrainingProgressResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attempts = $v.attempts;
      _completedAt = $v.completedAt;
      _completedStepIds = $v.completedStepIds?.toBuilder();
      _correctCount = $v.correctCount;
      _id = $v.id;
      _moduleId = $v.moduleId;
      _score = $v.score;
      _scoredCount = $v.scoredCount;
      _startedAt = $v.startedAt;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TrainingProgressResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$TrainingProgressResponse;
  }

  @override
  void update(void Function(TrainingProgressResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TrainingProgressResponse build() => _build();

  _$TrainingProgressResponse _build() {
    _$TrainingProgressResponse _$result;
    try {
      _$result = _$v ??
          new _$TrainingProgressResponse._(
              attempts: attempts,
              completedAt: completedAt,
              completedStepIds: _completedStepIds?.build(),
              correctCount: correctCount,
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'TrainingProgressResponse', 'id'),
              moduleId: BuiltValueNullFieldError.checkNotNull(
                  moduleId, r'TrainingProgressResponse', 'moduleId'),
              score: score,
              scoredCount: scoredCount,
              startedAt: BuiltValueNullFieldError.checkNotNull(
                  startedAt, r'TrainingProgressResponse', 'startedAt'),
              status: BuiltValueNullFieldError.checkNotNull(
                  status, r'TrainingProgressResponse', 'status'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'completedStepIds';
        _completedStepIds?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'TrainingProgressResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
