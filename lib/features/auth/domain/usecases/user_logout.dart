import 'package:whatsapp_blast/core/di/init_dependencies.dart';
import 'package:whatsapp_blast/core/network/token_manager.dart';
import '../../../../core/shared/entities/dio_response.dart';
import '../repositories/auth_repository.dart';

class UserLogout {
  final AuthRepository repository;
  const UserLogout(this.repository);

  DioResponse call({required String message}) {
    final tokenManager = serviceLocator<TokenManager>();
    tokenManager.clearTokens();
    return DioResponse(isSuccess: true, message: message);
  }
}
