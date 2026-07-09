# Low-Fidelity Wireframe — Jaga Saku

> Converted from the attached PDF into Markdown format.

## App Identity

App Name: Jaga Saku
Tagline: Jaga pengeluaran, pahami kebiasaan.

## Main Navigation

Bottom Navigation:
[Home] [Calendar] [+ Add] [Insight] [More]

Tujuan navigasi:

- Home: Ringkasan utama dan kondisi keuangan harian.
- Calendar: Ledger transaksi berdasarkan tanggal.
- Add: Input transaksi cepat.
- Insight: Report dan spending habit.
- More: Account, Budget, Category, Settings, Backup.

## 1. Home Screen

### Purpose

Home menjadi pusat informasi utama. User harus langsung tahu:

- Total saldo saat ini.
- Pengeluaran bulan ini.
- Budget masih aman atau tidak.
- Pengeluaran hari ini seperti apa.
- Transaksi terbaru.

### Wireframe

```text
  ┌─────────────────────────────────────┐
  │ Hi, Oki                                       │
  │ Jaga pengeluaran, pahami kebiasaan. │
  │                                         [🔔]   │
  ├─────────────────────────────────────┤
  │                                               │


 │ ┌─────────────────────────────────┐ │
 │ │ Total Saldo                              │ │
 │ │ Rp 8.450.000                             │ │
 │ │                                          │ │
 │ │ Bulan ini                                │ │
 │ │ Income      Rp 7.000.000                 │ │
 │ │ Expense     Rp 3.250.000                 │ │
 │ └─────────────────────────────────┘ │
 │                                              │
 │ ┌─────────────────────────────────┐ │
 │ │ Budget Guard                             │ │
 │ │ Makan tersisa Rp750.000                  │ │
 │ │ Aman harian: Rp50.000/hari               │ │
 │ │ [██████░░░░] 50% terpakai                │ │
 │ │                                          │ │
 │ │ Status: Aman                             │ │
 │ └─────────────────────────────────┘ │
 │                                              │
 │ ┌─────────────────────────────────┐ │
 │ │ Review Hari Ini                          │ │
 │ │ Kamu sudah keluar Rp128.000              │ │
 │ │ Kategori terbesar: Makan                 │ │
 │ │ Unplanned: Rp45.000                      │ │
 │ └─────────────────────────────────┘ │
 │                                              │
 │ Recent Transactions                 See All│
 │ ┌─────────────────────────────────┐ │
 │ │ 🍽 Lunch                                  │ │
 │ │ Makan • Cash                  -Rp35.000 │ │
 │ ├─────────────────────────────────┤ │
 │ │ 🛵 GoRide                                 │ │
 │ │ Transport • GoPay             -Rp18.000 │ │
 │ ├─────────────────────────────────┤ │
 │ │ 💼 Salary                                 │ │
 │ │ Gaji • BCA               +Rp7.000.000 │ │
 │ └─────────────────────────────────┘ │
 │                                              │
 ├─────────────────────────────────────┤
 │ Home        Calendar        +       Insight │
 │ More                                         │
 └─────────────────────────────────────┘
```

### UI Notes

- Total Saldo menjadi hero card utama.

- Budget Guard harus terlihat sebagai fitur pembeda.
- Review Hari Ini dibuat ringkas agar user tidak merasa overload.
- Recent transaction cukup 3–5 item.
- CTA utama untuk transaksi tetap ada di bottom nav tengah.

### Important Components

HomeHeader
TotalBalanceCard
MonthlySummaryCard
BudgetGuardCard
DailyReviewCard
TransactionTile
BottomNavigationBar

## 2. Calendar Screen

### Purpose

Calendar menjadi ledger harian. User bisa melihat transaksi berdasarkan tanggal dan memahami pola
pengeluaran harian.

### Wireframe

