import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kdbx/kdbx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:password_manager/l10n/app_localizations.dart';
import '../../core/auth/auth_service.dart';
import '../../core/auth/auto_lock_manager.dart';
import '../../core/crypto/password_generator.dart';
import '../../core/kdbx/kdbx_service.dart';
import '../../core/providers/settings_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  static const _totalPages = 5;

  // Page 3: Create password
  final _nameController = TextEditingController(text: 'Passwords');
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  String? _passwordError;

  // Page 4: Biometric
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;

  // Page 5: Complete
  bool _isCreating = false;
  String? _masterPassword;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
    _confirmController.addListener(_onPasswordChanged);
    _checkBiometric();
  }

  void _onPasswordChanged() {
    setState(() {
      _passwordError = null;
    });
  }

  Future<void> _checkBiometric() async {
    final authService = ref.read(authServiceProvider);
    final available = await authService.isBiometricAvailable();
    if (mounted) {
      setState(() => _biometricAvailable = available);
    }
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  bool _validatePassword() {
    final l10n = AppLocalizations.of(context)!;
    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = l10n.enterMasterPassword);
      return false;
    }
    if (_passwordController.text != _confirmController.text) {
      setState(() => _passwordError = l10n.passwordsDoNotMatch);
      return false;
    }
    final strength = PasswordGenerator.calculateStrength(_passwordController.text);
    if (strength < 1) {
      setState(() => _passwordError = l10n.weak);
      return false;
    }
    return true;
  }

  Future<void> _onPasswordStepDone() async {
    if (!_validatePassword()) return;
    _masterPassword = _passwordController.text;

    if (_biometricAvailable) {
      _goToPage(3);
    } else {
      await _createDatabaseAndFinish();
    }
  }

  Future<void> _enableBiometric() async {
    final l10n = AppLocalizations.of(context)!;
    final authService = ref.read(authServiceProvider);

    final authenticated = await authService.authenticateWithBiometric(
      localizedReason: l10n.biometricPromptSubtitle,
    );

    if (!mounted) return;

    if (authenticated) {
      if (_masterPassword != null) {
        await authService.storeMasterPasswordForQuickUnlock(_masterPassword!);
      }
      ref.read(biometricEnabledProvider.notifier).setEnabled(true);
      setState(() => _biometricEnabled = true);
      await _createDatabaseAndFinish();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.biometricFailed)),
      );
    }
  }

  Future<void> _skipBiometric() async {
    await _createDatabaseAndFinish();
  }

  Future<void> _createDatabaseAndFinish() async {
    if (_isCreating) return;
    setState(() => _isCreating = true);

    try {
      final kdbxService = ref.read(kdbxServiceProvider);
      final credentials = Credentials(
        ProtectedValue.fromString(_masterPassword!),
      );

      final dir = await getApplicationDocumentsDirectory();
      final filePath = p.join(dir.path, '${_nameController.text}.kdbx');

      await kdbxService.create(
        name: _nameController.text,
        credentials: credentials,
        filePath: filePath,
      );

      ref.read(recentFilesProvider.notifier).addFile(filePath);
      ref.read(onboardingCompleteProvider.notifier).setComplete();
      ref.read(lockStateProvider.notifier).unlock();

      _goToPage(4);
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: $e')),
        );
        setState(() => _isCreating = false);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _WelcomePage(onNext: () => _goToPage(1)),
                  _MasterPasswordInfoPage(onNext: () => _goToPage(2)),
                  _CreatePasswordPage(
                    nameController: _nameController,
                    passwordController: _passwordController,
                    confirmController: _confirmController,
                    obscurePassword: _obscurePassword,
                    onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                    error: _passwordError,
                    onDone: _onPasswordStepDone,
                  ),
                  _BiometricSetupPage(
                    available: _biometricAvailable,
                    enabled: _biometricEnabled,
                    onEnable: _enableBiometric,
                    onSkip: _skipBiometric,
                    isCreating: _isCreating,
                  ),
                  _CompletePage(
                    onGo: () => context.go('/home'),
                  ),
                ],
              ),
            ),
            _DotIndicator(
              current: _currentPage,
              total: _totalPages,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Page 1: Welcome ──────────────────────────────────────────────

class _WelcomePage extends StatelessWidget {
  final VoidCallback onNext;
  const _WelcomePage({required this.onNext});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icon/app_icon.png', width: 100, height: 100),
          const SizedBox(height: 32),
          Text(
            l10n.welcomeTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.welcomeSubtitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.welcomeDescription,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          FilledButton.icon(
            onPressed: onNext,
            icon: const Icon(Icons.arrow_forward),
            label: Text(l10n.getStarted),
            style: FilledButton.styleFrom(
              minimumSize: const Size(200, 48),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Page 2: Master Password Explanation ──────────────────────────

class _MasterPasswordInfoPage extends StatelessWidget {
  final VoidCallback onNext;
  const _MasterPasswordInfoPage({required this.onNext});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.key_rounded, size: 80, color: colorScheme.primary),
          const SizedBox(height: 32),
          Text(
            l10n.masterPasswordExplanationTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            l10n.masterPasswordExplanation,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            color: colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                    color: colorScheme.onErrorContainer, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.masterPasswordWarning,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          FilledButton.icon(
            onPressed: onNext,
            icon: const Icon(Icons.arrow_forward),
            label: Text(l10n.next),
            style: FilledButton.styleFrom(
              minimumSize: const Size(200, 48),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Page 3: Create Password ──────────────────────────────────────

class _CreatePasswordPage extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final String? error;
  final VoidCallback onDone;

  const _CreatePasswordPage({
    required this.nameController,
    required this.passwordController,
    required this.confirmController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.error,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final password = passwordController.text;
    final strength = PasswordGenerator.calculateStrength(password);
    final strengthColors = [
      Colors.red, Colors.orange, Colors.yellow.shade700,
      Colors.lightGreen, Colors.green,
    ];
    final strengthLabels = [
      l10n.weak, l10n.fair, 'Buona', l10n.strong, l10n.veryStrong,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Icon(Icons.lock_open_rounded, size: 64, color: colorScheme.primary),
          const SizedBox(height: 20),
          Text(
            l10n.createYourPassword,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: l10n.databaseName,
              prefixIcon: const Icon(Icons.storage),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: passwordController,
            obscureText: obscurePassword,
            decoration: InputDecoration(
              labelText: l10n.masterPassword,
              prefixIcon: const Icon(Icons.key),
              suffixIcon: IconButton(
                icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                onPressed: onToggleObscure,
              ),
            ),
          ),
          if (password.isNotEmpty) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (strength + 1) / 5,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation(strengthColors[strength]),
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 4),
            Text(
              '${l10n.passwordStrength}: ${strengthLabels[strength]}',
              style: TextStyle(
                color: strengthColors[strength],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 20),
          TextField(
            controller: confirmController,
            obscureText: obscurePassword,
            decoration: InputDecoration(
              labelText: l10n.confirmMasterPassword,
              prefixIcon: const Icon(Icons.key),
              errorText: error,
            ),
            onSubmitted: (_) => onDone(),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: onDone,
            icon: const Icon(Icons.arrow_forward),
            label: Text(l10n.next),
            style: FilledButton.styleFrom(
              minimumSize: const Size(200, 48),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Page 4: Biometric Setup ──────────────────────────────────────

class _BiometricSetupPage extends StatelessWidget {
  final bool available;
  final bool enabled;
  final VoidCallback onEnable;
  final VoidCallback onSkip;
  final bool isCreating;

  const _BiometricSetupPage({
    required this.available,
    required this.enabled,
    required this.onEnable,
    required this.onSkip,
    required this.isCreating,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            enabled ? Icons.fingerprint : Icons.fingerprint,
            size: 80,
            color: enabled ? Colors.green : colorScheme.primary,
          ),
          const SizedBox(height: 32),
          Text(
            l10n.onboardingBiometricTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.onboardingBiometricDescription,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          if (isCreating)
            const CircularProgressIndicator()
          else if (enabled)
            Icon(Icons.check_circle, size: 48, color: Colors.green)
          else ...[
            FilledButton.icon(
              onPressed: onEnable,
              icon: const Icon(Icons.fingerprint),
              label: Text(l10n.enableBiometric),
              style: FilledButton.styleFrom(
                minimumSize: const Size(200, 48),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onSkip,
              child: Text(l10n.skipForNow),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Page 5: Complete ─────────────────────────────────────────────

class _CompletePage extends StatelessWidget {
  final VoidCallback onGo;
  const _CompletePage({required this.onGo});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline_rounded,
            size: 100, color: Colors.green.shade600),
          const SizedBox(height: 32),
          Text(
            l10n.onboardingCompleteTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.onboardingCompleteDescription,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          FilledButton.icon(
            onPressed: onGo,
            icon: const Icon(Icons.arrow_forward),
            label: Text(l10n.letsGo),
            style: FilledButton.styleFrom(
              minimumSize: const Size(200, 48),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Dot Indicator ────────────────────────────────────────────────

class _DotIndicator extends StatelessWidget {
  final int current;
  final int total;
  const _DotIndicator({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? colorScheme.primary : colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
