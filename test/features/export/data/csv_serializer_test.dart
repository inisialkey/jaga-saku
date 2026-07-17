import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/export/data/csv_serializer.dart';
import 'package:jaga_saku/features/export/domain/entities/export_row.dart';
import 'package:jaga_saku/features/export/domain/entities/transaction_source.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

/// RFC-4180 + formula-injection escaping is the #1 test target. Builds rows
/// through [CsvSerializer.serialize] and asserts header shape, cell formatting,
/// and every escape branch.
void main() {
  const serializer = CsvSerializer();

  const header =
      'date,type,source,account,target_account,category,amount,'
      'planned_status,spending_type,note,receipt_attached,created_at';

  int at(int y, int m, int d, [int h = 0, int min = 0]) =>
      DateTime(y, m, d, h, min).millisecondsSinceEpoch;

  ExportRow row({
    int date = 0,
    TransactionType type = TransactionType.expense,
    TransactionSource source = TransactionSource.manual,
    String account = 'Cash',
    String? targetAccount,
    String? category = 'Makan',
    int amount = 1000,
    PlannedStatus? plannedStatus,
    SpendingType? spendingType,
    String? note,
    bool receiptAttached = false,
    int createdAt = 0,
  }) => ExportRow(
    date: date,
    type: type,
    source: source,
    account: account,
    targetAccount: targetAccount,
    category: category,
    amount: amount,
    plannedStatus: plannedStatus,
    spendingType: spendingType,
    note: note,
    receiptAttached: receiptAttached,
    createdAt: createdAt,
  );

  // The single data line of a one-row export (drop the header + CRLF).
  String lineOf(ExportRow r) => serializer.serialize([r]).split('\r\n')[1];

  test('empty list → header-only, valid file', () {
    expect(serializer.serialize([]), header);
  });

  test('the header is the exact fixed-ASCII schema', () {
    expect(serializer.serialize([row()]).split('\r\n').first, header);
  });

  test('rows are CRLF-separated with no trailing newline', () {
    final csv = serializer.serialize([row(), row()]);
    expect(csv.split('\r\n'), hasLength(3)); // header + 2 rows
    expect(csv.endsWith('\n'), isFalse);
  });

  test('a plain expense row formats every cell', () {
    final line = lineOf(
      row(
        date: at(2026, 7, 8),
        plannedStatus: PlannedStatus.planned,
        spendingType: SpendingType.need,
        amount: 35000,
        note: 'Lunch',
        createdAt: at(2026, 7, 8, 14, 30),
      ),
    );
    expect(
      line,
      '2026-07-08,expense,manual,Cash,,Makan,35000,'
      'planned,need,Lunch,no,2026-07-08 14:30',
    );
  });

  test('a note with a comma is quoted', () {
    expect(
      lineOf(row(note: 'Lunch, drinks')).contains('"Lunch, drinks"'),
      isTrue,
    );
  });

  test('a note with a quote doubles it inside quotes', () {
    expect(lineOf(row(note: 'say "hi"')).contains('"say ""hi"""'), isTrue);
  });

  test('a note with a newline is quoted', () {
    expect(
      lineOf(row(note: 'line1\nline2')).contains('"line1\nline2"'),
      isTrue,
    );
  });

  test('a note with a carriage return is quoted', () {
    expect(lineOf(row(note: 'a\rb')).contains('"a\rb"'), isTrue);
  });

  for (final lead in ['=', '+', '-', '@']) {
    test('a note starting "$lead" gets a formula-guard prefix', () {
      final line = lineOf(row(note: '${lead}cmd'));
      expect(
        line.contains(
          "'$lead"
          'cmd',
        ),
        isTrue,
      );
    });
  }

  test(
    'a formula-lead value that also needs quoting is guarded then quoted',
    () {
      // Leading '=' → prefix quote; the comma then forces RFC quoting.
      expect(lineOf(row(note: '=1,2')).contains('"\'=1,2"'), isTrue);
    },
  );

  test('plain fields are left unquoted', () {
    final line = lineOf(row(account: 'BCA', category: 'Gaji', note: 'ok'));
    expect(line.contains(',BCA,'), isTrue);
    expect(line.contains('"'), isFalse);
  });

  test('a transfer row fills target_account, leaves category empty', () {
    final line = lineOf(
      row(type: TransactionType.transfer, targetAccount: 'BCA', category: null),
    );
    // ...,transfer,manual,Cash,BCA,,...  → category cell between BCA and amount is empty.
    expect(line.contains(',transfer,manual,Cash,BCA,,'), isTrue);
  });

  test('source reconciliation is written as its value', () {
    expect(
      lineOf(
        row(source: TransactionSource.reconciliation),
      ).contains(',reconciliation,'),
      isTrue,
    );
  });

  test('amount is a plain positive integer with no separators', () {
    expect(lineOf(row(amount: 1500000)).contains(',1500000,'), isTrue);
  });

  test('receipt_attached renders yes when a receipt exists', () {
    expect(lineOf(row(receiptAttached: true)).contains(',yes,'), isTrue);
  });

  test('income/transfer leave planned_status and spending_type empty', () {
    final line = lineOf(row(type: TransactionType.income, category: 'Gaji'));
    // planned_status + spending_type cells (after amount) are empty.
    expect(line.contains(',1000,,,'), isTrue);
  });
}