```text
  ┌─────────────────────────────────────┐
  │ Calendar                                      │
  │ July 2026                              [< >] │
  ├─────────────────────────────────────┤
  │                                               │
  │ ┌─────────────────────────────────┐ │
  │ │ Mon Tue Wed Thu Fri Sat Sun               │ │
  │ │            1     2    3    4    5         │ │
  │ │            •          •    •              │ │
  │ │   6    7     8    9   10   11   12        │ │
  │ │        •   [8]         •                  │ │
  │ │ 13    14   15    16   17   18   19        │ │
  │ │ 20    21   22    23   24   25   26        │ │
  │ │ 27    28   29    30   31                  │ │
  │ └─────────────────────────────────┘ │
  │                                               │
  │ ┌─────────────────────────────────┐ │
  │ │ July 8, 2026                              │ │


 │ │ Income      Rp0                         │ │
 │ │ Expense     Rp128.000                   │ │
 │ │ Balance -Rp128.000                      │ │
 │ └─────────────────────────────────┘ │
 │                                              │
 │ Transactions                                 │
 │ ┌─────────────────────────────────┐ │
 │ │ 🍽 Lunch                                 │ │
 │ │ Makan • Need • Planned                  │ │
 │ │ Cash                          -Rp35.000 │ │
 │ ├─────────────────────────────────┤ │
 │ │ ☕ Coffee                                │ │
 │ │ Kopi • Want • Unplanned                 │ │
 │ │ Cash                          -Rp28.000 │ │
 │ ├─────────────────────────────────┤ │
 │ │ 🛵 GoRide                                │ │
 │ │ Transport • Need • Planned              │ │
 │ │ GoPay                         -Rp18.000 │ │
 │ └─────────────────────────────────┘ │
 │                                              │
 ├─────────────────────────────────────┤
 │ Home        Calendar        +       Insight │
 │ More                                         │
 └─────────────────────────────────────┘
```

### UI Notes

- Calendar cell cukup punya dot/indicator transaksi.
- Tanggal selected diberi highlight.
- Ringkasan harian tampil tepat di bawah kalender.
- List transaksi menggunakan format compact.
- Data need/want dan planned/unplanned bisa muncul sebagai label kecil.

### Important Components

MonthSelector
CalendarGrid
DailySummaryCard
TransactionTile
EmptyTransactionState

## 3. Add Transaction Screen

### Purpose

Screen ini harus paling cepat digunakan. User bisa input income, expense, atau transfer tanpa banyak
langkah.

### Wireframe — Expense Mode

```text
  ┌─────────────────────────────────────┐
  │ Add Transaction                        [X]   │
  ├─────────────────────────────────────┤
  │                                              │
  │ ┌─────────────────────────────────┐ │
  │ │ [Expense] [Income] [Transfer]            │ │
  │ └─────────────────────────────────┘ │
  │                                              │
  │ Amount                                       │
  │ ┌─────────────────────────────────┐ │
  │ │ Rp 0                                     │ │
  │ └─────────────────────────────────┘ │
  │                                              │
  │ Account                                      │
  │ ┌─────────────────────────────────┐ │
  │ │ Cash                                 >   │ │
  │ └─────────────────────────────────┘ │
  │                                              │
  │ Category                                     │
  │ ┌─────────────────────────────────┐ │
  │ │ Makan                                >   │ │
  │ └─────────────────────────────────┘ │
  │                                              │
  │ Planned Status                               │
  │ ┌─────────────────────────────────┐ │
  │ │ [Planned] [Unplanned]                    │ │
  │ └─────────────────────────────────┘ │
  │                                              │
  │ Spending Type                                │
  │ ┌─────────────────────────────────┐ │
  │ │ [Need] [Want] [Lifestyle]                │ │
  │ │ [Emergency]                              │ │
  │ └─────────────────────────────────┘ │
  │                                              │
  │ Date                                         │


 │ ┌─────────────────────────────────┐ │
 │ │ Today, July 8, 2026             >   │ │
 │ └─────────────────────────────────┘ │
 │                                         │
 │ Note                                    │
 │ ┌─────────────────────────────────┐ │
 │ │ Example: Lunch with team            │ │
 │ └─────────────────────────────────┘ │
 │                                         │
 │ ┌─────────────────────────────────┐ │
 │ │ Save Transaction                    │ │
 │ └─────────────────────────────────┘ │
 │                                         │
 └─────────────────────────────────────┘
```

