import 'dart:async';

import 'package:flutter/material.dart';

import '../design_system/motion.dart';
import '../design_system/primitives.dart';
import '../design_system/tokens_generated.dart';
import 'app_routes.dart';
import 'auth_controller.dart';

final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
const _resetCooldown = Duration(seconds: 60);

void _backToLogin(BuildContext context) =>
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);

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
                            Text(
                              'Welcome back',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
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
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  key: const Key('open-forgot-password'),
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed(AppRoutes.forgotPassword),
                                  child: const Text('Forgot password?'),
                                ),
                                TextButton(
                                  key: const Key('open-signup'),
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed(AppRoutes.signup),
                                  child: const Text('Sign up'),
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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  String? _emailError;
  bool _sent = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _email.dispose();
    super.dispose();
  }

  int _cooldownSeconds(AuthController auth) {
    final sentAt = auth.passwordResetSentAt;
    if (sentAt == null) return 0;
    final remaining = _resetCooldown - DateTime.now().difference(sentAt);
    return remaining.isNegative ? 0 : remaining.inSeconds + 1;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _send() async {
    final auth = AuthProvider.of(context);
    final email = _email.text.trim();
    setState(() {
      _emailError = email.isEmpty
          ? 'Email is required'
          : !_emailPattern.hasMatch(email)
              ? 'Enter a valid email address'
              : null;
    });
    if (_emailError != null ||
        auth.status == AuthStatus.sendingPasswordReset ||
        (_sent && _cooldownSeconds(auth) > 0)) {
      return;
    }
    if (await auth.sendPasswordReset(email) && mounted) {
      setState(() => _sent = true);
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    final loading = auth.status == AuthStatus.sendingPasswordReset;
    final cooldown = _cooldownSeconds(auth);
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _Wordmark(),
                          const SizedBox(height: DsSpacing.s6),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: StatusPill(
                              label: _sent
                                  ? 'Check your inbox'
                                  : 'Account recovery',
                              status:
                                  _sent ? AppStatus.healthy : AppStatus.info,
                            ),
                          ),
                          const SizedBox(height: DsSpacing.s4),
                          Text(
                            _sent ? 'Reset link requested' : 'Forgot password',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: DsSpacing.s3),
                          if (_sent) ...[
                            Semantics(
                              liveRegion: true,
                              child: const Text(
                                'If an account exists for that email, a reset link has been sent.',
                              ),
                            ),
                            const SizedBox(height: DsSpacing.s3),
                            const Text(
                              "Complete the password change in Firebase's secure hosted flow.",
                            ),
                          ] else ...[
                            const Text(
                              "Enter your email and we'll request a secure Firebase reset link.",
                            ),
                            const SizedBox(height: DsSpacing.s6),
                            AppTextField(
                              key: const Key('forgot-email'),
                              label: 'Email',
                              controller: _email,
                              enabled: !loading,
                              errorText: _emailError,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              onSubmitted: (_) => _send(),
                            ),
                          ],
                          if (auth.error != null) ...[
                            const SizedBox(height: DsSpacing.s4),
                            Semantics(
                              liveRegion: true,
                              child: Text(
                                auth.error!,
                                style: const TextStyle(
                                  color: DsColors.statusCritical,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: DsSpacing.s6),
                          AppButton(
                            label: _sent
                                ? cooldown > 0
                                    ? 'Resend available in ${cooldown}s'
                                    : 'Resend reset link'
                                : 'Send reset link',
                            loading: loading,
                            variant: _sent
                                ? AppButtonVariant.ghost
                                : AppButtonVariant.primary,
                            onPressed: loading || (_sent && cooldown > 0)
                                ? null
                                : _send,
                          ),
                          const SizedBox(height: DsSpacing.s3),
                          TextButton(
                            onPressed:
                                loading ? null : () => _backToLogin(context),
                            child: const Text('Back to login'),
                          ),
                        ],
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

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _company = TextEditingController();
  final _displayName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final Map<String, String> _errors = {};
  bool _showPassword = false;

  @override
  void dispose() {
    _company.dispose();
    _displayName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final password = _password.text;
    setState(() {
      _errors
        ..clear()
        ..addAll({
          if (_company.text.trim().isEmpty)
            'company': 'Company name is required',
          if (_displayName.text.trim().isEmpty)
            'displayName': 'Display name is required',
          if (_email.text.trim().isEmpty)
            'email': 'Email is required'
          else if (!_emailPattern.hasMatch(_email.text.trim()))
            'email': 'Enter a valid email address',
          if (password.length < 8 ||
              !RegExp(r'[A-Z]').hasMatch(password) ||
              !RegExp(r'[a-z]').hasMatch(password) ||
              !RegExp(r'\d').hasMatch(password))
            'password': 'Use 8+ characters with upper, lower, and a number',
          if (_confirmPassword.text != password)
            'confirm': 'Passwords do not match',
        });
    });
    if (_errors.isNotEmpty) return;
    await AuthProvider.of(context).register(
      RegistrationInput(
        companyName: _company.text.trim(),
        displayName: _displayName.text.trim(),
        email: _email.text.trim(),
        password: password,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    final loading = auth.status == AuthStatus.signingUp;
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _IndustrialBackdrop()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(DsSpacing.s6),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: AppCard(
                    padding: const EdgeInsets.all(DsSpacing.s8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _Wordmark(),
                        const SizedBox(height: DsSpacing.s6),
                        Text(
                          'Create your organization',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: DsSpacing.s2),
                        const Text(
                          'Your first account becomes the Company Admin.',
                        ),
                        const SizedBox(height: DsSpacing.s6),
                        AppTextField(
                          key: const Key('signup-company'),
                          label: 'Company name',
                          controller: _company,
                          enabled: !loading,
                          errorText: _errors['company'],
                        ),
                        const SizedBox(height: DsSpacing.s4),
                        AppTextField(
                          key: const Key('signup-display-name'),
                          label: 'Display name',
                          controller: _displayName,
                          enabled: !loading,
                          errorText: _errors['displayName'],
                        ),
                        const SizedBox(height: DsSpacing.s4),
                        AppTextField(
                          key: const Key('signup-email'),
                          label: 'Email',
                          controller: _email,
                          enabled: !loading,
                          errorText: _errors['email'],
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: DsSpacing.s4),
                        AppTextField(
                          key: const Key('signup-password'),
                          label: 'Password',
                          controller: _password,
                          enabled: !loading,
                          errorText: _errors['password'],
                          obscureText: !_showPassword,
                          suffixIcon: IconButton(
                            onPressed: loading
                                ? null
                                : () => setState(
                                      () => _showPassword = !_showPassword,
                                    ),
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                        const SizedBox(height: DsSpacing.s4),
                        AppTextField(
                          key: const Key('signup-confirm-password'),
                          label: 'Confirm password',
                          controller: _confirmPassword,
                          enabled: !loading,
                          errorText: _errors['confirm'],
                          obscureText: !_showPassword,
                        ),
                        const SizedBox(height: DsSpacing.s6),
                        AppButton(
                          label: 'Create organization',
                          loading: loading,
                          onPressed: loading ? null : _submit,
                        ),
                        const SizedBox(height: DsSpacing.s3),
                        TextButton(
                          onPressed:
                              loading ? null : () => _backToLogin(context),
                          child: const Text('Back to login'),
                        ),
                      ],
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

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    final checking = auth.status == AuthStatus.checkingVerification;
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _IndustrialBackdrop()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(DsSpacing.s6),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: AppCard(
                    padding: const EdgeInsets.all(DsSpacing.s8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _Wordmark(),
                        const SizedBox(height: DsSpacing.s8),
                        const Icon(
                          Icons.mark_email_unread_outlined,
                          size: 52,
                          color: DsColors.primary500,
                        ),
                        const SizedBox(height: DsSpacing.s4),
                        Text(
                          'Verify your email',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: DsSpacing.s3),
                        Text(
                          'We sent a verification link to ${auth.currentUser?.email ?? 'your email'}. Open it, then continue.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: DsSpacing.s6),
                        AppButton(
                          label: "I've verified — continue",
                          loading: checking,
                          onPressed: checking ? null : auth.refreshVerification,
                        ),
                        const SizedBox(height: DsSpacing.s3),
                        AppButton(
                          label: auth.verificationResendAvailable
                              ? 'Resend verification'
                              : 'Verification email sent',
                          variant: AppButtonVariant.ghost,
                          onPressed: auth.verificationResendAvailable
                              ? auth.resendVerification
                              : null,
                        ),
                        const SizedBox(height: DsSpacing.s3),
                        TextButton(
                          // Signing out flips the guard, which redirects to
                          // login and clears the navigation stack.
                          onPressed: checking ? null : auth.signOut,
                          child: const Text('Back to login'),
                        ),
                      ],
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
                Text(
                  'Flacron EnergyVerse',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'FIELD OPERATIONS INTELLIGENCE',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
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
                  Text(
                    'UID: ${user.uid}',
                    style: const TextStyle(fontFamily: 'JetBrains Mono'),
                  ),
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
                  Text(
                    'Session',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: DsSpacing.s2),
                  const Text(
                    'Open the permission-gated demo area, or refresh the '
                    'session to pick up server-side role changes.',
                  ),
                  const SizedBox(height: DsSpacing.s4),
                  Wrap(
                    spacing: DsSpacing.s3,
                    runSpacing: DsSpacing.s3,
                    children: [
                      AppButton(
                        key: const Key('open-rbac-demo'),
                        label: 'Assets demo',
                        variant: AppButtonVariant.ghost,
                        onPressed: () => Navigator.of(context)
                            .pushNamed(AppRoutes.rbacDemo),
                      ),
                      AppButton(
                        key: const Key('refresh-session'),
                        label: 'Refresh session',
                        variant: AppButtonVariant.ghost,
                        onPressed: auth.refreshSession,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: DsSpacing.s6),
          StaggeredReveal(
            index: 3,
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resolved permissions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: DsSpacing.s2),
                  const Text(
                    'Authoritative permissions returned by /api/v1/auth/me.',
                  ),
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

class RbacDemoScreen extends StatelessWidget {
  const RbacDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assets demo')),
      body: ListView(
        padding: const EdgeInsets.all(DsSpacing.s6),
        children: [
          StaggeredReveal(
            index: 0,
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StatusPill(
                    label: 'Access granted',
                    status: AppStatus.healthy,
                  ),
                  const SizedBox(height: DsSpacing.s4),
                  Text(
                    'Assets demo',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: DsSpacing.s3),
                  const Text(
                    'This page requires the assets.write permission. The '
                    'client gate mirrors the authoritative FastAPI '
                    'require_permission dependency on /api/v1/_rbac-demo/single.',
                  ),
                  const SizedBox(height: DsSpacing.s5),
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil(AppRoutes.home, (_) => false),
                    child: const Text('Back to Home'),
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
