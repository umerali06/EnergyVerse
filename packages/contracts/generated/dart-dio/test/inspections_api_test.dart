import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for InspectionsApi
void main() {
  final instance = FevApiClient().getInspectionsApi();

  group(InspectionsApi, () {
    // Assign Checklist Template
    //
    //Future<InspectionDetail> assignInspectionChecklistTemplate(String inspectionId, AssignChecklistTemplateRequest assignChecklistTemplateRequest) async
    test('test assignInspectionChecklistTemplate', () async {
      // TODO
    });

    // Attach Inspection Media
    //
    // Registers a reference to media the mobile client already uploaded directly to Firebase Storage (Phase 7.4) -- no bytes pass through here.
    //
    //Future<InspectionDetail> attachInspectionMedia(String inspectionId, AttachInspectionMediaRequest attachInspectionMediaRequest) async
    test('test attachInspectionMedia', () async {
      // TODO
    });

    // Cancel Inspection
    //
    //Future<InspectionDetail> cancelInspection(String inspectionId) async
    test('test cancelInspection', () async {
      // TODO
    });

    // Complete Inspection
    //
    //Future<InspectionDetail> completeInspection(String inspectionId) async
    test('test completeInspection', () async {
      // TODO
    });

    // Create Inspection
    //
    // Idempotent upsert keyed by the client-generated `id` (sync contract, D-0xx): a byte-identical resubmit returns the same resource -- hence a fixed 200, never 201, since this route can't statically know whether a given call created or replayed a record.
    //
    //Future<InspectionDetail> createInspection(CreateInspectionRequest createInspectionRequest) async
    test('test createInspection', () async {
      // TODO
    });

    // Delete Inspection
    //
    //Future<InspectionDeleted> deleteInspection(String inspectionId) async
    test('test deleteInspection', () async {
      // TODO
    });

    // Detach Inspection Media
    //
    // Idempotent on an already-detached `media_id` -- the mobile outbox replays this call at-least-once.
    //
    //Future<InspectionDetail> detachInspectionMedia(String inspectionId, String mediaId) async
    test('test detachInspectionMedia', () async {
      // TODO
    });

    // Get Inspection
    //
    //Future<InspectionDetail> getInspection(String inspectionId) async
    test('test getInspection', () async {
      // TODO
    });

    // List Inspections
    //
    //Future<InspectionListPage> listInspections({ String assetId, String facilityId, String status, String inspectorId, DateTime fromDate, DateTime toDate, String cursor, int limit }) async
    test('test listInspections', () async {
      // TODO
    });

    // Start Inspection
    //
    //Future<InspectionDetail> startInspection(String inspectionId) async
    test('test startInspection', () async {
      // TODO
    });

    // Update Inspection
    //
    //Future<InspectionDetail> updateInspection(String inspectionId, UpdateInspectionRequest updateInspectionRequest) async
    test('test updateInspection', () async {
      // TODO
    });

    // Update Inspection Media
    //
    //Future<InspectionDetail> updateInspectionMedia(String inspectionId, String mediaId, UpdateInspectionMediaRequest updateInspectionMediaRequest) async
    test('test updateInspectionMedia', () async {
      // TODO
    });
  });
}
