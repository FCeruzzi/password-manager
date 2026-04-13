import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kdbx/kdbx.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

final kdbxServiceProvider = Provider<KdbxService>((ref) => KdbxService());

class KdbxService {
  KdbxFile? _currentFile;
  String? _currentFilePath;
  Credentials? _currentCredentials;
  bool _isDirty = false;

  KdbxFile? get currentFile => _currentFile;
  String? get currentFilePath => _currentFilePath;
  bool get isDirty => _isDirty;
  bool get isOpen => _currentFile != null;

  void markDirty() => _isDirty = true;

  Future<KdbxFile> create({
    required String name,
    required Credentials credentials,
    String? filePath,
  }) async {
    final kdbxFormat = KdbxFormat();
    final file = kdbxFormat.create(credentials, name);

    // Create default groups
    final root = file.body.rootGroup;
    _createGroup(file, root, 'Generale');
    _createGroup(file, root, 'Email');
    _createGroup(file, root, 'Social');
    _createGroup(file, root, 'Banca');
    _createGroup(file, root, 'Carte di credito');
    _createGroup(file, root, 'Note sicure');

    _currentFile = file;
    _currentCredentials = credentials;
    _isDirty = true;

    if (filePath != null) {
      _currentFilePath = filePath;
      await save();
    } else {
      final dir = await getApplicationDocumentsDirectory();
      _currentFilePath = p.join(dir.path, '$name.kdbx');
      await save();
    }

    return file;
  }

  KdbxGroup _createGroup(KdbxFile file, KdbxGroup parent, String name) {
    return file.createGroup(parent: parent, name: name);
  }

  Future<KdbxFile> open({
    required Uint8List bytes,
    required Credentials credentials,
    String? filePath,
  }) async {
    final kdbxFormat = KdbxFormat();
    final file = await kdbxFormat.read(bytes, credentials);
    _currentFile = file;
    _currentCredentials = credentials;
    _currentFilePath = filePath;
    _isDirty = false;
    return file;
  }

