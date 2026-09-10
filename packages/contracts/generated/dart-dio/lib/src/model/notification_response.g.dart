// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationResponse extends NotificationResponse {
  @override
  final String body;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<String>? deliveredChannels;
  @override
  final String event;
  @override
  final String id;
  @override
  final BuiltMap<String, String>? metadata;
  @override
  final DateTime? readAt;
  @override
  final String targetId;
  @override
  final String targetType;
  @override
  final String title;

  factory _$NotificationResponse(
          [void Function(NotificationResponseBuilder)? updates]) =>
      (new NotificationResponseBuilder()..update(updates))._build();

  _$NotificationResponse._(
      {required this.body,
      required this.createdAt,
      this.deliveredChannels,
      required this.event,
      required this.id,
      this.metadata,
      this.readAt,
      required this.targetId,
      required this.targetType,
      required this.title})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        body, r'NotificationResponse', 'body');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'NotificationResponse', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        event, r'NotificationResponse', 'event');
    BuiltValueNullFieldError.checkNotNull(id, r'NotificationResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        targetId, r'NotificationResponse', 'targetId');
    BuiltValueNullFieldError.checkNotNull(
        targetType, r'NotificationResponse', 'targetType');
    BuiltValueNullFieldError.checkNotNull(
        title, r'NotificationResponse', 'title');
  }

  @override
  NotificationResponse rebuild(
          void Function(NotificationResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationResponseBuilder toBuilder() =>
      new NotificationResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationResponse &&
        body == other.body &&
        createdAt == other.createdAt &&
        deliveredChannels == other.deliveredChannels &&
        event == other.event &&
        id == other.id &&
        metadata == other.metadata &&
        readAt == other.readAt &&
        targetId == other.targetId &&
        targetType == other.targetType &&
        title == other.title;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, deliveredChannels.hashCode);
    _$hash = $jc(_$hash, event.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, metadata.hashCode);
    _$hash = $jc(_$hash, readAt.hashCode);
    _$hash = $jc(_$hash, targetId.hashCode);
    _$hash = $jc(_$hash, targetType.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationResponse')
          ..add('body', body)
          ..add('createdAt', createdAt)
          ..add('deliveredChannels', deliveredChannels)
          ..add('event', event)
          ..add('id', id)
          ..add('metadata', metadata)
          ..add('readAt', readAt)
          ..add('targetId', targetId)
          ..add('targetType', targetType)
          ..add('title', title))
        .toString();
  }
}

class NotificationResponseBuilder
    implements Builder<NotificationResponse, NotificationResponseBuilder> {
  _$NotificationResponse? _$v;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<String>? _deliveredChannels;
  ListBuilder<String> get deliveredChannels =>
      _$this._deliveredChannels ??= new ListBuilder<String>();
  set deliveredChannels(ListBuilder<String>? deliveredChannels) =>
      _$this._deliveredChannels = deliveredChannels;

  String? _event;
  String? get event => _$this._event;
  set event(String? event) => _$this._event = event;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  MapBuilder<String, String>? _metadata;
  MapBuilder<String, String> get metadata =>
      _$this._metadata ??= new MapBuilder<String, String>();
  set metadata(MapBuilder<String, String>? metadata) =>
      _$this._metadata = metadata;

  DateTime? _readAt;
  DateTime? get readAt => _$this._readAt;
  set readAt(DateTime? readAt) => _$this._readAt = readAt;

  String? _targetId;
  String? get targetId => _$this._targetId;
  set targetId(String? targetId) => _$this._targetId = targetId;

  String? _targetType;
  String? get targetType => _$this._targetType;
  set targetType(String? targetType) => _$this._targetType = targetType;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  NotificationResponseBuilder() {
    NotificationResponse._defaults(this);
  }

  NotificationResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _body = $v.body;
      _createdAt = $v.createdAt;
      _deliveredChannels = $v.deliveredChannels?.toBuilder();
      _event = $v.event;
      _id = $v.id;
      _metadata = $v.metadata?.toBuilder();
      _readAt = $v.readAt;
      _targetId = $v.targetId;
      _targetType = $v.targetType;
      _title = $v.title;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NotificationResponse;
  }

  @override
  void update(void Function(NotificationResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationResponse build() => _build();

  _$NotificationResponse _build() {
    _$NotificationResponse _$result;
    try {
      _$result = _$v ??
          new _$NotificationResponse._(
              body: BuiltValueNullFieldError.checkNotNull(
                  body, r'NotificationResponse', 'body'),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, r'NotificationResponse', 'createdAt'),
              deliveredChannels: _deliveredChannels?.build(),
              event: BuiltValueNullFieldError.checkNotNull(
                  event, r'NotificationResponse', 'event'),
              id: BuiltValueNullFieldError.checkNotNull(
                  id, r'NotificationResponse', 'id'),
              metadata: _metadata?.build(),
              readAt: readAt,
              targetId: BuiltValueNullFieldError.checkNotNull(
                  targetId, r'NotificationResponse', 'targetId'),
              targetType: BuiltValueNullFieldError.checkNotNull(
                  targetType, r'NotificationResponse', 'targetType'),
              title: BuiltValueNullFieldError.checkNotNull(
                  title, r'NotificationResponse', 'title'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'deliveredChannels';
        _deliveredChannels?.build();

        _$failedField = 'metadata';
        _metadata?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'NotificationResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
