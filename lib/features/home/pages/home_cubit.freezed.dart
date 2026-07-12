// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeDashboard {

/// Σ balance of non-archived accounts (already tx-derived from M1/M2).
 int get totalBalance;/// This month's income / expense totals (transfers excluded from both).
 int get monthIncome; int get monthExpense;/// Today's expense total (the daily review).
 int get todaySpent;/// Today's expense sum for [PlannedStatus.unplanned] rows.
 int get todayUnplanned;/// Name of today's largest-expense category; null when nothing was spent.
 String? get topCategoryName;/// Up to 5 most recent transactions, newest first.
 List<Transaction> get recent;/// id → Category / Account lookups used to resolve names on the tiles.
 Map<int, Category> get categoriesById; Map<int, Account> get accountsById;/// The most at-risk budget for the current month, or null when there are no
/// budgets (the guard card then shows its empty state + a live CTA).
 BudgetGuardView? get budgetGuard;/// Favorite templates (`is_favorite = 1`) for the Home quick-tap strip;
/// empty hides the section.
 List<TxTemplate> get favorites;
/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeDashboardCopyWith<HomeDashboard> get copyWith => _$HomeDashboardCopyWithImpl<HomeDashboard>(this as HomeDashboard, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeDashboard&&(identical(other.totalBalance, totalBalance) || other.totalBalance == totalBalance)&&(identical(other.monthIncome, monthIncome) || other.monthIncome == monthIncome)&&(identical(other.monthExpense, monthExpense) || other.monthExpense == monthExpense)&&(identical(other.todaySpent, todaySpent) || other.todaySpent == todaySpent)&&(identical(other.todayUnplanned, todayUnplanned) || other.todayUnplanned == todayUnplanned)&&(identical(other.topCategoryName, topCategoryName) || other.topCategoryName == topCategoryName)&&const DeepCollectionEquality().equals(other.recent, recent)&&const DeepCollectionEquality().equals(other.categoriesById, categoriesById)&&const DeepCollectionEquality().equals(other.accountsById, accountsById)&&(identical(other.budgetGuard, budgetGuard) || other.budgetGuard == budgetGuard)&&const DeepCollectionEquality().equals(other.favorites, favorites));
}


@override
int get hashCode => Object.hash(runtimeType,totalBalance,monthIncome,monthExpense,todaySpent,todayUnplanned,topCategoryName,const DeepCollectionEquality().hash(recent),const DeepCollectionEquality().hash(categoriesById),const DeepCollectionEquality().hash(accountsById),budgetGuard,const DeepCollectionEquality().hash(favorites));

@override
String toString() {
  return 'HomeDashboard(totalBalance: $totalBalance, monthIncome: $monthIncome, monthExpense: $monthExpense, todaySpent: $todaySpent, todayUnplanned: $todayUnplanned, topCategoryName: $topCategoryName, recent: $recent, categoriesById: $categoriesById, accountsById: $accountsById, budgetGuard: $budgetGuard, favorites: $favorites)';
}


}

