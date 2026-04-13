import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kdbx/kdbx.dart';
import 'package:password_manager/l10n/app_localizations.dart';
import 'package:otp/otp.dart';
import 'dart:async';
import '../../core/kdbx/kdbx_service.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/pdf/pdf_service.dart';

class EntryDetailScreen extends ConsumerStatefulWidget {
  final String entryUuid;

  const EntryDetailScreen({super.key, required this.entryUuid});

  @override
  ConsumerState<EntryDetailScreen> createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends ConsumerState<EntryDetailScreen> {
  bool _showPassword = false;
  Timer? _totpTimer;
  String _totpCode = '';
  int _totpRemaining = 30;

  @override
  void initState() {
    super.initState();
    _startTotpTimer();
  }

  @override
  void dispose() {
    _totpTimer?.cancel();
    super.dispose();
  }

  void _startTotpTimer() {
    _updateTotp();
    _totpTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTotp();
    });
  }

  void _updateTotp() {
    final kdbxService = ref.read(kdbxServiceProvider);
    final entry = _findEntry(kdbxService);
    if (entry == null) return;

    final otpUri = kdbxService.getTotpUri(entry);
    if (otpUri == null) return;

    try {
      final uri = Uri.parse(otpUri);
      final secret = uri.queryParameters['secret'] ?? '';
      final digits = int.tryParse(uri.queryParameters['digits'] ?? '6') ?? 6;
      final period = int.tryParse(uri.queryParameters['period'] ?? '30') ?? 30;
      final algorithm = uri.queryParameters['algorithm']?.toUpperCase() ?? 'SHA1';

      Algorithm algo;
      switch (algorithm) {
        case 'SHA256':
          algo = Algorithm.SHA256;
        case 'SHA512':
          algo = Algorithm.SHA512;
        default:
          algo = Algorithm.SHA1;
      }

      final now = DateTime.now().millisecondsSinceEpoch;
      final code = OTP.generateTOTPCodeString(
        secret,
        now,
        length: digits,
        interval: period,
        algorithm: algo,
        isGoogle: true,
      );

      final remaining = period - ((now ~/ 1000) % period);

      if (mounted) {
        setState(() {
          _totpCode = code;
          _totpRemaining = remaining;
        });
      }
    } catch (_) {}
  }

  KdbxEntry? _findEntry(KdbxService kdbxService) {
    if (!kdbxService.isOpen) return null;
    final allEntries = kdbxService.getAllEntries();
    try {
      return allEntries.firstWhere((e) => e.uuid.uuid == widget.entryUuid);
    } catch (_) {
      return null;
    }
  }

  void _copyField(String value, String label) {
    if (value.isEmpty) return;
    Clipboard.setData(ClipboardData(text: value));
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.copiedToClipboard), duration: const Duration(seconds: 2)),
    );
    final delay = ref.read(clipboardClearDelayProvider);
    if (delay.inSeconds > 0) {
      Future.delayed(delay, () => Clipboard.setData(const ClipboardData(text: '')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final kdbxService = ref.watch(kdbxServiceProvider);
    final entry = _findEntry(kdbxService);

    if (entry == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.noEntries)),
      );
    }

    final title = entry.getString(KdbxKeyCommon.TITLE)?.getText() ?? '';
    final username = entry.getString(KdbxKeyCommon.USER_NAME)?.getText() ?? '';
    final password = entry.getString(KdbxKeyCommon.PASSWORD)?.getText() ?? '';
    final url = entry.getString(KdbxKeyCommon.URL)?.getText() ?? '';
    final notes = entry.getString(KdbxKey('Notes'))?.getText() ?? '';
    final otpUri = kdbxService.getTotpUri(entry);

    // Collect custom fields (non-standard)
    final standardKeys = {
      KdbxKeyCommon.TITLE.key,
      KdbxKeyCommon.USER_NAME.key,
      KdbxKeyCommon.PASSWORD.key,
      KdbxKeyCommon.URL.key,
      'Notes',
      'otp', 'OTPAuth', 'TOTP Seed', 'TOTP Settings',
      '_pm_archived',
    };
    final customFields = entry.stringEntries
        .where((e) => !standardKeys.contains(e.key.key))
        .toList();

    // Attachments
    final binaries = entry.binaryEntries.toList();

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.go('/home/entry-form', extra: {
                'entryUuid': widget.entryUuid,
              });
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) {
              final isArchived = kdbxService.isArchived(entry);
              return [
                PopupMenuItem(
                  value: 'archive',
                  child: ListTile(
                    leading: Icon(isArchived ? Icons.unarchive : Icons.archive),
                    title: Text(isArchived ? l10n.unarchive : l10n.archive),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'pdf',
                  child: ListTile(
                    leading: const Icon(Icons.picture_as_pdf),
                    title: Text(l10n.exportPdf),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'print',
                  child: ListTile(
                    leading: const Icon(Icons.print),
                    title: Text(l10n.printEntry),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'history',
                  child: ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(l10n.history),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: colorScheme.error),
                    title: Text(l10n.delete, style: TextStyle(color: colorScheme.error)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ];
            },
            onSelected: (value) async {
              if (value == 'delete') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l10n.deleteEntry),
                    content: Text(l10n.deleteEntryConfirm),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text(l10n.cancel),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.error,
                        ),
                        child: Text(l10n.delete),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  kdbxService.deleteEntry(entry);
                  await kdbxService.save();
                  if (mounted) context.go('/home');
                }
              } else if (value == 'history') {
                _showHistory(context, entry);
              } else if (value == 'archive') {
                final isArchived = kdbxService.isArchived(entry);
                if (isArchived) {
                  kdbxService.unarchiveEntry(entry);
                } else {
                  kdbxService.archiveEntry(entry);
                }
                await kdbxService.save();
                if (mounted) context.go('/home');
              } else if (value == 'pdf') {
                await PdfService.exportEntryPdf(entry, kdbxService);
              } else if (value == 'print') {
                await PdfService.printEntry(entry, kdbxService);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Title card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      title.isNotEmpty ? title[0].toUpperCase() : '?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Fields
          if (username.isNotEmpty)
            _FieldTile(
              icon: Icons.person,
              label: l10n.username,
              value: username,
              onCopy: () => _copyField(username, l10n.username),
            ),
          _FieldTile(
            icon: Icons.key,
            label: l10n.password,
            value: _showPassword ? password : '••••••••',
            onCopy: () => _copyField(password, l10n.password),
            trailing: IconButton(
              icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _showPassword = !_showPassword),
            ),
          ),
          if (url.isNotEmpty)
            _FieldTile(
              icon: Icons.link,
              label: l10n.url,
              value: url,
              onCopy: () => _copyField(url, l10n.url),
            ),
          if (notes.isNotEmpty)
            _FieldTile(
              icon: Icons.notes,
              label: l10n.notes,
              value: notes,
              multiline: true,
              onCopy: () => _copyField(notes, l10n.notes),
            ),

          // TOTP
          if (otpUri != null && _totpCode.isNotEmpty) ...[
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: _totpRemaining / 30,
                      strokeWidth: 3,
                      color: _totpRemaining <= 5 ? colorScheme.error : colorScheme.primary,
                    ),
                    Icon(Icons.timer, size: 16, color: colorScheme.primary),
                  ],
                ),
                title: Text(
                  _totpCode,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                subtitle: Text('${l10n.totp} · ${_totpRemaining}s'),
                trailing: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyField(_totpCode, l10n.totp),
                ),
              ),
            ),
          ],

          // Tags
          if (kdbxService.getTags(entry).isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text(l10n.tags, style: Theme.of(context).textTheme.titleMedium),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: kdbxService.getTags(entry).map((tag) => Chip(
                label: Text(tag),
                avatar: const Icon(Icons.label, size: 16),
              )).toList(),
            ),
          ],

          // Custom fields
          if (customFields.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text(l10n.customFields, style: Theme.of(context).textTheme.titleMedium),
            ),
            ...customFields.map((cf) {
              final value = cf.value?.getText() ?? '';
              return _FieldTile(
                icon: Icons.text_fields,
                label: cf.key.key,
                value: value,
                onCopy: () => _copyField(value, cf.key.key),
              );
            }),
          ],

          // Attachments
          if (binaries.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text(l10n.attachments, style: Theme.of(context).textTheme.titleMedium),
            ),
            ...binaries.map((b) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.attach_file),
                  title: Text(b.key.key),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {
                      // TODO: Save binary to downloads
                    },
                  ),
                ),
              );
            }),
          ],

          // Timestamps
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TimestampRow(
                    label: l10n.createdAt,
                    time: entry.times.creationTime.get(),
                  ),
                  const SizedBox(height: 4),
                  _TimestampRow(
                    label: l10n.modifiedAt,
                    time: entry.times.lastModificationTime.get(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHistory(BuildContext context, KdbxEntry entry) {
    final l10n = AppLocalizations.of(context)!;
    final history = entry.history.toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (ctx, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.entryHistory, style: Theme.of(context).textTheme.titleLarge),
            ),
            Expanded(
              child: history.isEmpty
                  ? Center(child: Text(l10n.noEntries))
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final histEntry = history[index];
                        final title = histEntry.getString(KdbxKeyCommon.TITLE)?.getText() ?? '';
                        final modified = histEntry.times.lastModificationTime.get();
                        return ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(title),
                          subtitle: Text(
                            modified != null
                                ? '${modified.day}/${modified.month}/${modified.year} ${modified.hour}:${modified.minute.toString().padLeft(2, '0')}'
                                : '',
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onCopy;
  final Widget? trailing;
  final bool multiline;

  const _FieldTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onCopy,
    this.trailing,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label, style: Theme.of(context).textTheme.bodySmall),
        subtitle: Text(
          value,
          maxLines: multiline ? null : 1,
          overflow: multiline ? null : TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailing != null) trailing!,
            IconButton(icon: const Icon(Icons.copy, size: 20), onPressed: onCopy),
          ],
        ),
      ),
    );
  }
}

class _TimestampRow extends StatelessWidget {
  final String label;
  final DateTime? time;

  const _TimestampRow({required this.label, this.time});

  @override
  Widget build(BuildContext context) {
    final dateStr = time != null
        ? '${time!.day}/${time!.month}/${time!.year} ${time!.hour}:${time!.minute.toString().padLeft(2, '0')}'
        : '-';
    return Row(
      children: [
        Text('$label: ', style: Theme.of(context).textTheme.bodySmall),
        Text(dateStr, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
