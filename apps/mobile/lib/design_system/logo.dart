import 'package:flutter/material.dart';

import 'tokens_generated.dart';

enum LogoVariant { mark, wordmark, full }

/// Brand logo that auto-selects the light/dark asset from the active theme.
/// Call sites never reference file paths, so adding a theme variant later
/// only touches this widget. Assets are derived from the owner-supplied
/// master lockup (white background removed; dark variant = navy → light
/// recolor with the brand orange unchanged).
class BrandLogo extends StatelessWidget {
  const BrandLogo({
    this.variant = LogoVariant.wordmark,
    this.height = 32,
    this.decorative = false,
    super.key,
  });

  final LogoVariant variant;
  final double height;

  /// Marks the image as decorative when an adjacent text label already
  /// names the product.
  final bool decorative;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final name = switch (variant) {
      LogoVariant.mark => 'mark',
      LogoVariant.wordmark => 'wordmark',
      LogoVariant.full => 'full',
    };
    final image = Image.asset(
      'assets/brand/logo-$name-${dark ? 'dark' : 'light'}.png',
      height: height,
      fit: BoxFit.contain,
      semanticLabel: decorative ? null : 'Flacron EnergyVerse',
      excludeFromSemantics: decorative,
    );
    return image;
  }
}

/// Ultra-premium orbital logo loader: wraps a rotating gradient ring & glow
/// around the central brand logo for splash and authentication loading states.
class LogoLoader extends StatefulWidget {
  const LogoLoader({
    this.height = 36,
    this.label = 'Restoring session',
    this.variant = LogoVariant.mark,
    super.key,
  });

  final double height;
  final String label;
  final LogoVariant variant;

  @override
  State<LogoLoader> createState() => _LogoLoaderState();
}

class _LogoLoaderState extends State<LogoLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Aura Glow
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: DsColors.accent500.withValues(alpha: dark ? 0.25 : 0.15),
                    blurRadius: 32,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),

            // Outer Rotating Ring
            RotationTransition(
              turns: _controller,
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: const AlwaysStoppedAnimation<Color>(DsColors.accent500),
                  backgroundColor: DsColors.primary400.withValues(alpha: 0.2),
                ),
              ),
            ),

            // Glassmorphic Inner Disc Container
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: (dark ? DsColors.darkSurface : Colors.white).withValues(alpha: 0.9),
                shape: BoxShape.circle,
                border: Border.all(
                  color: DsColors.primary400.withValues(alpha: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: BrandLogo(
                  decorative: true,
                  height: widget.height,
                  variant: widget.variant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: DsSpacing.s6),
        Semantics(
          liveRegion: true,
          child: Text(
            widget.label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: dark ? DsColors.primary400 : DsColors.primary600,
              fontFamily: DsTypography.mono,
            ),
          ),
        ),
      ],
    );
  }
}

