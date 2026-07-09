# Jaga Saku UI Design

> Converted from the attached PDF into Markdown format.

Create a high-fidelity mobile app UI design for a personal finance app called Jaga Saku.

Tagline: “Jaga pengeluaran, pahami kebiasaan.”

Jaga Saku is an offline-first personal finance app for Indonesian users. The app helps users record daily
transactions, manage multiple accounts, monitor budgets, and understand spending habits through simple
insights.

The app is inspired by personal finance ledger apps like Money Manager, but it must not look like a clone.
The design should feel cleaner, more modern, more local-friendly, and more insight-focused.

## Design Goal

Create 5 main mobile screens:

1. Home
2. Calendar
3. Add Transaction
4. Insight
5. More

Show all 5 screens side by side in one mobile UI presentation.

## Platform & Canvas

Design for a modern mobile app.

Use this frame size:

- Width: 390px
- Height: 844px

Use iOS/Android safe area spacing.

## Visual Style

Use a clean, modern, calm personal finance design style.

The app should feel:

- Clean
- Calm
- Friendly
- Trustworthy
- Organized

- Budget-aware
- Easy to use daily
- Relevant for Indonesian users

Avoid making the UI too complex, too colorful, too corporate, or too similar to accounting software.

Use card-based layout, soft rounded corners, clear hierarchy, readable money amounts, and simple charts.

## Color Palette

Use a soft green finance-oriented palette.

Primary colors:

- Primary Green: #16A34A
- Primary Green Dark: #15803D
- Primary Green Light: #DCFCE7

Semantic colors:

- Income: #22C55E
- Expense: #EF4444
- Transfer: #3B82F6
- Warning: #F59E0B
- Critical: #DC2626
- Info: #0EA5E9

Light mode neutral colors:

- Background: #F8FAFC
- Surface: #FFFFFF
- Surface Soft: #F1F5F9
- Border: #E2E8F0
- Text Primary: #0F172A
- Text Secondary: #64748B
- Text Tertiary: #94A3B8

Use light mode as the main design.

## Typography

Use Plus Jakarta Sans as the primary font.

Typography direction:

- Large money amount: 32px, bold
- Page title: 24px, bold

- Section title: 18–20px, semibold
- Body text: 14–16px, regular
- Metadata and labels: 12px, medium
- Button text: 14–16px, semibold

Money format should use Indonesian Rupiah style:

- Rp 8.450.000
- -Rp 35.000
- +Rp 7.000.000

## Layout Rules

Use:

- Page padding: 16px
- Card padding: 16px
- Card radius: 20px
- Input radius: 14px
- Button radius: 14px
- Chip radius: full pill
- Section gap: 20px
- Bottom navigation height: around 72px

Use soft shadows only. Keep the UI clean and not too heavy.

## Icon Style

Use rounded line icons or softly filled icons.

Recommended icon feel:

- Simple
- Rounded
- Friendly
- Consistent stroke width

Use category icons for transactions, such as food, coffee, transport, salary, wallet, chart, calendar, settings.

## Bottom Navigation

Use the same bottom navigation across the main screens:

- Home
- Calendar
- Add
- Insight

- More

Make the Add button in the center more prominent, using a circular green button with a plus icon.

Selected nav item should use Primary Green. Unselected icons should use muted gray.

## Screen 1 — Home

### Purpose

The Home screen should immediately answer:

“Apakah kondisi uang saya masih aman?”

It should show total balance, monthly summary, budget guard, daily review, and recent transactions.

### Content

Header:

- Greeting: “Hi, Oki”
- Subtitle: “Jaga pengeluaran, pahami kebiasaan.”
- Notification icon on the right

Hero card:

- Label: “Total Saldo”
- Amount: “Rp 8.450.000”
- Monthly summary inside the card:
- Income: “Rp 7.000.000”
- Expense: “Rp 3.250.000”

Budget Guard card:

- Title: “Budget Guard”
- Text: “Makan tersisa Rp 750.000”
- Text: “Aman harian: Rp 50.000/hari”
- Progress bar around 50%
- Status badge: “Aman”

Daily Review card:

- Title: “Review Hari Ini”
- Text: “Kamu sudah keluar Rp 128.000”
- Text: “Kategori terbesar: Makan”

- Text: “Unplanned: Rp 45.000”

Recent Transactions section:

- Section title: “Recent Transactions”
- Small “See All” action on the right
- Transaction item 1:
- Title: “Lunch”
- Detail: “Makan • Cash”
- Amount: “-Rp 35.000”
- Expense color
- Transaction item 2:
- Title: “GoRide”
- Detail: “Transport • GoPay”
- Amount: “-Rp 18.000”
- Expense color
- Transaction item 3:
- Title: “Salary”
- Detail: “Gaji • BCA”
- Amount: “+Rp 7.000.000”
- Income color

### Visual Direction

Make the Total Saldo card the strongest visual element.

Budget Guard should feel like the unique feature of the app.

Daily Review should feel helpful and friendly, not judgmental.

## Screen 2 — Calendar

### Purpose

The Calendar screen is a daily finance ledger. Users can see transactions based on selected date.

### Content

Header:

- Page title: “Calendar”
- Month selector: “July 2026”
- Previous and next month arrow buttons

Calendar card:

- Monthly calendar grid
- Show weekdays: Mon Tue Wed Thu Fri Sat Sun
- Highlight selected date: July 8
- Use small dots or tiny indicators on dates with transactions

Daily summary card:

- Date: “July 8, 2026”
- Income: “Rp 0”
- Expense: “Rp 128.000”
- Balance: “-Rp 128.000”

Transactions list:

