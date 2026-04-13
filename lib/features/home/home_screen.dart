import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kdbx/kdbx.dart';
import 'package:password_manager/l10n/app_localizations.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../core/kdbx/kdbx_service.dart';
import '../../core/auth/auto_lock_manager.dart';
import '../../core/providers/settings_provider.dart';

/// Provider for current selected group UUID
final selectedGroupProvider = StateProvider<String?>((ref) => null);

/// Provider for current sort mode
final sortModeProvider = StateProvider<SortMode>((ref) => SortMode.title);

/// Provider for showing archived entries
final showArchivedProvider = StateProvider<bool>((ref) => false);

/// Provider for filtering by tag
final selectedTagProvider = StateProvider<String?>((ref) => null);

enum SortMode { title, modified, created }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver {
  DateTime? _pauseTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Apply wakelock
    final stayAwake = ref.read(stayAwakeProvider);
    if (stayAwake) {
      WakelockPlus.enable();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _pauseTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      if (_pauseTime != null) {
        final timeout = ref.read(autoLockTimeoutProvider);
        final elapsed = DateTime.now().difference(_pauseTime!);
        if (timeout.inSeconds > 0 && elapsed >= timeout) {
          _save();
          final autoExit = ref.read(autoExitProvider);
          if (autoExit) {
            SystemNavigator.pop();
          } else {
            ref.read(lockStateProvider.notifier).lock();
          }
        }
      }
      _pauseTime = null;
    }
  }

  Future<void> _save() async {
    final kdbxService = ref.read(kdbxServiceProvider);
    if (kdbxService.isDirty) {
      await kdbxService.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final kdbxService = ref.watch(kdbxServiceProvider);
    final selectedGroup = ref.watch(selectedGroupProvider);
    final sortMode = ref.watch(sortModeProvider);
    final showArchived = ref.watch(showArchivedProvider);
    final selectedTag = ref.watch(selectedTagProvider);

    if (!kdbxService.isOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/vault');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final rootGroup = kdbxService.currentFile!.body.rootGroup;
    final groups = rootGroup.groups.toList();

    // Get entries for current group or all entries
    List<KdbxEntry> entries;
    String currentGroupName;
    if (showArchived) {
      entries = kdbxService.getArchivedEntries();
      currentGroupName = l10n.archivedEntries;
    } else if (selectedGroup == null) {
      entries = kdbxService.getAllEntries();
      currentGroupName = l10n.allEntries;
    } else {
      final group = _findGroup(rootGroup, selectedGroup);
      entries = (group?.entries.toList() ?? [])
          .where((e) => !kdbxService.isArchived(e))
          .toList();
      currentGroupName = group?.name.get() ?? l10n.allEntries;
    }

    // Filter by tag
    if (selectedTag != null) {
      entries = entries.where((e) {
        final tags = kdbxService.getTags(e);
        return tags.contains(selectedTag);
      }).toList();
      currentGroupName = '$currentGroupName · #$selectedTag';
    }

    // Sort entries
    entries = _sortEntries(entries, sortMode);

    return Scaffold(
      appBar: AppBar(
        title: Text(currentGroupName),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.go('/home/search'),
          ),
          PopupMenuButton<SortMode>(
            icon: const Icon(Icons.sort),
            onSelected: (mode) => ref.read(sortModeProvider.notifier).state = mode,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: SortMode.title,
                child: Text(l10n.sortByTitle),
              ),
              PopupMenuItem(
                value: SortMode.modified,
                child: Text(l10n.sortByModified),
              ),
              PopupMenuItem(
                value: SortMode.created,
                child: Text(l10n.sortByCreated),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/home/settings'),
          ),
        ],
      ),
      drawer: _buildDrawer(context, l10n, rootGroup, groups, selectedGroup),
      body: entries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.no_encryption_rounded, size: 64,
                      color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(l10n.noEntries, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            )
          : ListView.builder(
              itemCount: entries.length,
              padding: const EdgeInsets.only(bottom: 80),
              itemBuilder: (context, index) {
                final entry = entries[index];
                return _EntryTile(entry: entry);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/home/entry-form', extra: {
            'groupUuid': selectedGroup ?? rootGroup.uuid.uuid,
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    AppLocalizations l10n,
    KdbxGroup rootGroup,
    List<KdbxGroup> groups,
    String? selectedGroup,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final kdbxService = ref.read(kdbxServiceProvider);
    final showArchived = ref.watch(showArchivedProvider);
    final selectedTag = ref.watch(selectedTagProvider);
    final allTags = kdbxService.getAllTags().toList()..sort();

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: colorScheme.primaryContainer),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.shield_rounded, size: 48, color: colorScheme.onPrimaryContainer),
                  const SizedBox(height: 8),
                  Text(
                    l10n.appTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: Text(l10n.allEntries),
              selected: selectedGroup == null && !showArchived && selectedTag == null,
              onTap: () {
                ref.read(selectedGroupProvider.notifier).state = null;
                ref.read(showArchivedProvider.notifier).state = false;
                ref.read(selectedTagProvider.notifier).state = null;
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive_outlined),
              title: Text(l10n.archivedEntries),
              selected: showArchived,
              trailing: Text(
                '${kdbxService.getArchivedEntries().length}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onTap: () {
                ref.read(showArchivedProvider.notifier).state = true;
                ref.read(selectedGroupProvider.notifier).state = null;
                ref.read(selectedTagProvider.notifier).state = null;
                Navigator.of(context).pop();
              },
            ),
            const Divider(),
            // Tags section
            if (allTags.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    Text(l10n.tags, style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
              ),
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: allTags.length,
                  itemBuilder: (context, index) {
                    final tag = allTags[index];
                    final isSelected = selectedTag == tag;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(tag),
                        selected: isSelected,
                        onSelected: (selected) {
                          ref.read(selectedTagProvider.notifier).state = selected ? tag : null;
                          ref.read(showArchivedProvider.notifier).state = false;
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.groups, style: Theme.of(context).textTheme.titleSmall),
                  IconButton(
                    icon: const Icon(Icons.create_new_folder_outlined, size: 20),
                    onPressed: () => context.go('/home/groups'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  return _GroupTile(
                    group: groups[index],
                    selectedGroup: selectedGroup,
                    depth: 0,
                  );
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: Text(l10n.unlock),
              subtitle: const Text('Blocca'),
              onTap: () {
                _save();
                ref.read(lockStateProvider.notifier).lock();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  KdbxGroup? _findGroup(KdbxGroup parent, String uuid) {
    if (parent.uuid.uuid == uuid) return parent;
    for (final group in parent.groups) {
      final found = _findGroup(group, uuid);
      if (found != null) return found;
    }
    return null;
  }

  List<KdbxEntry> _sortEntries(List<KdbxEntry> entries, SortMode mode) {
    final sorted = List<KdbxEntry>.from(entries);
    switch (mode) {
      case SortMode.title:
        sorted.sort((a, b) {
          final aTitle = a.getString(KdbxKeyCommon.TITLE)?.getText() ?? '';
          final bTitle = b.getString(KdbxKeyCommon.TITLE)?.getText() ?? '';
          return aTitle.toLowerCase().compareTo(bTitle.toLowerCase());
        });
      case SortMode.modified:
        sorted.sort((a, b) {
          final aTime = a.times.lastModificationTime.get() ?? DateTime(2000);
          final bTime = b.times.lastModificationTime.get() ?? DateTime(2000);
          return bTime.compareTo(aTime);
        });
      case SortMode.created:
        sorted.sort((a, b) {
          final aTime = a.times.creationTime.get() ?? DateTime(2000);
          final bTime = b.times.creationTime.get() ?? DateTime(2000);
          return bTime.compareTo(aTime);
        });
    }
    return sorted;
  }
}

class _GroupTile extends ConsumerWidget {
  final KdbxGroup group;
  final String? selectedGroup;
  final int depth;

  const _GroupTile({
    required this.group,
    required this.selectedGroup,
    required this.depth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = selectedGroup == group.uuid.uuid;
    final hasChildren = group.groups.isNotEmpty;
    final entryCount = group.entries.length;

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 16.0 + (depth * 16.0), right: 16),
          leading: Icon(
            hasChildren ? Icons.folder : Icons.folder_outlined,
            color: isSelected ? Theme.of(context).colorScheme.primary : null,
          ),
          title: Text(
            group.name.get() ?? '',
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: Text('$entryCount', style: Theme.of(context).textTheme.bodySmall),
          selected: isSelected,
          onTap: () {
            ref.read(selectedGroupProvider.notifier).state = group.uuid.uuid;
            Navigator.of(context).pop();
          },
        ),
        if (hasChildren)
          ...group.groups.map((subGroup) => _GroupTile(
            group: subGroup,
            selectedGroup: selectedGroup,
            depth: depth + 1,
          )),
      ],
    );
  }
}

class _EntryTile extends ConsumerWidget {
  final KdbxEntry entry;

  const _EntryTile({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = entry.getString(KdbxKeyCommon.TITLE)?.getText() ?? '';
    final username = entry.getString(KdbxKeyCommon.USER_NAME)?.getText() ?? '';
    final url = entry.getString(KdbxKeyCommon.URL)?.getText() ?? '';
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Text(
            title.isNotEmpty ? title[0].toUpperCase() : '?',
            style: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          username.isNotEmpty ? username : url,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.copy, size: 20),
          tooltip: l10n.copy,
          onPressed: () {
            final password = entry.getString(KdbxKeyCommon.PASSWORD)?.getText() ?? '';
            if (password.isNotEmpty) {
              Clipboard.setData(ClipboardData(text: password));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.copiedToClipboard),
                  duration: const Duration(seconds: 2),
                ),
              );
              // Auto-clear clipboard
              final delay = ref.read(clipboardClearDelayProvider);
              if (delay.inSeconds > 0) {
                Future.delayed(delay, () {
                  Clipboard.setData(const ClipboardData(text: ''));
                });
              }
            }
          },
        ),
        onTap: () {
          context.go('/home/entry/${entry.uuid.uuid}');
        },
      ),
    );
  }
}
