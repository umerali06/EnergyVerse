import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'motion.dart';
import 'primitives.dart';
import 'theme.dart';
import 'tokens_generated.dart';

class DesignSystemShowcase extends StatefulWidget {
  const DesignSystemShowcase({super.key});

  static const routeName = '/design-system';

  @override
  State<DesignSystemShowcase> createState() => _DesignSystemShowcaseState();
}

class _DesignSystemShowcaseState extends State<DesignSystemShowcase> {
  String _status = 'operational';

  @override
  Widget build(BuildContext context) {
    assert(kDebugMode, 'The design-system showcase is development-only');
    final themeController = AppThemeScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('FEV Design System'),
        actions: [
          Semantics(
            button: true,
            label: 'Switch theme',
            child: IconButton(
              onPressed: themeController.toggle,
              tooltip: 'Switch theme',
              icon: Icon(
                themeController.mode == ThemeMode.dark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(DsSpacing.s4),
        children: [
          const AppBadge(label: 'DEV-ONLY SHOWCASE'),
          const SizedBox(height: DsSpacing.s3),
          Text(
            'Industrial energy primitives',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: DsSpacing.s2),
          Text(
            'Shared tokens, accessible states, and reduced-motion-aware interaction.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: DsSpacing.s2),
          Text('ASSET-OG-1042 · WO-2026-0088', style: AppThemes.mono(context)),
          const SizedBox(height: DsSpacing.s8),
          _section(
            context,
            'Status and badges',
            Wrap(
              spacing: DsSpacing.s2,
              runSpacing: DsSpacing.s2,
              children: const [
                StatusPill(label: 'Healthy', status: AppStatus.healthy),
                StatusPill(label: 'Warning', status: AppStatus.warning),
                StatusPill(label: 'Critical', status: AppStatus.critical),
                StatusPill(label: 'Info', status: AppStatus.info),
                AppBadge(label: 'Inspection due'),
              ],
            ),
          ),
          _section(
            context,
            'Buttons',
            Wrap(
              spacing: DsSpacing.s2,
              runSpacing: DsSpacing.s2,
              children: [
                AppButton(label: 'Primary', onPressed: () {}),
                AppButton(
                  label: 'Accent',
                  onPressed: () {},
                  variant: AppButtonVariant.accent,
                ),
                AppButton(
                  label: 'Ghost',
                  onPressed: () {},
                  variant: AppButtonVariant.ghost,
                ),
                AppButton(
                  label: 'Danger',
                  onPressed: () {},
                  variant: AppButtonVariant.danger,
                ),
                const AppButton(label: 'Loading', loading: true),
                const AppButton(label: 'Disabled'),
              ],
            ),
          ),
          _section(
            context,
            'Form controls',
            Column(
              children: [
                const AppTextField(label: 'Asset name', hint: 'Separator A-12'),
                const SizedBox(height: DsSpacing.s4),
                const AppTextField(
                  label: 'Asset tag',
                  errorText: 'Asset tag is required',
                ),
                const SizedBox(height: DsSpacing.s4),
                AppSelect<String>(
                  label: 'Status',
                  value: _status,
                  items: const [
                    DropdownMenuItem(
                      value: 'operational',
                      child: Text('Operational'),
                    ),
                    DropdownMenuItem(
                      value: 'maintenance',
                      child: Text('Maintenance'),
                    ),
                  ],
                  onChanged: (value) =>
                      setState(() => _status = value ?? _status),
                ),
                const SizedBox(height: DsSpacing.s4),
                const AppTextField(
                  label: 'Inspector notes',
                  hint: 'Record field observations…',
                  maxLines: 4,
                ),
              ],
            ),
          ),
          _section(
            context,
            'Feedback and modal',
            Wrap(
              spacing: DsSpacing.s2,
              runSpacing: DsSpacing.s2,
              children: [
                AppButton(
                  label: 'Open modal',
                  variant: AppButtonVariant.ghost,
                  onPressed: () => showAppModal<void>(
                    context,
                    title: 'Confirm industrial action',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Shared surface, radius, and motion tokens.',
                        ),
                        const SizedBox(height: DsSpacing.s4),
                        AppButton(
                          label: 'Confirm',
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                ),
                AppButton(
                  label: 'Show toast',
                  variant: AppButtonVariant.accent,
                  onPressed: () => showAppToast(
                    context,
                    'Inspection draft saved',
                    status: AppStatus.healthy,
                  ),
                ),
                Tooltip(
                  message: 'Verified against the current role matrix',
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 48),
                    padding: const EdgeInsets.all(DsSpacing.s3),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.semantic.border),
                      borderRadius: BorderRadius.circular(DsRadius.md),
                    ),
                    child: const Text('Long-press tooltip'),
                  ),
                ),
              ],
            ),
          ),
          _section(
            context,
            'Tabs and loading',
            Column(
              children: [
                AppTabs(
                  labels: ['Overview', 'History'],
                  children: [
                    Center(child: Text('Shared operational overview')),
                    Center(child: Text('Audit-ready history state')),
                  ],
                ),
                const AppSkeleton(height: 20),
                const SizedBox(height: DsSpacing.s3),
                const AppSkeleton(height: 14, width: 220),
                const SizedBox(height: DsSpacing.s4),
                const AppLoader(label: 'Loading asset data'),
              ],
            ),
          ),
          _section(
            context,
            'Empty state',
            EmptyState(
              title: 'No matching records',
              description:
                  'Adjust filters or create a record in a later feature phase.',
              action: AppButton(
                label: 'Clear filters',
                variant: AppButtonVariant.ghost,
                onPressed: () {},
              ),
            ),
          ),
          _section(
            context,
            'Motion specification',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fade-slide, stagger, shimmer, and press feedback respect disable-animations.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: DsSpacing.s4),
                for (final (index, label) in [
                  'Inspect',
                  'Confirm',
                  'Audit',
                ].indexed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: DsSpacing.s2),
                    child: StaggeredReveal(
                      index: index,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(DsSpacing.s4),
                        decoration: BoxDecoration(
                          color: context.semantic.elevated,
                          borderRadius: BorderRadius.circular(DsRadius.lg),
                        ),
                        child: Text(label),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: DsSpacing.s12),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DsSpacing.s6),
      child: StaggeredReveal(
        index: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: DsSpacing.s3),
            AppCard(child: child),
          ],
        ),
      ),
    );
  }
}
