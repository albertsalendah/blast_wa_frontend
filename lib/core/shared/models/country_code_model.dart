class CountryCode {
  final String name;
  final String dialCode;
  final String code;

  CountryCode({required this.name, required this.dialCode, required this.code});

  factory CountryCode.fromJson(Map<String, dynamic> json) {
    return CountryCode(
      name: json['name'],
      dialCode: json['dial_code'],
      code: json['code'],
    );
  }
}
