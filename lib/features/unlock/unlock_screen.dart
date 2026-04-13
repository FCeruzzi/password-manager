import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kdbx/kdbx.dart';
import 'package:password_manager/l10n/app_localizations.dart';
import '../../core/auth/auth_service.dart';
import '../../core/auth/auto_lock_manager.dart';
import '../../core/kdbx/kdbx_service.dart';
import '../../core/providers/settings_provider.dart';

class UnlockScreen extends ConsumerStatefulWidget {
  const UnlockScreen({super.key});

  @override
  ConsumerState<UnlockScreen> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends ConsumerState<UnlockScreen> {
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryBiometricUnlock();
    });
  }

  Future<void> _tryBiometricUnlock() async {
    final authService = ref.read(authServiceProvider);
    final biometricEnabled = ref.read(biometricEnabledProvider);

    if (!biometricEnabled) return;

    final available = await authService.isBiometricAvailable();
    if (!available) return;

    final storedPassword = await authService.getStoredMasterPassword();
    if (storedPassword == null) return;

    final l10n = AppLocalizations.of(context)!;
    final authenticated = await authService.authenticateWithBiometric(
      localizedReason: l10n.biometricPromptSubtitle,
    );

    if (authenticated && mounted) {
      _unlockWithPassword(storedPassword);
    }
  }

  Future<void> _unlockWithPassword(String password) async {
    final kdbxService = ref.read(kdbxServiceProvider);

    if (!kdbxService.isOpen) {
      // No file open — go to vault selector
      if (mounted) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacementNamed('/vault');
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Re-open the file with credentials to verify password
      final filePath = kdbxService.currentFilePath;
      if (filePath != null) {
        final credentials = Credentials(ProtectedValue.fromString(password));
        await kdbxService.openFile(filePath: filePath, credentials: credentials);
      }

      ref.read(lockStateProvider.notifier).unlock();

      // Store for biometric quick unlock
      final biometricEnabled = ref.read(biometricEnabledProvider);
      if (biometricEnabled) {
        await ref.read(authServiceProvider).storeMasterPasswordForQuickUnlock(password);
      }
    } catch (e) {
      setState(() {
        _error = AppLocalizations.of(context)!.wrongPassword;
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_rounded,
                  size: 80,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.appTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.enterMasterPassword,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: l10n.masterPassword,
                    prefixIcon: const Icon(Icons.key),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    errorText: _error,
                  ),
                  onSubmitted: (_) => _unlockWithPassword(_passwordController.text),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: _isLoading
                        ? null
                        : () => _unlockWithPassword(_passwordController.text),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.unlock),
                  ),
                ),
                const SizedBox(height: 16),
                Consumer(
                  builder: (context, ref, _) {
                    final biometricEnabled = ref.watch(biometricEnabledProvider);
                    if (!biometricEnabled) return const SizedBox.shrink();
                    return IconButton(
                      icon: const Icon(Icons.fingerprint, size: 48),
                      onPressed: _tryBiometricUnlock,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
