import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/material.dart';

import '../auth/auth_controller.dart';
import '../dashboard/dashboard_controller.dart' show LoadStatus;
import '../dashboard/format.dart';
import '../design_system/primitives.dart';
import '../design_system/theme.dart';
import '../design_system/tokens_generated.dart';
import 'company_controller.dart';

/// Company profile, read-only on mobile -- editing (profile fields and logo
/// branding) remains admin-web-only for Phase 3.3, mirroring D-023/D-026's
/// mobile-read-only precedent for occasional desk tasks.
class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({super.key});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  CompanyController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= CompanyController(api: AuthProvider.of(context).api)..start();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => ListView(
        key: const Key('company-settings-scroll'),
        padding: const EdgeInsets.all(DsSpacing.s6),
        children: [
          Text('Company Settings', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: DsSpacing.s2),
          Text(
            "Your organization's profile and tenant-wide settings.",
            style: TextStyle(color: context.semantic.textMuted),
          ),
          const SizedBox(height: DsSpacing.s5),
          if (controller.status == LoadStatus.loading) ...[
            const AppSkeleton(height: 64),
            const SizedBox(height: DsSpacing.s3),
            const AppSkeleton(height: 96),
          ] else if (controller.status == LoadStatus.error)
            EmptyState(
              action: AppButton(
                label: 'Retry',
                onPressed: () => controller.retry(),
                variant: AppButtonVariant.ghost,
              ),
              description: "Couldn't load company settings. Check your connection and try again.",
              title: 'Something went wrong',
            )
          else if (controller.profile != null)
            _CompanyProfileBody(profile: controller.profile!),
        ],
      ),
    );
  }
}

class _CompanyProfileBody extends StatelessWidget {
  const _CompanyProfileBody({required this.profile});

  final CompanyProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (profile.logoUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(DsRadius.sm),
                  child: Image.network(profile.logoUrl!, height: 64, fit: BoxFit.contain),
                ),
                const SizedBox(height: DsSpacing.s3),
              ],
              Text(profile.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: DsSpacing.s2),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: DsSpacing.s2,
                runSpacing: DsSpacing.s2,
                children: [
                  if (profile.industry != null) AppBadge(label: profile.industry!),
                  AppBadge(label: profile.timezone),
                  AppBadge(label: profile.locale),
                ],
              ),
              if (profile.contactEmail != null) ...[
                const SizedBox(height: DsSpacing.s3),
                Text('Contact email', style: Theme.of(context).textTheme.labelSmall),
                Text(profile.contactEmail!),
              ],
              if (profile.contactPhone != null) ...[
                const SizedBox(height: DsSpacing.s3),
                Text('Contact phone', style: Theme.of(context).textTheme.labelSmall),
                Text(profile.contactPhone!),
              ],
            ],
          ),
        ),
        const SizedBox(height: DsSpacing.s4),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Overview', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: DsSpacing.s3),
              Row(
                children: [
                  StatusPill(label: profile.subscriptionTier, status: AppStatus.info),
                  const SizedBox(width: DsSpacing.s2),
                  Expanded(
                    child: Text(
                      'Tier management is available in a later phase.',
                      style: TextStyle(color: context.semantic.textMuted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DsSpacing.s3),
              Text(
                'Company since '
                '${formatCompanyDate(profile.createdAt, timeZone: profile.timezone)}',
              ),
              const SizedBox(height: DsSpacing.s3),
              Row(
                children: [
                  _StatBlock(label: 'Users', value: profile.usersTotal),
                  const SizedBox(width: DsSpacing.s6),
                  _StatBlock(label: 'Roles', value: profile.rolesTotal),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: DsSpacing.s4),
        Text(
          'Editing the profile and logo is available in the admin web app.',
          style: TextStyle(color: context.semantic.textMuted),
        ),
      ],
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$value', style: Theme.of(context).textTheme.titleLarge),
        Text(label, style: TextStyle(color: context.semantic.textMuted)),
      ],
    );
  }
}
