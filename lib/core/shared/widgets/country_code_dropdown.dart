import 'package:flutter/material.dart';
import 'package:whatsapp_blast/config/theme/app_pallet.dart';
import 'package:whatsapp_blast/core/shared/models/country_code_model.dart';
import 'package:whatsapp_blast/core/usecase/load_country_code.dart';

class CountryCodeDropdown extends StatefulWidget {
  final Function(CountryCode countryCode) onSelected;
  const CountryCodeDropdown({super.key, required this.onSelected});

  @override
  State<CountryCodeDropdown> createState() => _CountryCodeDropdownState();
}

class _CountryCodeDropdownState extends State<CountryCodeDropdown> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<CountryCode> _countries = [];

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  void _loadCountries() async {
    List<CountryCode> countries = await LoadCountryCode.loadCountries();
    setState(() {
      _countries = countries;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 28,
      child: RawAutocomplete<CountryCode>(
        focusNode: _focusNode,
        textEditingController: _controller,
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return _countries; // Show all when input is empty
          }
          return _countries.where((country) {
            return country.name
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()) ||
                country.dialCode.contains(textEditingValue.text);
          }).toList();
        },
        displayStringForOption: (CountryCode option) =>
            "${option.name} (${option.dialCode})",
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          return TextField(
            controller: controller,
            focusNode: focusNode,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Select a country",
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              fillColor: AppPallete.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          );
        },
        optionsViewOpenDirection: OptionsViewOpenDirection.up,
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.bottomLeft,
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200, maxWidth: 300),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final CountryCode option = options.elementAt(index);
                    return ListTile(
                      title: Text(
                        "${option.name} (${option.dialCode})",
                        maxLines: 1,
                      ),
                      onTap: () => onSelected(option),
                    );
                  },
                ),
              ),
            ),
          );
        },
        onSelected: (CountryCode selected) {
          _controller.text = "${selected.code} (${selected.dialCode})";
          widget.onSelected(selected);
        },
      ),
    );
  }
}
