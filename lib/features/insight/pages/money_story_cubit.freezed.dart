// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'money_story_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MoneyStory {

/// The focused month (first-of-month), for the header selector.
 DateTime get month;/// Overview totals, transfers + system categories excluded.
 int get income; int get expense;/// income − expense (negative in a deficit month).
 int get saved;/// `saved / income`, whole percent; 0 when income is 0 (÷0 guard). Negative
/// in a deficit month.
 int get savingsRatePct;/// `saved < 0` — flips the hero copy + `MoneyText` sign/color.
 bool get isDeficit;/// Biggest expense category this month (system excluded), or null.
 int? get topCategoryId; int get topCategoryAmount;/// The single largest real expense row (system excluded), or null.
 Transaction? get biggestExpense;/// Signed month-over-month deltas vs the previous month.
 int get momIncome; int get momExpense;/// Need/want/lifestyle/emergency shares of the typed expense subset.
 Map<SpendingType, SpendingSlice> get needVsWant;/// Reconstructed net-worth points (trailing 12 months), oldest→newest.
 List<TrendPoint> get trend;/// Current net worth = `trend.last.netWorth` (or the baseline if empty).
 int get netWorth;/// id → Category / Account lookups to resolve names, icons, colors.
 Map<int, Category> get categoriesById; Map<int, Account> get accountsById;
/// Create a copy of MoneyStory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoneyStoryCopyWith<MoneyStory> get copyWith => _$MoneyStoryCopyWithImpl<MoneyStory>(this as MoneyStory, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoneyStory&&(identical(other.month, month) || other.month == month)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.savingsRatePct, savingsRatePct) || other.savingsRatePct == savingsRatePct)&&(identical(other.isDeficit, isDeficit) || other.isDeficit == isDeficit)&&(identical(other.topCategoryId, topCategoryId) || other.topCategoryId == topCategoryId)&&(identical(other.topCategoryAmount, topCategoryAmount) || other.topCategoryAmount == topCategoryAmount)&&(identical(other.biggestExpense, biggestExpense) || other.biggestExpense == biggestExpense)&&(identical(other.momIncome, momIncome) || other.momIncome == momIncome)&&(identical(other.momExpense, momExpense) || other.momExpense == momExpense)&&const DeepCollectionEquality().equals(other.needVsWant, needVsWant)&&const DeepCollectionEquality().equals(other.trend, trend)&&(identical(other.netWorth, netWorth) || other.netWorth == netWorth)&&const DeepCollectionEquality().equals(other.categoriesById, categoriesById)&&const DeepCollectionEquality().equals(other.accountsById, accountsById));
}


@override
int get hashCode => Object.hash(runtimeType,month,income,expense,saved,savingsRatePct,isDeficit,topCategoryId,topCategoryAmount,biggestExpense,momIncome,momExpense,const DeepCollectionEquality().hash(needVsWant),const DeepCollectionEquality().hash(trend),netWorth,const DeepCollectionEquality().hash(categoriesById),const DeepCollectionEquality().hash(accountsById));

@override
String toString() {
  return 'MoneyStory(month: $month, income: $income, expense: $expense, saved: $saved, savingsRatePct: $savingsRatePct, isDeficit: $isDeficit, topCategoryId: $topCategoryId, topCategoryAmount: $topCategoryAmount, biggestExpense: $biggestExpense, momIncome: $momIncome, momExpense: $momExpense, needVsWant: $needVsWant, trend: $trend, netWorth: $netWorth, categoriesById: $categoriesById, accountsById: $accountsById)';
}


}

