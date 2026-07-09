# UI Style Guide — Jaga Saku

> Converted from the attached PDF into Markdown format.

## 1. Brand Identity

### App Name

Jaga Saku

### Tagline

Jaga pengeluaran, pahami kebiasaan.

### Product Personality

Jaga Saku harus terasa:

- Ringan
- Aman
- Rapi
- Dekat dengan user Indonesia
- Tidak terlalu formal
- Tidak terlalu playful
- Mudah dipakai setiap hari

### Design Keywords

Clean
Calm
Friendly
Insightful
Budget-aware
Daily-use
Local-friendly

## 2. Design Direction

Jaga Saku menggunakan gaya desain:

Modern personal finance app
Card-based layout
Soft rounded corners
Clear money hierarchy

Friendly finance tone
Insight-first dashboard
Minimal but informative

Desain tidak boleh terlalu mirip aplikasi accounting yang padat. Fokus utama adalah membuat user cepat
memahami:

- Saldo saat ini
- Pengeluaran bulan ini
- Budget masih aman atau tidak
- Pengeluaran hari ini
- Pola kebiasaan spending

## 3. Visual Mood

### Mood Utama

Mood          Penjelasan

Calm          User tidak merasa panik saat melihat kondisi uang

Trustworthy   Cocok untuk aplikasi keuangan pribadi

Friendly      Dekat dengan kebiasaan harian

Organized     Data keuangan terasa rapi

Helpful       Insight terasa membantu, bukan menghakimi

### Avoid

Hindari style yang:

- Terlalu ramai
- Terlalu banyak gradient
- Terlalu banyak warna mencolok
- Terlalu mirip banking app
- Terlalu serius seperti accounting software
- Terlalu banyak chart di satu screen

## 4. Color Palette

### Primary Color

Gunakan warna hijau sebagai warna utama karena memberi kesan aman, stabil, dan dekat dengan finance.

Primary Green: #16A34A
Primary Green Dark: #15803D
Primary Green Light: #DCFCE7

### Semantic Colors

Income: #22C55E
Expense: #EF4444
Transfer: #3B82F6
Warning: #F59E0B
Critical: #DC2626
Info: #0EA5E9
Success: #16A34A

### Neutral Colors — Light Mode

Background: #F8FAFC
Surface: #FFFFFF
Surface Soft: #F1F5F9
Border: #E2E8F0

Text Primary: #0F172A
Text Secondary: #64748B
Text Tertiary: #94A3B8
Disabled: #CBD5E1

### Neutral Colors — Dark Mode

Background Dark: #020617
Surface Dark: #0F172A
Surface Soft Dark: #1E293B
Border Dark: #334155

Text Primary Dark: #F8FAFC
Text Secondary Dark: #CBD5E1
Text Tertiary Dark: #94A3B8
Disabled Dark: #475569

### Recommended Color Usage

Use Case             Color

Primary button       Primary Green

Use Case               Color

Income amount          Income

Expense amount         Expense

Transfer amount        Transfer

Budget safe            Primary Green

Budget warning         Warning

Budget critical        Critical

Empty state icon       Text Tertiary

Card background        Surface

Page background        Background

## 5. Typography

### Font Recommendation

Gunakan font yang clean dan mudah dibaca.

Pilihan:

Inter
Plus Jakarta Sans
Manrope
SF Pro, fallback iOS
Roboto, fallback Android

### Rekomendasi utama:

Plus Jakarta Sans

### Alasan:

- Modern
- Friendly
- Cocok untuk market Indonesia
- Bagus untuk dashboard dan angka

## 6. Type Scale

### Display

### Display Large

Size: 32
Weight: Bold
Usage: Total balance, major amount

### Display Medium

Size: 28
Weight: Bold
Usage: Important financial number

### Heading

### Heading 1

Size: 24
Weight: Bold
Usage: Page title

### Heading 2

Size: 20
Weight: SemiBold
Usage: Section title

### Heading 3

Size: 18
Weight: SemiBold
Usage: Card title

### Body

### Body Large

Size: 16
Weight: Regular
Usage: Main content

### Body Medium

Size: 14
Weight: Regular
Usage: Transaction detail, description

### Body Small

Size: 12
Weight: Regular
Usage: Metadata, helper text, labels

### Label

### Label Large

Size: 14
Weight: SemiBold
Usage: Button text

### Label Medium

Size: 12
Weight: Medium
Usage: Chip, status badge

### Label Small

Size: 11
Weight: Medium
Usage: Tiny label

## 7. Money Typography

Angka uang harus mudah dibaca dan punya hierarchy kuat.

### Total Balance