### Wireframe — Transfer Mode

```text
 ┌─────────────────────────────────────┐
 │ Add Transaction                   [X]   │
 ├─────────────────────────────────────┤
 │                                         │
 │ ┌─────────────────────────────────┐ │
 │ │ [Expense] [Income] [Transfer]       │ │
 │ └─────────────────────────────────┘ │
 │                                         │
 │ Amount                                  │
 │ ┌─────────────────────────────────┐ │
 │ │ Rp 0                                │ │
 │ └─────────────────────────────────┘ │
 │                                         │
 │ From Account                            │
 │ ┌─────────────────────────────────┐ │
 │ │ BCA                             >   │ │
 │ └─────────────────────────────────┘ │
 │                                         │
 │ To Account                              │
 │ ┌─────────────────────────────────┐ │
 │ │ GoPay                           >   │ │
 │ └─────────────────────────────────┘ │
 │                                         │
 │ Date                                    │
 │ ┌─────────────────────────────────┐ │
 │ │ Today, July 8, 2026             >   │ │
 │ └─────────────────────────────────┘ │
 │                                         │


 │ Note                                          │
 │ ┌─────────────────────────────────┐ │
 │ │ Example: Top up GoPay                     │ │
 │ └─────────────────────────────────┘ │
 │                                               │
 │ ┌─────────────────────────────────┐ │
 │ │ Save Transfer                             │ │
 │ └─────────────────────────────────┘ │
 │                                               │
 └─────────────────────────────────────┘
```

### UI Notes

- Amount input harus besar dan mudah dibaca.
- Expense, Income, Transfer pakai segmented control.
- Field account/category lebih cocok pakai bottom sheet selector.
- Save button sticky di bawah.
- Untuk income, planned/unplanned dan spending type tidak perlu tampil.
- Untuk transfer, category tidak perlu tampil.
- Saat expense melebihi safe daily limit, tampilkan warning ringan sebelum save.

### Budget Guard Warning Example

```text
 ┌─────────────────────────────────────┐
 │ Budget Warning                                │
 │ Pengeluaran ini melewati batas aman │
 │ harian kategori Makan.                        │
 │                                               │
 │ Batas aman: Rp50.000/hari                     │
 │ Transaksi ini: Rp75.000                       │
 │                                               │
 │ [Tetap Simpan] [Ubah Nominal]                 │
 └─────────────────────────────────────┘
```

### Important Components

TransactionTypeSegmentedControl
AmountInputField
AccountSelectorField
CategorySelectorField
PlannedStatusToggle
SpendingTypeChips
DateSelectorField
NoteInputField

StickySaveButton
BudgetWarningBottomSheet

## 4. Insight Screen

### Purpose

Insight menjadi pembeda utama Jaga Saku. Screen ini bukan hanya report, tapi membantu user memahami
kebiasaan pengeluaran.

### Wireframe

