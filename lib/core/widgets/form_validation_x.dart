import 'package:flutter/widgets.dart';
import 'package:jaga_saku/core/form/form_validation.dart';
import 'package:jaga_saku/core/localization/localization.dart';

export 'package:jaga_saku/core/form/form_validation.dart';

extension FormValidationErrorX on FormValidationError {
  /// User-safe, localized message for the first-failing form field (D1).
  /// Reuses the transaction form's validation strings where the fields match;
  /// four cases (name / label / start-date / end-before-start) are form-specific.
  String localize(BuildContext context) {
    final s = Strings.of(context)!;
    return switch (this) {
      FormValidationError.amountRequired => s.amountRequiredError,
      FormValidationError.accountRequired => s.accountRequiredError,
      FormValidationError.categoryRequired => s.categoryRequiredError,
      FormValidationError.toAccountRequired => s.toAccountRequiredError,
      FormValidationError.transferSameAccount => s.transferSameAccountError,
      FormValidationError.nameRequired => s.nameRequired,
      FormValidationError.labelRequired => s.labelRequired,
      FormValidationError.startDateRequired => s.startDateRequired,
      FormValidationError.endDateBeforeStart => s.endDateBeforeStart,
    };
  }
}