  Future<KdbxFile> openFile({
    required String filePath,
    required Credentials credentials,
  }) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    return open(bytes: bytes, credentials: credentials, filePath: filePath);
  }

  Future<void> save() async {
    if (_currentFile == null || _currentFilePath == null) return;
    final bytes = await _currentFile!.save();
    final file = File(_currentFilePath!);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes);
    _isDirty = false;
  }

  Future<void> saveAs(String filePath) async {
    if (_currentFile == null) return;
    _currentFilePath = filePath;
    await save();
  }

  Future<void> changeMasterPassword(Credentials newCredentials) async {
    if (_currentFile == null) return;
    // The kdbx package handles credentials change via save with new creds
    _currentCredentials = newCredentials;
    _currentFile!.credentials = newCredentials;
    _isDirty = true;
  }

  void close() {
    _currentFile = null;
    _currentFilePath = null;
    _currentCredentials = null;
    _isDirty = false;
  }

  // Entry operations
  KdbxEntry createEntry(KdbxGroup group) {
    final entry = KdbxEntry.create(_currentFile!, group);
    group.addEntry(entry);
    _isDirty = true;
    return entry;
  }

  void updateEntry(KdbxEntry entry, {
    String? title,
    String? username,
    String? password,
    String? url,
    String? notes,
    Map<String, String>? customFields,
    Map<String, bool>? protectedFields,
  }) {
    if (title != null) {
      entry.setString(KdbxKeyCommon.TITLE, PlainValue(title));
    }
    if (username != null) {
      entry.setString(KdbxKeyCommon.USER_NAME, PlainValue(username));
    }
    if (password != null) {
      entry.setString(KdbxKeyCommon.PASSWORD, ProtectedValue.fromString(password));
    }
    if (url != null) {
      entry.setString(KdbxKeyCommon.URL, PlainValue(url));
    }
    if (notes != null) {
      entry.setString(KdbxKey('Notes'), PlainValue(notes));
    }
    if (customFields != null) {
      for (final entry2 in customFields.entries) {
        final isProtected = protectedFields?[entry2.key] ?? false;
        if (isProtected) {
          entry.setString(KdbxKey(entry2.key), ProtectedValue.fromString(entry2.value));
        } else {
          entry.setString(KdbxKey(entry2.key), PlainValue(entry2.value));
        }
      }
    }
    _isDirty = true;
  }

  void deleteEntry(KdbxEntry entry) {
    _currentFile!.deleteEntry(entry);
    _isDirty = true;
  }

  void moveEntry(KdbxEntry entry, KdbxGroup targetGroup) {
    _currentFile!.move(entry, targetGroup);
    _isDirty = true;
  }

  // Group operations
  KdbxGroup createGroup(KdbxGroup parent, String name) {
    final group = _createGroup(_currentFile!, parent, name);
    _isDirty = true;
    return group;
  }

  void renameGroup(KdbxGroup group, String newName) {
    group.name.set(newName);
    _isDirty = true;
  }

  void deleteGroup(KdbxGroup group) {
    _currentFile!.deleteGroup(group);
    _isDirty = true;
  }

  void moveGroup(KdbxGroup group, KdbxGroup targetParent) {
    _currentFile!.move(group, targetParent);
    _isDirty = true;
  }

  // Attachment operations
  void addAttachment(KdbxEntry entry, String filename, Uint8List data) {
    entry.createBinary(isProtected: false, name: filename, bytes: data);
    _isDirty = true;
  }

  void removeAttachment(KdbxEntry entry, String key) {
    entry.removeBinary(KdbxKey(key));
    _isDirty = true;
  }

  // Search
  List<KdbxEntry> searchEntries(String query) {
    if (_currentFile == null || query.isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    final results = <KdbxEntry>[];

    void searchGroup(KdbxGroup group) {
      for (final entry in group.entries) {
        final title = entry.getString(KdbxKeyCommon.TITLE)?.getText() ?? '';
        final username = entry.getString(KdbxKeyCommon.USER_NAME)?.getText() ?? '';
        final url = entry.getString(KdbxKeyCommon.URL)?.getText() ?? '';
        final notes = entry.getString(KdbxKey('Notes'))?.getText() ?? '';

        if (title.toLowerCase().contains(lowerQuery) ||
            username.toLowerCase().contains(lowerQuery) ||
            url.toLowerCase().contains(lowerQuery) ||
            notes.toLowerCase().contains(lowerQuery)) {
          results.add(entry);
        }

        // Search custom fields
        for (final key in entry.stringEntries) {
          if (key.value?.getText()?.toLowerCase().contains(lowerQuery) == true) {
            if (!results.contains(entry)) results.add(entry);
            break;
          }
        }
      }
      for (final subGroup in group.groups) {
        searchGroup(subGroup);
      }
    }

    searchGroup(_currentFile!.body.rootGroup);
    return results;
  }

  // Get all entries flat
  List<KdbxEntry> getAllEntries() {
    if (_currentFile == null) return [];
    final results = <KdbxEntry>[];
    void collect(KdbxGroup group) {
      results.addAll(group.entries);
      for (final sub in group.groups) {
        collect(sub);
      }
    }
    collect(_currentFile!.body.rootGroup);
    return results;
  }

  // TOTP support
  String? getTotpUri(KdbxEntry entry) {
    // Check common TOTP field names used by various KeePass plugins
    for (final key in ['otp', 'OTPAuth', 'TOTP Seed', 'TOTP Settings']) {
      final value = entry.getString(KdbxKey(key));
      if (value != null) return value.getText();
    }
    return null;
  }

  void setTotpUri(KdbxEntry entry, String otpauthUri) {
    entry.setString(KdbxKey('otp'), ProtectedValue.fromString(otpauthUri));
    _isDirty = true;
  }

  // Merge for sync
  Future<MergeContext> merge(KdbxFile remote) async {
    if (_currentFile == null) throw StateError('No file open');
    final mergeContext = _currentFile!.merge(remote);
    _isDirty = true;
    return mergeContext;
  }
}
