// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContactRequest extends ContactRequest {
  @override
  final String category;
  @override
  final String? company;
  @override
  final String email;
  @override
  final String message;
  @override
  final String name;
  @override
  final String subject;

  factory _$ContactRequest([void Function(ContactRequestBuilder)? updates]) =>
      (new ContactRequestBuilder()..update(updates))._build();

  _$ContactRequest._(
      {required this.category,
      this.company,
      required this.email,
      required this.message,
      required this.name,
      required this.subject})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        category, r'ContactRequest', 'category');
    BuiltValueNullFieldError.checkNotNull(email, r'ContactRequest', 'email');
    BuiltValueNullFieldError.checkNotNull(
        message, r'ContactRequest', 'message');
    BuiltValueNullFieldError.checkNotNull(name, r'ContactRequest', 'name');
    BuiltValueNullFieldError.checkNotNull(
        subject, r'ContactRequest', 'subject');
  }

  @override
  ContactRequest rebuild(void Function(ContactRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContactRequestBuilder toBuilder() =>
      new ContactRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContactRequest &&
        category == other.category &&
        company == other.company &&
        email == other.email &&
        message == other.message &&
        name == other.name &&
        subject == other.subject;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, company.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, subject.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContactRequest')
          ..add('category', category)
          ..add('company', company)
          ..add('email', email)
          ..add('message', message)
          ..add('name', name)
          ..add('subject', subject))
        .toString();
  }
}

class ContactRequestBuilder
    implements Builder<ContactRequest, ContactRequestBuilder> {
  _$ContactRequest? _$v;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _company;
  String? get company => _$this._company;
  set company(String? company) => _$this._company = company;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _subject;
  String? get subject => _$this._subject;
  set subject(String? subject) => _$this._subject = subject;

  ContactRequestBuilder() {
    ContactRequest._defaults(this);
  }

  ContactRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _company = $v.company;
      _email = $v.email;
      _message = $v.message;
      _name = $v.name;
      _subject = $v.subject;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContactRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ContactRequest;
  }

  @override
  void update(void Function(ContactRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContactRequest build() => _build();

  _$ContactRequest _build() {
    final _$result = _$v ??
        new _$ContactRequest._(
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'ContactRequest', 'category'),
            company: company,
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'ContactRequest', 'email'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'ContactRequest', 'message'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'ContactRequest', 'name'),
            subject: BuiltValueNullFieldError.checkNotNull(
                subject, r'ContactRequest', 'subject'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
