import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kdbx/kdbx.dart';
import 'package:file_picker/file_picker.dart';
import 'package:password_manager/l10n/app_localizations.dart';
import '../../core/kdbx/kdbx_service.dart';
import '../../core/crypto/password_generator.dart';

class EntryFormScreen extends ConsumerStatefulWidget {
  final String? entryUuid;
  final String? groupUuid;

  const EntryFormScreen({super.key, this.entryUuid, this.groupUuid});

  @override
  ConsumerState<EntryFormScreen> createState() => _EntryFormScreenState();
}

class _EntryFormScreenState extends ConsumerState<EntryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _urlController = TextEditingController();
  final _notesController = TextEditingController();
  final _totpController = TextEditingController();

  bool _isEditing = false;
  bool _obscurePassword = true;
  final _customFields = <_CustomField>[];
  String? _selectedGroupUuid;
  List<String> _tags = [];
  final _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isEditing = widget.entryUuid != null;
    _selectedGroupUuid = widget.groupUuid;

    if (_isEditing) {
      _loadEntry();
    }
  }

  void _loadEntry() {
    final kdbxService = ref.read(kdbxServiceProvider);
    final entry = _findEntry(kdbxService);
    if (entry == null) return;

    _titleController.text = entry.getString(KdbxKeyCommon.TITLE)?.getText() ?? '';
    _usernameController.text = entry.getString(KdbxKeyCommon.USER_NAME)?.getText() ?? '';
    _passwordController.text = entry.getString(KdbxKeyCommon.PASSWORD)?.getText() ?? '';
    _urlController.text = entry.getString(KdbxKeyCommon.URL)?.getText() ?? '';
    _notesController.text = entry.getString(KdbxKey('Notes'))?.getText() ?? '';

    final otpUri = kdbxService.getTotpUri(entry);
    if (otpUri != null) _totpController.text = otpUri;

    // Load custom fields
    final standardKeys = {
      KdbxKeyCommon.TITLE.key,
      KdbxKeyCommon.USER_NAME.key,
      KdbxKeyCommon.PASSWORD.key,
      KdbxKeyCommon.URL.key,
      'Notes',
      'otp', 'OTPAuth', 'TOTP Seed', 'TOTP Settings',
      '_pm_archived',
    };

    for (final entry2 in entry.stringEntries) {
      if (!standardKeys.contains(entry2.key.key)) {
        _customFields.add(_CustomField(
          nameController: TextEditingController(text: entry2.key.key),
          valueController: TextEditingController(text: entry2.value?.getText() ?? ''),
          isProtected: entry2.value is ProtectedValue,
        ));
      }
    }

    // Load tags
    _tags = kdbxService.getTags(entry);

    _selectedGroupUuid = entry.parent?.uuid.uuid;
  }

  KdbxEntry? _findEntry(KdbxService kdbxService) {
    if (!kdbxService.isOpen || widget.entryUuid == null) return null;
    try {
      return kdbxService.getAllEntries().firstWhere((e) => e.uuid.uuid == widget.entryUuid);
    } catch (_) {
      return null;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final kdbxService = ref.read(kdbxServiceProvider);
    if (!kdbxService.isOpen) return;

    final rootGroup = kdbxService.currentFile!.body.rootGroup;

    KdbxEntry entry;
    if (_isEditing) {
      entry = _findEntry(kdbxService)!;
    } else {
      // Find target group
      KdbxGroup targetGroup;
      if (_selectedGroupUuid != null) {
        targetGroup = _findGroupRecursive(rootGroup, _selectedGroupUuid!) ?? rootGroup;
      } else {
        targetGroup = rootGroup;
      }
      entry = kdbxService.createEntry(targetGroup);
    }

    // Build custom fields map
    final customFieldsMap = <String, String>{};
    final protectedFieldsMap = <String, bool>{};
    for (final cf in _customFields) {
      final name = cf.nameController.text.trim();
      if (name.isNotEmpty) {
        customFieldsMap[name] = cf.valueController.text;
        protectedFieldsMap[name] = cf.isProtected;
      }
    }

    kdbxService.updateEntry(
      entry,
      title: _titleController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      url: _urlController.text.trim(),
      notes: _notesController.text,
      customFields: customFieldsMap,
      protectedFields: protectedFieldsMap,
    );

    // Handle TOTP
    if (_totpController.text.isNotEmpty) {
      kdbxService.setTotpUri(entry, _totpController.text.trim());
    }

    // Handle tags
    kdbxService.setTags(entry, _tags);

    await kdbxService.save();

    if (mounted) {
      if (_isEditing) {
        context.go('/home/entry/${entry.uuid.uuid}');
      } else {
        context.go('/home');
      }
    }
  }

  KdbxGroup? _findGroupRecursive(KdbxGroup parent, String uuid) {
    if (parent.uuid.uuid == uuid) return parent;
    for (final group in parent.groups) {
      final found = _findGroupRecursive(group, uuid);
      if (found != null) return found;
    }
    return null;
  }

  void _addTag(String tag) {
    final trimmed = tag.trim();
    if (trimmed.isNotEmpty && !_tags.contains(trimmed)) {
      setState(() => _tags.add(trimmed));
    }
    _tagController.clear();
  }

  void _generatePassword() {
    final password = PasswordGenerator.generate(
      length: 20,
      uppercase: true,
      lowercase: true,
      digits: true,
      symbols: true,
    );
    setState(() {
      _passwordController.text = password;
      _obscurePassword = false;
    });
  }

  Future<void> _addAttachment() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;
    if (file.bytes == null && file.path == null) return;

    final kdbxService = ref.read(kdbxServiceProvider);
    final entry = _findEntry(kdbxService);
    if (entry == null) return;

    Uint8List bytes;
    if (file.bytes != null) {
      bytes = file.bytes!;
    } else {
      bytes = await io.File(file.path!).readAsBytes();
    }

    kdbxService.addAttachment(entry, file.name, bytes);
    final l10n = AppLocalizations.of(context)!;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.attachmentAdded)),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    _totpController.dispose();
    _tagController.dispose();
    for (final cf in _customFields) {
      cf.nameController.dispose();
      cf.valueController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editEntry : l10n.addEntry),
        actions: [
          TextButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check),
            label: Text(l10n.save),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.title,
                prefixIcon: const Icon(Icons.label),
              ),
              validator: (v) => v == null || v.trim().isEmpty ? l10n.title : null,
              autofocus: !_isEditing,
            ),
            const SizedBox(height: 16),

            // Username
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: l10n.username,
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),

            // Password
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: l10n.password,
                prefixIcon: const Icon(Icons.key),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    IconButton(
                      icon: const Icon(Icons.auto_awesome),
                      tooltip: l10n.generatePassword,
                      onPressed: _generatePassword,
                    ),
                  ],
                ),
              ),
            ),
            // Password strength indicator
            if (_passwordController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: _PasswordStrengthBar(password: _passwordController.text),
              ),
            const SizedBox(height: 16),

            // URL
            TextFormField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: l10n.url,
                prefixIcon: const Icon(Icons.link),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: l10n.notes,
                prefixIcon: const Icon(Icons.notes),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),

            // TOTP
            ExpansionTile(
              title: Text(l10n.totp),
              leading: const Icon(Icons.timer),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _totpController,
                    decoration: InputDecoration(
                      labelText: 'otpauth:// URI',
                      hintText: 'otpauth://totp/...',
                      prefixIcon: const Icon(Icons.qr_code),
                    ),
                  ),
                ),
              ],
            ),

            // Tags
            ExpansionTile(
              title: Text(l10n.tags),
              leading: const Icon(Icons.label),
              initiallyExpanded: _tags.isNotEmpty,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    children: _tags.map((tag) => Chip(
                      label: Text(tag),
                      onDeleted: () => setState(() => _tags.remove(tag)),
                    )).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _tagController,
                          decoration: InputDecoration(
                            labelText: l10n.addTag,
                            isDense: true,
                            prefixIcon: const Icon(Icons.new_label, size: 20),
                          ),
                          onSubmitted: _addTag,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _addTag(_tagController.text),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Custom fields
            ExpansionTile(
              title: Text(l10n.customFields),
              leading: const Icon(Icons.text_fields),
              initiallyExpanded: _customFields.isNotEmpty,
              children: [
                ..._customFields.asMap().entries.map((mapEntry) {
                  final index = mapEntry.key;
                  final cf = mapEntry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: cf.nameController,
                            decoration: InputDecoration(
                              labelText: l10n.fieldName,
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: cf.valueController,
                            decoration: InputDecoration(
                              labelText: l10n.fieldValue,
                              isDense: true,
                            ),
                            obscureText: cf.isProtected,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            cf.isProtected ? Icons.lock : Icons.lock_open,
                            size: 20,
                          ),
                          onPressed: () => setState(() => cf.isProtected = !cf.isProtected),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle, size: 20, color: colorScheme.error),
                          onPressed: () => setState(() {
                            cf.nameController.dispose();
                            cf.valueController.dispose();
                            _customFields.removeAt(index);
                          }),
                        ),
                      ],
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _customFields.add(_CustomField(
                          nameController: TextEditingController(),
                          valueController: TextEditingController(),
                        ));
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addCustomField),
                  ),
                ),
              ],
            ),

            // Attachments (only for existing entries)
            if (_isEditing)
              ExpansionTile(
                title: Text(l10n.attachments),
                leading: const Icon(Icons.attach_file),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: OutlinedButton.icon(
                      onPressed: _addAttachment,
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addAttachment),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _CustomField {
  final TextEditingController nameController;
  final TextEditingController valueController;
  bool isProtected;

  _CustomField({
    required this.nameController,
    required this.valueController,
    this.isProtected = false,
  });
}

class _PasswordStrengthBar extends StatelessWidget {
  final String password;

  const _PasswordStrengthBar({required this.password});

  @override
  Widget build(BuildContext context) {
    final strength = PasswordGenerator.calculateStrength(password);
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow.shade700,
      Colors.lightGreen,
      Colors.green,
    ];
    final labels = ['Debole', 'Discreta', 'Buona', 'Forte', 'Molto forte'];

    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: (strength + 1) / 5,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation(colors[strength]),
          ),
        ),
        const SizedBox(width: 8),
        Text(labels[strength], style: TextStyle(fontSize: 12, color: colors[strength])),
      ],
    );
  }
}
