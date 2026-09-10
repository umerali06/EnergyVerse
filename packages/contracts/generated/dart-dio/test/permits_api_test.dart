import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for PermitsApi
void main() {
  final instance = FevApiClient().getPermitsApi();

  group(PermitsApi, () {
    // Acknowledge Permit
    //
    //Future<PermitDetail> acknowledgePermit(String permitId, AcknowledgePermitRequest acknowledgePermitRequest) async
    test('test acknowledgePermit', () async {
      // TODO
    });

    // Activate Permit
    //
    //Future<PermitDetail> activatePermit(String permitId, ActivatePermitRequest activatePermitRequest) async
    test('test activatePermit', () async {
      // TODO
    });

    // Close Permit
    //
    //Future<PermitDetail> closePermit(String permitId, ClosePermitRequest closePermitRequest) async
    test('test closePermit', () async {
      // TODO
    });

    // Create Permit
    //
    //Future<PermitDetail> createPermit(CreatePermitRequest createPermitRequest) async
    test('test createPermit', () async {
      // TODO
    });

    // Decide Permit Approval
    //
    //Future<PermitDetail> decidePermitApproval(String permitId, DecidePermitApprovalRequest decidePermitApprovalRequest) async
    test('test decidePermitApproval', () async {
      // TODO
    });

    // Delete Permit
    //
    //Future<PermitDeleted> deletePermit(String permitId) async
    test('test deletePermit', () async {
      // TODO
    });

    // Get Permit
    //
    //Future<PermitDetail> getPermit(String permitId) async
    test('test getPermit', () async {
      // TODO
    });

    // List Permits
    //
    //Future<PermitListPage> listPermits({ String permitType, String facilityId, String workerId, String cursor, int limit }) async
    test('test listPermits', () async {
      // TODO
    });

    // Resume Permit
    //
    //Future<PermitDetail> resumePermit(String permitId, ResumePermitRequest resumePermitRequest) async
    test('test resumePermit', () async {
      // TODO
    });

    // Revoke Permit
    //
    //Future<PermitDetail> revokePermit(String permitId, ControlPermitRequest controlPermitRequest) async
    test('test revokePermit', () async {
      // TODO
    });

    // Submit Permit
    //
    //Future<PermitDetail> submitPermit(String permitId, SubmitPermitRequest submitPermitRequest) async
    test('test submitPermit', () async {
      // TODO
    });

    // Suspend Permit
    //
    //Future<PermitDetail> suspendPermit(String permitId, ControlPermitRequest controlPermitRequest) async
    test('test suspendPermit', () async {
      // TODO
    });

    // Update Permit
    //
    //Future<PermitDetail> updatePermit(String permitId, UpdatePermitRequest updatePermitRequest) async
    test('test updatePermit', () async {
      // TODO
    });
  });
}
