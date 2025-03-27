import 'package:whatsapp_blast/features/whatsapp_api/domain/entities/phone_number.dart';

class PhoneNumberModel extends PhoneNumber {
  PhoneNumberModel({
    required super.id,
    required super.email,
    required super.whatsappNumber,
  });

  factory PhoneNumberModel.fromJson(Map<String, dynamic> json) {
    return PhoneNumberModel(
      id: json['id'].toString(),
      email: json['email'] ?? '',
      whatsappNumber: json['whatsapp_number'] ?? '',
    );
  }

  PhoneNumberModel copyWith({
    String? id,
    String? email,
    String? whatsappNumber,
  }) {
    return PhoneNumberModel(
      id: id ?? this.id,
      email: email ?? this.email,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
    );
  }
}
