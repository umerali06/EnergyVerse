// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_corrective_action_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UpdateCorrectiveActionRequestStatusEnum
    _$updateCorrectiveActionRequestStatusEnum_inProgress =
    const UpdateCorrectiveActionRequestStatusEnum._('inProgress');
const UpdateCorrectiveActionRequestStatusEnum
    _$updateCorrectiveActionRequestStatusEnum_completed =
    const UpdateCorrectiveActionRequestStatusEnum._('completed');

UpdateCorrectiveActionRequestStatusEnum
    _$updateCorrectiveActionRequestStatusEnumValueOf(String name) {
  switch (name) {
    case 'inProgress':
      return _$updateCorrectiveActionRequestStatusEnum_inProgress;
    case 'completed':
      return _$updateCorrectiveActionRequestStatusEnum_completed;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<UpdateCorrectiveActionRequestStatusEnum>
    _$updateCorrectiveActionRequestStatusEnumValues = new BuiltSet<
        UpdateCorrectiveActionRequestStatusEnum>(const <UpdateCorrectiveActionRequestStatusEnum>[
  _$updateCorrectiveActionRequestStatusEnum_inProgress,
  _$updateCorrectiveActionRequestStatusEnum_completed,
]);

Serializer<UpdateCorrectiveActionRequestStatusEnum>
    _$updateCorrectiveActionRequestStatusEnumSerializer =
    new _$UpdateCorrectiveActionRequestStatusEnumSerializer();

class _$UpdateCorrectiveActionRequestStatusEnumSerializer
    implements PrimitiveSerializer<UpdateCorrectiveActionRequestStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'inProgress': 'in_progress',
    'completed': 'completed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'in_progress': 'inProgress',
    'completed': 'completed',
  };

  @override
  final Iterable<Type> types = const <Type>[
    UpdateCorrectiveActionRequestStatusEnum
  ];
  @override
  final String wireName = 'UpdateCorrectiveActionRequestStatusEnum';

  @override
  Object serialize(Serializers serializers,
          UpdateCorrectiveActionRequestStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UpdateCorrectiveActionRequestStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UpdateCorrectiveActionRequestStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UpdateCorrectiveActionRequest extends UpdateCorrectiveActionRequest {
  @override
  final String? completionNotes;
  @override
  final UpdateCorrectiveActionRequestStatusEnum status;

  factory _$UpdateCorrectiveActionRequest(
          [void Function(UpdateCorrectiveActionRequestBuilder)? updates]) =>
      (new UpdateCorrectiveActionRequestBuilder()..update(updates))._build();

  _$UpdateCorrectiveActionRequest._(
      {this.completionNotes, required this.status})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        status, r'UpdateCorrectiveActionRequest', 'status');
  }

  @override
  UpdateCorrectiveActionRequest rebuild(
          void Function(UpdateCorrectiveActionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateCorrectiveActionRequestBuilder toBuilder() =>
      new UpdateCorrectiveActionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateCorrectiveActionRequest &&
        completionNotes == other.completionNotes &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, completionNotes.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateCorrectiveActionRequest')
          ..add('completionNotes', completionNotes)
          ..add('status', status))
        .toString();
  }
}

class UpdateCorrectiveActionRequestBuilder
    implements
        Builder<UpdateCorrectiveActionRequest,
            UpdateCorrectiveActionRequestBuilder> {
  _$UpdateCorrectiveActionRequest? _$v;

  String? _completionNotes;
  String? get completionNotes => _$this._completionNotes;
  set completionNotes(String? completionNotes) =>
      _$this._completionNotes = completionNotes;

  UpdateCorrectiveActionRequestStatusEnum? _status;
  UpdateCorrectiveActionRequestStatusEnum? get status => _$this._status;
  set status(UpdateCorrectiveActionRequestStatusEnum? status) =>
      _$this._status = status;

  UpdateCorrectiveActionRequestBuilder() {
    UpdateCorrectiveActionRequest._defaults(this);
  }

  UpdateCorrectiveActionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _completionNotes = $v.completionNotes;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateCorrectiveActionRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateCorrectiveActionRequest;
  }

  @override
  void update(void Function(UpdateCorrectiveActionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateCorrectiveActionRequest build() => _build();

  _$UpdateCorrectiveActionRequest _build() {
    final _$result = _$v ??
        new _$UpdateCorrectiveActionRequest._(
            completionNotes: completionNotes,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'UpdateCorrectiveActionRequest', 'status'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
