import 'package:whatsapp_blast/features/auth/data/models/user_model.dart';
import 'package:whatsapp_blast/core/shared/entities/dio_response.dart';

class DioResponseModel extends DioResponse {
  DioResponseModel({
    required super.isSuccess,
    required super.message,
    super.user,
    super.accessToken,
    super.refreshToken,
  });

  factory DioResponseModel.fromJson(Map<String, dynamic> json) {
    return DioResponseModel(
      isSuccess: json['isSuccess'],
      message: json['message'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      accessToken: json['accessToken']?.toString(),
      refreshToken: json['refreshToken']?.toString(),
    );
  }

  DioResponseModel copyWith({
    bool? isSuccess,
    String? message,
    UserModel? user,
    String? accessToken,
    String? refreshToken,
  }) {
    return DioResponseModel(
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.accessToken,
    );
  }
}
