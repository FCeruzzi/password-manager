import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kdbx/kdbx.dart';
import 'package:password_manager/l10n/app_localizations.dart';
import '../../core/auth/auth_service.dart';
import '../../core/auth/auto_lock_manager.dart';
import '../../core/kdbx/kdbx_service.dart';
import '../../core/providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final themeMode = ref.watch(themeModeProvider);
    final autoLockTimeout = ref.watch(autoLockTimeoutProvider);
    final clipboardDelay = ref.watch(clipboardClearDelayProvider);
    final biometricEnabled = ref.watch(biometricEnabledProvider);
    final kdbxService = ref.watch(kdbxServiceProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          // Security section
          _SectionHeader(title: l10n.security),
          SwitchListTile(
            secondary: const Icon(Icons.fingerprint),
            title: Text(l10n.biometricUnlock),
            value: biometricEnabled,
            onChanged: (value) async {
              final authService = ref.read(authServiceProvider);
              final available = await authService.isBiometricAvailable();
              if (!available) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Biometria non disponibile')),
                  );
                }
                return;
              }
              ref.read(biometricEnabledProvider.notifier).setEnabled(value);
              if (!value) {
                await authService.clearStoredMasterPassword();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.timer),
            title: Text(l10n.autoLockTimeout),
            subtitle: Text(_formatDuration(autoLockTimeout, l10n)),
            onTap: () => _showAutoLockDialog(context, ref, l10n),
          ),
          ListTile(
            leading: const Icon(Icons.content_paste_off),
            title: Text(l10n.clipboardClearDelay),
            subtitle: Text(_formatDuration(clipboardDelay, l10n)),
            onTap: () => _showClipboardDialog(context, ref, l10n),
          ),
          ListTile(
            leading: const Icon(Icons.key),
            title: Text(l10n.changeMasterPassword),
            onTap: () => _changeMasterPassword(context, ref, l10n, kdbxService),
          ),

          const Divider(),

          // Appearance section
          _SectionHeader(title: l10n.theme),
          RadioGroup<ThemeMode>(
            groupValue: themeMode,
            onChanged: (v) { if (v != null) ref.read(themeModeProvider.notifier).setThemeMode(v); },
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(l10n.systemTheme),
                  value: ThemeMode.system,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.lightTheme),
                  value: ThemeMode.light,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.darkTheme),
                  value: ThemeMode.dark,
                ),
              ],
            ),
          ),

          const Divider(),

          // Database info
          if (kdbxService.isOpen) ...[
            _SectionHeader(title: l10n.databaseInfo),
            ListTile(
              leading: const Icon(Icons.storage),
              title: Text(l10n.databaseName),
              subtitle: Text(kdbxService.currentFile!.body.meta.databaseName.get() ?? ''),
            ),
            ListTile(
              leading: const Icon(Icons.numbers),
              title: Text(l10n.entries),
              subtitle: Text('${kdbxService.getAllEntries().length}'),
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: Text(l10n.groups),
              subtitle: Text('${_countGroups(kdbxService.currentFile!.body.rootGroup)}'),
            ),
          ],

          const Divider(),

          // Import/Export
          _SectionHeader(title: '${l10n.import} / ${l10n.export}'),
          ListTile(
            leading: const Icon(Icons.file_upload),
            title: Text(l10n.export),
            subtitle: Text(l10n.exportSuccess),
            onTap: () => _exportDatabase(context, ref, kdbxService),
          ),
          ListTile(
            leading: const Icon(Icons.file_download),
            title: Text(l10n.importFromOldApp),
            subtitle: const Text('JSON cifrato (app precedente)'),
            onTap: () => _importFromOldApp(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.table_chart),
            title: Text(l10n.importFromCsv),
            onTap: () => _importFromCsv(context, ref),
          ),

          const Divider(),

          // Password Generator shortcut
          ListTile(
            leading: const Icon(Icons.auto_awesome),
            title: Text(l10n.passwordGenerator),
            onTap: () => context.go('/home/password-generator'),
          ),

          const Divider(),

          // About
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.about),
            subtitle: Text('${l10n.version} 1.0.0'),
          ),

          // Lock
          ListTile(
            leading: Icon(Icons.lock, color: colorScheme.error),
            title: const Text('Blocca'),
            onTap: () {
              kdbxService.save();
              ref.read(lockStateProvider.notifier).lock();
              context.go('/unlock');
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _formatDuration(Duration d, AppLocalizations l10n) {
    if (d.inSeconds <= 0) return l10n.never;
    if (d.inSeconds < 60) return l10n.seconds(d.inSeconds);
    return l10n.minutes(d.inMinutes);
  }

  int _countGroups(KdbxGroup group) {
    var count = group.groups.length;
    for (final sub in group.groups) {
      count += _countGroups(sub);
    }
    return count;
  }

  void _showAutoLockDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final options = [
      (const Duration(seconds: 0), l10n.immediately),
      (const Duration(seconds: 30), l10n.seconds(30)),
      (const Duration(minutes: 1), l10n.minutes(1)),
      (const Duration(minutes: 5), l10n.minutes(5)),
      (const Duration(minutes: 15), l10n.minutes(15)),
      (const Duration(minutes: 30), l10n.minutes(30)),
      (const Duration(seconds: -1), l10n.never),
    ];

    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.autoLockTimeout),
        children: options.map((o) => SimpleDialogOption(
          onPressed: () {
            ref.read(autoLockTimeoutProvider.notifier).setTimeout(o.$1);
            Navigator.of(ctx).pop();
          },
          child: Text(o.$2),
        )).toList(),
      ),
    );
  }

  void _showClipboardDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final options = [
      (const Duration(seconds: 15), l10n.seconds(15)),
      (const Duration(seconds: 30), l10n.seconds(30)),
      (const Duration(minutes: 1), l10n.minutes(1)),
      (const Duration(minutes: 2), l10n.minutes(2)),
      (const Duration(seconds: -1), l10n.never),
    ];

    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.clipboardClearDelay),
        children: options.map((o) => SimpleDialogOption(
          onPressed: () {
            ref.read(clipboardClearDelayProvider.notifier).setDelay(o.$1);
            Navigator.of(ctx).pop();
          },
          child: Text(o.$2),
        )).toList(),
      ),
    );
  }

  Future<void> _changeMasterPassword(
    BuildContext context, WidgetRef ref, AppLocalizations l10n, KdbxService kdbxService,
  ) async {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.changeMasterPassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.currentPassword),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.newPassword),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.confirmMasterPassword),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text(l10n.save)),
        ],
      ),
    );

    if (result != true) return;

    if (newController.text != confirmController.text) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.passwordsDoNotMatch)),
        );
      }
      return;
    }

    try {
      final newCreds = Credentials(ProtectedValue.fromString(newController.text));
      await kdbxService.changeMasterPassword(newCreds);
      await kdbxService.save();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password cambiata con successo')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: $e')),
        );
      }
    }
  }

  Future<void> _exportDatabase(BuildContext context, WidgetRef ref, KdbxService kdbxService) async {
    // Save is sufficient since KDBX IS the export format
    try {
      await kdbxService.save();
      final l10n = AppLocalizations.of(context)!;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.exportSuccess}: ${kdbxService.currentFilePath}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: $e')),
        );
      }
    }
  }

  void _importFromOldApp(BuildContext context, WidgetRef ref) {
    // TODO: Implement import from old JSON format
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funzionalità in arrivo')),
    );
  }

  void _importFromCsv(BuildContext context, WidgetRef ref) {
    // TODO: Implement CSV import
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funzionalità in arrivo')),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
