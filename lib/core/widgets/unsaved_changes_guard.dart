import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Wraps a form scaffold to intercept a discard-with-unsaved-edits back gesture
/// (D2). When [canLeave] is false, a system back / gesture / `CloseButton`
/// (`Navigator.maybePop`) is paused and a [ConfirmSheet] asks whether to discard;
/// on confirm it pops directly via [Navigator] (an imperative pop bypasses this
/// same guard, so there is no second prompt).
///
/// A successful save pops with go_router's `context.pop(true)` — also an
/// imperative pop — so it likewise bypasses the guard; the `|| state.isSaving`
/// the caller ORs into [canLeave] is the belt-and-braces net for the save window.
class UnsavedChangesGuard extends StatelessWidget {
  const UnsavedChangesGuard({
    required this.canLeave,
    required this.child,
    super.key,
  });

  /// When true the route pops normally (no prompt): pristine form, or a save in
  /// flight / just completed.
  final bool canLeave;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return PopScope(
      canPop: canLeave,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final leave = await ConfirmSheet.show(
          context,
          title: s.unsavedChangesTitle,
          message: s.unsavedChangesMessage,
          confirmLabel: s.discard,
          cancelLabel: s.keepEditing,
          destructive: true,
        );
        if (leave && context.mounted) Navigator.of(context).pop();
      },
      child: child,
    );
  }
}
