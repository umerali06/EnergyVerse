import 'package:fev_api_client/fev_api_client.dart';

import 'assets_fixtures.dart';

QrScanResult qrScanResultFixture({
  AssetDetail? asset,
  int inspectionsTotal = 0,
  int maintenanceTotal = 0,
  int workOrdersTotal = 0,
}) {
  return QrScanResult(
    (builder) => builder
      ..asset.replace(asset ?? assetDetailFixture())
      ..inspectionsTotal = inspectionsTotal
      ..maintenanceTotal = maintenanceTotal
      ..workOrdersTotal = workOrdersTotal,
  );
}