```text
  ┌─────────────────────────────────────┐
  │ Insight                                    │
  │ July 2026                          [v]     │
  ├─────────────────────────────────────┤
  │                                            │
  │ ┌─────────────────────────────────┐ │
  │ │ Monthly Overview                       │ │
  │ │ Income     Rp7.000.000                 │ │
  │ │ Expense    Rp3.250.000                 │ │
  │ │ Saved      Rp3.750.000                 │ │
  │ └─────────────────────────────────┘ │
  │                                            │
  │ Expense by Category                        │
  │ ┌─────────────────────────────────┐ │
  │ │               [Donut Chart]            │ │
  │ │                                        │ │
  │ │ Makan         Rp1.250.000      38%     │ │
  │ │ Transport     Rp620.000        19%     │ │
  │ │ Kopi          Rp255.000         8%     │ │
  │ └─────────────────────────────────┘ │
  │                                            │
  │ Planned vs Unplanned                       │
  │ ┌─────────────────────────────────┐ │
  │ │ Planned         Rp2.100.000            │ │
  │ │ [████████░░] 72%                       │ │
  │ │                                        │ │
  │ │ Unplanned       Rp850.000              │ │
  │ │ [████░░░░░░] 28%                       │ │
  │ └─────────────────────────────────┘ │
  │                                            │


 │ Need vs Want                                   │
 │ ┌─────────────────────────────────┐ │
 │ │ Need             64%                       │ │
 │ │ Want             22%                       │ │
 │ │ Lifestyle        10%                       │ │
 │ │ Emergency         4%                       │ │
 │ └─────────────────────────────────┘ │
 │                                                │
 │ Spending Insight                               │
 │ ┌─────────────────────────────────┐ │
 │ │ ⚠ Budget Kopi sudah terpakai               │ │
 │ │ 85% bulan ini.                             │ │
 │ ├─────────────────────────────────┤ │
 │ │ 📈 Pengeluaran Makan naik 18%               │ │
 │ │ dibanding bulan lalu.                      │ │
 │ ├─────────────────────────────────┤ │
 │ │ 💡 Unplanned expense bulan ini              │ │
 │ │ lebih tinggi dari bulan lalu.              │ │
 │ └─────────────────────────────────┘ │
 │                                                │
 ├─────────────────────────────────────┤
 │ Home        Calendar         +       Insight │
 │ More                                           │
 └─────────────────────────────────────┘
```

### UI Notes

- Insight harus pakai bahasa manusiawi, bukan istilah teknis.
- Jangan tampilkan terlalu banyak chart sekaligus.
- Chart cukup 2–3 bagian utama.
- Insight cards harus terasa actionable.
- Month selector diletakkan di header agar user bisa review bulan lain.

### Important Components

MonthSelector
MonthlyOverviewCard
ExpenseCategoryChart
PlannedUnplannedCard
NeedWantCard
InsightCard

## 5. More Screen

### Purpose

More menjadi tempat fitur pendukung agar bottom navigation tetap clean.

### Wireframe

```text
  ┌─────────────────────────────────────┐
  │ More                                            │
  ├─────────────────────────────────────┤
  │                                                 │
  │ ┌─────────────────────────────────┐ │
  │ │ Jaga Saku                                   │ │
  │ │ Jaga pengeluaran, pahami                    │ │
  │ │ kebiasaan.                                  │ │
  │ └─────────────────────────────────┘ │
  │                                                 │
  │ Finance                                         │
  │ ┌─────────────────────────────────┐ │
  │ │ 💳 Accounts                          >       │ │
  │ ├─────────────────────────────────┤ │
  │ │ 🧾 Categories                        >       │ │
  │ ├─────────────────────────────────┤ │
  │ │ 🎯 Budget                            >       │ │
  │ ├─────────────────────────────────┤ │
  │ │ 🔁 Recurring, V2                     >       │ │
  │ └─────────────────────────────────┘ │
  │                                                 │
  │ Data                                            │
  │ ┌─────────────────────────────────┐ │
  │ │ 📤 Export CSV, V2                    >       │ │
  │ ├─────────────────────────────────┤ │
  │ │ 💾 Backup & Restore, V2              >       │ │
  │ └─────────────────────────────────┘ │
  │                                                 │
  │ App                                             │
  │ ┌─────────────────────────────────┐ │
  │ │ 🌙 Appearance                            >    │ │
  │ ├─────────────────────────────────┤ │
  │ │ 🔐 Security, V2                      >       │ │
  │ ├─────────────────────────────────┤ │
  │ │ ⚙ Settings                          >       │ │
  │ ├─────────────────────────────────┤ │


  │ │ ℹ About Jaga Saku                    >   │ │
  │ └─────────────────────────────────┘ │
  │                                              │
  ├─────────────────────────────────────┤
  │ Home        Calendar        +       Insight │
  │ More                                         │
  └─────────────────────────────────────┘
```

