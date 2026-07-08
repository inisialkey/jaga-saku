import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

void main() {
  group('featureFlagsFrom', () {
    test('extracts the String->bool flag map', () {
      expect(
        featureFlagsFrom({
          'data': {
            'feature_flags': {'dark_mode': true, 'new_checkout': false},
          },
        }),
        {'dark_mode': true, 'new_checkout': false},
      );
    });

    test('empty when body / data / flags are missing or wrong type', () {
      expect(featureFlagsFrom(null), isEmpty);
      expect(featureFlagsFrom('x'), isEmpty);
      expect(featureFlagsFrom({'data': 'x'}), isEmpty);
      expect(featureFlagsFrom(<String, dynamic>{}), isEmpty);
      expect(
        featureFlagsFrom({
          'data': {'feature_flags': 'x'},
        }),
        isEmpty,
      );
    });

    test('skips non-bool values', () {
      expect(
        featureFlagsFrom({
          'data': {
            'feature_flags': {'a': true, 'b': 1, 'c': 'yes'},
          },
        }),
        {'a': true},
      );
    });
  });

  group('RemoteConfigService.isEnabled', () {
    final service = RemoteConfigService(
      DioClient(isUnitTest: true),
      initialFlags: const {'on': true, 'off': false},
    );

    test('returns the known flag value', () {
      expect(service.isEnabled('on'), isTrue);
      expect(service.isEnabled('off'), isFalse);
    });

    test('returns the fallback for an unknown key', () {
      expect(service.isEnabled('missing'), isFalse);
      expect(service.isEnabled('missing', fallback: true), isTrue);
    });

    test('all exposes a read-only snapshot', () {
      expect(service.all, {'on': true, 'off': false});
      expect(() => service.all['x'] = true, throwsUnsupportedError);
    });
  });
}
