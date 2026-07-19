import 'package:flutter/material.dart';

import 'motion.dart';
import 'theme.dart';
import 'tokens_generated.dart';

enum AppButtonVariant { primary, accent, ghost, danger }

class AppButton extends StatefulWidget {
  const AppButton({
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;
  final IconData? icon;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.loading;
    final colors = Theme.of(context).colorScheme;
    final (background, foreground, border) = switch (widget.variant) {
      AppButtonVariant.primary => (
        DsColors.primary500,
        Colors.white,
        Colors.transparent,
      ),
      AppButtonVariant.accent => (
        DsColors.accent500,
        DsColors.accentInk,
        Colors.transparent,
      ),
      AppButtonVariant.ghost => (
        Colors.transparent,
        colors.onSurface,
        context.semantic.border,
      ),
      AppButtonVariant.danger => (
        DsColors.statusCritical,
        Colors.white,
        Colors.transparent,
      ),
    };
    final style = ElevatedButton.styleFrom(
      backgroundColor: background,
      foregroundColor: foreground,
      disabledBackgroundColor: background.withAlpha(115),
      disabledForegroundColor: foreground.withAlpha(179),
      side: BorderSide(color: border),
      elevation: widget.variant == AppButtonVariant.ghost ? 0 : 2,
      minimumSize: const Size(48, 48),
    );
    final content = widget.loading
        ? const AppLoader(size: 18, label: 'Loading')
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 18),
                const SizedBox(width: DsSpacing.s2),
              ],
              Text(widget.label),
            ],
          );

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.loading ? '${widget.label}, loading' : widget.label,
      child: Listener(
        onPointerDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onPointerUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onPointerCancel: enabled
            ? (_) => setState(() => _pressed = false)
            : null,
        child: AnimatedScale(
          duration: motionDuration(context, DsMotion.fast),
          curve: DsMotion.standard,
          scale: _pressed && !prefersReducedMotion(context) ? 0.97 : 1,
          child: ElevatedButton(
            onPressed: enabled ? widget.onPressed : null,
            style: style,
            child: content,
          ),
        ),
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.enabled = true,
    this.maxLines = 1,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.autofillHints,
    this.textInputAction,
    this.onSubmitted,
    super.key,
  });

  final String label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final bool enabled;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      obscureText: obscureText,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class AppSelect<T> extends StatelessWidget {
  const AppSelect({
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    super.key,
  });

  final String label;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final T? value;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(labelText: label),
      items: items,
      onChanged: onChanged,
      // ignore: deprecated_member_use
      value: value,
    );
  }
}

class AppCard extends StatelessWidget {
  const AppCard({required this.child, this.padding, super.key});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(DsSpacing.s4),
        child: child,
      ),
    );
  }
}

enum AppStatus { healthy, warning, critical, info }

extension on AppStatus {
  Color get color => switch (this) {
    AppStatus.healthy => DsColors.statusSuccess,
    AppStatus.warning => DsColors.statusWarning,
    AppStatus.critical => DsColors.statusCritical,
    AppStatus.info => DsColors.statusInfo,
  };

  /// WCAG-safe text color per brightness: deep variants on light surfaces,
  /// a brightened critical on dark ones.
  Color textColor(bool dark) => switch (this) {
    AppStatus.healthy => dark ? DsColors.statusSuccess : DsColors.statusSuccessDeep,
    AppStatus.warning => dark ? DsColors.statusWarning : DsColors.statusWarningDeep,
    AppStatus.critical =>
      dark ? DsColors.statusCriticalBright : DsColors.statusCriticalDeep,
    AppStatus.info => dark ? DsColors.primary400 : DsColors.statusInfoDeep,
  };
}

class StatusPill extends StatelessWidget {
  const StatusPill({required this.label, required this.status, super.key});

  final String label;
  final AppStatus status;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final color = status.textColor(dark);
    return Semantics(
      label: 'Status: $label',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: status.color.withAlpha(30),
          border: Border.all(color: color.withAlpha(70)),
          borderRadius: BorderRadius.circular(DsRadius.sm),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DsSpacing.s3,
            vertical: DsSpacing.s1,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: DsSpacing.s2),
              Text(
                label.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBadge extends StatelessWidget {
  const AppBadge({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.semantic.elevated,
        border: Border.all(color: context.semantic.border),
        borderRadius: BorderRadius.circular(DsRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DsSpacing.s2,
          vertical: 2,
        ),
        child: Text(label, style: Theme.of(context).textTheme.labelSmall),
      ),
    );
  }
}

class AppModal extends StatelessWidget {
  const AppModal({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(DsSpacing.s6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: context.semantic.border,
                  borderRadius: BorderRadius.circular(DsRadius.full),
                ),
              ),
            ),
            const SizedBox(height: DsSpacing.s4),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: DsSpacing.s4),
            child,
          ],
        ),
      ),
    );
  }
}

Future<T?> showAppModal<T>(
  BuildContext context, {
  required String title,
  required Widget child,
}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: true,
  showDragHandle: false,
  backgroundColor: Theme.of(context).colorScheme.surface,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(DsRadius.xl2)),
  ),
  builder: (_) => AppModal(title: title, child: child),
);

void showAppToast(
  BuildContext context,
  String message, {
  AppStatus status = AppStatus.info,
}) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(buildAppToast(message, status: status));
}

SnackBar buildAppToast(String message, {AppStatus status = AppStatus.info}) =>
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.circle, color: status.color, size: 12),
          const SizedBox(width: DsSpacing.s3),
          Expanded(child: Text(message)),
        ],
      ),
    );

class AppTabs extends StatelessWidget {
  const AppTabs({required this.labels, required this.children, super.key});

  final List<String> labels;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    assert(labels.length == children.length);
    return DefaultTabController(
      length: labels.length,
      child: Column(
        children: [
          TabBar(tabs: labels.map((label) => Tab(text: label)).toList()),
          SizedBox(height: 120, child: TabBarView(children: children)),
        ],
      ),
    );
  }
}

class AppSkeleton extends StatefulWidget {
  const AppSkeleton({
    this.width = double.infinity,
    this.height = 16,
    super.key,
  });

  final double width;
  final double height;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (prefersReducedMotion(context)) {
      _controller.stop();
      _controller.value = 0.5;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DsRadius.md),
            gradient: LinearGradient(
              begin: Alignment(-1.5 + (_controller.value * 3), 0),
              end: Alignment(-0.5 + (_controller.value * 3), 0),
              colors: [
                context.semantic.elevated,
                context.semantic.border,
                context.semantic.elevated,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppLoader extends StatelessWidget {
  const AppLoader({this.label = 'Loading', this.size = 24, super.key});

  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: SizedBox.square(
        dimension: size,
        child: const CircularProgressIndicator(strokeWidth: 2.4),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    required this.description,
    this.action,
    super.key,
  });

  final String title;
  final String description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DsSpacing.s8),
      decoration: BoxDecoration(
        border: Border.all(color: context.semantic.border),
        borderRadius: BorderRadius.circular(DsRadius.xl),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.layers_clear_outlined,
            color: DsColors.primary400,
            size: 36,
          ),
          const SizedBox(height: DsSpacing.s3),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: DsSpacing.s2),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (action != null) ...[
            const SizedBox(height: DsSpacing.s4),
            action!,
          ],
        ],
      ),
    );
  }
}