Transaction item 1:

- Title: “Lunch”
- Detail: “Makan • Need • Planned”
- Account: “Cash”
- Amount: “-Rp 35.000”

Transaction item 2:

- Title: “Coffee”
- Detail: “Kopi • Want • Unplanned”
- Account: “Cash”
- Amount: “-Rp 28.000”

Transaction item 3:

- Title: “GoRide”
- Detail: “Transport • Need • Planned”
- Account: “GoPay”
- Amount: “-Rp 18.000”

### Visual Direction

The calendar should look clean and not too dense.

Use selected date highlight with Primary Green.

Use small badges for Need, Want, Planned, and Unplanned.

Keep transaction tiles compact and readable.

## Screen 3 — Add Transaction

### Purpose

The Add Transaction screen should be fast, simple, and optimized for daily use.

Design this screen in Expense mode.

### Content

Header:

- Page title: “Add Transaction”
- Close icon on the right

Transaction type segmented control:

- Expense selected
- Income
- Transfer

Amount input:

- Label: “Amount”
- Large amount text: “Rp 0”
- Make this the most prominent form field

Account selector:

- Label: “Account”
- Value: “Cash”
- Chevron icon

Category selector:

- Label: “Category”
- Value: “Makan”
- Chevron icon

Planned Status:

- Label: “Planned Status”
- Two pill options:
- Planned
- Unplanned selected or neutral

Spending Type:

- Label: “Spending Type”
- Chip options:
- Need
- Want
- Lifestyle
- Emergency

Date selector:

- Label: “Date”
- Value: “Today, July 8, 2026”
- Chevron icon

Note input:

- Label: “Note”
- Placeholder: “Example: Lunch with team”

Save button:

- Sticky bottom button
- Text: “Save Transaction”
- Primary Green background
- White text

Optional warning state:

Show a small Budget Guard hint below the amount or before the save button:

“Batas aman Makan hari ini: Rp 50.000”

### Visual Direction

Make the amount input large and easy to use.

Use bottom-sheet style selector fields, but only show the main screen UI.

Keep the form clean and not overwhelming.

The user should feel they can add a transaction in under 10 seconds.

## Screen 4 — Insight

### Purpose

The Insight screen is the unique identity of Jaga Saku. It should help users understand spending habits, not
just display generic reports.

### Content

Header:

- Page title: “Insight”
- Month selector: “July 2026”

Monthly Overview card:

- Income: “Rp 7.000.000”
- Expense: “Rp 3.250.000”
- Saved: “Rp 3.750.000”

Expense by Category card:

- Title: “Expense by Category”
- Donut chart
- Category list:
- Makan: “Rp 1.250.000” — 38%
- Transport: “Rp 620.000” — 19%
- Kopi: “Rp 255.000” — 8%

Planned vs Unplanned card:

- Planned: “Rp 2.100.000” — 72%
- Unplanned: “Rp 850.000” — 28%
- Use progress bars

Need vs Want card:

- Need: 64%
- Want: 22%
- Lifestyle: 10%
- Emergency: 4%

Spending Insight section:

Insight card 1:

- Icon: warning

- Text: “Budget Kopi sudah terpakai 85% bulan ini.”

Insight card 2:

- Icon: trend up
- Text: “Pengeluaran Makan naik 18% dibanding bulan lalu.”

Insight card 3:

- Icon: lightbulb
- Text: “Unplanned expense bulan ini lebih tinggi dari bulan lalu.”

### Visual Direction

Keep the Insight screen informative but not crowded.

Use friendly Indonesian copy.

Charts should be simple and clean.

Insight cards should feel useful, not judgmental.

Avoid too many chart colors.

## Screen 5 — More

### Purpose

The More screen contains supporting features and settings while keeping the main navigation clean.

### Content

Top card:

- App name: “Jaga Saku”
- Tagline: “Jaga pengeluaran, pahami kebiasaan.”
- Small app icon placeholder

Section 1: Finance

Menu items:

- Accounts
- Categories

- Budget
- Recurring

Section 2: Data

Menu items:

- Export CSV
- Backup & Restore

Section 3: App

Menu items:

- Appearance
- Security
- Settings
- About Jaga Saku

For V2 or future features, add a small “Soon” badge to:

- Recurring
- Export CSV
- Backup & Restore
- Security

### Visual Direction

Use grouped menu cards.

Each menu item should have:

- Icon
- Title
- Optional badge
- Chevron

More screen should feel organized, not like a random settings list.

## Components to Design

Create consistent reusable UI components:

- AppCard
- TotalBalanceCard
- BudgetGuardCard

- DailyReviewCard
- TransactionTile
- InsightCard
- SummaryCard
- PrimaryButton
- SegmentedControl
- ChoiceChip
- SelectorField
- AmountInputField
- ProgressBar
- BottomNavigationBar
- MonthSelector
- MenuTile

## Design Quality Requirements

The final UI should look like a polished portfolio-ready mobile app.

Make sure:

- Hierarchy is clear.
- Money amounts are easy to scan.
- Forms are clean.
- Icons are consistent.
- Cards have enough spacing.
- Budget Guard and Insight feel like unique features.
- The design does not look like a Money Manager clone.
- The app feels made for Indonesian users.
- Text is readable and not too small.
- The UI is modern but still realistic to implement in Flutter.

## Final Output Requirement

Generate 5 high-fidelity mobile screens side by side:

1. Home
2. Calendar
3. Add Transaction
4. Insight
5. More

Use light mode.

Use a clean green finance theme.

Use realistic Indonesian money data.

Make the design suitable for a Mobile Developer portfolio case study.
