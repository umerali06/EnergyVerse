// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_training_step_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CompleteTrainingStepRequest extends CompleteTrainingStepRequest {
  @override
  final bool? correct;
  @override
  final String? selectedOption;

  factory _$CompleteTrainingStepRequest(
          [void Function(CompleteTrainingStepRequestBuilder)? updates]) =>
      (new CompleteTrainingStepRequestBuilder()..update(updates))._build();

  _$CompleteTrainingStepRequest._({this.correct, this.selectedOption})
      : super._();

  @override
  CompleteTrainingStepRequest rebuild(
          void Function(CompleteTrainingStepRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompleteTrainingStepRequestBuilder toBuilder() =>
      new CompleteTrainingStepRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompleteTrainingStepRequest &&
        correct == other.correct &&
        selectedOption == other.selectedOption;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, correct.hashCode);
    _$hash = $jc(_$hash, selectedOption.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompleteTrainingStepRequest')
          ..add('correct', correct)
          ..add('selectedOption', selectedOption))
        .toString();
  }
}

class CompleteTrainingStepRequestBuilder
    implements
        Builder<CompleteTrainingStepRequest,
            CompleteTrainingStepRequestBuilder> {
  _$CompleteTrainingStepRequest? _$v;

  bool? _correct;
  bool? get correct => _$this._correct;
  set correct(bool? correct) => _$this._correct = correct;

  String? _selectedOption;
  String? get selectedOption => _$this._selectedOption;
  set selectedOption(String? selectedOption) =>
      _$this._selectedOption = selectedOption;

  CompleteTrainingStepRequestBuilder() {
    CompleteTrainingStepRequest._defaults(this);
  }

  CompleteTrainingStepRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _correct = $v.correct;
      _selectedOption = $v.selectedOption;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompleteTrainingStepRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CompleteTrainingStepRequest;
  }

  @override
  void update(void Function(CompleteTrainingStepRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompleteTrainingStepRequest build() => _build();

  _$CompleteTrainingStepRequest _build() {
    final _$result = _$v ??
        new _$CompleteTrainingStepRequest._(
            correct: correct, selectedOption: selectedOption);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
