import 'package:flutter/material.dart';

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
