import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:kdbx/kdbx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import '../kdbx/kdbx_service.dart';

class CsvService {
  static const _headers = ['Group', 'Title', 'Username', 'Password', 'URL', 'Notes', 'Tags'];

  /// Export all entries to a KeePass-compatible CSV file and share it.
  static Future<String> exportCsv(KdbxService kdbxService) async {
    final entries = kdbxService.getAllEntries(includeArchived: true);
    final rows = <List<String>>[_headers];

    for (final entry in entries) {
      final groupName = entry.parent?.name.get() ?? '';
      final title = entry.getString(KdbxKeyCommon.TITLE)?.getText() ?? '';
      final username = entry.getString(KdbxKeyCommon.USER_NAME)?.getText() ?? '';
      final password = entry.getString(KdbxKeyCommon.PASSWORD)?.getText() ?? '';
      final url = entry.getString(KdbxKeyCommon.URL)?.getText() ?? '';
      final notes = entry.getString(KdbxKey('Notes'))?.getText() ?? '';
      final tags = kdbxService.getTags(entry).join(';');

      rows.add([groupName, title, username, password, url, notes, tags]);
    }

    final csv = const ListToCsvConverter().convert(rows);
    final dir = await getApplicationCacheDirectory();
    final filePath = p.join(dir.path, 'password_export.csv');
    final file = File(filePath);
    await file.writeAsString(csv, encoding: utf8);

    await Share.shareXFiles(
      [XFile(filePath)],
      text: 'Password Export CSV',
    );

    return filePath;
  }

  /// Import entries from a CSV file. Returns number of entries imported.
  static Future<int> importCsv(KdbxService kdbxService) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result == null || result.files.isEmpty) return 0;

    final filePath = result.files.single.path;
    if (filePath == null) return 0;

    final content = await File(filePath).readAsString(encoding: utf8);
    final rows = const CsvToListConverter().convert(content);

    if (rows.isEmpty) return 0;

    // Detect headers
    final headers = rows.first.map((e) => e.toString().toLowerCase()).toList();
    final groupIdx = headers.indexOf('group');
    final titleIdx = headers.indexOf('title');
    final usernameIdx = headers.indexOf('username');
    final passwordIdx = headers.indexOf('password');
    final urlIdx = headers.indexOf('url');
    final notesIdx = headers.indexOf('notes');
    final tagsIdx = headers.indexOf('tags');

    if (titleIdx < 0) throw FormatException('CSV must have a Title column');

    final rootGroup = kdbxService.currentFile!.body.rootGroup;
    final groupCache = <String, KdbxGroup>{};

    int count = 0;
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;

      String cellAt(int idx) =>
          idx >= 0 && idx < row.length ? row[idx].toString() : '';

      final groupName = cellAt(groupIdx);
      final title = cellAt(titleIdx);
      if (title.isEmpty) continue;

      // Find or create group
      KdbxGroup targetGroup;
      if (groupName.isNotEmpty) {
        targetGroup = groupCache[groupName] ?? _findOrCreateGroup(kdbxService, rootGroup, groupName);
        groupCache[groupName] = targetGroup;
      } else {
        targetGroup = rootGroup;
      }

      final entry = kdbxService.createEntry(targetGroup);
      kdbxService.updateEntry(
        entry,
        title: title,
        username: cellAt(usernameIdx),
        password: cellAt(passwordIdx),
        url: cellAt(urlIdx),
        notes: cellAt(notesIdx),
      );

      // Tags
      final tagsStr = cellAt(tagsIdx);
      if (tagsStr.isNotEmpty) {
        final tags = tagsStr.split(';').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();
        kdbxService.setTags(entry, tags);
      }

      count++;
    }

    return count;
  }

  static KdbxGroup _findOrCreateGroup(KdbxService kdbxService, KdbxGroup root, String name) {
    for (final group in root.groups) {
      if (group.name.get() == name) return group;
    }
    return kdbxService.createGroup(root, name);
  }
}
