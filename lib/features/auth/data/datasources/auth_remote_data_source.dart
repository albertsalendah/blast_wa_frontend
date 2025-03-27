import 'package:whatsapp_blast/core/utils/constants/constants.dart';

import '../../../../core/di/init_dependencies.dart';
import '../../../../core/network/token_manager.dart';
import '../../../../core/shared/models/dio_response_model.dart';
import '../../../../core/errors/exceptions.dart';
import 'package:dio/dio.dart';

//Example of remote data source

abstract interface class AuthRemoteDataSource {
  Future<DioResponseModel> signUp(
      {required String name, required String email, required String password});
  Future<DioResponseModel> signIn(
      {required String email, required String password});
  Future<DioResponseModel> getUserData({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final tokenManager = serviceLocator<TokenManager>();
  final Dio client;
  AuthRemoteDataSourceImpl({
    required this.client,
  });

  DioResponseModel _handleDioException(DioException e) {
    if (e.response != null) {
      try {
        return DioResponseModel.fromJson(e.response!.data);
      } catch (error) {
        throw ServerException("Invalid response data: $error");
      }
    } else {
      throw ServerException(e.message ?? "Network error.");
    }
  }

  @override
  Future<DioResponseModel> signIn(
      {required String email, required String password}) async {
    try {
      final response = await client
          .post(loginPath, data: {'email': email, 'password': password});
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['isSuccess'] == true) {
        tokenManager.setAccessToken(
          accessToken: response.data['accessToken'],
        );
      }
      return response.data != null
          ? DioResponseModel.fromJson(response.data)
          : throw const ServerException('Data is null!');
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<DioResponseModel> signUp(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final response = await client.post(registerPath,
          data: {'name': name, 'email': email, 'password': password});
      return response.data != null
          ? DioResponseModel.fromJson(response.data)
          : throw const ServerException('Data is null!');
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<DioResponseModel> getUserData({required String email}) async {
    try {
      final refreshToken = tokenManager.refreshToken;
      final response = await client.get(getUserPath, data: {'email': email});
      if (response.statusCode == 200 &&
          response.data != null &&
          refreshToken != response.data['user']['refreshToken']) {
        tokenManager.setRefreshToken(
            refreshToken: response.data['user']['refreshToken']);
      }
      return response.data != null
          ? DioResponseModel.fromJson(response.data)
          : throw const ServerException('Data is null!');
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
