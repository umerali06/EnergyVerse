import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/design_system/theme.dart';
import 'package:fev_mobile/documents/documents_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeDocumentsApi implements DocumentsApiContract {
  FakeDocumentsApi({this.documents = const []});

  final List<DocumentListItem> documents;

  @override
  Future<DocumentListPage> getDocuments({
    String? category,
    String? q,
    String? cursor,
    int limit = 25,
  }) async {
    var filtered = documents;
    if (category != null && category.isNotEmpty) {
      filtered = filtered
          .where((d) => d.category.name.toLowerCase() == category.toLowerCase())
          .toList();
    }
    if (q != null && q.isNotEmpty) {
      filtered = filtered
          .where((d) =>
              d.title.toLowerCase().contains(q.toLowerCase()) ||
              d.documentCode.toLowerCase().contains(q.toLowerCase()))
          .toList();
    }
    return DocumentListPage((b) => b
      ..items.addAll(filtered)
      ..nextCursor = null);
  }

  @override
  Future<DocumentDetail> createDocument(CreateDocumentRequest request) async {
    var detail = DocumentDetail((b) => b
      ..id = request.id
      ..title = request.title
      ..documentCode = request.documentCode
      ..category = DocumentDetailCategoryEnum.valueOf(request.category.name)
      ..description = request.description
      ..filePath = request.filePath
      ..filename = request.filename
      ..fileFormat = request.fileFormat != null
          ? DocumentDetailFileFormatEnum.valueOf(request.fileFormat!.name)
          : DocumentDetailFileFormatEnum.pdf
      ..fileSizeBytes = request.fileSizeBytes
      ..version = 1
      ..status = DocumentDetailStatusEnum.active
      ..downloadUrl = 'https://example.com/${request.filename}'
      ..createdBy = 'test-user'
      ..createdAt = DateTime.now().toUtc()
      ..updatedAt = DateTime.now().toUtc());
    if (request.tags != null) {
      detail = detail.rebuild((b) => b..tags.addAll(request.tags!));
    }
    return detail;
  }

  @override
  Future<DocumentDetail> getDocument(String documentId) async {
    final item = documents.firstWhere((d) => d.id == documentId);
    var detail = DocumentDetail((b) => b
      ..id = item.id
      ..title = item.title
      ..documentCode = item.documentCode
      ..category = DocumentDetailCategoryEnum.valueOf(item.category.name)
      ..description = item.description
      ..facilityId = item.facilityId
      ..assetId = item.assetId
      ..filePath = item.filePath
      ..filename = item.filename
      ..fileFormat = DocumentDetailFileFormatEnum.valueOf(item.fileFormat.name)
      ..fileSizeBytes = item.fileSizeBytes
      ..version = item.version
      ..status = DocumentDetailStatusEnum.valueOf(item.status.name)
      ..downloadUrl = item.downloadUrl
      ..createdBy = item.createdBy
      ..createdAt = item.createdAt
      ..updatedAt = item.updatedAt);
    if (item.tags != null) {
      detail = detail.rebuild((b) => b..tags.addAll(item.tags!));
    }
    return detail;
  }

  @override
  Future<DocumentDetail> updateDocument(
    String documentId,
    UpdateDocumentRequest request,
  ) async {
    return getDocument(documentId);
  }

  @override
  Future<DocumentDeleted> deleteDocument(String documentId) async {
    return DocumentDeleted((b) => b
      ..id = documentId
      ..deleted = true);
  }
}

void main() {
  final sampleDoc = DocumentListItem((b) => b
    ..id = 'doc-1'
    ..title = 'High Pressure Feed Pump SOP'
    ..documentCode = 'DOC-SOP-001'
    ..category = DocumentListItemCategoryEnum.sop
    ..filePath = 'sops/sop.pdf'
    ..filename = 'sop.pdf'
    ..fileFormat = DocumentListItemFileFormatEnum.pdf
    ..fileSizeBytes = 2048000
    ..version = 1
    ..status = DocumentListItemStatusEnum.active
    ..tags.addAll(['SOP', 'Safety'])
    ..createdBy = 'demo-user'
    ..createdAt = DateTime.now().toUtc()
    ..updatedAt = DateTime.now().toUtc());

  testWidgets('renders documents list and filters by category', (tester) async {
    final fakeApi = FakeDocumentsApi(documents: [sampleDoc]);
    final theme = AppThemeController();
    addTearDown(() => theme.dispose());

    await tester.pumpWidget(AppThemeScope(
      controller: theme,
      child: MaterialApp(
        theme: AppThemes.light,
        home: Scaffold(
          body: DocumentsScreen(api: fakeApi),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.text('Documents'), findsOneWidget);
    expect(find.text('High Pressure Feed Pump SOP'), findsOneWidget);
    expect(find.text('DOC-SOP-001'), findsOneWidget);

    // Tap category chip
    await tester.tap(find.byKey(const Key('category-chip-manual')));
    await tester.pumpAndSettle();

    expect(find.text('No documents found'), findsOneWidget);
  });
}