/// @nodoc
abstract mixin class $HomeDashboardCopyWith<$Res>  {
  factory $HomeDashboardCopyWith(HomeDashboard value, $Res Function(HomeDashboard) _then) = _$HomeDashboardCopyWithImpl;
@useResult
$Res call({
 int totalBalance, int monthIncome, int monthExpense, int todaySpent, int todayUnplanned, String? topCategoryName, List<Transaction> recent, Map<int, Category> categoriesById, Map<int, Account> accountsById, BudgetGuardView? budgetGuard, List<TxTemplate> favorites
});


$BudgetGuardViewCopyWith<$Res>? get budgetGuard;

}
/// @nodoc
class _$HomeDashboardCopyWithImpl<$Res>
    implements $HomeDashboardCopyWith<$Res> {
  _$HomeDashboardCopyWithImpl(this._self, this._then);

  final HomeDashboard _self;
  final $Res Function(HomeDashboard) _then;

/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalBalance = null,Object? monthIncome = null,Object? monthExpense = null,Object? todaySpent = null,Object? todayUnplanned = null,Object? topCategoryName = freezed,Object? recent = null,Object? categoriesById = null,Object? accountsById = null,Object? budgetGuard = freezed,Object? favorites = null,}) {
  return _then(_self.copyWith(
totalBalance: null == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as int,monthIncome: null == monthIncome ? _self.monthIncome : monthIncome // ignore: cast_nullable_to_non_nullable
as int,monthExpense: null == monthExpense ? _self.monthExpense : monthExpense // ignore: cast_nullable_to_non_nullable
as int,todaySpent: null == todaySpent ? _self.todaySpent : todaySpent // ignore: cast_nullable_to_non_nullable
as int,todayUnplanned: null == todayUnplanned ? _self.todayUnplanned : todayUnplanned // ignore: cast_nullable_to_non_nullable
as int,topCategoryName: freezed == topCategoryName ? _self.topCategoryName : topCategoryName // ignore: cast_nullable_to_non_nullable
as String?,recent: null == recent ? _self.recent : recent // ignore: cast_nullable_to_non_nullable
as List<Transaction>,categoriesById: null == categoriesById ? _self.categoriesById : categoriesById // ignore: cast_nullable_to_non_nullable
as Map<int, Category>,accountsById: null == accountsById ? _self.accountsById : accountsById // ignore: cast_nullable_to_non_nullable
as Map<int, Account>,budgetGuard: freezed == budgetGuard ? _self.budgetGuard : budgetGuard // ignore: cast_nullable_to_non_nullable
as BudgetGuardView?,favorites: null == favorites ? _self.favorites : favorites // ignore: cast_nullable_to_non_nullable
as List<TxTemplate>,
  ));
}
/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetGuardViewCopyWith<$Res>? get budgetGuard {
    if (_self.budgetGuard == null) {
    return null;
  }

  return $BudgetGuardViewCopyWith<$Res>(_self.budgetGuard!, (value) {
    return _then(_self.copyWith(budgetGuard: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeDashboard].
extension HomeDashboardPatterns on HomeDashboard {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeDashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeDashboard() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeDashboard value)  $default,){
final _that = this;
switch (_that) {
case _HomeDashboard():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeDashboard value)?  $default,){
final _that = this;
switch (_that) {
case _HomeDashboard() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalBalance,  int monthIncome,  int monthExpense,  int todaySpent,  int todayUnplanned,  String? topCategoryName,  List<Transaction> recent,  Map<int, Category> categoriesById,  Map<int, Account> accountsById,  BudgetGuardView? budgetGuard,  List<TxTemplate> favorites)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeDashboard() when $default != null:
return $default(_that.totalBalance,_that.monthIncome,_that.monthExpense,_that.todaySpent,_that.todayUnplanned,_that.topCategoryName,_that.recent,_that.categoriesById,_that.accountsById,_that.budgetGuard,_that.favorites);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalBalance,  int monthIncome,  int monthExpense,  int todaySpent,  int todayUnplanned,  String? topCategoryName,  List<Transaction> recent,  Map<int, Category> categoriesById,  Map<int, Account> accountsById,  BudgetGuardView? budgetGuard,  List<TxTemplate> favorites)  $default,) {final _that = this;
switch (_that) {
case _HomeDashboard():
return $default(_that.totalBalance,_that.monthIncome,_that.monthExpense,_that.todaySpent,_that.todayUnplanned,_that.topCategoryName,_that.recent,_that.categoriesById,_that.accountsById,_that.budgetGuard,_that.favorites);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalBalance,  int monthIncome,  int monthExpense,  int todaySpent,  int todayUnplanned,  String? topCategoryName,  List<Transaction> recent,  Map<int, Category> categoriesById,  Map<int, Account> accountsById,  BudgetGuardView? budgetGuard,  List<TxTemplate> favorites)?  $default,) {final _that = this;
switch (_that) {
case _HomeDashboard() when $default != null:
return $default(_that.totalBalance,_that.monthIncome,_that.monthExpense,_that.todaySpent,_that.todayUnplanned,_that.topCategoryName,_that.recent,_that.categoriesById,_that.accountsById,_that.budgetGuard,_that.favorites);case _:
  return null;

}
}

}

/// @nodoc


class _HomeDashboard extends HomeDashboard {
  const _HomeDashboard({required this.totalBalance, required this.monthIncome, required this.monthExpense, required this.todaySpent, required this.todayUnplanned, this.topCategoryName, final  List<Transaction> recent = const <Transaction>[], final  Map<int, Category> categoriesById = const <int, Category>{}, final  Map<int, Account> accountsById = const <int, Account>{}, this.budgetGuard, final  List<TxTemplate> favorites = const <TxTemplate>[]}): _recent = recent,_categoriesById = categoriesById,_accountsById = accountsById,_favorites = favorites,super._();
  

/// Σ balance of non-archived accounts (already tx-derived from M1/M2).
@override final  int totalBalance;
/// This month's income / expense totals (transfers excluded from both).
@override final  int monthIncome;
@override final  int monthExpense;
/// Today's expense total (the daily review).
@override final  int todaySpent;
/// Today's expense sum for [PlannedStatus.unplanned] rows.
@override final  int todayUnplanned;
/// Name of today's largest-expense category; null when nothing was spent.
@override final  String? topCategoryName;
/// Up to 5 most recent transactions, newest first.
 final  List<Transaction> _recent;
/// Up to 5 most recent transactions, newest first.
@override@JsonKey() List<Transaction> get recent {
  if (_recent is EqualUnmodifiableListView) return _recent;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recent);
}

/// id → Category / Account lookups used to resolve names on the tiles.
 final  Map<int, Category> _categoriesById;
/// id → Category / Account lookups used to resolve names on the tiles.
@override@JsonKey() Map<int, Category> get categoriesById {
  if (_categoriesById is EqualUnmodifiableMapView) return _categoriesById;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_categoriesById);
}

 final  Map<int, Account> _accountsById;
