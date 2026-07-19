// GENERATED from packages/design-tokens/tokens.json. Do not edit.
import 'package:flutter/material.dart';

abstract final class DsColors {
  static const primary50 = Color(0xFFF1F6FE);
  static const primary100 = Color(0xFFDFEAFD);
  static const primary200 = Color(0xFFBDD4F7);
  static const primary300 = Color(0xFF95B7EC);
  static const primary400 = Color(0xFF6F99DC);
  static const primary500 = Color(0xFF4D7BC5);
  static const primary600 = Color(0xFF3160AA);
  static const primary700 = Color(0xFF17468E);
  static const primary800 = Color(0xFF002865);
  static const primary900 = Color(0xFF001A49);
  static const accent50 = Color(0xFFFFF2EE);
  static const accent100 = Color(0xFFFEE0D8);
  static const accent200 = Color(0xFFFBC1B2);
  static const accent300 = Color(0xFFF59E87);
  static const accent400 = Color(0xFFEE7A5C);
  static const accent500 = Color(0xFFFB4402);
  static const accent600 = Color(0xFFC93B12);
  static const accent700 = Color(0xFFA62B03);
  static const accent800 = Color(0xFF841F01);
  static const accent900 = Color(0xFF661802);
  static const statusSuccess = Color(0xFF1B9E4B);
  static const statusWarning = Color(0xFFE8A317);
  static const statusCritical = Color(0xFFC1123F);
  static const statusInfo = Color(0xFF6F99DC);
  static const statusStrongSuccess = Color(0xFF15803D);
  static const statusStrongWarning = Color(0xFF8A5A00);
  static const statusStrongCritical = Color(0xFFC1123F);
  static const statusStrongInfo = Color(0xFF2F5FA9);
  static const statusSoftSuccess = Color(0xFF57C983);
  static const statusSoftWarning = Color(0xFFEFAF3D);
  static const statusSoftCritical = Color(0xFFF26D84);
  static const statusSoftInfo = Color(0xFF7FA6E3);
  static const darkBackground = Color(0xFF040E20);
  static const darkSurface = Color(0xFF0A182E);
  static const darkElevated = Color(0xFF13223B);
  static const darkBorder = Color(0xFF21334F);
  static const darkTextPrimary = Color(0xFFF7F9FD);
  static const darkTextSecondary = Color(0xFFC6D0E2);
  static const darkTextMuted = Color(0xFF8C9CB8);
  static const lightBackground = Color(0xFFF7F9FC);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightElevated = Color(0xFFE3E8F0);
  static const lightBorder = Color(0xFFC6CEDB);
  static const lightTextPrimary = Color(0xFF011C49);
  static const lightTextSecondary = Color(0xFF2B4267);
  static const lightTextMuted = Color(0xFF54647D);
}

abstract final class DsTypography {
  static const heading = 'Space Grotesk';
  static const sans = 'IBM Plex Sans';
  static const mono = 'IBM Plex Mono';
  static const sizeDisplay = 40.0;
  static const sizeH1 = 30.0;
  static const sizeH2 = 24.0;
  static const sizeH3 = 20.0;
  static const sizeH4 = 17.0;
  static const sizeH5 = 15.0;
  static const sizeH6 = 13.0;
  static const sizeBodyLarge = 15.0;
  static const sizeBody = 13.0;
  static const sizeBodySmall = 12.0;
  static const sizeCaption = 11.0;
  static const sizeMicro = 10.0;
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
  static const sm = 2.0;
  static const md = 4.0;
  static const lg = 6.0;
  static const xl = 10.0;
  static const xl2 = 14.0;
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
  static const normal = Duration(milliseconds: 180);
  static const slow = Duration(milliseconds: 240);
  static const deliberate = Duration(milliseconds: 320);
  static const standard = Cubic(0.16, 1, 0.3, 1);
  static const enter = Cubic(0.16, 1, 0.3, 1);
  static const exit = Cubic(0.7, 0, 0.84, 0);
  static const emphasized = Cubic(0.16, 1, 0.3, 1);
  static const stagger = Duration(milliseconds: 55);
}
