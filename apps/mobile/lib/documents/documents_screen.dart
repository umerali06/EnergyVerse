import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../auth/auth_controller.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;
import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';
import 'document_detail_sheet.dart';
import 'documents_controller.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({this.api, super.key});

  final DocumentsApiContract? api;

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  DocumentsController? _controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) return;
    final candidate = widget.api ?? AuthProvider.of(context).api;
    if (candidate is! DocumentsApiContract) return;
    _controller = DocumentsController(api: candidate)..start();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void _openDetail(DocumentListItem doc) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DocumentDetailSheet(document: doc),
    );
  }

  String _categoryLabel(String cat) {
    switch (cat) {
      case 'sop':
        return 'SOPs';
      case 'manual':
        return 'Manuals';
      case 'safety_policy':
        return 'Safety Policies';
      case 'certificate':
        return 'Certificates';
      case 'drawing':
        return 'Drawings';
      case 'report':
        return 'Reports';
      default:
        return cat.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) {
      return const EmptyState(
        title: 'Documents unavailable',
        description: 'This API client does not support Document Management.',
      );
    }

    final theme = Theme.of(context);

    final categories = [
      {'key': null, 'label': 'All'},
      {'key': 'sop', 'label': 'SOPs'},
      {'key': 'manual', 'label': 'Manuals'},
      {'key': 'safety_policy', 'label': 'Safety Policies'},
      {'key': 'certificate', 'label': 'Certificates'},
      {'key': 'drawing', 'label': 'Drawings'},
      {'key': 'report', 'label': 'Reports'},
    ];

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => ListView(
        key: const Key('documents-scroll'),
        padding: const EdgeInsets.all(DsSpacing.s6),
        children: [
          Text(
            'Documents',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: DsSpacing.s2),
          Text(
            'Technical manuals, standard operating procedures, safety policies, and certificates.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: DsSpacing.s4),

          // Search Field
          AppTextField(
            key: const Key('documents-search-input'),
            label: 'Search documents',
            controller: _searchController,
            hint: 'Search by code, title, or tags...',
            onChanged: (val) => controller.setSearchQuery(val),
          ),
          const SizedBox(height: DsSpacing.s4),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) {
                final isSelected = controller.category == cat['key'];
                return Padding(
                  padding: const EdgeInsets.only(right: DsSpacing.s2),
                  child: FilterChip(
                    key: Key('category-chip-${cat['key'] ?? 'all'}'),
                    selected: isSelected,
                    label: Text(cat['label']!),
                    onSelected: (_) => controller.setCategory(cat['key']),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: DsSpacing.s5),

          // Content States
          if (controller.status == LoadStatus.loading) ...[
            const AppSkeleton(height: 100),
            const SizedBox(height: DsSpacing.s3),
            const AppSkeleton(height: 100),
          ] else if (controller.status == LoadStatus.error) ...[
            EmptyState(
              title: 'Unable to load documents',
              description: 'Check connection and try again.',
              action: AppButton(
                label: 'Retry',
                onPressed: controller.retry,
              ),
            ),
          ] else if (controller.items.isEmpty) ...[
            const EmptyState(
              title: 'No documents found',
              description: 'No technical documents match your filter or search query.',
            ),
          ] else ...[
            for (final doc in controller.items) ...[
              _DocumentCard(
                document: doc,
                onTap: () => _openDetail(doc),
                categoryLabel: _categoryLabel(doc.category.name),
              ),
              const SizedBox(height: DsSpacing.s3),
            ],
            if (controller.nextCursor != null)
              AppButton(
                label: 'Load more',
                loading: controller.loadingMore,
                variant: AppButtonVariant.ghost,
                onPressed: controller.loadMore,
              ),
          ],
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.document,
    required this.onTap,
    required this.categoryLabel,
  });

  final DocumentListItem document;
  final VoidCallback onTap;
  final String categoryLabel;

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DsRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(DsSpacing.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DsSpacing.s2,
                      vertical: DsSpacing.s1,
                    ),
                    decoration: BoxDecoration(
                      color: DsColors.primary500.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(DsRadius.sm),
                    ),
                    child: Text(
                      document.documentCode,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: DsColors.primary400,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  StatusPill(
                    label: document.status.name.toUpperCase(),
                    status: document.status == DocumentListItemStatusEnum.active
                        ? AppStatus.healthy
                        : AppStatus.info,
                  ),
                ],
              ),
              const SizedBox(height: DsSpacing.s2),
              Text(
                document.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: DsSpacing.s2),
              Row(
                children: [
                  Text(
                    categoryLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    ' · ${document.fileFormat.name.toUpperCase()} · ${_formatBytes(document.fileSizeBytes)} · v${document.version}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
