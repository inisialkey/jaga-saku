import 'package:jaga_saku/features/backup/domain/entities/backup_data.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_preview.dart';

/// Pure, synchronous per-table count of a validated [BackupData] — no repo, no
/// `Either` (the codebase's usecase convention allows local, non-failing
/// usecases). Rendered in the restore preview before the user confirms.
class PreviewBackup {
  const PreviewBackup();

  BackupPreview call(BackupData data) => BackupPreview(
    accounts: data.accounts.length,
    transactions: data.transactions.length,
    categories: data.categories.length,
    budgets: data.budgets.length,
    recurring: data.recurring.length,
    templates: data.txTemplates.length,
    settings: data.settings.length,
  );
}
