import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';

/// Shared catalog that maps the stable string keys stored in the DB
/// (`accounts.icon` / `categories.icon` are `TEXT`) to `iconsax` [IconData].
///
/// The DB never stores an [IconData] — only the key. Every screen that renders
/// an account / category icon resolves through [resolve] so a single catalog is
/// the source of truth (style guide §12). Keys are grouped by domain purely to
/// give the icon picker a sensible order ([pickerKeys]).
class AppIcons {
  AppIcons._();

  /// Curated, grouped `iconsax` set. Insertion order drives the picker order.
  static const Map<String, IconData> catalog = {
    // ── Money / accounts ────────────────────────────────────────────────
    'wallet': Iconsax.wallet,
    'bank': Iconsax.bank,
    'ewallet': Iconsax.wallet_3,
    'card': Iconsax.card,
    'cash': Iconsax.money,
    'savings': Iconsax.save_2,
    // ── Food ────────────────────────────────────────────────────────────
    'restaurant': Iconsax.reserve,
    'coffee': Iconsax.coffee,
    'groceries': Iconsax.shopping_cart,
    // ── Transport ───────────────────────────────────────────────────────
    'transport': Iconsax.bus,
    'car': Iconsax.car,
    'fuel': Iconsax.gas_station,
    // ── Lifestyle ───────────────────────────────────────────────────────
    'shopping': Iconsax.shopping_bag,
    'entertainment': Iconsax.music,
    'health': Iconsax.health,
    'gift': Iconsax.gift,
    'home': Iconsax.home_2,
    'bills': Iconsax.receipt_item,
    'education': Iconsax.teacher,
    'travel': Iconsax.airplane,
    // ── Income ──────────────────────────────────────────────────────────
    'salary': Iconsax.money_recive,
    'bonus': Iconsax.medal_star,
    'investment': Iconsax.trend_up,
    // ── Misc ────────────────────────────────────────────────────────────
    'category': Iconsax.category,
    // Used by transfer transactions (no user-facing category) — M2.
    'transfer': Iconsax.arrow_swap_horizontal,
  };

  /// Resolves a stored key to its icon, falling back to a neutral glyph for a
  /// null / unknown / legacy key (never throws).
  static IconData resolve(String? key) => catalog[key] ?? Iconsax.category;

  /// Keys in catalog order — the icon picker grid iterates these.
  static List<String> get pickerKeys => catalog.keys.toList(growable: false);
}
