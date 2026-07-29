# fev_api_client.api.AssetsApi

## Load the API package
```dart
import 'package:fev_api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createAsset**](AssetsApi.md#createasset) | **POST** /api/v1/assets | Create Asset
[**deleteAsset**](AssetsApi.md#deleteasset) | **DELETE** /api/v1/assets/{asset_id} | Delete Asset
[**deleteAssetMedia**](AssetsApi.md#deleteassetmedia) | **DELETE** /api/v1/assets/{asset_id}/media/{media_id} | Delete Asset Media
[**getAsset**](AssetsApi.md#getasset) | **GET** /api/v1/assets/{asset_id} | Get Asset
[**getAssetHistory**](AssetsApi.md#getassethistory) | **GET** /api/v1/assets/{asset_id}/history | Get Asset History
[**getAssetQrLabel**](AssetsApi.md#getassetqrlabel) | **GET** /api/v1/assets/{asset_id}/qr | Get Asset Qr Label
[**listAssets**](AssetsApi.md#listassets) | **GET** /api/v1/assets | List Assets
[**updateAsset**](AssetsApi.md#updateasset) | **PATCH** /api/v1/assets/{asset_id} | Update Asset
[**uploadAssetMedia**](AssetsApi.md#uploadassetmedia) | **POST** /api/v1/assets/{asset_id}/media | Upload Asset Media


# **createAsset**
> AssetDetail createAsset(createAssetRequest)

Create Asset

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAssetsApi();
final CreateAssetRequest createAssetRequest = ; // CreateAssetRequest |

try {
    final response = api.createAsset(createAssetRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AssetsApi->createAsset: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createAssetRequest** | [**CreateAssetRequest**](CreateAssetRequest.md)|  |

### Return type

[**AssetDetail**](AssetDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteAsset**
> AssetDeleted deleteAsset(assetId)

Delete Asset

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAssetsApi();
final String assetId = assetId_example; // String |

try {
    final response = api.deleteAsset(assetId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AssetsApi->deleteAsset: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assetId** | **String**|  |

### Return type

[**AssetDeleted**](AssetDeleted.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteAssetMedia**
> AssetDetail deleteAssetMedia(assetId, mediaId)

Delete Asset Media

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAssetsApi();
final String assetId = assetId_example; // String |
final String mediaId = mediaId_example; // String |

try {
    final response = api.deleteAssetMedia(assetId, mediaId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AssetsApi->deleteAssetMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assetId** | **String**|  |
 **mediaId** | **String**|  |

### Return type

[**AssetDetail**](AssetDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAsset**
> AssetDetail getAsset(assetId)

Get Asset

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAssetsApi();
final String assetId = assetId_example; // String |

try {
    final response = api.getAsset(assetId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AssetsApi->getAsset: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assetId** | **String**|  |

### Return type

[**AssetDetail**](AssetDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAssetHistory**
> AssetHistoryPage getAssetHistory(assetId, cursor, limit)

Get Asset History

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAssetsApi();
final String assetId = assetId_example; // String |
final String cursor = cursor_example; // String |
final int limit = 56; // int |

try {
    final response = api.getAssetHistory(assetId, cursor, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AssetsApi->getAssetHistory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assetId** | **String**|  |
 **cursor** | **String**|  | [optional]
 **limit** | **int**|  | [optional] [default to 25]

### Return type

[**AssetHistoryPage**](AssetHistoryPage.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAssetQrLabel**
> AssetQrLabel getAssetQrLabel(assetId)

Get Asset Qr Label

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAssetsApi();
final String assetId = assetId_example; // String |

try {
    final response = api.getAssetQrLabel(assetId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AssetsApi->getAssetQrLabel: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assetId** | **String**|  |

### Return type

[**AssetQrLabel**](AssetQrLabel.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAssets**
> AssetListPage listAssets(facilityId, areaId, category, currentStatus, parentAssetId, search, sort, cursor, limit)

List Assets

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAssetsApi();
final String facilityId = facilityId_example; // String |
final String areaId = areaId_example; // String |
final String category = category_example; // String |
final String currentStatus = currentStatus_example; // String |
final String parentAssetId = parentAssetId_example; // String |
final String search = search_example; // String |
final String sort = sort_example; // String |
final String cursor = cursor_example; // String |
final int limit = 56; // int |

try {
    final response = api.listAssets(facilityId, areaId, category, currentStatus, parentAssetId, search, sort, cursor, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AssetsApi->listAssets: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **facilityId** | **String**|  | [optional]
 **areaId** | **String**|  | [optional]
 **category** | **String**|  | [optional]
 **currentStatus** | **String**|  | [optional]
 **parentAssetId** | **String**|  | [optional]
 **search** | **String**|  | [optional]
 **sort** | **String**|  | [optional] [default to '-created_at']
 **cursor** | **String**|  | [optional]
 **limit** | **int**|  | [optional] [default to 25]

### Return type

[**AssetListPage**](AssetListPage.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateAsset**
> AssetDetail updateAsset(assetId, updateAssetRequest)

Update Asset

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAssetsApi();
final String assetId = assetId_example; // String |
final UpdateAssetRequest updateAssetRequest = ; // UpdateAssetRequest |

try {
    final response = api.updateAsset(assetId, updateAssetRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AssetsApi->updateAsset: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assetId** | **String**|  |
 **updateAssetRequest** | [**UpdateAssetRequest**](UpdateAssetRequest.md)|  |

### Return type

[**AssetDetail**](AssetDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadAssetMedia**
> AssetDetail uploadAssetMedia(assetId, kind, file)

Upload Asset Media

### Example
```dart
import 'package:fev_api_client/api.dart';

final api = FevApiClient().getAssetsApi();
final String assetId = assetId_example; // String |
final String kind = kind_example; // String |
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile |

try {
    final response = api.uploadAssetMedia(assetId, kind, file);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AssetsApi->uploadAssetMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **assetId** | **String**|  |
 **kind** | **String**|  |
 **file** | **MultipartFile**|  |

### Return type

[**AssetDetail**](AssetDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
