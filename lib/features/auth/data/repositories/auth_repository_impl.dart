import 'package:whatsapp_blast/core/shared/entities/dio_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/exceptions.dart';
import 'package:fpdart/fpdart.dart';

//Example of data repository implementation
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, DioResponse>> signIn(
      {required String email, required String password}) async {
    return _geResponse(
      fn: () async =>
          await remoteDataSource.signIn(email: email, password: password),
    );
  }

  @override
  Future<Either<Failure, DioResponse>> signUp(
      {required String name,
      required String email,
      required String password}) async {
    return _geResponse(
      fn: () async => await remoteDataSource.signUp(
          name: name, email: email, password: password),
    );
  }

  Future<Either<Failure, DioResponse>> _geResponse(
      {required Future<DioResponse> Function() fn}) async {
    try {
      final response = await fn();
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, DioResponse>> getUserData({required String email}) {
    return _geResponse(
      fn: () async => await remoteDataSource.getUserData(email: email),
    );
  }
}
