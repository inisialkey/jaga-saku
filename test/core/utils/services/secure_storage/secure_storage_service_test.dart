import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/utils/services/secure_storage/secure_storage_service.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

/// [SecureStorageService] against a mocked [FlutterSecureStorage] — no
/// MethodChannel is touched (the ctor injects the fake). Proves write/delete/
/// containsKey delegate, read returns the value, and — the keystore-reset
/// fail-safe (plan §4-E) — read swallows a [PlatformException] and returns null.
void main() {
  late MockFlutterSecureStorage storage;
  late SecureStorageService service;

  setUp(() {
    storage = MockFlutterSecureStorage();
    service = SecureStorageService(storage: storage);
  });

  test('write delegates to the underlying storage', () async {
    when(
      () => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});

    await service.write('pin_hash', 'abc');

    verify(() => storage.write(key: 'pin_hash', value: 'abc')).called(1);
  });

  test('read returns the stored value', () async {
    when(
      () => storage.read(key: any(named: 'key')),
    ).thenAnswer((_) async => 'abc');

    expect(await service.read('pin_hash'), 'abc');
  });

  test('read swallows a PlatformException and returns null (§4-E)', () async {
    when(
      () => storage.read(key: any(named: 'key')),
    ).thenThrow(PlatformException(code: 'decrypt_error'));

    expect(await service.read('pin_hash'), isNull);
  });

  test('delete delegates to the underlying storage', () async {
    when(() => storage.delete(key: any(named: 'key'))).thenAnswer((_) async {});

    await service.delete('pin_hash');

    verify(() => storage.delete(key: 'pin_hash')).called(1);
  });

  test('containsKey delegates to the underlying storage', () async {
    when(
      () => storage.containsKey(key: any(named: 'key')),
    ).thenAnswer((_) async => true);

    expect(await service.containsKey('pin_hash'), isTrue);
  });
}
