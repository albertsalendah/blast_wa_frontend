import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:whatsapp_blast/core/shared/models/country_code_model.dart';

class LoadCountryCode {
  static Future<List<CountryCode>> loadCountries() async {
    final String response =
        await rootBundle.loadString('assets/json/CountryCodes.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => CountryCode.fromJson(json)).toList();
  }
}
