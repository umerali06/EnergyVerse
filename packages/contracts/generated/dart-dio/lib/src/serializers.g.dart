// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (new Serializers().toBuilder()
      ..add(CompanyRegistrationRequest.serializer)
      ..add(CompanyRegistrationResponse.serializer)
      ..add(CurrentUser.serializer)
      ..add(DemoGateResponse.serializer)
      ..add(DemoGateResponseOkEnum.serializer)
      ..add(ErrorEnvelope.serializer)
      ..add(HealthResponse.serializer)
      ..add(HealthResponseFirestoreEnum.serializer)
      ..add(HealthResponseServiceEnum.serializer)
      ..add(HealthResponseStatusEnum.serializer)
      ..add(ServiceResponse.serializer)
      ..add(ServiceResponseServiceEnum.serializer)
      ..add(ServiceResponseStatusEnum.serializer)
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => new MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltSet, const [const FullType(String)]),
          () => new SetBuilder<String>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
