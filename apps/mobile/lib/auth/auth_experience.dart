import 'package:flutter/material.dart';

import '../design_system/motion.dart';
import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';
import 'auth_controller.dart';

final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

class AuthExperience extends StatelessWidget {
  const AuthExperience({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    return switch (auth.status) {
      AuthStatus.restoring => const Scaffold(
          body: Center(child: AppLoader(label: 'Restoring session')),
        ),
      AuthStatus.authenticated when auth.currentUser != null =>
        const AuthenticatedHome(),
      _ => const LoginScreen(),
    };
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _emailError;
  String? _passwordError;
  bool _showPassword = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    setState(() {
      _emailError = email.isEmpty
          ? 'Email is required'
          : !_emailPattern.hasMatch(email)
              ? 'Enter a valid email address'
              : null;
      _passwordError = _password.text.isEmpty ? 'Password is required' : null;
    });
    if (_emailError != null || _passwordError != null) return;
    await AuthProvider.of(context).signIn(email, _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    final loading = auth.status == AuthStatus.signingIn;
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _IndustrialBackdrop()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(DsSpacing.s6),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: StaggeredReveal(
                    index: 0,
                    child: AppCard(
                      padding: const EdgeInsets.all(DsSpacing.s8),
                      child: AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const _Wordmark(),
                            const SizedBox(height: DsSpacing.s8),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: StatusPill(
                                label: 'Secure access',
                                status: AppStatus.info,
                              ),
                            ),
                            const SizedBox(height: DsSpacing.s4),
                            Text('Welcome back',
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                            const SizedBox(height: DsSpacing.s2),
                            Text(
                              'Sign in with your company-issued account.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: DsSpacing.s6),
                            AppTextField(
                              key: const Key('login-email'),
                              label: 'Email',
                              hint: 'name@company.com',
                              controller: _email,
                              enabled: !loading,
                              errorText: _emailError,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: DsSpacing.s5),
                            AppTextField(
                              key: const Key('login-password'),
                              label: 'Password',
                              hint: 'Enter your password',
                              controller: _password,
                              enabled: !loading,
                              errorText: _passwordError,
                              obscureText: !_showPassword,
                              autofillHints: const [AutofillHints.password],
                              onSubmitted: (_) => _submit(),
                              suffixIcon: IconButton(
                                onPressed: loading
                                    ? null
                                    : () => setState(
                                          () => _showPassword = !_showPassword,
                                        ),
                                icon: Icon(_showPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                                tooltip: _showPassword
                                    ? 'Hide password'
                                    : 'Show password',
                              ),
                            ),
                            if (auth.error != null) ...[
                              const SizedBox(height: DsSpacing.s4),
                              Semantics(
                                liveRegion: true,
                                child: Text(
                                  auth.error!,
                                  key: const Key('login-error'),
                                  style: const TextStyle(
                                    color: DsColors.statusCritical,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: DsSpacing.s6),
                            AppButton(
                              label: 'Login',
                              loading: loading,
                              onPressed: loading ? null : _submit,
                            ),
                            const SizedBox(height: DsSpacing.s5),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: null,
                                  child: Text('Forgot password?'),
                                ),
                                TextButton(
                                  onPressed: null,
                                  child: Text('Sign up'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IndustrialBackdrop extends StatelessWidget {
  const _IndustrialBackdrop();

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.8, -0.8),
            radius: 1.35,
            colors: [
              DsColors.primary500.withAlpha(48),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
      );
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: DsColors.primary500,
              borderRadius: BorderRadius.circular(DsRadius.lg),
            ),
            child: const Text(
              'F',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'JetBrains Mono',
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: DsSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Flacron EnergyVerse',
                    style: Theme.of(context).textTheme.titleLarge),
                Text('FIELD OPERATIONS INTELLIGENCE',
                    style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
        ],
      );
}

class AuthenticatedHome extends StatelessWidget {
  const AuthenticatedHome({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    final user = auth.currentUser!;
    final name = user.email.split('@').first.replaceAll(RegExp(r'[._-]+'), ' ');
    final permissions = user.permissions.toList()..sort();
    return Scaffold(
      appBar: AppBar(
        title: const Text('FEV Field App'),
        actions: [
          TextButton.icon(
            onPressed: auth.signOut,
            icon: const Icon(Icons.logout),
            label: const Text('Sign out'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(DsSpacing.s6),
        children: [
          StaggeredReveal(
            index: 0,
            child: Text(
              'Welcome, $name',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: DsSpacing.s2),
          Text(user.email, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: DsSpacing.s6),
          StaggeredReveal(
            index: 1,
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StatusPill(
                    label: 'Authenticated',
                    status: AppStatus.healthy,
                  ),
                  const SizedBox(height: DsSpacing.s5),
                  Text('Role: ${user.roleKey}', key: const Key('home-role')),
                  const SizedBox(height: DsSpacing.s2),
                  Text('Company: ${user.companyId}'),
                  const SizedBox(height: DsSpacing.s2),
                  Text('UID: ${user.uid}',
                      style: const TextStyle(fontFamily: 'JetBrains Mono')),
                ],
              ),
            ),
          ),
          const SizedBox(height: DsSpacing.s6),
          StaggeredReveal(
            index: 2,
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Resolved permissions',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: DsSpacing.s2),
                  const Text(
                      'Authoritative permissions returned by /api/v1/auth/me.'),
                  const SizedBox(height: DsSpacing.s4),
                  Wrap(
                    spacing: DsSpacing.s2,
                    runSpacing: DsSpacing.s2,
                    children: permissions
                        .map((permission) => AppBadge(label: permission))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
