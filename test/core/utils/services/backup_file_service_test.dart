import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/utils/services/backup_file_service.dart';

/// `write`/`read` are exercised against an injected temp dir (the docsDirProvider
/// seam), so no MethodChannel is touched. `share`/`pickJson` are platform-channel
/// calls and are coverage-ignored in the service.
void main() {
  late Directory tempDir;
  late BackupFileService service;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('backup_svc_test');
    service = BackupFileService(docsDirProvider: () async => tempDir);
  });

  tearDown(() async {
    if (tempDir.existsSync()) await tempDir.delete(recursive: true);
  });

  test('write then read round-trips the file contents', () async {
    const contents = '{"app":"Jaga Saku","schemaVersion":7}';
    final path = await service.write('jaga-saku-backup.json', contents);

    expect(File(path).existsSync(), isTrue);
    expect(await service.read(path), contents);
    // Persisted under the <docs>/backups/ subdirectory.
    expect(File(path).parent.path, endsWith('backups'));
  });

  test('write creates the backups directory when missing', () async {
    expect(Directory('${tempDir.path}/backups').existsSync(), isFalse);

    await service.write('a.json', 'x');

    expect(Directory('${tempDir.path}/backups').existsSync(), isTrue);
  });
}
