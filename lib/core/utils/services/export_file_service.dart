import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

/// Writes an export file to `<temp>/exports/<fileName>` and hands it to the
/// system share sheet. Exports are transient (regenerable, unlike backups), so
/// they live under [getTemporaryDirectory], not app-docs.
///
/// [tempDirProvider] is the testability seam — DI wires path_provider's
/// `getTemporaryDirectory`; unit tests pass `() async => tempDir`, so [write]
/// touches no MethodChannel. [share] is an inherent platform-channel call and is
/// coverage-ignored. Reached via the cubit only (rule 5).
class ExportFileService {
  ExportFileService({required Future<Directory> Function() tempDirProvider})
    : _tempDirProvider = tempDirProvider;

  final Future<Directory> Function() _tempDirProvider;

  static const String _subdir = 'exports';

  /// Writes [contents] to `<temp>/exports/<fileName>` (creating the dir) and
  /// returns the absolute path.
  Future<String> write(String fileName, String contents) async {
    final tmp = await _tempDirProvider();
    final dir = Directory(p.join(tmp.path, _subdir));
    if (!dir.existsSync()) dir.createSync(recursive: true);
    final path = p.join(dir.path, fileName);
    await File(path).writeAsString(contents);
    return path;
  }

  //coverage:ignore-start
  // ponytail: duplicates BackupFileService.share — the only overlap between the
  // two file services. Two consumers don't justify a shared FileShareService
  // yet; converge both onto one if a third share consumer appears.
  /// Opens the system share sheet for the file at [path].
  Future<void> share(String path) async {
    await SharePlus.instance.share(ShareParams(files: [XFile(path)]));
  }

  //coverage:ignore-end
}
