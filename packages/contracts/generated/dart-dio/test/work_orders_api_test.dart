import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for WorkOrdersApi
void main() {
  final instance = FevApiClient().getWorkOrdersApi();

  group(WorkOrdersApi, () {
    // Accept Work Order
    //
    // Only the assigned technician can accept -- a 403 `not_assigned_technician` otherwise, even for a caller who holds `work_orders.write` for other reasons (D-066).
    //
    //Future<WorkOrderDetail> acceptWorkOrder(String workOrderId) async
    test('test acceptWorkOrder', () async {
      // TODO
    });

    // Assign Work Order
    //
    // Reachable from `open` (first assignment) or `assigned` (reassign to a different technician) -- never from `in_progress` onward, since the original technician has already started real repair work by then.
    //
    //Future<WorkOrderDetail> assignWorkOrder(String workOrderId, AssignWorkOrderRequest assignWorkOrderRequest) async
    test('test assignWorkOrder', () async {
      // TODO
    });

    // Cancel Work Order
    //
    //Future<WorkOrderDetail> cancelWorkOrder(String workOrderId) async
    test('test cancelWorkOrder', () async {
      // TODO
    });

    // Close Work Order
    //
    // Gated by `work_orders.close`, deliberately distinct from `work_orders.write` (D-066) -- the assigned technician (who only holds `.write`) cannot reach this route at all, enforcing the spec's \"Supervisor Review\" step rather than leaving it advisory.
    //
    //Future<WorkOrderDetail> closeWorkOrder(String workOrderId) async
    test('test closeWorkOrder', () async {
      // TODO
    });

    // Create Work Order
    //
    //Future<WorkOrderDetail> createWorkOrder(CreateWorkOrderRequest createWorkOrderRequest) async
    test('test createWorkOrder', () async {
      // TODO
    });

    // Delete Work Order
    //
    //Future<WorkOrderDeleted> deleteWorkOrder(String workOrderId) async
    test('test deleteWorkOrder', () async {
      // TODO
    });

    // Get Work Order
    //
    //Future<WorkOrderDetail> getWorkOrder(String workOrderId) async
    test('test getWorkOrder', () async {
      // TODO
    });

    // List Work Orders
    //
    //Future<WorkOrderListPage> listWorkOrders({ String assetId, String facilityId, String status, String technicianId, String cursor, int limit }) async
    test('test listWorkOrders', () async {
      // TODO
    });

    // Submit Work Order For Review
    //
    // Only the assigned technician can submit -- same 403 posture as `accept_work_order` (D-066).
    //
    //Future<WorkOrderDetail> submitWorkOrderForReview(String workOrderId, SubmitWorkOrderForReviewRequest submitWorkOrderForReviewRequest) async
    test('test submitWorkOrderForReview', () async {
      // TODO
    });
  });
}
