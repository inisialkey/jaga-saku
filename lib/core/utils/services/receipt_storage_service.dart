import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';
import 'package:path/path.dart' as p;

/// First on-device file-I/O service (V2-M4). Picks a photo, copies its bytes
/// into `<app-docs>/receipts/<micros>.jpg`, and returns the **relative** path
/// stored in `transactions.receipt_path` (resolved at read — the iOS docs
/// container path changes across reinstall/OS update, so absolute would dangle).
///
/// [docsDirProvider] is the testability seam: DI wires it to path_provider's
/// `getApplicationDocumentsDirectory`; unit tests pass `() async => tempDir`, so
/// no MethodChannel is touched. Reached via cubit/repo only (rule 5).
class ReceiptStorageService {
  ReceiptStorageService({
    required Future<Directory> Function() docsDirProvider,
    ImagePicker? picker,
  }) : _docsDirProvider = docsDirProvider,
       _picker = picker ?? ImagePicker();

  final Future<Directory> Function() _docsDirProvider;
  final ImagePicker _picker;

  static const String _subdir = 'receipts';

  /// Picks (camera/gallery), copies bytes into app-docs, returns the relative
  /// path. `null` when the user cancels. Throws only on a genuine pick/copy
  /// error (the cubit maps that to a toast). `imageQuality`/`maxWidth` cap size.
  Future<String?> pickAndStore(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1600,
    );
    if (picked == null) return null; // cancelled
    final docs = await _docsDirProvider();
    final dir = Directory(p.join(docs.path, _subdir));
    if (!dir.existsSync()) dir.createSync(recursive: true);
    final relativePath = p.join(
      _subdir,
      '${DateTime.now().microsecondsSinceEpoch}.jpg',
    );
    // readAsBytes → writeAsBytes copies the pixels, so the receipt survives the
    // original being deleted from the gallery.
    await File(
      p.join(docs.path, relativePath),
    ).writeAsBytes(await picked.readAsBytes());
    return relativePath; // e.g. 'receipts/1720800000000000.jpg' — no leading slash
  }

  /// Absolute [File] for a stored relative path, or null if the file is gone
  /// (iOS restore / manual removal) → the UI renders a placeholder, not a crash.
  Future<File?> resolve(String relativePath) async {
    final docs = await _docsDirProvider();
    final file = File(p.join(docs.path, relativePath));
    return file.existsSync() ? file : null;
  }

  /// Removes the file. No-throw + idempotent (missing file is a no-op); logs on
  /// a real I/O error so a stale file never blocks a row delete.
  Future<void> delete(String relativePath) async {
    try {
      final docs = await _docsDirProvider();
      final file = File(p.join(docs.path, relativePath));
      if (file.existsSync()) await file.delete();
    } catch (e, s) {
      log.e('receipt delete failed', error: e, stackTrace: s);
    }
  }
}