/// @nodoc
abstract mixin class $MoneyStoryCopyWith<$Res>  {
  factory $MoneyStoryCopyWith(MoneyStory value, $Res Function(MoneyStory) _then) = _$MoneyStoryCopyWithImpl;
@useResult
$Res call({
 DateTime month, int income, int expense, int saved, int savingsRatePct, bool isDeficit, int? topCategoryId, int topCategoryAmount, Transaction? biggestExpense, int momIncome, int momExpense, Map<SpendingType, SpendingSlice> needVsWant, List<TrendPoint> trend, int netWorth, Map<int, Category> categoriesById, Map<int, Account> accountsById
});


$TransactionCopyWith<$Res>? get biggestExpense;

}
/// @nodoc
class _$MoneyStoryCopyWithImpl<$Res>
    implements $MoneyStoryCopyWith<$Res> {
  _$MoneyStoryCopyWithImpl(this._self, this._then);

  final MoneyStory _self;
  final $Res Function(MoneyStory) _then;

/// Create a copy of MoneyStory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? income = null,Object? expense = null,Object? saved = null,Object? savingsRatePct = null,Object? isDeficit = null,Object? topCategoryId = freezed,Object? topCategoryAmount = null,Object? biggestExpense = freezed,Object? momIncome = null,Object? momExpense = null,Object? needVsWant = null,Object? trend = null,Object? netWorth = null,Object? categoriesById = null,Object? accountsById = null,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as int,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as int,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as int,savingsRatePct: null == savingsRatePct ? _self.savingsRatePct : savingsRatePct // ignore: cast_nullable_to_non_nullable
as int,isDeficit: null == isDeficit ? _self.isDeficit : isDeficit // ignore: cast_nullable_to_non_nullable
as bool,topCategoryId: freezed == topCategoryId ? _self.topCategoryId : topCategoryId // ignore: cast_nullable_to_non_nullable
as int?,topCategoryAmount: null == topCategoryAmount ? _self.topCategoryAmount : topCategoryAmount // ignore: cast_nullable_to_non_nullable
as int,biggestExpense: freezed == biggestExpense ? _self.biggestExpense : biggestExpense // ignore: cast_nullable_to_non_nullable
as Transaction?,momIncome: null == momIncome ? _self.momIncome : momIncome // ignore: cast_nullable_to_non_nullable
as int,momExpense: null == momExpense ? _self.momExpense : momExpense // ignore: cast_nullable_to_non_nullable
as int,needVsWant: null == needVsWant ? _self.needVsWant : needVsWant // ignore: cast_nullable_to_non_nullable
as Map<SpendingType, SpendingSlice>,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as List<TrendPoint>,netWorth: null == netWorth ? _self.netWorth : netWorth // ignore: cast_nullable_to_non_nullable
as int,categoriesById: null == categoriesById ? _self.categoriesById : categoriesById // ignore: cast_nullable_to_non_nullable
as Map<int, Category>,accountsById: null == accountsById ? _self.accountsById : accountsById // ignore: cast_nullable_to_non_nullable
as Map<int, Account>,
  ));
}
/// Create a copy of MoneyStory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionCopyWith<$Res>? get biggestExpense {
    if (_self.biggestExpense == null) {
    return null;
  }

  return $TransactionCopyWith<$Res>(_self.biggestExpense!, (value) {
    return _then(_self.copyWith(biggestExpense: value));
  });
}
}


