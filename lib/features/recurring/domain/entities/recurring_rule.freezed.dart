// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecurringRule {

/// The owned `tx_templates` row id (the FK target). `0` until the two-table
/// insert assigns it.
 int get templateId; RecurrenceFreq get freq;/// First occurrence + the day-of-month/weekday anchor, midnight-local millis.
 int get startDate;/// Cursor: earliest UNRESOLVED occurrence, midnight-local millis.
 int get nextDue;/// `null` until persisted (SQLite AUTOINCREMENT assigns it on insert).
 int? get id;/// Every N units (every 2 months, every 3 weeks, …).
 int get interval;/// Optional inclusive last bound; `null` = open-ended.
 int? get endDate; int get createdAt;/// Non-persisted: the joined `tx_templates` shape, filled by `getRules()`;
/// `null` on a plain read / insert.
 TxTemplate? get template;
/// Create a copy of RecurringRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringRuleCopyWith<RecurringRule> get copyWith => _$RecurringRuleCopyWithImpl<RecurringRule>(this as RecurringRule, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringRule&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.freq, freq) || other.freq == freq)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.nextDue, nextDue) || other.nextDue == nextDue)&&(identical(other.id, id) || other.id == id)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.template, template) || other.template == template));
}


@override
int get hashCode => Object.hash(runtimeType,templateId,freq,startDate,nextDue,id,interval,endDate,createdAt,template);

@override
String toString() {
  return 'RecurringRule(templateId: $templateId, freq: $freq, startDate: $startDate, nextDue: $nextDue, id: $id, interval: $interval, endDate: $endDate, createdAt: $createdAt, template: $template)';
}


}

/// @nodoc
abstract mixin class $RecurringRuleCopyWith<$Res>  {
  factory $RecurringRuleCopyWith(RecurringRule value, $Res Function(RecurringRule) _then) = _$RecurringRuleCopyWithImpl;
@useResult
$Res call({
 int templateId, RecurrenceFreq freq, int startDate, int nextDue, int? id, int interval, int? endDate, int createdAt, TxTemplate? template
});


$TxTemplateCopyWith<$Res>? get template;

}
/// @nodoc
class _$RecurringRuleCopyWithImpl<$Res>
    implements $RecurringRuleCopyWith<$Res> {
  _$RecurringRuleCopyWithImpl(this._self, this._then);

  final RecurringRule _self;
  final $Res Function(RecurringRule) _then;

/// Create a copy of RecurringRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? templateId = null,Object? freq = null,Object? startDate = null,Object? nextDue = null,Object? id = freezed,Object? interval = null,Object? endDate = freezed,Object? createdAt = null,Object? template = freezed,}) {
  return _then(_self.copyWith(
templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as int,freq: null == freq ? _self.freq : freq // ignore: cast_nullable_to_non_nullable
as RecurrenceFreq,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as int,nextDue: null == nextDue ? _self.nextDue : nextDue // ignore: cast_nullable_to_non_nullable
as int,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,template: freezed == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as TxTemplate?,
  ));
}
/// Create a copy of RecurringRule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TxTemplateCopyWith<$Res>? get template {
    if (_self.template == null) {
    return null;
  }

  return $TxTemplateCopyWith<$Res>(_self.template!, (value) {
    return _then(_self.copyWith(template: value));
  });
}
}


/// Adds pattern-matching-related methods to [RecurringRule].
extension RecurringRulePatterns on RecurringRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringRule value)  $default,){
final _that = this;
switch (_that) {
case _RecurringRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringRule value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int templateId,  RecurrenceFreq freq,  int startDate,  int nextDue,  int? id,  int interval,  int? endDate,  int createdAt,  TxTemplate? template)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringRule() when $default != null:
return $default(_that.templateId,_that.freq,_that.startDate,_that.nextDue,_that.id,_that.interval,_that.endDate,_that.createdAt,_that.template);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int templateId,  RecurrenceFreq freq,  int startDate,  int nextDue,  int? id,  int interval,  int? endDate,  int createdAt,  TxTemplate? template)  $default,) {final _that = this;
switch (_that) {
case _RecurringRule():
return $default(_that.templateId,_that.freq,_that.startDate,_that.nextDue,_that.id,_that.interval,_that.endDate,_that.createdAt,_that.template);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int templateId,  RecurrenceFreq freq,  int startDate,  int nextDue,  int? id,  int interval,  int? endDate,  int createdAt,  TxTemplate? template)?  $default,) {final _that = this;
switch (_that) {
case _RecurringRule() when $default != null:
return $default(_that.templateId,_that.freq,_that.startDate,_that.nextDue,_that.id,_that.interval,_that.endDate,_that.createdAt,_that.template);case _:
  return null;

}
}

}