### UI Notes

- More jangan jadi tempat sampah fitur. Tetap group by section.
- Untuk MVP, fitur V2 bisa disembunyikan atau diberi label “Coming Soon”.
- Budget sebenarnya penting, tapi tidak masuk bottom nav agar nav tetap sederhana.
- Accounts, Categories, dan Budget bisa menjadi menu utama di More.

### Important Components

AppInfoCard
MenuSection
MenuTile
ComingSoonBadge

## Additional Supporting Screens

Walaupun 5 screen utama sudah cukup, beberapa supporting screen tetap perlu dibuat setelah ini.

### Account Screen

```text
  ┌─────────────────────────────────────┐
  │ Accounts                               [+]   │
  ├─────────────────────────────────────┤
  │ Total Asset                                  │
  │ Rp 8.450.000                                 │
  │                                              │
  │ ┌─────────────────────────────────┐ │
  │ │ Cash                          Rp450.000 │ │
  │ ├─────────────────────────────────┤ │
  │ │ BCA                       Rp7.500.000 │ │
  │ ├─────────────────────────────────┤ │
  │ │ GoPay                         Rp500.000 │ │


 │ └─────────────────────────────────┘ │
 └─────────────────────────────────────┘
```

### Budget Screen

```text
 ┌─────────────────────────────────────┐
 │ Budget                          [+]    │
 │ July 2026                      [v]     │
 ├─────────────────────────────────────┤
 │ ┌─────────────────────────────────┐ │
 │ │ Makan                              │ │
 │ │ Rp750.000 / Rp1.500.000            │ │
 │ │ [█████░░░░░] 50%                   │ │
 │ │ Aman harian: Rp50.000/hari         │ │
 │ ├─────────────────────────────────┤ │
 │ │ Kopi                               │ │
 │ │ Rp255.000 / Rp300.000              │ │
 │ │ [████████░░] 85% Warning           │ │
 │ │ Aman harian: Rp3.000/hari          │ │
 │ └─────────────────────────────────┘ │
 └─────────────────────────────────────┘
```

### Category Screen

```text
 ┌─────────────────────────────────────┐
 │ Categories                      [+]    │
 ├─────────────────────────────────────┤
 │ [Expense] [Income]                     │
 │                                        │
 │ Makan                                  │
 │ ├─ Sarapan                             │
 │ ├─ Lunch                               │
 │ └─ Dinner                              │
 │                                        │
 │ Transport                              │
 │ ├─ Ojek Online                         │
 │ ├─ Bensin                              │
 │ └─ Parkir                              │
 └─────────────────────────────────────┘
```

## Design Rules for Low-Fidelity Phase

## Layout Rules

Page padding: 16
Card padding: 16
Card radius: 20
Section gap: 20
Item gap: 12
Bottom nav height: 72

### Content Hierarchy

## 1. Money amount

## 2. Status or warning

## 3. Supporting detail

## 4. Secondary action

### Component Priority

Komponen yang wajib dibuat reusable:

AppCard
TransactionTile
SummaryCard
BudgetGuardCard
DailyReviewCard
InsightCard
AmountInput
SelectorField
SegmentedControl
ChoiceChipGroup
MonthSelector
BottomNavigation

## Final Low-Fidelity Direction

Jaga Saku harus terasa seperti:

Clean finance tracker
Daily-use friendly app
Budget-aware dashboard
Calendar-based transaction ledger
Insight-first report screen
Indonesia-friendly money habit companion

Fokus desain utama:

Home = kondisi keuangan sekarang
Calendar = transaksi harian
Add = input super cepat
Insight = pemahaman kebiasaan
More = pengaturan dan fitur pendukung
