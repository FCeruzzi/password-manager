import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:kdbx/kdbx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:password_manager/l10n/app_localizations.dart';
import '../../core/auth/auth_service.dart';
import '../../core/auth/auto_lock_manager.dart';
import '../../core/kdbx/kdbx_service.dart';
import '../../core/providers/settings_provider.dart';

class VaultSelectorScreen extends ConsumerStatefulWidget {
  const VaultSelectorScreen({super.key});

  @override
  ConsumerState<VaultSelectorScreen> createState() => _VaultSelectorScreenState();
}

class _VaultSelectorScreenState extends ConsumerState<VaultSelectorScreen> {
  bool _isLoading = false;

  Future<void> _createNewDatabase() async {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: 'Passwords');
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CreateDatabaseDialog(
        nameController: nameController,
        passwordController: passwordController,
        confirmController: confirmController,
      ),
    );

    if (result != true || !mounted) return;

    setState(() => _isLoading = true);

    try {
      final kdbxService = ref.read(kdbxServiceProvider);
      final credentials = Credentials(
        ProtectedValue.fromString(passwordController.text),
      );

      final dir = await getApplicationDocumentsDirectory();
      final filePath = p.join(dir.path, '${nameController.text}.kdbx');

      await kdbxService.create(
        name: nameController.text,
        credentials: credentials,
        filePath: filePath,
      );

      ref.read(recentFilesProvider.notifier).addFile(filePath);

      // Store master password for biometric
      final biometricEnabled = ref.read(biometricEnabledProvider);
      if (biometricEnabled) {
        await ref.read(authServiceProvider).storeMasterPasswordForQuickUnlock(
          passwordController.text,
        );
      }

      ref.read(lockStateProvider.notifier).unlock();
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _openExistingDatabase() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty || !mounted) return;

    final filePath = result.files.single.path;
    if (filePath == null) return;

    await _openDatabaseWithPassword(filePath);
  }

  Future<void> _openDatabaseWithPassword(String filePath) async {
    final l10n = AppLocalizations.of(context)!;
    final passwordController = TextEditingController();

    final password = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _PasswordDialog(controller: passwordController),
    );

    if (password == null || password.isEmpty || !mounted) return;

    setState(() => _isLoading = true);

    try {
      final kdbxService = ref.read(kdbxServiceProvider);
      final credentials = Credentials(ProtectedValue.fromString(password));

      await kdbxService.openFile(filePath: filePath, credentials: credentials);
      ref.read(recentFilesProvider.notifier).addFile(filePath);

      final biometricEnabled = ref.read(biometricEnabledProvider);
      if (biometricEnabled) {
        await ref.read(authServiceProvider).storeMasterPasswordForQuickUnlock(password);
      }

      ref.read(lockStateProvider.notifier).unlock();
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.wrongPassword)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final recentFiles = ref.watch(recentFilesProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          const SizedBox(height: 32),
                          Icon(
                            Icons.shield_rounded,
                            size: 80,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.appTitle,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              Expanded(
                                child: _ActionCard(
                                  icon: Icons.add_rounded,
                                  label: l10n.createDatabase,
                                  onTap: _createNewDatabase,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _ActionCard(
                                  icon: Icons.folder_open_rounded,
                                  label: l10n.openDatabase,
                                  onTap: _openExistingDatabase,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (recentFiles.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                        child: Text(
                          l10n.recentDatabases,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final filePath = recentFiles[index];
                          final fileName = p.basename(filePath);
                          final fileExists = File(filePath).existsSync();

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 32),
                            leading: Icon(
                              Icons.lock_rounded,
                              color: fileExists ? colorScheme.primary : colorScheme.outline,
                            ),
                            title: Text(
                              fileName,
                              style: TextStyle(
                                color: fileExists ? null : colorScheme.outline,
                              ),
                            ),
                            subtitle: Text(
                              filePath,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                ref.read(recentFilesProvider.notifier).removeFile(filePath);
                              },
                            ),
                            enabled: fileExists,
                            onTap: fileExists
                                ? () => _openDatabaseWithPassword(filePath)
                                : null,
                          );
                        },
                        childCount: recentFiles.length,
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(icon, size: 48, color: colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateDatabaseDialog extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;

  const _CreateDatabaseDialog({
    required this.nameController,
    required this.passwordController,
    required this.confirmController,
  });

  @override
  State<_CreateDatabaseDialog> createState() => _CreateDatabaseDialogState();
}

class _CreateDatabaseDialogState extends State<_CreateDatabaseDialog> {
  bool _obscure = true;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.createDatabase),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: widget.nameController,
              decoration: InputDecoration(
                labelText: l10n.databaseName,
                prefixIcon: const Icon(Icons.storage),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: widget.passwordController,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: l10n.masterPassword,
                prefixIcon: const Icon(Icons.key),
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: widget.confirmController,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: l10n.confirmMasterPassword,
                prefixIcon: const Icon(Icons.key),
                errorText: _error,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (widget.passwordController.text.isEmpty) {
              setState(() => _error = l10n.enterMasterPassword);
              return;
            }
            if (widget.passwordController.text != widget.confirmController.text) {
              setState(() => _error = l10n.passwordsDoNotMatch);
              return;
            }
            Navigator.of(context).pop(true);
          },
          child: Text(l10n.createDatabase),
        ),
      ],
    );
  }
}

class _PasswordDialog extends StatefulWidget {
  final TextEditingController controller;

  const _PasswordDialog({required this.controller});

  @override
  State<_PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<_PasswordDialog> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.masterPassword),
      content: TextField(
        controller: widget.controller,
        obscureText: _obscure,
        autofocus: true,
        decoration: InputDecoration(
          labelText: l10n.enterMasterPassword,
          prefixIcon: const Icon(Icons.key),
          suffixIcon: IconButton(
            icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
        onSubmitted: (_) => Navigator.of(context).pop(widget.controller.text),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(widget.controller.text),
          child: Text(l10n.unlock),
        ),
      ],
    );
  }
}
