import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/shared/entities/dio_response.dart';
import '../repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

// Example of use case
class UserSignIn implements UseCase<DioResponse, UserSignInParams> {
  final AuthRepository repository;
  const UserSignIn(this.repository);
  @override
  Future<Either<Failure, DioResponse>> call(UserSignInParams params) async {
    return await repository.signIn(
        email: params.email, password: params.password);
  }
}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({
    required this.email,
    required this.password,
  });
}
