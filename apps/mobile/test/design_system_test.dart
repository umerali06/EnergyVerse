import 'package:fev_mobile/design_system/motion.dart';
import 'package:fev_mobile/design_system/primitives.dart';
import 'package:fev_mobile/design_system/showcase.dart';
import 'package:fev_mobile/design_system/theme.dart';
import 'package:fev_mobile/design_system/tokens_generated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('dark and light ThemeData resolve the shared semantic tokens', () {
    expect(AppThemes.dark.brightness, Brightness.dark);
    expect(AppThemes.dark.scaffoldBackgroundColor, DsColors.darkBackground);
    expect(AppThemes.dark.colorScheme.primary, DsColors.primary500);
    expect(AppThemes.light.brightness, Brightness.light);
    expect(AppThemes.light.scaffoldBackgroundColor, DsColors.lightBackground);
    expect(
      AppThemes.dark.textTheme.displayLarge?.fontSize,
      DsTypography.sizeDisplay,
    );
  });

  testWidgets('renders primitive variants and accessible states',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.dark,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                AppButton(label: 'Primary', onPressed: () {}),
                AppButton(
                  label: 'Accent',
                  onPressed: () {},
                  variant: AppButtonVariant.accent,
                ),
                const AppButton(label: 'Disabled'),
                const AppButton(label: 'Saving', loading: true),
                const AppTextField(label: 'Asset name'),
                AppSelect<String>(
                  label: 'Status',
                  items: const [
                    DropdownMenuItem(value: 'healthy', child: Text('Healthy')),
                  ],
                  onChanged: (_) {},
                ),
                const AppCard(child: Text('Card content')),
                const AppBadge(label: 'Badge'),
                const StatusPill(
                  label: 'Critical',
                  status: AppStatus.critical,
                ),
                AppTabs(
                  labels: ['One'],
                  children: [Text('Panel one')],
                ),
                const AppSkeleton(height: 14),
                const AppLoader(label: 'Loading assets'),
                const EmptyState(title: 'Empty', description: 'Nothing here'),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Primary'), findsOneWidget);
    expect(find.text('Accent'), findsOneWidget);
    expect(find.byType(AppTextField), findsOneWidget);
    expect(find.byType(AppSkeleton), findsOneWidget);
    expect(find.text('Empty'), findsOneWidget);
    final primarySize =
        tester.getSize(find.widgetWithText(ElevatedButton, 'Primary'));
    expect(primarySize.height, greaterThanOrEqualTo(48));
    expect(
      tester.getSemantics(find.byType(StatusPill)).label,
      contains('Status: Critical'),
    );
  });

  testWidgets('modal and toast helpers render feedback', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.dark,
        home: Builder(
          builder: (context) => Scaffold(
            body: Column(
              children: [
                TextButton(
                  onPressed: () => showAppModal<void>(
                    context,
                    title: 'Confirm action',
                    child: const Text('Modal content'),
                  ),
                  child: const Text('Open'),
                ),
                TextButton(
                  onPressed: () => showAppToast(context, 'Saved'),
                  child: const Text('Toast'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Confirm action'), findsOneWidget);
    expect(find.text('Modal content'), findsOneWidget);
    Navigator.of(tester.element(find.text('Modal content'))).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Toast'));
    await tester.pump();
    expect(find.text('Saved'), findsOneWidget);
  });

  testWidgets('theme controller toggles and persists light mode',
      (tester) async {
    final controller = AppThemeController();
    await controller.load();
    expect(controller.mode, ThemeMode.dark);

    await controller.toggle();

    expect(controller.mode, ThemeMode.light);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('fev-theme'), 'light');
    controller.dispose();
  });

  testWidgets('reduced-motion disables stagger transition duration',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.dark,
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: const StaggeredReveal(index: 4, child: Text('Reduced item')),
        ),
      ),
    );
    await tester.pump();

    final opacity =
        tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity));
    expect(opacity.duration, Duration.zero);
    expect(opacity.opacity, 1);
  });

  testWidgets('dev showcase renders in dark and light themes', (tester) async {
    final controller = AppThemeController();
    await tester.pumpWidget(
      AppThemeScope(
        controller: controller,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) => MaterialApp(
            theme: AppThemes.light,
            darkTheme: AppThemes.dark,
            themeMode: controller.mode,
            themeAnimationDuration: Duration.zero,
            home: const DesignSystemShowcase(),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('FEV Design System'), findsOneWidget);
    expect(Theme.of(tester.element(find.text('FEV Design System'))).brightness,
        Brightness.dark);

    await controller.setMode(ThemeMode.light);
    await tester.pump(const Duration(milliseconds: 250));
    expect(Theme.of(tester.element(find.text('FEV Design System'))).brightness,
        Brightness.light);
    controller.dispose();
  });
}
