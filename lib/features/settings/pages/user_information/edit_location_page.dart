import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';

class EditLocationPage extends StatefulWidget {
  const EditLocationPage({super.key});

  @override
  State<EditLocationPage> createState() => _EditLocationPageState();
}

class _EditLocationPageState extends State<EditLocationPage> {
  final _conLocation = TextEditingController();
  final _fnLocation = FocusNode();

  bool _isLocationValid = false;
  // ignore: unused_field
  String _selectedLocation = '';
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  // Dummy data rekomendasi — ganti dengan API (Google Places, dll.)
  final _dummyLocations = [
    'Jakarta, Indonesia',
    'Jakarta Selatan, Indonesia',
    'Jakarta Utara, Indonesia',
    'Jakarta Barat, Indonesia',
    'Jakarta Timur, Indonesia',
    'Jakarta Pusat, Indonesia',
    'Bandung, Jawa Barat',
    'Surabaya, Jawa Timur',
    'Medan, Sumatera Utara',
    'Makassar, Sulawesi Selatan',
    'Yogyakarta, DIY',
    'Semarang, Jawa Tengah',
    'Palembang, Sumatera Selatan',
    'Denpasar, Bali',
    'Bogor, Jawa Barat',
    'Depok, Jawa Barat',
    'Tangerang, Banten',
    'Bekasi, Jawa Barat',
  ];

  void _onSearchChanged(String value) {
    setState(() {
      _isLocationValid = false;
      _selectedLocation = '';
      if (value.trim().isEmpty) {
        _suggestions = [];
        _showSuggestions = false;
      } else {
        _suggestions = _dummyLocations
            .where((loc) => loc.toLowerCase().contains(value.toLowerCase()))
            .toList();
        _showSuggestions = _suggestions.isNotEmpty;
      }
    });
  }

  void _onSelectSuggestion(String location) {
    setState(() {
      _selectedLocation = location;
      _isLocationValid = true;
      _showSuggestions = false;
      _conLocation.text = location;
      _conLocation.selection = TextSelection.fromPosition(
        TextPosition(offset: location.length),
      );
    });
    _fnLocation.unfocus();
  }

  void _onSave() {
    if (!_isLocationValid) return;
    Strings.of(context)!.featureNotAvailableYet.toToastError(context);
  }

  @override
  void dispose() {
    _conLocation.dispose();
    _fnLocation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Parent(
    appBar: MyAppBar(
      title: Strings.of(context)!.editLocation,

      onBack: () => context.pop(),
    ),
    bottomNavigation: Padding(
      padding: EdgeInsets.all(Dimens.space24),
      child: Button(
        width: double.maxFinite,
        title: Strings.of(context)!.save,
        onPressed: _isLocationValid ? _onSave : null,
      ),
    ),
    child: SingleChildScrollView(
      padding: EdgeInsets.all(Dimens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.of(context)!.pleaseEnterLocation,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: Dimens.space8),
          TextF(
            key: const Key('location'),
            focusNode: _fnLocation,
            textInputAction: TextInputAction.search,
            controller: _conLocation,
            keyboardType: TextInputType.streetAddress,
            hint: Strings.of(context)!.location,
            prefixIcon: const Icon(Icons.search),
            isValid: _isLocationValid,
            validatorListener: _onSearchChanged,
            errorMessage: '',
          ),
          if (_showSuggestions) ...[
            SizedBox(height: Dimens.space8),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Palette.cardDark
                    : Palette.card,
                borderRadius: BorderRadius.circular(Dimens.cornerRadiusForm),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _suggestions.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Theme.of(context).dividerColor),
                itemBuilder: (_, index) {
                  final suggestion = _suggestions[index];
                  return InkWell(
                    onTap: () => _onSelectSuggestion(suggestion),
                    borderRadius: BorderRadius.circular(
                      Dimens.cornerRadiusForm,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimens.space16,
                        vertical: Dimens.space12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: Theme.of(context).hintColor,
                          ),
                          SizedBox(width: Dimens.space8),
                          Expanded(
                            child: Text(
                              suggestion,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