Size: 32
Weight: Bold
Line height: 40

### Card Amount

Size: 20
Weight: SemiBold
Line height: 28

### Transaction Amount

Size: 15
Weight: SemiBold
Line height: 22

### Small Amount

Size: 13
Weight: Medium
Line height: 18

### Format

Gunakan format Indonesia:

Rp 8.450.000
-Rp 35.000
+Rp 7.000.000

### Income:

+Rp 7.000.000

### Expense:

-Rp 35.000

### Transfer:

Rp 500.000

## 8. Spacing System

Gunakan 8-point spacing system.

4   = extra small
8   = small

12 = compact
16 = default page/card padding
20 = section gap
24 = large gap
32 = extra large gap
40 = screen section spacing

### Usage

Token           Value   Usage

spacing.xs         4    Icon gap, tiny label

spacing.sm         8    Item inner gap

spacing.md        12    Tile gap

spacing.lg        16    Page padding, card padding

spacing.xl        20    Section gap

spacing.2xl       24    Card group gap

spacing.3xl       32    Large section gap

## 9. Radius System

Gunakan rounded corner yang lembut.

Small: 8
Medium: 12
Large: 16
XLarge: 20
Bottom Sheet: 24 top-left/top-right
Full Pill: 999

### Usage

Component                    Radius

Small badge                     999

Chip                            999

Input field                      14

Button                           14

Component                Radius

Card                          20

Modal bottom sheet            24

Bottom navigation item        16

## 10. Shadow & Elevation

Gunakan shadow ringan. Jangan terlalu tebal.

### Light Mode Shadow

Card Shadow:
x: 0
y: 8
blur: 24
spread: 0
color: #0F172A with 6% opacity

### Soft Shadow

x: 0
y: 4
blur: 12
spread: 0
color: #0F172A with 4% opacity

### Usage

Component             Shadow

Main card             Soft shadow

Floating add button   Medium shadow

Bottom sheet          Medium shadow

Transaction tile      No shadow or very soft

Input field           No shadow

## 11. Layout Rules

### Page

Horizontal padding: 16
Top padding: 16–24
Bottom padding: 24 + bottom nav safe area

### Card

Padding: 16
Radius: 20
Gap between cards: 16–20

### Section

Section title margin bottom: 12
Section gap: 20–24

### Transaction Tile

Height: flexible, minimum 64
Padding: 12–16
Icon size: 40
Amount aligned right

## 12. Icon Style

### Icon Direction

Gunakan icon yang:

Rounded
Simple
Line-based atau softly filled
Consistent stroke width
Tidak terlalu detail

### Recommended Icon Libraries

Lucide Icons
Phosphor Icons
Iconsax
Material Symbols Rounded

Untuk Flutter, pilihan yang cocok:

iconsax
phosphor_flutter
lucide_icons_flutter

### Icon Size

Small: 16
Medium: 20
Default: 24
Large: 32
Category icon: 40 container

### Category Icon Container

Size: 40x40
Radius: 12
Background: soft category color
Icon: category color

## 13. Component Style

### 13.1 Primary Button

### Usage

Untuk aksi utama seperti:

- Save Transaction
- Add Account
- Set Budget
- Continue

### Style

Height: 52
Radius: 14
Background: Primary Green
Text: White
Font: Label Large

### States

Default: Primary Green
Pressed: Primary Green Dark
Disabled: Disabled background + muted text
Loading: show spinner + disabled interaction

### 13.2 Secondary Button

### Style

Height: 48
Radius: 14
Background: Primary Green Light
Text: Primary Green Dark
Border: none

Usage:

- Edit
- View Detail
- Setup later
- Secondary action

### 13.3 Text Button

Usage:

- Skip
- See All
- Change
- Clear Filter

Style:

Text color: Primary Green
Font: Label Medium
No background

### 13.4 App Card

### Style

Background: Surface
Radius: 20
Padding: 16
Border: Border color 1px optional
Shadow: Soft shadow

### Usage

- Total Balance Card
- Budget Guard Card
- Daily Review Card
- Insight Card
- Budget Item Card

### 13.5 Total Balance Card

### Content

Label: Total Saldo
Amount: Rp 8.450.000
Monthly income
Monthly expense

### Hierarchy

## 1. Total balance

## 2. Monthly summary

## 3. Supporting label

### Notes

Balance amount harus paling besar di Home.

### 13.6 Budget Guard Card

### Content

Title: Budget Guard
Category name
Remaining budget
Safe daily limit
Progress bar
Status badge

### Example

Budget Guard
Makan tersisa Rp750.000
Aman harian: Rp50.000/hari
[Progress bar]
Status: Aman