/// @nodoc


class _RecurringRule implements RecurringRule {
  const _RecurringRule({required this.templateId, required this.freq, required this.startDate, required this.nextDue, this.id, this.interval = 1, this.endDate, this.createdAt = 0, this.template});
  

/// The owned `tx_templates` row id (the FK target). `0` until the two-table
/// insert assigns it.
@override final  int templateId;
@override final  RecurrenceFreq freq;
/// First occurrence + the day-of-month/weekday anchor, midnight-local millis.
@override final  int startDate;
/// Cursor: earliest UNRESOLVED occurrence, midnight-local millis.
@override final  int nextDue;
/// `null` until persisted (SQLite AUTOINCREMENT assigns it on insert).
@override final  int? id;
/// Every N units (every 2 months, every 3 weeks, …).
@override@JsonKey() final  int interval;
/// Optional inclusive last bound; `null` = open-ended.
@override final  int? endDate;
@override@JsonKey() final  int createdAt;
/// Non-persisted: the joined `tx_templates` shape, filled by `getRules()`;
/// `null` on a plain read / insert.
@override final  TxTemplate? template;

/// Create a copy of RecurringRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringRuleCopyWith<_RecurringRule> get copyWith => __$RecurringRuleCopyWithImpl<_RecurringRule>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringRule&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.freq, freq) || other.freq == freq)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.nextDue, nextDue) || other.nextDue == nextDue)&&(identical(other.id, id) || other.id == id)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.template, template) || other.template == template));
}


@override
int get hashCode => Object.hash(runtimeType,templateId,freq,startDate,nextDue,id,interval,endDate,createdAt,template);

@override
String toString() {
  return 'RecurringRule(templateId: $templateId, freq: $freq, startDate: $startDate, nextDue: $nextDue, id: $id, interval: $interval, endDate: $endDate, createdAt: $createdAt, template: $template)';
}


}

/// @nodoc
abstract mixin class _$RecurringRuleCopyWith<$Res> implements $RecurringRuleCopyWith<$Res> {
  factory _$RecurringRuleCopyWith(_RecurringRule value, $Res Function(_RecurringRule) _then) = __$RecurringRuleCopyWithImpl;
@override @useResult
$Res call({
 int templateId, RecurrenceFreq freq, int startDate, int nextDue, int? id, int interval, int? endDate, int createdAt, TxTemplate? template
});


@override $TxTemplateCopyWith<$Res>? get template;

}
/// @nodoc
class __$RecurringRuleCopyWithImpl<$Res>
    implements _$RecurringRuleCopyWith<$Res> {
  __$RecurringRuleCopyWithImpl(this._self, this._then);

  final _RecurringRule _self;
  final $Res Function(_RecurringRule) _then;

/// Create a copy of RecurringRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? templateId = null,Object? freq = null,Object? startDate = null,Object? nextDue = null,Object? id = freezed,Object? interval = null,Object? endDate = freezed,Object? createdAt = null,Object? template = freezed,}) {
  return _then(_RecurringRule(
templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as int,freq: null == freq ? _self.freq : freq // ignore: cast_nullable_to_non_nullable
as RecurrenceFreq,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as int,nextDue: null == nextDue ? _self.nextDue : nextDue // ignore: cast_nullable_to_non_nullable
as int,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,template: freezed == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as TxTemplate?,
  ));
}

/// Create a copy of RecurringRule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TxTemplateCopyWith<$Res>? get template {
    if (_self.template == null) {
    return null;
  }

  return $TxTemplateCopyWith<$Res>(_self.template!, (value) {
    return _then(_self.copyWith(template: value));
  });
}
}

/// @nodoc
mixin _$PendingOccurrence {

 RecurringRule get rule; TxTemplate get template; int get dueDate;
/// Create a copy of PendingOccurrence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingOccurrenceCopyWith<PendingOccurrence> get copyWith => _$PendingOccurrenceCopyWithImpl<PendingOccurrence>(this as PendingOccurrence, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingOccurrence&&(identical(other.rule, rule) || other.rule == rule)&&(identical(other.template, template) || other.template == template)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate));
}


@override
int get hashCode => Object.hash(runtimeType,rule,template,dueDate);

@override
String toString() {
  return 'PendingOccurrence(rule: $rule, template: $template, dueDate: $dueDate)';
}


}

