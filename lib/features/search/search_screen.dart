import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kdbx/kdbx.dart';
import 'package:password_manager/l10n/app_localizations.dart';
import '../../core/kdbx/kdbx_service.dart';
import '../../core/providers/settings_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  List<KdbxEntry> _results = [];
  String? _filterGroupUuid;

  void _search(String query) {
    final kdbxService = ref.read(kdbxServiceProvider);
    var results = kdbxService.searchEntries(query);

    // Apply group filter
    if (_filterGroupUuid != null) {
      results = results.where((e) => e.parent?.uuid.uuid == _filterGroupUuid).toList();
    }

    setState(() => _results = results);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final kdbxService = ref.watch(kdbxServiceProvider);
    final colorScheme = Theme.of(context).colorScheme;

    // Build group list for filter
    final groups = <KdbxGroup>[];
    if (kdbxService.isOpen) {
      void collectGroups(KdbxGroup g) {
        groups.add(g);
        for (final sub in g.groups) {
          collectGroups(sub);
        }
      }
      for (final g in kdbxService.currentFile!.body.rootGroup.groups) {
        collectGroups(g);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.searchEntries,
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _results = []);
                    },
                  )
                : null,
          ),
          onChanged: _search,
        ),
        actions: [
          PopupMenuButton<String?>(
            icon: Icon(
              Icons.filter_list,
              color: _filterGroupUuid != null ? colorScheme.primary : null,
            ),
            onSelected: (uuid) {
              setState(() => _filterGroupUuid = uuid);
              if (_searchController.text.isNotEmpty) {
                _search(_searchController.text);
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: null,
                child: Text(l10n.allEntries),
              ),
              ...groups.map((g) => PopupMenuItem(
                value: g.uuid.uuid,
                child: Text(g.name.get() ?? ''),
              )),
            ],
          ),
        ],
      ),
      body: _results.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(
                    _searchController.text.isEmpty ? l10n.searchEntries : l10n.noResults,
                    style: TextStyle(color: colorScheme.outline),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final entry = _results[index];
                final title = entry.getString(KdbxKeyCommon.TITLE)?.getText() ?? '';
                final username = entry.getString(KdbxKeyCommon.USER_NAME)?.getText() ?? '';
                final groupName = entry.parent?.name.get() ?? '';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        title.isNotEmpty ? title[0].toUpperCase() : '?',
                        style: TextStyle(color: colorScheme.onPrimaryContainer),
                      ),
                    ),
                    title: _highlightText(title, _searchController.text, context),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (username.isNotEmpty) _highlightText(username, _searchController.text, context),
                        Text(
                          groupName,
                          style: TextStyle(fontSize: 11, color: colorScheme.outline),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      onPressed: () {
                        final password = entry.getString(KdbxKeyCommon.PASSWORD)?.getText() ?? '';
                        if (password.isNotEmpty) {
                          Clipboard.setData(ClipboardData(text: password));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.copiedToClipboard)),
                          );
                          final delay = ref.read(clipboardClearDelayProvider);
                          if (delay.inSeconds > 0) {
                            Future.delayed(delay, () => Clipboard.setData(const ClipboardData(text: '')));
                          }
                        }
                      },
                    ),
                    onTap: () => context.go('/home/entry/${entry.uuid.uuid}'),
                  ),
                );
              },
            ),
    );
  }

  Widget _highlightText(String text, String query, BuildContext context) {
    if (query.isEmpty) return Text(text);

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index == -1) return Text(text);

    final colorScheme = Theme.of(context).colorScheme;
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: text.substring(index, index + query.length),
            style: TextStyle(
              backgroundColor: colorScheme.primaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: text.substring(index + query.length)),
        ],
      ),
    );
  }
}
