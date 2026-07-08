import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';

/// UseCase convention for this codebase.
///
/// There are two kinds of usecase, chosen by whether the operation can fail
/// in a way the UI must surface:
///
/// 1. **Async / network usecases** — extend [UseCase] and return
///    `Future<Either<Failure, T>>`. The `Left` branch carries a [Failure]
///    that cubits fold into a `*.failure(Failure)` state. Use this for
///    anything that crosses the network (or any boundary that can fail).
///
/// 2. **Purely-local / sync usecases** — are plain callable classes that
///    expose a `call()` method and DO NOT use `Either`. Local preferences
///    (e.g. theme/language settings, see `GetSettings`/`UpdateTheme`/
///    `UpdateLanguage`) have no meaningful failure surface, so wrapping them
///    in `Either<Failure, _>` would add ceremony without value. They simply
///    return their result (or `void`/`Future<void>`).
///
/// Do NOT force `Either` onto local prefs. Pick the kind by the failure
/// surface, not by habit.
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Class to handle when useCase don't need params
class NoParams {}
