import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dio_token_interceptor.dart';
import 'token_manager.dart';

class DioClient {
  final Dio dio;

  DioClient(TokenManager tokenManager)
      : dio = Dio(BaseOptions(
          baseUrl: dotenv.env['API_URL'] ?? '',
          headers: {'Content-Type': 'application/json'},
        )) {
    dio.interceptors
        .add(TokenInterceptor(dio: dio, tokenManager: tokenManager));
    // dio.interceptors.add(LogInterceptor(requestBody: true));
  }
}
