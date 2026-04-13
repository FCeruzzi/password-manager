import 'dart:typed_data';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstract file source for local and cloud storage
abstract class FileSource {
  String get displayName;
  String get identifier;

  Future<Uint8List> read();
  Future<void> write(Uint8List data);
  Future<bool> exists();
}

class LocalFileSource extends FileSource {
  final String filePath;

  LocalFileSource(this.filePath);

  @override
  String get displayName => filePath.split(Platform.pathSeparator).last;

  @override
  String get identifier => filePath;

  @override
  Future<Uint8List> read() async {
    final file = File(filePath);
    return file.readAsBytes();
  }

  @override
  Future<void> write(Uint8List data) async {
    final file = File(filePath);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(data);
  }

  @override
  Future<bool> exists() async {
    return File(filePath).exists();
  }
}

final fileSourceProvider = Provider<FileSource?>((ref) => null);
