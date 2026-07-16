// GENERATED from packages/design-tokens/tokens.json. Do not edit.
import 'package:flutter/material.dart';

abstract final class DsColors {
  static const primary50 = Color(0xFFEFF6FF);
  static const primary100 = Color(0xFFDBEAFE);
  static const primary200 = Color(0xFFBFDBFE);
  static const primary300 = Color(0xFF93C5FD);
  static const primary400 = Color(0xFF60A5FA);
  static const primary500 = Color(0xFF2563EB);
  static const primary600 = Color(0xFF1D4ED8);
  static const primary700 = Color(0xFF1E40AF);
  static const primary800 = Color(0xFF1E3A8A);
  static const primary900 = Color(0xFF172554);
  static const accent50 = Color(0xFFFFF7ED);
  static const accent100 = Color(0xFFFFEDD5);
  static const accent200 = Color(0xFFFED7AA);
  static const accent300 = Color(0xFFFDBA74);
  static const accent400 = Color(0xFFFB923C);
  static const accent500 = Color(0xFFF97316);
  static const accent600 = Color(0xFFEA580C);
  static const accent700 = Color(0xFFC2410C);
  static const accent800 = Color(0xFF9A3412);
  static const accent900 = Color(0xFF7C2D12);
  static const statusSuccess = Color(0xFF16A34A);
  static const statusWarning = Color(0xFFF59E0B);
  static const statusCritical = Color(0xFFDC2626);
  static const statusInfo = Color(0xFF2563EB);
  static const darkBackground = Color(0xFF0A0E1A);
  static const darkSurface = Color(0xFF111827);
  static const darkElevated = Color(0xFF1A2234);
  static const darkBorder = Color(0xFF334155);
  static const darkTextPrimary = Color(0xFFF8FAFC);
  static const darkTextSecondary = Color(0xFFCBD5E1);
  static const darkTextMuted = Color(0xFF94A3B8);
  static const lightBackground = Color(0xFFF8FAFC);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightElevated = Color(0xFFE2E8F0);
  static const lightBorder = Color(0xFFCBD5E1);
  static const lightTextPrimary = Color(0xFF0F172A);
  static const lightTextSecondary = Color(0xFF334155);
  static const lightTextMuted = Color(0xFF64748B);
}

abstract final class DsTypography {
  static const sans = 'Inter';
  static const mono = 'JetBrains Mono';
  static const sizeDisplay = 48.0;
  static const sizeH1 = 36.0;
  static const sizeH2 = 30.0;
  static const sizeH3 = 24.0;
  static const sizeH4 = 20.0;
  static const sizeH5 = 18.0;
  static const sizeH6 = 16.0;
  static const sizeBodyLarge = 16.0;
  static const sizeBody = 14.0;
  static const sizeBodySmall = 12.0;
  static const sizeCaption = 11.0;
}

abstract final class DsSpacing {
  static const s0 = 0.0;
  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s3 = 12.0;
  static const s4 = 16.0;
  static const s5 = 20.0;
  static const s6 = 24.0;
  static const s8 = 32.0;
  static const s10 = 40.0;
  static const s12 = 48.0;
  static const s16 = 64.0;
  static const s20 = 80.0;
  static const s24 = 96.0;
}

abstract final class DsRadius {
  static const none = 0.0;
  static const sm = 4.0;
  static const md = 8.0;
  static const lg = 12.0;
  static const xl = 16.0;
  static const xl2 = 24.0;
  static const full = 9999.0;
}

abstract final class DsZIndex {
  static const base = 0;
  static const raised = 10;
  static const dropdown = 100;
  static const sticky = 200;
  static const overlay = 400;
  static const modal = 500;
  static const toast = 600;
  static const tooltip = 700;
}

abstract final class DsMotion {
  static const instant = Duration(milliseconds: 0);
  static const fast = Duration(milliseconds: 120);
  static const normal = Duration(milliseconds: 200);
  static const slow = Duration(milliseconds: 320);
  static const deliberate = Duration(milliseconds: 480);
  static const standard = Cubic(0.2, 0, 0, 1);
  static const enter = Cubic(0, 0, 0.2, 1);
  static const exit = Cubic(0.4, 0, 1, 1);
  static const emphasized = Cubic(0.2, 0.8, 0.2, 1);
  static const stagger = Duration(milliseconds: 55);
}
