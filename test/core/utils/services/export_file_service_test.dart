import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/utils/services/export_file_service.dart';

/// `write` is exercised against an injected temp dir (the tempDirProvider seam),
/// so no MethodChannel is touched. `share` is a platform-channel call and is
/// coverage-ignored in the service.
void main() {
  late Directory tempDir;
  late ExportFileService service;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('export_svc_test');
    service = ExportFileService(tempDirProvider: () async => tempDir);
  });

  tearDown(() async {
    if (tempDir.existsSync()) await tempDir.delete(recursive: true);
  });

  test('write then read back round-trips the CSV contents', () async {
    const contents = 'a,b\r\nc,d';
    final path = await service.write('jaga-saku-transactions.csv', contents);

    expect(File(path).existsSync(), isTrue);
    expect(await File(path).readAsString(), contents);
    // Persisted under the <temp>/exports/ subdirectory.
    expect(File(path).parent.path, endsWith('exports'));
  });

  test('write creates the exports directory when missing', () async {
    expect(Directory('${tempDir.path}/exports').existsSync(), isFalse);

    await service.write('x.csv', 'x');

    expect(Directory('${tempDir.path}/exports').existsSync(), isTrue);
  });
}
