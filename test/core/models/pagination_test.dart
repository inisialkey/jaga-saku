import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/models/pagination.dart';

void main() {
  group('PaginationMeta.fromJson', () {
    test('parses snake_case keys', () {
      final result = PaginationMeta.fromJson(const {
        'page': 1,
        'limit': 20,
        'total': 153,
        'total_pages': 8,
        'has_next': true,
        'has_prev': false,
      });

      expect(result.page, equals(1));
      expect(result.limit, equals(20));
      expect(result.total, equals(153));
      expect(result.totalPages, equals(8));
      expect(result.hasNext, isTrue);
      expect(result.hasPrev, isFalse);
    });

    test('applies defaults for missing keys', () {
      final result = PaginationMeta.fromJson(const {});

      expect(result.page, equals(1));
      expect(result.limit, equals(20));
      expect(result.total, equals(0));
      expect(result.totalPages, equals(0));
      expect(result.hasNext, isFalse);
      expect(result.hasPrev, isFalse);
    });
  });

  group('Page.fromEnvelope', () {
    test('decodes a list data + meta envelope', () {
      final page = Page<String>.fromEnvelope(const {
        'success': true,
        'message': 'ok',
        'data': ['a', 'b', 'c'],
        'meta': {
          'page': 2,
          'limit': 3,
          'total': 9,
          'total_pages': 3,
          'has_next': true,
          'has_prev': true,
        },
      }, (json) => json! as String);

      expect(page.items, equals(['a', 'b', 'c']));
      expect(page.meta.page, equals(2));
      expect(page.meta.hasNext, isTrue);
    });

    test('yields empty items + default meta when data/meta missing', () {
      final page = Page<String>.fromEnvelope(const {
        'success': true,
        'data': null,
      }, (json) => json! as String);

      expect(page.items, isEmpty);
      expect(page.meta, equals(const PaginationMeta()));
    });

    test('value equality holds for identical pages', () {
      const meta = PaginationMeta(total: 1, totalPages: 1);
      const a = Page<String>(items: ['x'], meta: meta);
      const b = Page<String>(items: ['x'], meta: meta);

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });
  });
}