/// @nodoc
abstract mixin class $PendingOccurrenceCopyWith<$Res>  {
  factory $PendingOccurrenceCopyWith(PendingOccurrence value, $Res Function(PendingOccurrence) _then) = _$PendingOccurrenceCopyWithImpl;
@useResult
$Res call({
 RecurringRule rule, TxTemplate template, int dueDate
});


$RecurringRuleCopyWith<$Res> get rule;$TxTemplateCopyWith<$Res> get template;

}
/// @nodoc
class _$PendingOccurrenceCopyWithImpl<$Res>
    implements $PendingOccurrenceCopyWith<$Res> {
  _$PendingOccurrenceCopyWithImpl(this._self, this._then);

  final PendingOccurrence _self;
  final $Res Function(PendingOccurrence) _then;

/// Create a copy of PendingOccurrence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rule = null,Object? template = null,Object? dueDate = null,}) {
  return _then(_self.copyWith(
rule: null == rule ? _self.rule : rule // ignore: cast_nullable_to_non_nullable
as RecurringRule,template: null == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as TxTemplate,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of PendingOccurrence
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecurringRuleCopyWith<$Res> get rule {
  
  return $RecurringRuleCopyWith<$Res>(_self.rule, (value) {
    return _then(_self.copyWith(rule: value));
  });
}/// Create a copy of PendingOccurrence
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TxTemplateCopyWith<$Res> get template {
  
  return $TxTemplateCopyWith<$Res>(_self.template, (value) {
    return _then(_self.copyWith(template: value));
  });
}
}


/// Adds pattern-matching-related methods to [PendingOccurrence].
extension PendingOccurrencePatterns on PendingOccurrence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingOccurrence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingOccurrence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingOccurrence value)  $default,){
final _that = this;
switch (_that) {
case _PendingOccurrence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingOccurrence value)?  $default,){
final _that = this;
switch (_that) {
case _PendingOccurrence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RecurringRule rule,  TxTemplate template,  int dueDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingOccurrence() when $default != null:
return $default(_that.rule,_that.template,_that.dueDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RecurringRule rule,  TxTemplate template,  int dueDate)  $default,) {final _that = this;
switch (_that) {
case _PendingOccurrence():
return $default(_that.rule,_that.template,_that.dueDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RecurringRule rule,  TxTemplate template,  int dueDate)?  $default,) {final _that = this;
switch (_that) {
case _PendingOccurrence() when $default != null:
return $default(_that.rule,_that.template,_that.dueDate);case _:
  return null;

}
}

}

/// @nodoc


class _PendingOccurrence implements PendingOccurrence {
  const _PendingOccurrence({required this.rule, required this.template, required this.dueDate});
  

@override final  RecurringRule rule;
@override final  TxTemplate template;
@override final  int dueDate;

/// Create a copy of PendingOccurrence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingOccurrenceCopyWith<_PendingOccurrence> get copyWith => __$PendingOccurrenceCopyWithImpl<_PendingOccurrence>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingOccurrence&&(identical(other.rule, rule) || other.rule == rule)&&(identical(other.template, template) || other.template == template)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate));
}


@override
int get hashCode => Object.hash(runtimeType,rule,template,dueDate);

@override
String toString() {
  return 'PendingOccurrence(rule: $rule, template: $template, dueDate: $dueDate)';
}


}

/// @nodoc
abstract mixin class _$PendingOccurrenceCopyWith<$Res> implements $PendingOccurrenceCopyWith<$Res> {
  factory _$PendingOccurrenceCopyWith(_PendingOccurrence value, $Res Function(_PendingOccurrence) _then) = __$PendingOccurrenceCopyWithImpl;
@override @useResult
$Res call({
 RecurringRule rule, TxTemplate template, int dueDate
});


@override $RecurringRuleCopyWith<$Res> get rule;@override $TxTemplateCopyWith<$Res> get template;

}
/// @nodoc
class __$PendingOccurrenceCopyWithImpl<$Res>
    implements _$PendingOccurrenceCopyWith<$Res> {
  __$PendingOccurrenceCopyWithImpl(this._self, this._then);

  final _PendingOccurrence _self;
  final $Res Function(_PendingOccurrence) _then;

/// Create a copy of PendingOccurrence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rule = null,Object? template = null,Object? dueDate = null,}) {
  return _then(_PendingOccurrence(
rule: null == rule ? _self.rule : rule // ignore: cast_nullable_to_non_nullable
as RecurringRule,template: null == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as TxTemplate,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of PendingOccurrence
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecurringRuleCopyWith<$Res> get rule {
  
  return $RecurringRuleCopyWith<$Res>(_self.rule, (value) {
    return _then(_self.copyWith(rule: value));
  });
}/// Create a copy of PendingOccurrence
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TxTemplateCopyWith<$Res> get template {
  
  return $TxTemplateCopyWith<$Res>(_self.template, (value) {
    return _then(_self.copyWith(template: value));
  });
}
}

// dart format on
