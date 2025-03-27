import 'package:whatsapp_blast/core/shared/entities/dio_response.dart';
import '../../../../core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

//Example of domain repository
abstract interface class AuthRepository {
  Future<Either<Failure, DioResponse>> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, DioResponse>> signIn({
    required String email,
    required String password,
  });
  Future<Either<Failure, DioResponse>> getUserData({required String email});
}