@override@JsonKey() Map<int, Account> get accountsById {
  if (_accountsById is EqualUnmodifiableMapView) return _accountsById;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_accountsById);
}

/// The most at-risk budget for the current month, or null when there are no
/// budgets (the guard card then shows its empty state + a live CTA).
@override final  BudgetGuardView? budgetGuard;
/// Favorite templates (`is_favorite = 1`) for the Home quick-tap strip;
/// empty hides the section.
 final  List<TxTemplate> _favorites;
/// Favorite templates (`is_favorite = 1`) for the Home quick-tap strip;
/// empty hides the section.
@override@JsonKey() List<TxTemplate> get favorites {
  if (_favorites is EqualUnmodifiableListView) return _favorites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favorites);
}


/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeDashboardCopyWith<_HomeDashboard> get copyWith => __$HomeDashboardCopyWithImpl<_HomeDashboard>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeDashboard&&(identical(other.totalBalance, totalBalance) || other.totalBalance == totalBalance)&&(identical(other.monthIncome, monthIncome) || other.monthIncome == monthIncome)&&(identical(other.monthExpense, monthExpense) || other.monthExpense == monthExpense)&&(identical(other.todaySpent, todaySpent) || other.todaySpent == todaySpent)&&(identical(other.todayUnplanned, todayUnplanned) || other.todayUnplanned == todayUnplanned)&&(identical(other.topCategoryName, topCategoryName) || other.topCategoryName == topCategoryName)&&const DeepCollectionEquality().equals(other._recent, _recent)&&const DeepCollectionEquality().equals(other._categoriesById, _categoriesById)&&const DeepCollectionEquality().equals(other._accountsById, _accountsById)&&(identical(other.budgetGuard, budgetGuard) || other.budgetGuard == budgetGuard)&&const DeepCollectionEquality().equals(other._favorites, _favorites));
}