/// Adds pattern-matching-related methods to [MoneyStory].
extension MoneyStoryPatterns on MoneyStory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoneyStory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoneyStory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoneyStory value)  $default,){
final _that = this;
switch (_that) {
case _MoneyStory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoneyStory value)?  $default,){
final _that = this;
switch (_that) {
case _MoneyStory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime month,  int income,  int expense,  int saved,  int savingsRatePct,  bool isDeficit,  int? topCategoryId,  int topCategoryAmount,  Transaction? biggestExpense,  int momIncome,  int momExpense,  Map<SpendingType, SpendingSlice> needVsWant,  List<TrendPoint> trend,  int netWorth,  Map<int, Category> categoriesById,  Map<int, Account> accountsById)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoneyStory() when $default != null:
return $default(_that.month,_that.income,_that.expense,_that.saved,_that.savingsRatePct,_that.isDeficit,_that.topCategoryId,_that.topCategoryAmount,_that.biggestExpense,_that.momIncome,_that.momExpense,_that.needVsWant,_that.trend,_that.netWorth,_that.categoriesById,_that.accountsById);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime month,  int income,  int expense,  int saved,  int savingsRatePct,  bool isDeficit,  int? topCategoryId,  int topCategoryAmount,  Transaction? biggestExpense,  int momIncome,  int momExpense,  Map<SpendingType, SpendingSlice> needVsWant,  List<TrendPoint> trend,  int netWorth,  Map<int, Category> categoriesById,  Map<int, Account> accountsById)  $default,) {final _that = this;
switch (_that) {
case _MoneyStory():
return $default(_that.month,_that.income,_that.expense,_that.saved,_that.savingsRatePct,_that.isDeficit,_that.topCategoryId,_that.topCategoryAmount,_that.biggestExpense,_that.momIncome,_that.momExpense,_that.needVsWant,_that.trend,_that.netWorth,_that.categoriesById,_that.accountsById);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime month,  int income,  int expense,  int saved,  int savingsRatePct,  bool isDeficit,  int? topCategoryId,  int topCategoryAmount,  Transaction? biggestExpense,  int momIncome,  int momExpense,  Map<SpendingType, SpendingSlice> needVsWant,  List<TrendPoint> trend,  int netWorth,  Map<int, Category> categoriesById,  Map<int, Account> accountsById)?  $default,) {final _that = this;
switch (_that) {
case _MoneyStory() when $default != null:
return $default(_that.month,_that.income,_that.expense,_that.saved,_that.savingsRatePct,_that.isDeficit,_that.topCategoryId,_that.topCategoryAmount,_that.biggestExpense,_that.momIncome,_that.momExpense,_that.needVsWant,_that.trend,_that.netWorth,_that.categoriesById,_that.accountsById);case _:
  return null;

}
}

}

/// @nodoc


class _MoneyStory extends MoneyStory {
  const _MoneyStory({required this.month, this.income = 0, this.expense = 0, this.saved = 0, this.savingsRatePct = 0, this.isDeficit = false, this.topCategoryId, this.topCategoryAmount = 0, this.biggestExpense, this.momIncome = 0, this.momExpense = 0, final  Map<SpendingType, SpendingSlice> needVsWant = const <SpendingType, SpendingSlice>{}, final  List<TrendPoint> trend = const <TrendPoint>[], this.netWorth = 0, final  Map<int, Category> categoriesById = const <int, Category>{}, final  Map<int, Account> accountsById = const <int, Account>{}}): _needVsWant = needVsWant,_trend = trend,_categoriesById = categoriesById,_accountsById = accountsById,super._();
  

/// The focused month (first-of-month), for the header selector.
@override final  DateTime month;
/// Overview totals, transfers + system categories excluded.
@override@JsonKey() final  int income;
@override@JsonKey() final  int expense;
/// income − expense (negative in a deficit month).
@override@JsonKey() final  int saved;
/// `saved / income`, whole percent; 0 when income is 0 (÷0 guard). Negative
/// in a deficit month.
@override@JsonKey() final  int savingsRatePct;
/// `saved < 0` — flips the hero copy + `MoneyText` sign/color.
@override@JsonKey() final  bool isDeficit;
/// Biggest expense category this month (system excluded), or null.
@override final  int? topCategoryId;
@override@JsonKey() final  int topCategoryAmount;
/// The single largest real expense row (system excluded), or null.
@override final  Transaction? biggestExpense;
/// Signed month-over-month deltas vs the previous month.
@override@JsonKey() final  int momIncome;
@override@JsonKey() final  int momExpense;
/// Need/want/lifestyle/emergency shares of the typed expense subset.
 final  Map<SpendingType, SpendingSlice> _needVsWant;
/// Need/want/lifestyle/emergency shares of the typed expense subset.
@override@JsonKey() Map<SpendingType, SpendingSlice> get needVsWant {
  if (_needVsWant is EqualUnmodifiableMapView) return _needVsWant;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_needVsWant);
}

/// Reconstructed net-worth points (trailing 12 months), oldest→newest.
 final  List<TrendPoint> _trend;
