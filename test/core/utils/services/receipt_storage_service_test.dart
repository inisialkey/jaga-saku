import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jaga_saku/core/utils/services/receipt_storage_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;

import '../../../helpers/mocks.dart';

/// [ReceiptStorageService] against a real temp dir + a mocked [ImagePicker] — no
/// MethodChannel is touched (the C2 seam: `docsDirProvider` injects the temp
/// dir). Proves bytes are copied to a **relative** path, cancel returns null,
/// resolve/delete behave, and a re-pick + delete-old frees only the first file.
void main() {
  setUpAll(registerFallbackValues);

  late Directory tempDocs;
  late File source;
  late MockImagePicker picker;
  late ReceiptStorageService service;

  // Stubs the picker to return an [XFile] for the temp source file (or null).
  void stubPick(XFile? result) => when(
    () => picker.pickImage(
      source: any(named: 'source'),
      imageQuality: any(named: 'imageQuality'),
      maxWidth: any(named: 'maxWidth'),
    ),
  ).thenAnswer((_) async => result);

  setUp(() async {
    tempDocs = await Directory.systemTemp.createTemp('m4docs');
    source = await File(
      p.join(tempDocs.path, 'src.jpg'),
    ).writeAsBytes([1, 2, 3]);
    picker = MockImagePicker();
    service = ReceiptStorageService(
      docsDirProvider: () async => tempDocs,
      picker: picker,
    );
  });

  tearDown(() => tempDocs.deleteSync(recursive: true));

  test(
    'pickAndStore copies bytes to a relative receipts/<micros>.jpg',
    () async {
      stubPick(XFile(source.path));

      final path = (await service.pickAndStore(ImageSource.gallery))!;

      // Relative-path guard (doc §13): no leading slash, no container prefix.
      expect(path, matches(RegExp(r'^receipts/\d+\.jpg$')));
      final stored = File(p.join(tempDocs.path, path));
      expect(stored.existsSync(), isTrue);
      expect(stored.readAsBytesSync(), [
        1,
        2,
        3,
      ]); // bytes were copied, not linked
    },
  );

  test('pickAndStore returns null when the user cancels', () async {
    stubPick(null);

    expect(await service.pickAndStore(ImageSource.camera), isNull);
  });

  test(
    'resolve finds a stored file and returns null for a missing one',
    () async {
      stubPick(XFile(source.path));
      final path = (await service.pickAndStore(ImageSource.gallery))!;

      final resolved = await service.resolve(path);
      expect(resolved, isNotNull);
      expect(resolved!.path, p.join(tempDocs.path, path));

      expect(await service.resolve('receipts/does-not-exist.jpg'), isNull);
    },
  );

  test(
    'delete is idempotent — removes the file, no throw on a second call',
    () async {
      stubPick(XFile(source.path));
      final path = (await service.pickAndStore(ImageSource.gallery))!;
      expect(File(p.join(tempDocs.path, path)).existsSync(), isTrue);

      await service.delete(path);
      expect(File(p.join(tempDocs.path, path)).existsSync(), isFalse);
      // Second delete of a now-missing file is a silent no-op.
      await service.delete(path);
      expect(File(p.join(tempDocs.path, path)).existsSync(), isFalse);
    },
  );

  test('re-pick then delete(old) frees only the first file', () async {
    stubPick(XFile(source.path));
    final first = (await service.pickAndStore(ImageSource.gallery))!;
    // A distinct microsecond timestamp yields a distinct filename.
    await Future<void>.delayed(const Duration(milliseconds: 2));
    final second = (await service.pickAndStore(ImageSource.gallery))!;
    expect(first, isNot(second));

    await service.delete(first);

    expect(File(p.join(tempDocs.path, first)).existsSync(), isFalse);
    expect(File(p.join(tempDocs.path, second)).existsSync(), isTrue);
  });
}