@override
int get hashCode => Object.hash(runtimeType,totalBalance,monthIncome,monthExpense,todaySpent,todayUnplanned,topCategoryName,const DeepCollectionEquality().hash(_recent),const DeepCollectionEquality().hash(_categoriesById),const DeepCollectionEquality().hash(_accountsById),budgetGuard,const DeepCollectionEquality().hash(_favorites));

@override
String toString() {
  return 'HomeDashboard(totalBalance: $totalBalance, monthIncome: $monthIncome, monthExpense: $monthExpense, todaySpent: $todaySpent, todayUnplanned: $todayUnplanned, topCategoryName: $topCategoryName, recent: $recent, categoriesById: $categoriesById, accountsById: $accountsById, budgetGuard: $budgetGuard, favorites: $favorites)';
}


}

/// @nodoc
abstract mixin class _$HomeDashboardCopyWith<$Res> implements $HomeDashboardCopyWith<$Res> {
  factory _$HomeDashboardCopyWith(_HomeDashboard value, $Res Function(_HomeDashboard) _then) = __$HomeDashboardCopyWithImpl;
@override @useResult
$Res call({
 int totalBalance, int monthIncome, int monthExpense, int todaySpent, int todayUnplanned, String? topCategoryName, List<Transaction> recent, Map<int, Category> categoriesById, Map<int, Account> accountsById, BudgetGuardView? budgetGuard, List<TxTemplate> favorites
});


@override $BudgetGuardViewCopyWith<$Res>? get budgetGuard;

}
/// @nodoc
class __$HomeDashboardCopyWithImpl<$Res>
    implements _$HomeDashboardCopyWith<$Res> {
  __$HomeDashboardCopyWithImpl(this._self, this._then);

  final _HomeDashboard _self;
  final $Res Function(_HomeDashboard) _then;

/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalBalance = null,Object? monthIncome = null,Object? monthExpense = null,Object? todaySpent = null,Object? todayUnplanned = null,Object? topCategoryName = freezed,Object? recent = null,Object? categoriesById = null,Object? accountsById = null,Object? budgetGuard = freezed,Object? favorites = null,}) {
  return _then(_HomeDashboard(
totalBalance: null == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as int,monthIncome: null == monthIncome ? _self.monthIncome : monthIncome // ignore: cast_nullable_to_non_nullable
as int,monthExpense: null == monthExpense ? _self.monthExpense : monthExpense // ignore: cast_nullable_to_non_nullable
as int,todaySpent: null == todaySpent ? _self.todaySpent : todaySpent // ignore: cast_nullable_to_non_nullable
as int,todayUnplanned: null == todayUnplanned ? _self.todayUnplanned : todayUnplanned // ignore: cast_nullable_to_non_nullable
as int,topCategoryName: freezed == topCategoryName ? _self.topCategoryName : topCategoryName // ignore: cast_nullable_to_non_nullable
as String?,recent: null == recent ? _self._recent : recent // ignore: cast_nullable_to_non_nullable
as List<Transaction>,categoriesById: null == categoriesById ? _self._categoriesById : categoriesById // ignore: cast_nullable_to_non_nullable
as Map<int, Category>,accountsById: null == accountsById ? _self._accountsById : accountsById // ignore: cast_nullable_to_non_nullable
as Map<int, Account>,budgetGuard: freezed == budgetGuard ? _self.budgetGuard : budgetGuard // ignore: cast_nullable_to_non_nullable
as BudgetGuardView?,favorites: null == favorites ? _self._favorites : favorites // ignore: cast_nullable_to_non_nullable
as List<TxTemplate>,
  ));
}

