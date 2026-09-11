import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for PermitTemplatesApi
void main() {
  final instance = FevApiClient().getPermitTemplatesApi();

  group(PermitTemplatesApi, () {
    // Create Permit Template
    //
    //Future<PermitTemplateDetail> createPermitTemplate(CreatePermitTemplateRequest createPermitTemplateRequest) async
    test('test createPermitTemplate', () async {
      // TODO
    });

    // Delete Permit Template
    //
    //Future<PermitTemplateDeleted> deletePermitTemplate(String templateId) async
    test('test deletePermitTemplate', () async {
      // TODO
    });

    // Get Permit Template
    //
    //Future<PermitTemplateDetail> getPermitTemplate(String templateId) async
    test('test getPermitTemplate', () async {
      // TODO
    });

    // List Permit Templates
    //
    //Future<PermitTemplateListPage> listPermitTemplates({ String permitType, String cursor, int limit }) async
    test('test listPermitTemplates', () async {
      // TODO
    });

    // Update Permit Template
    //
    //Future<PermitTemplateDetail> updatePermitTemplate(String templateId, UpdatePermitTemplateRequest updatePermitTemplateRequest) async
    test('test updatePermitTemplate', () async {
      // TODO
    });
  });
}
