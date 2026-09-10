import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for DocumentsApi
void main() {
  final instance = FevApiClient().getDocumentsApi();

  group(DocumentsApi, () {
    // Create Document
    //
    //Future<DocumentDetail> createDocument(CreateDocumentRequest createDocumentRequest) async
    test('test createDocument', () async {
      // TODO
    });

    // Delete Document
    //
    //Future<DocumentDeleted> deleteDocument(String documentId) async
    test('test deleteDocument', () async {
      // TODO
    });

    // Get Document
    //
    //Future<DocumentDetail> getDocument(String documentId) async
    test('test getDocument', () async {
      // TODO
    });

    // List Documents
    //
    //Future<DocumentListPage> listDocuments({ String category, String facilityId, String status, String search, String cursor, int limit }) async
    test('test listDocuments', () async {
      // TODO
    });

    // Update Document
    //
    //Future<DocumentDetail> updateDocument(String documentId, UpdateDocumentRequest updateDocumentRequest) async
    test('test updateDocument', () async {
      // TODO
    });
  });
}