Status Badge

Safe: Green
Warning: Orange
Critical: Red
Over Budget: Red filled

### 13.7 Daily Review Card

### Content

Title: Review Hari Ini
Total spent today
Top category
Unplanned amount
Short insight

### Tone

Gunakan bahasa yang ringan:

Hari ini kamu sudah keluar Rp128.000.
Kategori terbesar: Makan.

Hindari copy yang menghakimi seperti:

Kamu boros hari ini.

Gunakan:

Pengeluaran hari ini lebih tinggi dari rata-rata minggu ini.

### 13.8 Transaction Tile

Structure

[Category Icon] [Title + Detail] [Amount]

### Example

🍽 Lunch
Makan • Cash
-Rp35.000

### Metadata Optional

Need
Want
Planned
Unplanned

### Amount Color

Income: Green
Expense: Red
Transfer: Blue or neutral

### 13.9 Segmented Control

Usage:

Expense | Income | Transfer

### Style

Height: 44
Radius: 14
Background: Surface Soft
Selected background: Surface / Primary Green
Selected text: Primary Green or White

### 13.10 Choice Chip

Usage:

Need
Want
Lifestyle
Emergency
Planned
Unplanned

### Style

Height: 36
Radius: 999
Padding horizontal: 14
Background default: Surface Soft

Background selected: Primary Green Light
Text selected: Primary Green Dark

### 13.11 Input Field

### Style

Height: 52
Radius: 14
Background: Surface
Border: Border 1px
Padding horizontal: 16

### Amount Field

Amount field boleh lebih besar:

Height: 72
Text size: 28
Font weight: Bold

### 13.12 Selector Field

Usage:

- Account selector
- Category selector
- Date selector
- Month selector

### Style

Height: 52
Radius: 14
Background: Surface
Border: Border 1px
Right icon: chevron

### 13.13 Progress Bar

Usage:

- Budget progress
- Planned vs unplanned
- Need vs want

### Style

Height: 8
Radius: 999
Background: Surface Soft
Fill: semantic color based on status

### 13.14 Insight Card

### Style

Background: Surface
Radius: 16
Padding: 14–16
Icon: 32 container
Title/body text

### Example

⚠ Budget Kopi sudah terpakai 85% bulan ini.

### Insight Types

Type       Icon Mood   Color

Warning    Alert       Orange

Positive   Check       Green

Trend Up   Chart       Blue

Critical   Alert       Red

Tip        Lightbulb   Info

## 14. Chart Style

Charts harus sederhana dan mudah dibaca.

### General Rules

Max 2–3 chart cards per screen
Avoid too many colors
Show label and amount
Always include fallback empty state

### Donut Chart

Usage:

- Expense by category

Style:

Center label optional
Category list below chart
Use category color

### Bar Chart

Usage:

- Income vs expense
- Planned vs unplanned

Style:

Simple vertical bars
Minimal grid lines
Legend visible

### Line Chart

Usage:

- Monthly trend

Style:

Soft line
Few data labels
Do not overload with dots

## 15. Empty State

Empty state harus friendly dan memberi aksi jelas.

Example — No Transactions

Belum ada transaksi
Mulai catat pengeluaran pertamamu hari ini.

[Tambah Transaksi]

Example — No Budget

Budget belum dibuat
Atur budget agar Jaga Saku bisa bantu memantau pengeluaranmu.

[Buat Budget]

### Empty State Style

Icon/illustration: 80–120
Title: Heading 3
Description: Body Medium
CTA: Primary or Secondary Button

## 16. Error State

Error copy harus jelas dan tidak teknis.

### Example

Data belum bisa dimuat
Coba ulangi beberapa saat lagi.

[Coba Lagi]

Hindari:

SQLiteException occurred.

Untuk debug, simpan di log, bukan tampil ke user.

## 17. Loading State

Gunakan loading yang ringan.

### Recommended

Skeleton card
Shimmer optional
Small spinner for button loading

### Avoid

Full screen loading terlalu sering
Spinner tanpa konteks

## 18. Bottom Navigation

Items

### Home

### Calendar

Add
### Insight

### More

### Style

Height: 72
Background: Surface

Top border: Border color
Selected icon: Primary Green
Selected label: Primary Green
Unselected: Text Tertiary

### Add Button

Tombol Add di tengah harus lebih menonjol.

Size: 56
Shape: Circle
Background: Primary Green
Icon: Plus
Icon color: White
Shadow: Medium

## 19. Bottom Sheet

Bottom sheet digunakan untuk:

- Account selector
- Category selector
- Date picker
- Filter
- Budget warning
- Delete confirmation

### Style