/// Create a copy of HomeDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetGuardViewCopyWith<$Res>? get budgetGuard {
    if (_self.budgetGuard == null) {
    return null;
  }

  return $BudgetGuardViewCopyWith<$Res>(_self.budgetGuard!, (value) {
    return _then(_self.copyWith(budgetGuard: value));
  });
}
}

/// @nodoc
mixin _$BudgetGuardView {

 String get categoryName; int get remaining; int get safeDaily; double get ratio; BudgetStatusLevel get level; String? get categoryIcon;/// ARGB color of the category.
 int? get categoryColor;
/// Create a copy of BudgetGuardView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetGuardViewCopyWith<BudgetGuardView> get copyWith => _$BudgetGuardViewCopyWithImpl<BudgetGuardView>(this as BudgetGuardView, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetGuardView&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.safeDaily, safeDaily) || other.safeDaily == safeDaily)&&(identical(other.ratio, ratio) || other.ratio == ratio)&&(identical(other.level, level) || other.level == level)&&(identical(other.categoryIcon, categoryIcon) || other.categoryIcon == categoryIcon)&&(identical(other.categoryColor, categoryColor) || other.categoryColor == categoryColor));
}


@override
int get hashCode => Object.hash(runtimeType,categoryName,remaining,safeDaily,ratio,level,categoryIcon,categoryColor);

@override
String toString() {
  return 'BudgetGuardView(categoryName: $categoryName, remaining: $remaining, safeDaily: $safeDaily, ratio: $ratio, level: $level, categoryIcon: $categoryIcon, categoryColor: $categoryColor)';
}


}

/// @nodoc
abstract mixin class $BudgetGuardViewCopyWith<$Res>  {
  factory $BudgetGuardViewCopyWith(BudgetGuardView value, $Res Function(BudgetGuardView) _then) = _$BudgetGuardViewCopyWithImpl;
@useResult
$Res call({
 String categoryName, int remaining, int safeDaily, double ratio, BudgetStatusLevel level, String? categoryIcon, int? categoryColor
});




}
/// @nodoc
class _$BudgetGuardViewCopyWithImpl<$Res>
    implements $BudgetGuardViewCopyWith<$Res> {
  _$BudgetGuardViewCopyWithImpl(this._self, this._then);

  final BudgetGuardView _self;
  final $Res Function(BudgetGuardView) _then;

/// Create a copy of BudgetGuardView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryName = null,Object? remaining = null,Object? safeDaily = null,Object? ratio = null,Object? level = null,Object? categoryIcon = freezed,Object? categoryColor = freezed,}) {
  return _then(_self.copyWith(
categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,safeDaily: null == safeDaily ? _self.safeDaily : safeDaily // ignore: cast_nullable_to_non_nullable
as int,ratio: null == ratio ? _self.ratio : ratio // ignore: cast_nullable_to_non_nullable
as double,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as BudgetStatusLevel,categoryIcon: freezed == categoryIcon ? _self.categoryIcon : categoryIcon // ignore: cast_nullable_to_non_nullable
as String?,categoryColor: freezed == categoryColor ? _self.categoryColor : categoryColor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetGuardView].
extension BudgetGuardViewPatterns on BudgetGuardView {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetGuardView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetGuardView() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetGuardView value)  $default,){
final _that = this;
switch (_that) {
case _BudgetGuardView():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetGuardView value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetGuardView() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String categoryName,  int remaining,  int safeDaily,  double ratio,  BudgetStatusLevel level,  String? categoryIcon,  int? categoryColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetGuardView() when $default != null:
return $default(_that.categoryName,_that.remaining,_that.safeDaily,_that.ratio,_that.level,_that.categoryIcon,_that.categoryColor);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String categoryName,  int remaining,  int safeDaily,  double ratio,  BudgetStatusLevel level,  String? categoryIcon,  int? categoryColor)  $default,) {final _that = this;
switch (_that) {
case _BudgetGuardView():
return $default(_that.categoryName,_that.remaining,_that.safeDaily,_that.ratio,_that.level,_that.categoryIcon,_that.categoryColor);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String categoryName,  int remaining,  int safeDaily,  double ratio,  BudgetStatusLevel level,  String? categoryIcon,  int? categoryColor)?  $default,) {final _that = this;
switch (_that) {
case _BudgetGuardView() when $default != null:
return $default(_that.categoryName,_that.remaining,_that.safeDaily,_that.ratio,_that.level,_that.categoryIcon,_that.categoryColor);case _:
  return null;

}
}

}

