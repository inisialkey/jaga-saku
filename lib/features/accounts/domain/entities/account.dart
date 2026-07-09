import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';

/// The kind of money store an [Account] represents. Persisted as its [value]
/// string in `accounts.type`; the enum keeps the domain type-safe (rule 19 —
/// no raw strings leaking into the entity).
enum AccountType {
  cash('cash'),
  bank('bank'),
  ewallet('ewallet');

  const AccountType(this.value);

  /// Stored representation (the `type` column value).
  final String value;

  /// Maps a stored string back to the enum, defaulting to [cash] for an
  /// unknown / legacy value (never throws).
  static AccountType fromValue(String? value) => AccountType.values.firstWhere(
    (t) => t.value == value,
    orElse: () => AccountType.cash,
  );
}

/// A money account (cash / bank / e-wallet). Pure domain entity — colors are
/// ARGB `int`, the icon is a catalog key `String`, and the type is a domain
/// [AccountType]; no Flutter / data types cross this boundary.
@freezed
abstract class Account with _$Account {
  const factory Account({
    required String name,
    required AccountType type,

    /// `null` until persisted (SQLite AUTOINCREMENT assigns it on insert).
    int? id,
    @Default(0) int openingBalance,

    /// [AppIcons] catalog key, resolved to an `IconData` in the UI layer.
    String? icon,

    /// ARGB color value.
    int? color,
    @Default(0) int sortOrder,
    @Default(false) bool archived,
    @Default(0) int createdAt,

    /// Derived, non-persisted spendable balance. Populated by the balance SQL
    /// query (opening balance +/- signed transaction sums); equals
    /// [openingBalance] until transactions exist (M2).
    @Default(0) int balance,
  }) = _Account;
}
