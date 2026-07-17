import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

/// Wraps the three file plugins backup/restore needs: writes/reads a JSON file
/// under `<app-docs>/backups/`, shares it via the system sheet, and picks a
/// `.json` file to restore.
///
/// [docsDirProvider] is the testability seam — DI wires path_provider's
/// `getApplicationDocumentsDirectory`; unit tests pass `() async => tempDir`, so
/// `write`/`read` touch no MethodChannel. `share`/`pickJson` are inherently
/// platform-channel calls and are coverage-ignored. Reached via the cubit only
/// (rule 5).
class BackupFileService {
  BackupFileService({required Future<Directory> Function() docsDirProvider})
    : _docsDirProvider = docsDirProvider;

  final Future<Directory> Function() _docsDirProvider;

  static const String _subdir = 'backups';

  /// Writes [contents] to `<app-docs>/backups/<fileName>` (creating the dir) and
  /// returns the absolute path.
  Future<String> write(String fileName, String contents) async {
    final docs = await _docsDirProvider();
    final dir = Directory(p.join(docs.path, _subdir));
    if (!dir.existsSync()) dir.createSync(recursive: true);
    final path = p.join(dir.path, fileName);
    await File(path).writeAsString(contents);
    return path;
  }

  /// Reads a file's full text contents.
  Future<String> read(String path) => File(path).readAsString();

  //coverage:ignore-start
  /// Opens the system share sheet for the file at [path].
  Future<void> share(String path) async {
    await SharePlus.instance.share(ShareParams(files: [XFile(path)]));
  }

  /// Prompts the user to pick a `.json` backup; returns its path (null on
  /// cancel).
  Future<String?> pickJson() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    return result?.files.single.path;
  }

  //coverage:ignore-end
}
