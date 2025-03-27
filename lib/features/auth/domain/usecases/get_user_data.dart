import 'package:fpdart/fpdart.dart';
import 'package:whatsapp_blast/core/usecase/usecase.dart';
import 'package:whatsapp_blast/core/shared/entities/dio_response.dart';
import 'package:whatsapp_blast/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/errors/failure.dart';

class GetUserData implements UseCase<DioResponse, String> {
  final AuthRepository repository;
  const GetUserData(this.repository);
  @override
  Future<Either<Failure, DioResponse>> call(String param) async {
    return await repository.getUserData(email: param);
  }
}