/// Reconstructed net-worth points (trailing 12 months), oldest→newest.
@override@JsonKey() List<TrendPoint> get trend {
  if (_trend is EqualUnmodifiableListView) return _trend;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_trend);
}

/// Current net worth = `trend.last.netWorth` (or the baseline if empty).
@override@JsonKey() final  int netWorth;
/// id → Category / Account lookups to resolve names, icons, colors.
 final  Map<int, Category> _categoriesById;
/// id → Category / Account lookups to resolve names, icons, colors.
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


/// Create a copy of MoneyStory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoneyStoryCopyWith<_MoneyStory> get copyWith => __$MoneyStoryCopyWithImpl<_MoneyStory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoneyStory&&(identical(other.month, month) || other.month == month)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.savingsRatePct, savingsRatePct) || other.savingsRatePct == savingsRatePct)&&(identical(other.isDeficit, isDeficit) || other.isDeficit == isDeficit)&&(identical(other.topCategoryId, topCategoryId) || other.topCategoryId == topCategoryId)&&(identical(other.topCategoryAmount, topCategoryAmount) || other.topCategoryAmount == topCategoryAmount)&&(identical(other.biggestExpense, biggestExpense) || other.biggestExpense == biggestExpense)&&(identical(other.momIncome, momIncome) || other.momIncome == momIncome)&&(identical(other.momExpense, momExpense) || other.momExpense == momExpense)&&const DeepCollectionEquality().equals(other._needVsWant, _needVsWant)&&const DeepCollectionEquality().equals(other._trend, _trend)&&(identical(other.netWorth, netWorth) || other.netWorth == netWorth)&&const DeepCollectionEquality().equals(other._categoriesById, _categoriesById)&&const DeepCollectionEquality().equals(other._accountsById, _accountsById));
}


@override
int get hashCode => Object.hash(runtimeType,month,income,expense,saved,savingsRatePct,isDeficit,topCategoryId,topCategoryAmount,biggestExpense,momIncome,momExpense,const DeepCollectionEquality().hash(_needVsWant),const DeepCollectionEquality().hash(_trend),netWorth,const DeepCollectionEquality().hash(_categoriesById),const DeepCollectionEquality().hash(_accountsById));

@override
String toString() {
  return 'MoneyStory(month: $month, income: $income, expense: $expense, saved: $saved, savingsRatePct: $savingsRatePct, isDeficit: $isDeficit, topCategoryId: $topCategoryId, topCategoryAmount: $topCategoryAmount, biggestExpense: $biggestExpense, momIncome: $momIncome, momExpense: $momExpense, needVsWant: $needVsWant, trend: $trend, netWorth: $netWorth, categoriesById: $categoriesById, accountsById: $accountsById)';
}


}

