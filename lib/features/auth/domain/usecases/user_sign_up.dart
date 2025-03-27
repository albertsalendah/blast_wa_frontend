import 'package:whatsapp_blast/core/shared/entities/dio_response.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

// Example of use case
class UserSignUp implements UseCase<DioResponse, UserSignUpParams> {
  final AuthRepository repository;
  const UserSignUp(this.repository);

  @override
  Future<Either<Failure, DioResponse>> call(UserSignUpParams params) async {
    return await repository.signUp(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;

  UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
