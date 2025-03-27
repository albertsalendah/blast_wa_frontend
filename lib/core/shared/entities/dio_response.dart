import '../../../features/auth/domain/entities/user.dart';

class DioResponse {
  final bool isSuccess;
  final String message;
  final User? user;
  final String? accessToken;
  final String? refreshToken;
  DioResponse({
    required this.isSuccess,
    required this.message,
    this.user,
    this.accessToken,
    this.refreshToken,
  });
}