/// @nodoc
abstract mixin class _$MoneyStoryCopyWith<$Res> implements $MoneyStoryCopyWith<$Res> {
  factory _$MoneyStoryCopyWith(_MoneyStory value, $Res Function(_MoneyStory) _then) = __$MoneyStoryCopyWithImpl;
@override @useResult
$Res call({
 DateTime month, int income, int expense, int saved, int savingsRatePct, bool isDeficit, int? topCategoryId, int topCategoryAmount, Transaction? biggestExpense, int momIncome, int momExpense, Map<SpendingType, SpendingSlice> needVsWant, List<TrendPoint> trend, int netWorth, Map<int, Category> categoriesById, Map<int, Account> accountsById
});


@override $TransactionCopyWith<$Res>? get biggestExpense;

}
/// @nodoc
class __$MoneyStoryCopyWithImpl<$Res>
    implements _$MoneyStoryCopyWith<$Res> {
  __$MoneyStoryCopyWithImpl(this._self, this._then);

  final _MoneyStory _self;
  final $Res Function(_MoneyStory) _then;

/// Create a copy of MoneyStory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? income = null,Object? expense = null,Object? saved = null,Object? savingsRatePct = null,Object? isDeficit = null,Object? topCategoryId = freezed,Object? topCategoryAmount = null,Object? biggestExpense = freezed,Object? momIncome = null,Object? momExpense = null,Object? needVsWant = null,Object? trend = null,Object? netWorth = null,Object? categoriesById = null,Object? accountsById = null,}) {
  return _then(_MoneyStory(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as int,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as int,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as int,savingsRatePct: null == savingsRatePct ? _self.savingsRatePct : savingsRatePct // ignore: cast_nullable_to_non_nullable
as int,isDeficit: null == isDeficit ? _self.isDeficit : isDeficit // ignore: cast_nullable_to_non_nullable
as bool,topCategoryId: freezed == topCategoryId ? _self.topCategoryId : topCategoryId // ignore: cast_nullable_to_non_nullable
as int?,topCategoryAmount: null == topCategoryAmount ? _self.topCategoryAmount : topCategoryAmount // ignore: cast_nullable_to_non_nullable
as int,biggestExpense: freezed == biggestExpense ? _self.biggestExpense : biggestExpense // ignore: cast_nullable_to_non_nullable
as Transaction?,momIncome: null == momIncome ? _self.momIncome : momIncome // ignore: cast_nullable_to_non_nullable
as int,momExpense: null == momExpense ? _self.momExpense : momExpense // ignore: cast_nullable_to_non_nullable
as int,needVsWant: null == needVsWant ? _self._needVsWant : needVsWant // ignore: cast_nullable_to_non_nullable
as Map<SpendingType, SpendingSlice>,trend: null == trend ? _self._trend : trend // ignore: cast_nullable_to_non_nullable
as List<TrendPoint>,netWorth: null == netWorth ? _self.netWorth : netWorth // ignore: cast_nullable_to_non_nullable
as int,categoriesById: null == categoriesById ? _self._categoriesById : categoriesById // ignore: cast_nullable_to_non_nullable
as Map<int, Category>,accountsById: null == accountsById ? _self._accountsById : accountsById // ignore: cast_nullable_to_non_nullable
as Map<int, Account>,
  ));
}

/// Create a copy of MoneyStory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionCopyWith<$Res>? get biggestExpense {
    if (_self.biggestExpense == null) {
    return null;
  }

  return $TransactionCopyWith<$Res>(_self.biggestExpense!, (value) {
    return _then(_self.copyWith(biggestExpense: value));
  });
}
}

/// @nodoc
mixin _$MoneyStoryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoneyStoryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MoneyStoryState()';
}


}

/// @nodoc
class $MoneyStoryStateCopyWith<$Res>  {
$MoneyStoryStateCopyWith(MoneyStoryState _, $Res Function(MoneyStoryState) __);
}


/// Adds pattern-matching-related methods to [MoneyStoryState].
extension MoneyStoryStatePatterns on MoneyStoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MoneyStoryInitial value)?  initial,TResult Function( MoneyStoryLoading value)?  loading,TResult Function( MoneyStoryLoaded value)?  loaded,TResult Function( MoneyStoryError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MoneyStoryInitial() when initial != null:
return initial(_that);case MoneyStoryLoading() when loading != null:
return loading(_that);case MoneyStoryLoaded() when loaded != null:
return loaded(_that);case MoneyStoryError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MoneyStoryInitial value)  initial,required TResult Function( MoneyStoryLoading value)  loading,required TResult Function( MoneyStoryLoaded value)  loaded,required TResult Function( MoneyStoryError value)  error,}){
final _that = this;
switch (_that) {
case MoneyStoryInitial():
return initial(_that);case MoneyStoryLoading():
return loading(_that);case MoneyStoryLoaded():
return loaded(_that);case MoneyStoryError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MoneyStoryInitial value)?  initial,TResult? Function( MoneyStoryLoading value)?  loading,TResult? Function( MoneyStoryLoaded value)?  loaded,TResult? Function( MoneyStoryError value)?  error,}){
final _that = this;
switch (_that) {
case MoneyStoryInitial() when initial != null:
return initial(_that);case MoneyStoryLoading() when loading != null:
return loading(_that);case MoneyStoryLoaded() when loaded != null:
return loaded(_that);case MoneyStoryError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( MoneyStory story)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MoneyStoryInitial() when initial != null:
return initial();case MoneyStoryLoading() when loading != null:
return loading();case MoneyStoryLoaded() when loaded != null:
return loaded(_that.story);case MoneyStoryError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( MoneyStory story)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case MoneyStoryInitial():
return initial();case MoneyStoryLoading():
return loading();case MoneyStoryLoaded():
return loaded(_that.story);case MoneyStoryError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( MoneyStory story)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case MoneyStoryInitial() when initial != null:
return initial();case MoneyStoryLoading() when loading != null:
return loading();case MoneyStoryLoaded() when loaded != null:
return loaded(_that.story);case MoneyStoryError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class MoneyStoryInitial implements MoneyStoryState {
  const MoneyStoryInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoneyStoryInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MoneyStoryState.initial()';
}


}




/// @nodoc


class MoneyStoryLoading implements MoneyStoryState {
  const MoneyStoryLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoneyStoryLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MoneyStoryState.loading()';
}


}




