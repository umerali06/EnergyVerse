import 'dart:async';

import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import '../sync/sync_engine.dart';

String _riskLabel(String? risk) => switch (risk) {
      'low' => 'Low risk',
      'medium' => 'Medium risk',
      'high' => 'High risk',
      'critical' => 'Critical risk',
      _ => '',
    };

AppStatus _riskStatus(String? risk) => switch (risk) {
      'low' => AppStatus.healthy,
      'medium' => AppStatus.warning,
      'high' => AppStatus.warning,
      'critical' => AppStatus.critical,
      _ => AppStatus.info,
    };

/// The inspection detail screen's AI photo analysis section (spec 8 "AI
/// Photo & Video Analysis", Phase 7.10) -- lists every Claude vision run's
/// summary/recommendations/risk level and lets the inspector mark it
/// reviewed. The findings themselves render as ordinary annotations on the
/// photo they were run against (see [AnnotationCanvasScreen]'s "AI" badge);
/// this section is the analysis-level record, not a duplicate findings list.
/// Read-only once the inspection is no longer editable, same as every other
/// section -- there is nothing to review/override on a completed inspection.
class InspectionAiAnalysisSection extends StatefulWidget {
  const InspectionAiAnalysisSection({
    required this.inspectionId,
    required this.analyses,
    required this.editable,
    super.key,
  });

  final String inspectionId;
  final List<AiAnalysisResponse> analyses;
  final bool editable;

  @override
  State<InspectionAiAnalysisSection> createState() =>
      _InspectionAiAnalysisSectionState();
}

class _InspectionAiAnalysisSectionState
    extends State<InspectionAiAnalysisSection> {
  final Set<String> _reviewing = {};

  Future<void> _review(AiAnalysisResponse analysis) async {
    setState(() => _reviewing.add(analysis.id));
    try {
      await SyncProvider.repositoryOf(context).reviewAiAnalysis(
        inspectionId: widget.inspectionId,
        analysisId: analysis.id,
      );
    } catch (error) {
      if (mounted) {
        showAppToast(context, 'Could not mark reviewed: $error',
            status: AppStatus.critical);
      }
    } finally {
      if (mounted) setState(() => _reviewing.remove(analysis.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.analyses.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('AI ANALYSIS',
            style:
                TextStyle(color: context.semantic.textMuted, letterSpacing: 1)),
        const SizedBox(height: DsSpacing.s2),
        ...widget.analyses.map(
          (analysis) => Padding(
            padding: const EdgeInsets.only(bottom: DsSpacing.s2),
            child: _AiAnalysisTile(
              key: Key('ai-analysis-${analysis.id}'),
              analysis: analysis,
              editable: widget.editable,
              reviewing: _reviewing.contains(analysis.id),
              onReview: () => unawaited(_review(analysis)),
            ),
          ),
        ),
      ],
    );
  }
}

class _AiAnalysisTile extends StatelessWidget {
  const _AiAnalysisTile({
    required this.analysis,
    required this.editable,
    required this.reviewing,
    required this.onReview,
    super.key,
  });

  final AiAnalysisResponse analysis;
  final bool editable;
  final bool reviewing;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    final reviewed = analysis.reviewed == true;
    final findingCount = analysis.annotationIds?.length ?? 0;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(analysis.summary,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              if (reviewed)
                const StatusPill(label: 'Reviewed', status: AppStatus.healthy)
              else
                const StatusPill(
                    label: 'Needs review', status: AppStatus.warning),
            ],
          ),
          if (analysis.riskLevel != null) ...[
            const SizedBox(height: DsSpacing.s1),
            StatusPill(
              label: _riskLabel(analysis.riskLevel?.name),
              status: _riskStatus(analysis.riskLevel?.name),
            ),
          ],
          if (analysis.recommendations != null &&
              analysis.recommendations!.isNotEmpty) ...[
            const SizedBox(height: DsSpacing.s2),
            Text(
              analysis.recommendations!,
              style: TextStyle(color: context.semantic.textSecondary),
            ),
          ],
          const SizedBox(height: DsSpacing.s2),
          Text(
            '$findingCount finding${findingCount == 1 ? '' : 's'} · ${analysis.model}',
            style: TextStyle(
                color: context.semantic.textMuted,
                fontSize: DsTypography.sizeCaption),
          ),
          if (editable && !reviewed) ...[
            const SizedBox(height: DsSpacing.s2),
            AppButton(
              key: Key('mark-reviewed-${analysis.id}'),
              label: 'Mark reviewed',
              icon: Icons.check,
              variant: AppButtonVariant.ghost,
              onPressed: reviewing ? null : onReview,
            ),
          ],
        ],
      ),
    );
  }
}
