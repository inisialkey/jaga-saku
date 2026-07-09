import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';

part 'account_model.freezed.dart';

/// Data-layer row model for the `accounts` table. Maps are hand-written (no
/// `json_serializable`) because the shape is a SQLite row, not JSON:
/// `type` <-> enum, `archived` int <-> bool, and the derived `balance` column
/// from the balance query.
@freezed
abstract class AccountModel with _$AccountModel {
  const factory AccountModel({
    required String name,
    required AccountType type,
    int? id,
    @Default(0) int openingBalance,
    String? icon,
    int? color,
    @Default(0) int sortOrder,
    @Default(false) bool archived,
    @Default(0) int createdAt,
    @Default(0) int balance,
  }) = _AccountModel;

  const AccountModel._();

  /// Builds a model from a `SELECT a.*, ... AS balance` row. `balance` may be
  /// absent (plain reads) — it then falls back to `opening_balance`.
  factory AccountModel.fromMap(Map<String, Object?> map) => AccountModel(
    id: map['id'] as int?,
    name: map['name']! as String,
    type: AccountType.fromValue(map['type'] as String?),
    openingBalance: (map['opening_balance'] as int?) ?? 0,
    icon: map['icon'] as String?,
    color: map['color'] as int?,
    sortOrder: (map['sort_order'] as int?) ?? 0,
    archived: ((map['archived'] as int?) ?? 0) == 1,
    createdAt: (map['created_at'] as int?) ?? 0,
    balance: (map['balance'] as int?) ?? (map['opening_balance'] as int?) ?? 0,
  );

  factory AccountModel.fromEntity(Account account) => AccountModel(
    id: account.id,
    name: account.name,
    type: account.type,
    openingBalance: account.openingBalance,
    icon: account.icon,
    color: account.color,
    sortOrder: account.sortOrder,
    archived: account.archived,
    createdAt: account.createdAt,
    balance: account.balance,
  );

  /// Column map for insert/update. Omits `id` when null so AUTOINCREMENT fires,
  /// and omits the derived `balance` (not a column).
  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'name': name,
    'type': type.value,
    'opening_balance': openingBalance,
    'icon': icon,
    'color': color,
    'sort_order': sortOrder,
    'archived': archived ? 1 : 0,
    'created_at': createdAt,
  };

  Account toEntity() => Account(
    id: id,
    name: name,
    type: type,
    openingBalance: openingBalance,
    icon: icon,
    color: color,
    sortOrder: sortOrder,
    archived: archived,
    createdAt: createdAt,
    balance: balance,
  );
}