/// @nodoc


class MoneyStoryLoaded implements MoneyStoryState {
  const MoneyStoryLoaded(this.story);
  

 final  MoneyStory story;

/// Create a copy of MoneyStoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoneyStoryLoadedCopyWith<MoneyStoryLoaded> get copyWith => _$MoneyStoryLoadedCopyWithImpl<MoneyStoryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoneyStoryLoaded&&(identical(other.story, story) || other.story == story));
}


@override
int get hashCode => Object.hash(runtimeType,story);

@override
String toString() {
  return 'MoneyStoryState.loaded(story: $story)';
}


}

/// @nodoc
abstract mixin class $MoneyStoryLoadedCopyWith<$Res> implements $MoneyStoryStateCopyWith<$Res> {
  factory $MoneyStoryLoadedCopyWith(MoneyStoryLoaded value, $Res Function(MoneyStoryLoaded) _then) = _$MoneyStoryLoadedCopyWithImpl;
@useResult
$Res call({
 MoneyStory story
});


$MoneyStoryCopyWith<$Res> get story;

}
/// @nodoc
class _$MoneyStoryLoadedCopyWithImpl<$Res>
    implements $MoneyStoryLoadedCopyWith<$Res> {
  _$MoneyStoryLoadedCopyWithImpl(this._self, this._then);

  final MoneyStoryLoaded _self;
  final $Res Function(MoneyStoryLoaded) _then;

/// Create a copy of MoneyStoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? story = null,}) {
  return _then(MoneyStoryLoaded(
null == story ? _self.story : story // ignore: cast_nullable_to_non_nullable
as MoneyStory,
  ));
}

/// Create a copy of MoneyStoryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyStoryCopyWith<$Res> get story {
  
  return $MoneyStoryCopyWith<$Res>(_self.story, (value) {
    return _then(_self.copyWith(story: value));
  });
}
}

/// @nodoc


class MoneyStoryError implements MoneyStoryState {
  const MoneyStoryError(this.failure);
  

 final  Failure failure;

/// Create a copy of MoneyStoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoneyStoryErrorCopyWith<MoneyStoryError> get copyWith => _$MoneyStoryErrorCopyWithImpl<MoneyStoryError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoneyStoryError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'MoneyStoryState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MoneyStoryErrorCopyWith<$Res> implements $MoneyStoryStateCopyWith<$Res> {
  factory $MoneyStoryErrorCopyWith(MoneyStoryError value, $Res Function(MoneyStoryError) _then) = _$MoneyStoryErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$MoneyStoryErrorCopyWithImpl<$Res>
    implements $MoneyStoryErrorCopyWith<$Res> {
  _$MoneyStoryErrorCopyWithImpl(this._self, this._then);

  final MoneyStoryError _self;
  final $Res Function(MoneyStoryError) _then;

/// Create a copy of MoneyStoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(MoneyStoryError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
