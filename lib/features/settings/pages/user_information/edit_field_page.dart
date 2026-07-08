import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';

/// Resolves a localized label from the generated [Strings].
typedef _L10n = String Function(Strings s);

/// Config for a generic "edit a single text field" stub screen.
///
/// The homogeneous profile-field stubs (email / phone / age) collapse into one
/// [EditTextFieldPage] driven by this config instead of one near-identical file
/// each. The *real* persistence pattern lives in `EditNamePage` + `EditNameCubit`
/// (load via `GET /auth/me`, save via `PUT /users/{id}`) — clone that to wire a
/// field up for real; these stubs just validate and show a "not available" toast.
class EditTextFieldConfig {
  const EditTextFieldConfig({
    required this.fieldKey,
    required this.title,
    required this.description,
    required this.hint,
    required this.errorMessage,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.autofillHints,
    this.inputFormatters,
    this.unit,
  });

  final String fieldKey;
  final _L10n title;
  final _L10n description;
  final _L10n hint;
  final _L10n errorMessage;
  final bool Function(String value) validator;
  final TextInputType keyboardType;
  final List<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;

  /// Optional trailing unit label (e.g. "years old" for age).
  final _L10n? unit;

  factory EditTextFieldConfig.email() => EditTextFieldConfig(
    fieldKey: 'email',
    title: (s) => s.editEmail,
    description: (s) => s.pleaseEnterEmail,
    hint: (s) => s.email,
    errorMessage: (s) => s.errorInvalidEmail,
    keyboardType: TextInputType.emailAddress,
    autofillHints: const [AutofillHints.email],
    validator: (v) => v.isValidEmail(),
  );

  factory EditTextFieldConfig.phone() => EditTextFieldConfig(
    fieldKey: 'phone',
    title: (s) => s.editPhone,
    description: (s) => s.pleaseEnterNumber,
    hint: (s) => s.phoneNumber,
    errorMessage: (s) => s.errorEmptyField,
    keyboardType: TextInputType.phone,
    autofillHints: const [AutofillHints.telephoneNumber],
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    validator: (v) => v.trim().isNotEmpty,
  );

  factory EditTextFieldConfig.age() => EditTextFieldConfig(
    fieldKey: 'age',
    title: (s) => s.editAge,
    description: (s) => s.pleaseEnterAge,
    hint: (s) => s.age,
    errorMessage: (s) => s.errorEmptyField,
    keyboardType: TextInputType.number,
    unit: (s) => s.yearOld,
    validator: (v) => v.trim().isNotEmpty,
  );
}

/// Generic stub screen for editing a single text field. See [EditTextFieldConfig].
class EditTextFieldPage extends StatefulWidget {
  const EditTextFieldPage({required this.config, super.key});

  final EditTextFieldConfig config;

  @override
  State<EditTextFieldPage> createState() => _EditTextFieldPageState();
}

class _EditTextFieldPageState extends State<EditTextFieldPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isValid = false;

  void _onSave() {
    if (!_isValid) return;
    Strings.of(context)!.featureNotAvailableYet.toToastError(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final config = widget.config;
    final field = TextF(
      key: Key(config.fieldKey),
      focusNode: _focusNode,
      controller: _controller,
      textInputAction: TextInputAction.done,
      keyboardType: config.keyboardType,
      autoFillHints: config.autofillHints,
      inputFormatters: config.inputFormatters,
      hint: config.hint(s),
      isValid: _isValid,
      validatorListener: (value) =>
          setState(() => _isValid = config.validator(value)),
      errorMessage: config.errorMessage(s),
    );
    return Parent(
      appBar: MyAppBar(title: config.title(s), onBack: () => context.pop()),
      bottomNavigation: Padding(
        padding: EdgeInsets.all(Dimens.space24),
        child: Button(
          width: double.maxFinite,
          title: s.save,
          onPressed: _isValid ? _onSave : null,
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(Dimens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              config.description(s),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: Dimens.space8),
            if (config.unit == null)
              field
            else
              Row(
                children: [
                  Expanded(flex: 2, child: field),
                  SpacerH(value: Dimens.space12),
                  Expanded(
                    flex: 2,
                    child: Text(
                      config.unit!(s),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Config for a generic scroll-picker stub screen (height / weight). See
/// [EditPickerFieldPage].
class EditPickerFieldConfig {
  const EditPickerFieldConfig({
    required this.title,
    required this.description,
    required this.hint,
    required this.unit,
    required this.values,
  });

  final _L10n title;
  final _L10n description;
  final _L10n hint;
  final _L10n unit;
  final List<int> values;

  factory EditPickerFieldConfig.height() => EditPickerFieldConfig(
    title: (s) => s.editHeight,
    description: (s) => s.updateyourHeight,
    hint: (s) => s.height,
    unit: (s) => s.unitCm,
    values: List.generate(221, (i) => i + 120),
  );

  factory EditPickerFieldConfig.weight() => EditPickerFieldConfig(
    title: (s) => s.editWeight,
    description: (s) => s.updateyourWeight,
    hint: (s) => s.weight,
    unit: (s) => s.unitKg,
    values: List.generate(271, (i) => i + 30),
  );
}

/// Generic stub screen for picking a numeric value via a scroll picker.
class EditPickerFieldPage extends StatefulWidget {
  const EditPickerFieldPage({required this.config, super.key});

  final EditPickerFieldConfig config;

  @override
  State<EditPickerFieldPage> createState() => _EditPickerFieldPageState();
}

class _EditPickerFieldPageState extends State<EditPickerFieldPage> {
  int _selected = 0;

  void _onSave() {
    if (_selected == 0) return;
    Strings.of(context)!.featureNotAvailableYet.toToastError(context);
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final config = widget.config;
    return Parent(
      appBar: MyAppBar(title: config.title(s), onBack: () => context.pop()),
      bottomNavigation: Padding(
        padding: EdgeInsets.all(Dimens.space24),
        child: Button(
          width: double.maxFinite,
          title: s.save,
          onPressed: _selected != 0 ? _onSave : null,
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(Dimens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              config.description(s),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: Dimens.space8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropDown<int>(
                    hint: config.hint(s),
                    hintIsVisible: false,
                    value: _selected,
                    items: const [],
                    isScrollPicker: true,
                    scrollPickerValues: config.values,
                    scrollPickerUnit: config.unit(s),
                    onChanged: (value) =>
                        setState(() => _selected = value ?? 0),
                  ),
                ),
                SpacerH(value: Dimens.space12),
                Expanded(
                  flex: 2,
                  child: Text(
                    config.unit(s),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