/// @nodoc


class _BudgetGuardView implements BudgetGuardView {
  const _BudgetGuardView({required this.categoryName, required this.remaining, required this.safeDaily, required this.ratio, required this.level, this.categoryIcon, this.categoryColor});
  

@override final  String categoryName;
@override final  int remaining;
@override final  int safeDaily;
@override final  double ratio;
@override final  BudgetStatusLevel level;
@override final  String? categoryIcon;
/// ARGB color of the category.
@override final  int? categoryColor;

/// Create a copy of BudgetGuardView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetGuardViewCopyWith<_BudgetGuardView> get copyWith => __$BudgetGuardViewCopyWithImpl<_BudgetGuardView>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetGuardView&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.safeDaily, safeDaily) || other.safeDaily == safeDaily)&&(identical(other.ratio, ratio) || other.ratio == ratio)&&(identical(other.level, level) || other.level == level)&&(identical(other.categoryIcon, categoryIcon) || other.categoryIcon == categoryIcon)&&(identical(other.categoryColor, categoryColor) || other.categoryColor == categoryColor));
}


@override
int get hashCode => Object.hash(runtimeType,categoryName,remaining,safeDaily,ratio,level,categoryIcon,categoryColor);

@override
String toString() {
  return 'BudgetGuardView(categoryName: $categoryName, remaining: $remaining, safeDaily: $safeDaily, ratio: $ratio, level: $level, categoryIcon: $categoryIcon, categoryColor: $categoryColor)';
}


}

/// @nodoc
abstract mixin class _$BudgetGuardViewCopyWith<$Res> implements $BudgetGuardViewCopyWith<$Res> {
  factory _$BudgetGuardViewCopyWith(_BudgetGuardView value, $Res Function(_BudgetGuardView) _then) = __$BudgetGuardViewCopyWithImpl;
@override @useResult
$Res call({
 String categoryName, int remaining, int safeDaily, double ratio, BudgetStatusLevel level, String? categoryIcon, int? categoryColor
});




}
/// @nodoc
class __$BudgetGuardViewCopyWithImpl<$Res>
    implements _$BudgetGuardViewCopyWith<$Res> {
  __$BudgetGuardViewCopyWithImpl(this._self, this._then);

  final _BudgetGuardView _self;
  final $Res Function(_BudgetGuardView) _then;

/// Create a copy of BudgetGuardView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryName = null,Object? remaining = null,Object? safeDaily = null,Object? ratio = null,Object? level = null,Object? categoryIcon = freezed,Object? categoryColor = freezed,}) {
  return _then(_BudgetGuardView(
categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,safeDaily: null == safeDaily ? _self.safeDaily : safeDaily // ignore: cast_nullable_to_non_nullable
as int,ratio: null == ratio ? _self.ratio : ratio // ignore: cast_nullable_to_non_nullable
as double,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as BudgetStatusLevel,categoryIcon: freezed == categoryIcon ? _self.categoryIcon : categoryIcon // ignore: cast_nullable_to_non_nullable
as String?,categoryColor: freezed == categoryColor ? _self.categoryColor : categoryColor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$HomeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeState()';
}


}

/// @nodoc
class $HomeStateCopyWith<$Res>  {
$HomeStateCopyWith(HomeState _, $Res Function(HomeState) __);
}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HomeInitial value)?  initial,TResult Function( HomeLoading value)?  loading,TResult Function( HomeLoaded value)?  loaded,TResult Function( HomeError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HomeInitial() when initial != null:
return initial(_that);case HomeLoading() when loading != null:
return loading(_that);case HomeLoaded() when loaded != null:
return loaded(_that);case HomeError() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HomeInitial value)  initial,required TResult Function( HomeLoading value)  loading,required TResult Function( HomeLoaded value)  loaded,required TResult Function( HomeError value)  error,}){
final _that = this;
switch (_that) {
case HomeInitial():
return initial(_that);case HomeLoading():
return loading(_that);case HomeLoaded():
return loaded(_that);case HomeError():
return error(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HomeInitial value)?  initial,TResult? Function( HomeLoading value)?  loading,TResult? Function( HomeLoaded value)?  loaded,TResult? Function( HomeError value)?  error,}){
final _that = this;
switch (_that) {
case HomeInitial() when initial != null:
return initial(_that);case HomeLoading() when loading != null:
return loading(_that);case HomeLoaded() when loaded != null:
return loaded(_that);case HomeError() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( HomeDashboard dashboard)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HomeInitial() when initial != null:
return initial();case HomeLoading() when loading != null:
return loading();case HomeLoaded() when loaded != null:
return loaded(_that.dashboard);case HomeError() when error != null:
return error(_that.failure);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( HomeDashboard dashboard)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case HomeInitial():
return initial();case HomeLoading():
return loading();case HomeLoaded():
return loaded(_that.dashboard);case HomeError():
return error(_that.failure);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( HomeDashboard dashboard)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case HomeInitial() when initial != null:
return initial();case HomeLoading() when loading != null:
return loading();case HomeLoaded() when loaded != null:
return loaded(_that.dashboard);case HomeError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class HomeInitial implements HomeState {
  const HomeInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeState.initial()';
}


}




/// @nodoc


class HomeLoading implements HomeState {
  const HomeLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeState.loading()';
}


}