Top radius: 24
Padding: 20
Handle width: 40
Handle height: 4
Handle color: Border

### Bottom Sheet Layout

Title
Search field optional
List item
Action button optional

## 20. Light Mode

Light mode menjadi default.

### Feel

Clean
Bright
Soft
Friendly

### Usage

Background: #F8FAFC
Card: #FFFFFF
Text: #0F172A

## 21. Dark Mode

Dark mode harus tetap nyaman, bukan cuma invert warna.

### Feel

Calm
Low contrast but readable
Premium

### Usage

Background: #020617
Card: #0F172A
Surface Soft: #1E293B
Text Primary: #F8FAFC
Text Secondary: #CBD5E1

### Dark Mode Notes

- Jangan pakai pure black untuk semua surface.
- Card harus tetap terlihat dari background.

- Border lebih penting di dark mode.
- Chart color harus tetap cukup kontras.

## 22. Accessibility

### Minimum Contrast

Pastikan teks utama punya kontras cukup terhadap background.

### Touch Target

Minimum touch area: 44x44
Recommended: 48x48

### Text

- Jangan pakai font terlalu kecil untuk amount.
- Body text minimal 12.
- Label penting minimal 14.
- Amount utama minimal 28.

### Color

Jangan hanya mengandalkan warna. Tambahkan label/status.

Contoh:

Warning
Critical
Over Budget

## 23. Copywriting Tone

### Tone

Helpful
Calm
Clear
Non-judgmental
Local-friendly

### Good Copy

Budget Kopi sudah terpakai 85% bulan ini.

Pengeluaran hari ini lebih tinggi dari rata-rata minggu ini.

Saldo awal belum diatur. Atur saldo agar laporanmu lebih akurat.

### Avoid Copy

Kamu terlalu boros.

Keuanganmu buruk.

Pengeluaran kamu tidak sehat.

Gunakan bahasa yang membantu, bukan menyalahkan.

## 24. Design Tokens

### Flutter Token Example

```dart
class AppSpacing {
static const double xs = 4;
static const double sm = 8;
static const double md = 12;
static const double lg = 16;
static const double xl = 20;
static const double xxl = 24;
static const double xxxl = 32;
}


class AppRadius {
static const double sm = 8;
static const double md = 12;
static const double lg = 16;
static const double xl = 20;


static const double bottomSheet = 24;
static const double pill = 999;
}


class AppDurations {
static const Duration fast = Duration(milliseconds: 150);
static const Duration normal = Duration(milliseconds: 250);
static const Duration slow = Duration(milliseconds: 350);
}
```

## 25. Theme Extension Recommendation

Untuk Flutter, custom semantic color sebaiknya dibuat sebagai ThemeExtension , bukan hardcode di
widget.

Contoh semantic color:

income
expense
transfer
warning
critical
success
surfaceSoft
border
textSecondary

### Struktur konsep:

```dart
class AppPalette extends ThemeExtension<AppPalette> {
final Color income;
final Color expense;
final Color transfer;
final Color warning;
final Color critical;
final Color success;
final Color surfaceSoft;
final Color border;
final Color textSecondary;

const AppPalette({
required this.income,


required this.expense,
required this.transfer,
required this.warning,
required this.critical,
required this.success,
required this.surfaceSoft,
required this.border,
required this.textSecondary,
});
}
```

## 26. Component Priority for MVP

Komponen yang wajib dibuat lebih dulu:

AppScaffold
AppCard
PrimaryButton
SecondaryButton
AmountInputField
SelectorField
SegmentedControl
ChoiceChipGroup
TransactionTile
SummaryCard
BudgetGuardCard
DailyReviewCard
InsightCard
MonthSelector
BottomNavigation
EmptyStateView
ErrorStateView

## 27. Screen Style Summary

### Home

Hero: Total Balance
Unique card: Budget Guard

Support card: Daily Review
List: Recent Transactions

### Calendar

Calendar grid
Daily summary
Daily transaction list

### Add Transaction

Large amount input
Segmented transaction type
Bottom sheet selectors
Sticky save button

### Insight

Monthly overview
Expense chart
Planned vs unplanned
Need vs want
Insight cards

### More

Grouped menu
Finance
Data
App

## 28. Final Visual Direction

Jaga Saku harus terlihat seperti aplikasi yang:

Membantu user menjaga uang harian
Tidak menghakimi user
Mudah dipakai setiap hari
Rapi secara visual

Kuat secara informasi
Modern tapi tetap dekat dengan market Indonesia

Final design principle:

Informasi penting harus cepat terlihat, insight harus mudah dipahami, dan input transaksi harus
sesingkat mungkin.
