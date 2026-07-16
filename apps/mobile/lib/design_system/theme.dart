import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tokens_generated.dart';

class AppThemeController extends ChangeNotifier {
  static const _storageKey = 'fev-theme';

  ThemeMode _mode = ThemeMode.dark;
  ThemeMode get mode => _mode;

  Future<void> load() async {
    try {
      final value =
          (await SharedPreferences.getInstance()).getString(_storageKey);
      _mode = value == 'light' ? ThemeMode.light : ThemeMode.dark;
      notifyListeners();
    } catch (_) {
      _mode = ThemeMode.dark;
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    _mode = mode;
    notifyListeners();
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(
          _storageKey, mode == ThemeMode.light ? 'light' : 'dark');
    } catch (_) {
      // Persistence is best-effort; the active in-memory theme remains valid.
    }
  }

  Future<void> toggle() =>
      setMode(_mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
}

class AppThemeScope extends InheritedNotifier<AppThemeController> {
  const AppThemeScope({
    required AppThemeController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static AppThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppThemeScope>();
    assert(scope != null, 'AppThemeScope is required');
    return scope!.notifier!;
  }
}

abstract final class AppThemes {
  static ThemeData get dark => _build(brightness: Brightness.dark);
  static ThemeData get light => _build(brightness: Brightness.light);

  static ThemeData _build({required Brightness brightness}) {
    final foundation = ThemeData(brightness: brightness, useMaterial3: true);
    final dark = brightness == Brightness.dark;
    final background =
        dark ? DsColors.darkBackground : DsColors.lightBackground;
    final surface = dark ? DsColors.darkSurface : DsColors.lightSurface;
    final elevated = dark ? DsColors.darkElevated : DsColors.lightElevated;
    final border = dark ? DsColors.darkBorder : DsColors.lightBorder;
    final textPrimary =
        dark ? DsColors.darkTextPrimary : DsColors.lightTextPrimary;
    final textSecondary =
        dark ? DsColors.darkTextSecondary : DsColors.lightTextSecondary;
    final baseTextTheme = foundation.textTheme.apply(
      fontFamily: DsTypography.sans,
      bodyColor: textPrimary,
      displayColor: textPrimary,
    );
    final textTheme = baseTextTheme.copyWith(
      displayLarge: TextStyle(
        fontFamily: DsTypography.sans,
        fontSize: DsTypography.sizeDisplay,
        fontWeight: FontWeight.w700,
        height: 1.15,
        color: textPrimary,
      ),
      headlineLarge: TextStyle(
        fontFamily: DsTypography.sans,
        fontSize: DsTypography.sizeH1,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontFamily: DsTypography.sans,
        fontSize: DsTypography.sizeH2,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: textPrimary,
      ),
      headlineSmall: TextStyle(
        fontFamily: DsTypography.sans,
        fontSize: DsTypography.sizeH3,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontFamily: DsTypography.sans,
        fontSize: DsTypography.sizeH4,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontFamily: DsTypography.sans,
        fontSize: DsTypography.sizeH5,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleSmall: TextStyle(
        fontFamily: DsTypography.sans,
        fontSize: DsTypography.sizeH6,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: DsTypography.sans,
        fontSize: DsTypography.sizeBodyLarge,
        height: 1.5,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: DsTypography.sans,
        fontSize: DsTypography.sizeBody,
        height: 1.5,
        color: textSecondary,
      ),
      bodySmall: TextStyle(
        fontFamily: DsTypography.sans,
        fontSize: DsTypography.sizeBodySmall,
        height: 1.5,
        color: textSecondary,
      ),
      labelSmall: TextStyle(
        fontFamily: DsTypography.sans,
        fontSize: DsTypography.sizeCaption,
        fontWeight: FontWeight.w600,
        color: textSecondary,
      ),
    );

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: DsColors.primary500,
      onPrimary: Colors.white,
      secondary: DsColors.accent500,
      onSecondary: Colors.white,
      error: DsColors.statusCritical,
      onError: Colors.white,
      surface: surface,
      onSurface: textPrimary,
    );
    final outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(DsRadius.md),
      borderSide: BorderSide(color: border),
    );

    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      cardTheme: foundation.cardTheme.copyWith(
        color: surface,
        elevation: 4,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DsRadius.xl),
          side: BorderSide(color: border),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: background,
        border: outline,
        enabledBorder: outline,
        focusedBorder: outline.copyWith(
          borderSide: const BorderSide(color: DsColors.primary400, width: 2),
        ),
        errorBorder: outline.copyWith(
          borderSide: const BorderSide(color: DsColors.statusCritical),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DsSpacing.s4,
          vertical: DsSpacing.s3,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DsRadius.lg),
          ),
          textStyle:
              textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      tabBarTheme: foundation.tabBarTheme.copyWith(
        indicatorColor: DsColors.primary500,
        labelColor: DsColors.primary400,
        unselectedLabelColor: textSecondary,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: elevated,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DsRadius.lg),
        ),
      ),
      dividerColor: border,
      extensions: <ThemeExtension<dynamic>>[
        AppSemanticColors(
          elevated: elevated,
          border: border,
          textSecondary: textSecondary,
          textMuted: dark ? DsColors.darkTextMuted : DsColors.lightTextMuted,
        ),
      ],
    );
  }

  static TextStyle mono(BuildContext context) => TextStyle(
        fontFamily: DsTypography.mono,
        fontSize: DsTypography.sizeBodySmall,
        color: Theme.of(context).colorScheme.onSurface,
      );
}

@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.elevated,
    required this.border,
    required this.textSecondary,
    required this.textMuted,
  });

  final Color elevated;
  final Color border;
  final Color textSecondary;
  final Color textMuted;

  @override
  AppSemanticColors copyWith({
    Color? elevated,
    Color? border,
    Color? textSecondary,
    Color? textMuted,
  }) =>
      AppSemanticColors(
        elevated: elevated ?? this.elevated,
        border: border ?? this.border,
        textSecondary: textSecondary ?? this.textSecondary,
        textMuted: textMuted ?? this.textMuted,
      );

  @override
  AppSemanticColors lerp(covariant AppSemanticColors? other, double t) {
    if (other == null) return this;
    return AppSemanticColors(
      elevated: Color.lerp(elevated, other.elevated, t)!,
      border: Color.lerp(border, other.border, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppSemanticColors get semantic =>
      Theme.of(this).extension<AppSemanticColors>()!;
}