/// @nodoc


class HomeLoaded implements HomeState {
  const HomeLoaded(this.dashboard);
  

 final  HomeDashboard dashboard;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeLoadedCopyWith<HomeLoaded> get copyWith => _$HomeLoadedCopyWithImpl<HomeLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeLoaded&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard));
}


@override
int get hashCode => Object.hash(runtimeType,dashboard);

@override
String toString() {
  return 'HomeState.loaded(dashboard: $dashboard)';
}


}

/// @nodoc
abstract mixin class $HomeLoadedCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory $HomeLoadedCopyWith(HomeLoaded value, $Res Function(HomeLoaded) _then) = _$HomeLoadedCopyWithImpl;
@useResult
$Res call({
 HomeDashboard dashboard
});


$HomeDashboardCopyWith<$Res> get dashboard;

}
/// @nodoc
class _$HomeLoadedCopyWithImpl<$Res>
    implements $HomeLoadedCopyWith<$Res> {
  _$HomeLoadedCopyWithImpl(this._self, this._then);

  final HomeLoaded _self;
  final $Res Function(HomeLoaded) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? dashboard = null,}) {
  return _then(HomeLoaded(
null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as HomeDashboard,
  ));
}

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeDashboardCopyWith<$Res> get dashboard {
  
  return $HomeDashboardCopyWith<$Res>(_self.dashboard, (value) {
    return _then(_self.copyWith(dashboard: value));
  });
}
}

/// @nodoc


class HomeError implements HomeState {
  const HomeError(this.failure);
  

 final  Failure failure;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeErrorCopyWith<HomeError> get copyWith => _$HomeErrorCopyWithImpl<HomeError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'HomeState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $HomeErrorCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory $HomeErrorCopyWith(HomeError value, $Res Function(HomeError) _then) = _$HomeErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$HomeErrorCopyWithImpl<$Res>
    implements $HomeErrorCopyWith<$Res> {
  _$HomeErrorCopyWithImpl(this._self, this._then);

  final HomeError _self;
  final $Res Function(HomeError) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(HomeError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
