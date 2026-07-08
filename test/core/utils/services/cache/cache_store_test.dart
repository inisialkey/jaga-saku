import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

/// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../../../helpers/fake_path_provider_platform.dart';

void main() {
  late CacheStore store;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    // Initializes Hive (initFlutter) so CacheStore.open can open its box.
    await MainBoxMixin.initHive('cache_store_test_');
    store = await CacheStore.open('cache_store_test_');
    await store.clear();
  });

  test('round-trips a nested envelope as String-keyed maps', () async {
    await store.write('k', {
      'data': [
        {'id': '1'},
      ],
      'meta': {'total': 1},
    });

    final value = store.read('k');

    expect(value, isNotNull);
    expect(value!['meta'], {'total': 1});
    // Nested objects decode as Map<String, dynamic> (not Hive's Map<dynamic,_>).
    expect((value['data'] as List).first, isA<Map<String, dynamic>>());
  });

  test('read returns null for a missing key', () {
    expect(store.read('missing'), isNull);
  });

  test('read honours maxAge', () async {
    await store.write('k', {'x': 1});
    expect(store.read('k', maxAge: const Duration(minutes: 5)), isNotNull);

    await Future<void>.delayed(const Duration(milliseconds: 5));
    expect(store.read('k', maxAge: Duration.zero), isNull);
  });

  test('clear removes entries', () async {
    await store.write('k', {'x': 1});
    await store.clear();
    expect(store.read('k'), isNull);
  });
}
