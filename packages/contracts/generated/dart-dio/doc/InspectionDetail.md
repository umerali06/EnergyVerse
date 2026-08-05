# fev_api_client.model.InspectionDetail

## Load the model package
```dart
import 'package:fev_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**aiAnalysis** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | [optional]
**annotations** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  | [optional]
**arMeasurements** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  | [optional]
**areaId** | **String** |  | [optional]
**assetId** | **String** |  |
**checklistItemsSnapshot** | [**BuiltList&lt;ChecklistTemplateItem&gt;**](ChecklistTemplateItem.md) |  | [optional]
**checklistResponses** | [**BuiltList&lt;ChecklistResponse&gt;**](ChecklistResponse.md) |  | [optional]
**checklistTemplateId** | **String** |  | [optional]
**checklistTemplateVersion** | **int** |  | [optional]
**clientCreatedAt** | [**DateTime**](DateTime.md) |  |
**completedAt** | [**DateTime**](DateTime.md) |  | [optional]
**createdAt** | [**DateTime**](DateTime.md) |  |
**deviceId** | **String** |  | [optional]
**facilityId** | **String** |  |
**gpsLat** | **num** |  | [optional]
**gpsLng** | **num** |  | [optional]
**id** | **String** |  |
**inspectionType** | **String** |  |
**inspectorId** | **String** |  |
**media** | [**BuiltList&lt;InspectionMediaResponse&gt;**](InspectionMediaResponse.md) |  | [optional]
**notes** | **String** |  | [optional]
**origin** | **String** |  | [optional]
**readings** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | [optional]
**revision** | **int** |  |
**signature** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | [optional]
**startedAt** | [**DateTime**](DateTime.md) |  | [optional]
**status** | **String** |  |
**title** | **String** |  | [optional]
**updatedAt** | [**DateTime**](DateTime.md) |  |
**voiceNotes** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
