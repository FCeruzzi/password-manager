import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kdbx/kdbx.dart';
import 'package:password_manager/l10n/app_localizations.dart';
import '../../core/kdbx/kdbx_service.dart';

class GroupManageScreen extends ConsumerStatefulWidget {
  const GroupManageScreen({super.key});

  @override
  ConsumerState<GroupManageScreen> createState() => _GroupManageScreenState();
}

class _GroupManageScreenState extends ConsumerState<GroupManageScreen> {
  Future<void> _addGroup(KdbxGroup parent) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addGroup),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.groupName,
            prefixIcon: const Icon(Icons.folder),
          ),
          onSubmitted: (v) => Navigator.of(ctx).pop(v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (name != null && name.trim().isNotEmpty) {
      final kdbxService = ref.read(kdbxServiceProvider);
      kdbxService.createGroup(parent, name.trim());
      await kdbxService.save();
      setState(() {});
    }
  }

  Future<void> _renameGroup(KdbxGroup group) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: group.name.get() ?? '');

    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.editGroup),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.groupName,
            prefixIcon: const Icon(Icons.folder),
          ),
          onSubmitted: (v) => Navigator.of(ctx).pop(v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (newName != null && newName.trim().isNotEmpty) {
      final kdbxService = ref.read(kdbxServiceProvider);
      kdbxService.renameGroup(group, newName.trim());
      await kdbxService.save();
      setState(() {});
    }
  }

  Future<void> _deleteGroup(KdbxGroup group) async {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteGroup),
        content: Text(l10n.deleteGroupConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final kdbxService = ref.read(kdbxServiceProvider);
      kdbxService.deleteGroup(group);
      await kdbxService.save();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final kdbxService = ref.watch(kdbxServiceProvider);

    if (!kdbxService.isOpen) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.groups)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final rootGroup = kdbxService.currentFile!.body.rootGroup;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.groups),
        actions: [
          IconButton(
            icon: const Icon(Icons.create_new_folder),
            onPressed: () => _addGroup(rootGroup),
          ),
        ],
      ),
      body: ListView(
        children: rootGroup.groups.map((group) {
          return _buildGroupTile(group, 0);
        }).toList(),
      ),
    );
  }

  Widget _buildGroupTile(KdbxGroup group, int depth) {
    final hasChildren = group.groups.isNotEmpty;
    final entryCount = group.entries.length;

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 16.0 + (depth * 24.0), right: 8),
          leading: Icon(hasChildren ? Icons.folder : Icons.folder_outlined),
          title: Text(group.name.get() ?? ''),
          subtitle: Text('$entryCount voci'),
          trailing: PopupMenuButton(
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'add_sub',
                child: ListTile(
                  leading: const Icon(Icons.create_new_folder_outlined),
                  title: Text(AppLocalizations.of(context)!.addGroup),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'rename',
                child: ListTile(
                  leading: const Icon(Icons.edit),
                  title: Text(AppLocalizations.of(context)!.edit),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                  title: Text(
                    AppLocalizations.of(context)!.delete,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'add_sub':
                  _addGroup(group);
                case 'rename':
                  _renameGroup(group);
                case 'delete':
                  _deleteGroup(group);
              }
            },
          ),
        ),
        if (hasChildren)
          ...group.groups.map((sub) => _buildGroupTile(sub, depth + 1)),
      ],
    );
  }
}
