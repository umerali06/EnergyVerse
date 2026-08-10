// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_analysis_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AiAnalysisResponseRiskLevelEnum _$aiAnalysisResponseRiskLevelEnum_low =
    const AiAnalysisResponseRiskLevelEnum._('low');
const AiAnalysisResponseRiskLevelEnum _$aiAnalysisResponseRiskLevelEnum_medium =
    const AiAnalysisResponseRiskLevelEnum._('medium');
const AiAnalysisResponseRiskLevelEnum _$aiAnalysisResponseRiskLevelEnum_high =
    const AiAnalysisResponseRiskLevelEnum._('high');
const AiAnalysisResponseRiskLevelEnum
    _$aiAnalysisResponseRiskLevelEnum_critical =
    const AiAnalysisResponseRiskLevelEnum._('critical');

AiAnalysisResponseRiskLevelEnum _$aiAnalysisResponseRiskLevelEnumValueOf(
    String name) {
  switch (name) {
    case 'low':
      return _$aiAnalysisResponseRiskLevelEnum_low;
    case 'medium':
      return _$aiAnalysisResponseRiskLevelEnum_medium;
    case 'high':
      return _$aiAnalysisResponseRiskLevelEnum_high;
    case 'critical':
      return _$aiAnalysisResponseRiskLevelEnum_critical;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<AiAnalysisResponseRiskLevelEnum>
    _$aiAnalysisResponseRiskLevelEnumValues = new BuiltSet<
        AiAnalysisResponseRiskLevelEnum>(const <AiAnalysisResponseRiskLevelEnum>[
  _$aiAnalysisResponseRiskLevelEnum_low,
  _$aiAnalysisResponseRiskLevelEnum_medium,
  _$aiAnalysisResponseRiskLevelEnum_high,
  _$aiAnalysisResponseRiskLevelEnum_critical,
]);

Serializer<AiAnalysisResponseRiskLevelEnum>
    _$aiAnalysisResponseRiskLevelEnumSerializer =
    new _$AiAnalysisResponseRiskLevelEnumSerializer();

class _$AiAnalysisResponseRiskLevelEnumSerializer
    implements PrimitiveSerializer<AiAnalysisResponseRiskLevelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'low': 'low',
    'medium': 'medium',
    'high': 'high',
    'critical': 'critical',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'low': 'low',
    'medium': 'medium',
    'high': 'high',
    'critical': 'critical',
  };

  @override
  final Iterable<Type> types = const <Type>[AiAnalysisResponseRiskLevelEnum];
  @override
  final String wireName = 'AiAnalysisResponseRiskLevelEnum';

  @override
  Object serialize(
          Serializers serializers, AiAnalysisResponseRiskLevelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AiAnalysisResponseRiskLevelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AiAnalysisResponseRiskLevelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AiAnalysisResponse extends AiAnalysisResponse {
  @override
  final BuiltList<String>? annotationIds;
  @override
  final DateTime createdAt;
  @override
  final String createdBy;
  @override
  final String id;
  @override
  final String mediaLocalId;
  @override
  final String model;
  @override
  final String? recommendations;
  @override
  final bool? reviewed;
  @override
  final DateTime? reviewedAt;
  @override
  final String? reviewedBy;
  @override
  final AiAnalysisResponseRiskLevelEnum? riskLevel;
  @override
  final String summary;

  factory _$AiAnalysisResponse(
          [void Function(AiAnalysisResponseBuilder)? updates]) =>
      (new AiAnalysisResponseBuilder()..update(updates))._build();

  _$AiAnalysisResponse._(
      {this.annotationIds,
      required this.createdAt,
      required this.createdBy,
      required this.id,
      required this.mediaLocalId,
      required this.model,
      this.recommendations,
      this.reviewed,
      this.reviewedAt,
      this.reviewedBy,
      this.riskLevel,
      required this.summary})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'AiAnalysisResponse', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        createdBy, r'AiAnalysisResponse', 'createdBy');
    BuiltValueNullFieldError.checkNotNull(id, r'AiAnalysisResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        mediaLocalId, r'AiAnalysisResponse', 'mediaLocalId');
    BuiltValueNullFieldError.checkNotNull(
        model, r'AiAnalysisResponse', 'model');
    BuiltValueNullFieldError.checkNotNull(
        summary, r'AiAnalysisResponse', 'summary');
  }

  @override
  AiAnalysisResponse rebuild(
          void Function(AiAnalysisResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AiAnalysisResponseBuilder toBuilder() =>
      new AiAnalysisResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AiAnalysisResponse &&
        annotationIds == other.annotationIds &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        id == other.id &&
        mediaLocalId == other.mediaLocalId &&
        model == other.model &&
        recommendations == other.recommendations &&
        reviewed == other.reviewed &&
        reviewedAt == other.reviewedAt &&
        reviewedBy == other.reviewedBy &&
        riskLevel == other.riskLevel &&
        summary == other.summary;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, annotationIds.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, mediaLocalId.hashCode);
    _$hash = $jc(_$hash, model.hashCode);
    _$hash = $jc(_$hash, recommendations.hashCode);
    _$hash = $jc(_$hash, reviewed.hashCode);
    _$hash = $jc(_$hash, reviewedAt.hashCode);
    _$hash = $jc(_$hash, reviewedBy.hashCode);
    _$hash = $jc(_$hash, riskLevel.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AiAnalysisResponse')
          ..add('annotationIds', annotationIds)
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('id', id)
          ..add('mediaLocalId', mediaLocalId)
          ..add('model', model)
          ..add('recommendations', recommendations)
          ..add('reviewed', reviewed)
          ..add('reviewedAt', reviewedAt)
          ..add('reviewedBy', reviewedBy)
          ..add('riskLevel', riskLevel)
          ..add('summary', summary))
        .toString();
  }
}

class AiAnalysisResponseBuilder
    implements Builder<AiAnalysisResponse, AiAnalysisResponseBuilder> {
  _$AiAnalysisResponse? _$v;

  ListBuilder<String>? _annotationIds;
  ListBuilder<String> get annotationIds =>
      _$this._annotationIds ??= new ListBuilder<String>();
  set annotationIds(ListBuilder<String>? annotationIds) =>
      _$this._annotationIds = annotationIds;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _createdBy;
  String? get createdBy => _$this._createdBy;
  set createdBy(String? createdBy) => _$this._createdBy = createdBy;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _mediaLocalId;
  String? get mediaLocalId => _$this._mediaLocalId;
  set mediaLocalId(String? mediaLocalId) => _$this._mediaLocalId = mediaLocalId;

  String? _model;
  String? get model => _$this._model;
  set model(String? model) => _$this._model = model;

  String? _recommendations;
  String? get recommendations => _$this._recommendations;
  set recommendations(String? recommendations) =>
      _$this._recommendations = recommendations;

  bool? _reviewed;
  bool? get reviewed => _$this._reviewed;
  set reviewed(bool? reviewed) => _$this._reviewed = reviewed;

  DateTime? _reviewedAt;
  DateTime? get reviewedAt => _$this._reviewedAt;
  set reviewedAt(DateTime? reviewedAt) => _$this._reviewedAt = reviewedAt;

  String? _reviewedBy;
  String? get reviewedBy => _$this._reviewedBy;
  set reviewedBy(String? reviewedBy) => _$this._reviewedBy = reviewedBy;

  AiAnalysisResponseRiskLevelEnum? _riskLevel;
  AiAnalysisResponseRiskLevelEnum? get riskLevel => _$this._riskLevel;
  set riskLevel(AiAnalysisResponseRiskLevelEnum? riskLevel) =>
      _$this._riskLevel = riskLevel;

  String? _summary;
  String? get summary => _$this._summary;
  set summary(String? summary) => _$this._summary = summary;

  AiAnalysisResponseBuilder() {
    AiAnalysisResponse._defaults(this);
  }

  AiAnalysisResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _annotationIds = $v.annotationIds?.toBuilder();
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy;
      _id = $v.id;
      _mediaLocalId = $v.mediaLocalId;
      _model = $v.model;
      _recommendations = $v.recommendations;
      _reviewed = $v.reviewed;
      _reviewedAt = $v.reviewedAt;
      _reviewedBy = $v.reviewedBy;
      _riskLevel = $v.riskLevel;
      _summary = $v.summary;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AiAnalysisResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AiAnalysisResponse;
  }

  @override
  void update(void Function(AiAnalysisResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AiAnalysisResponse build() => _build();

  _$AiAnalysisResponse _build() {
    _$AiAnalysisResponse _$result;
    try {
      _$result = _$v ??
          new _$AiAnalysisResponse._(
              annotationIds: _annotationIds?.build(),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'AiAnalysisResponse', 'createdAt'),
              createdBy: BuiltValueNullFieldError.checkNotNull(
                  createdBy, r'AiAnalysisResponse', 'createdBy'),
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'AiAnalysisResponse', 'id'),
              mediaLocalId: BuiltValueNullFieldError.checkNotNull(
                  mediaLocalId, r'AiAnalysisResponse', 'mediaLocalId'),
              model: BuiltValueNullFieldError.checkNotNull(
                  model, r'AiAnalysisResponse', 'model'),
              recommendations: recommendations,
              reviewed: reviewed,
              reviewedAt: reviewedAt,
              reviewedBy: reviewedBy,
              riskLevel: riskLevel,
              summary: BuiltValueNullFieldError.checkNotNull(
                  summary, r'AiAnalysisResponse', 'summary'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'annotationIds';
        _annotationIds?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AiAnalysisResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
