# fev_api_client.model.PermitDetail

## Load the model package
```dart
import 'package:fev_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**activatedAt** | [**DateTime**](DateTime.md) |  | [optional]
**activatedBy** | **String** |  | [optional]
**approvalSnapshot** | [**BuiltList&lt;PermitApprovalSnapshotResponse&gt;**](PermitApprovalSnapshotResponse.md) |  |
**areaId** | **String** |  | [optional]
**assetId** | **String** |  | [optional]
**checklistSnapshot** | [**BuiltList&lt;PermitChecklistSnapshotResponse&gt;**](PermitChecklistSnapshotResponse.md) |  |
**closedAt** | [**DateTime**](DateTime.md) |  | [optional]
**closedBy** | **String** |  | [optional]
**closeoutNotes** | **String** |  | [optional]
**createdAt** | [**DateTime**](DateTime.md) |  |
**description** | **String** |  |
**expiredAt** | [**DateTime**](DateTime.md) |  | [optional]
**facilityId** | **String** |  |
**highestResidualRisk** | **String** |  |
**id** | **String** |  |
**issuerSignature** | [**PermitDigitalSignatureResponse**](PermitDigitalSignatureResponse.md) |  | [optional]
**permitNumber** | **String** |  |
**permitType** | **String** |  |
**revision** | **int** |  |
**revocationReason** | **String** |  | [optional]
**revokedAt** | [**DateTime**](DateTime.md) |  | [optional]
**revokedBy** | **String** |  | [optional]
**riskAssessment** | [**BuiltList&lt;PermitRiskAssessmentResponse&gt;**](PermitRiskAssessmentResponse.md) |  |
**status** | **String** |  |
**submittedAt** | [**DateTime**](DateTime.md) |  | [optional]
**suspendedAt** | [**DateTime**](DateTime.md) |  | [optional]
**suspendedBy** | **String** |  | [optional]
**suspensionReason** | **String** |  | [optional]
**templateId** | **String** |  |
**templateName** | **String** |  |
**templateVersion** | **int** |  |
**title** | **String** |  |
**updatedAt** | [**DateTime**](DateTime.md) |  |
**validFrom** | [**DateTime**](DateTime.md) |  |
**validUntil** | [**DateTime**](DateTime.md) |  |
**workerAcknowledgements** | [**BuiltList&lt;PermitWorkerAcknowledgementResponse&gt;**](PermitWorkerAcknowledgementResponse.md) |  |
**workerCount** | **int** |  |
**workerIds** | **BuiltList&lt;String&gt;** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
