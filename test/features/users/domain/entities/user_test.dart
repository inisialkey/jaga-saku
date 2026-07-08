import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/users/users.dart';

void main() {
  const tUser = User(
    id: 'u1',
    name: 'Test User',
    email: 'user@mock.com',
    role: 'user',
    isActive: true,
    createdAt: '2025-06-01T09:32:39.846Z',
    updatedAt: '2025-06-01T09:32:39.846Z',
    phone: '+6281234567891',
    avatarUrl: 'https://example.com/a.png',
  );

  test('stores fields correctly', () {
    expect(tUser.id, 'u1');
    expect(tUser.name, 'Test User');
    expect(tUser.email, 'user@mock.com');
    expect(tUser.role, 'user');
    expect(tUser.isActive, isTrue);
    expect(tUser.phone, '+6281234567891');
    expect(tUser.avatarUrl, 'https://example.com/a.png');
  });

  test('optional fields default to null', () {
    const u = User(
      id: 'u2',
      name: 'No Optionals',
      email: 'x@y.com',
      role: 'user',
      isActive: false,
      createdAt: '2025-06-01T09:32:39.846Z',
      updatedAt: '2025-06-01T09:32:39.846Z',
    );
    expect(u.phone, isNull);
    expect(u.avatarUrl, isNull);
  });

  test('equality and copyWith', () {
    final copy = tUser.copyWith(name: 'Changed');
    expect(copy.name, 'Changed');
    expect(copy == tUser, isFalse);
    expect(tUser.copyWith() == tUser, isTrue);
  });
}
