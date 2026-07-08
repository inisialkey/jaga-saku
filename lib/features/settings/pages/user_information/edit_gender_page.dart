import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';

class EditGenderPage extends StatefulWidget {
  const EditGenderPage({super.key});

  @override
  State<EditGenderPage> createState() => _EditGenderPageState();
}

class _EditGenderPageState extends State<EditGenderPage> {
  String? _selectedGender;

  /// Stable backend-facing codes. The on-screen label is localized via
  /// [_genderLabel]; the stored/sent value stays language-independent.
  final _genders = ['Male', 'Female'];

  String _genderLabel(BuildContext context, String gender) => gender == 'Male'
      ? Strings.of(context)!.male
      : Strings.of(context)!.female;

  void _onSave() {
    if (_selectedGender == null) return;
    Strings.of(context)!.featureNotAvailableYet.toToastError(context);
  }

  @override
  Widget build(BuildContext context) => Parent(
    appBar: MyAppBar(
      title: Strings.of(context)!.editGender,
      onBack: () => context.pop(),
    ),
    bottomNavigation: Padding(
      padding: EdgeInsets.all(Dimens.space24),
      child: Button(
        width: double.maxFinite,
        title: Strings.of(context)!.save,
        onPressed: _selectedGender != null ? _onSave : null,
      ),
    ),
    child: SingleChildScrollView(
      padding: EdgeInsets.all(Dimens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.of(context)!.pleaseSelectGender,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: Dimens.space8),
          DropDown<String?>(
            hint: Strings.of(context)!.gender,
            hintIsVisible: false,
            value: _selectedGender,
            items: [
              DropdownMenuItem<String?>(
                child: Text(
                  Strings.of(context)!.gender,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
              ..._genders.map(
                (gender) => DropdownMenuItem<String?>(
                  value: gender,
                  child: Text(_genderLabel(context, gender)),
                ),
              ),
            ],
            onChanged: (value) => setState(() => _selectedGender = value),
          ),
        ],
      ),
    ),
  );
}
