import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';

class DocumentDetailSheet extends StatelessWidget {
  const DocumentDetailSheet({required this.document, super.key});

  final DocumentListItem document;

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _categoryLabel(String cat) {
    switch (cat) {
      case 'sop':
        return 'SOP';
      case 'manual':
        return 'Manual';
      case 'safety_policy':
        return 'Safety Policy';
      case 'certificate':
        return 'Certificate';
      case 'drawing':
        return 'Drawing';
      case 'report':
        return 'Report';
      default:
        return cat.toUpperCase();
    }
  }

  Future<void> _openDownload(BuildContext context) async {
    final url = document.downloadUrl;
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Download URL unavailable')),
      );
      return;
    }
    final uri = Uri.parse(url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open document: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tags = document.tags?.toList() ?? [];
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: DsSpacing.s6,
        right: DsSpacing.s6,
        top: DsSpacing.s6,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DsSpacing.s3,
                    vertical: DsSpacing.s1,
                  ),
                  decoration: BoxDecoration(
                    color: DsColors.primary500.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(DsRadius.sm),
                  ),
                  child: Text(
                    document.documentCode,
                    style: theme.textTheme.labelMedium?.copyWith(
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
            const SizedBox(height: DsSpacing.s4),
            Text(
              document.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: DsSpacing.s2),
            Row(
              children: [
                Chip(
                  label: Text(_categoryLabel(document.category.name)),
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: DsSpacing.s2),
                Chip(
                  label: Text('${document.fileFormat.name.toUpperCase()} · ${_formatBytes(document.fileSizeBytes)}'),
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: DsSpacing.s2),
                Chip(
                  label: Text('v${document.version}'),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            if ((document.description ?? '').isNotEmpty) ...[
              const SizedBox(height: DsSpacing.s4),
              Text(
                'Description',
                style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: DsSpacing.s1),
              Text(
                document.description!,
                style: theme.textTheme.bodyMedium,
              ),
            ],
            if (tags.isNotEmpty) ...[
              const SizedBox(height: DsSpacing.s4),
              Text(
                'Tags',
                style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: DsSpacing.s1),
              Wrap(
                spacing: DsSpacing.s2,
                children: tags
                    .map((t) => Chip(
                          label: Text('#$t'),
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: DsSpacing.s6),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                key: const Key('download-doc-button'),
                label: 'View / Download Document',
                onPressed: () => _openDownload(context),
              ),
            ),
            const SizedBox(height: DsSpacing.s6),
          ],
        ),
      ),
    );
  }
}
