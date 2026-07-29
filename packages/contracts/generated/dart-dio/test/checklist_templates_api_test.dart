import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for ChecklistTemplatesApi
void main() {
  final instance = FevApiClient().getChecklistTemplatesApi();

  group(ChecklistTemplatesApi, () {
    // Create Checklist Template
    //
    //Future<ChecklistTemplateDetail> createChecklistTemplate(CreateChecklistTemplateRequest createChecklistTemplateRequest) async
    test('test createChecklistTemplate', () async {
      // TODO
    });

    // Delete Checklist Template
    //
    //Future<ChecklistTemplateDeleted> deleteChecklistTemplate(String templateId) async
    test('test deleteChecklistTemplate', () async {
      // TODO
    });

    // Get Checklist Template
    //
    //Future<ChecklistTemplateDetail> getChecklistTemplate(String templateId) async
    test('test getChecklistTemplate', () async {
      // TODO
    });

    // List Checklist Templates
    //
    //Future<ChecklistTemplateListPage> listChecklistTemplates({ String category, String cursor, int limit }) async
    test('test listChecklistTemplates', () async {
      // TODO
    });

    // Update Checklist Template
    //
    //Future<ChecklistTemplateDetail> updateChecklistTemplate(String templateId, UpdateChecklistTemplateRequest updateChecklistTemplateRequest) async
    test('test updateChecklistTemplate', () async {
      // TODO
    });
  });
}
