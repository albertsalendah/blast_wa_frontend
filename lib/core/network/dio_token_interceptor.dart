import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:whatsapp_blast/core/di/init_dependencies.dart';
import 'package:whatsapp_blast/core/utils/constants/constants.dart';
import 'package:whatsapp_blast/features/auth/presentation/bloc/auth_bloc.dart';

import 'token_manager.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;
  final TokenManager tokenManager;
  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  TokenInterceptor({required this.dio, required this.tokenManager});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? accessToken = tokenManager.accessToken;
    log('📡 Sending request: ${options.method} ${options.path}');
    log('📎 Headers: ${options.headers}');

    // if (options.data != null) {
    //   log('📄 Payload: ${options.data}');
    // }

    if (accessToken == null) {
      _isRefreshing = false;
      await tokenManager.loadTokens();
      accessToken = tokenManager.accessToken;
    }

    bool tokenExpiring =
        accessToken != null && _isTokenExpiringSoon(accessToken);
    bool checkPath = (options.path != loginPath &&
        options.path != registerPath &&
        options.path != logoutPath &&
        options.path != accessTokenPath);

    if (tokenExpiring && !_isRefreshing && checkPath) {
      log('⌚ Token is expiring soon. Refreshing...');
      _isRefreshing = true;
      _refreshCompleter = Completer<void>();

      try {
        await _refreshToken();
        accessToken = tokenManager.accessToken;
        _refreshCompleter!.complete();
      } catch (e) {
        log('❌ Error refreshing token: $e');
        _refreshCompleter!.completeError(e);
      } finally {
        _isRefreshing = false;
      }
    }

    if (_isRefreshing && checkPath) {
      log('⏳ Waiting for token refresh to complete....');
      await _refreshCompleter!.future;
      accessToken = tokenManager.accessToken;
    }

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    bool isUnauthorized =
        err.response?.statusCode == 401 || err.response?.statusCode == 403;
    String message = err.response?.data['message'] ?? '';
    if (isUnauthorized && err.requestOptions.path == accessTokenPath) {
      serviceLocator<AuthBloc>().add(LogoutEvent(message: message));
      return;
    }

    if (isUnauthorized && err.requestOptions.path != accessTokenPath) {
      if (!_isRefreshing) {
        _isRefreshing = true;
        _refreshCompleter = Completer<void>();

        try {
          log('🔄 Refreshing token due to error: ${err.response?.statusCode} ${err.requestOptions.path}');
          await _refreshToken();
          _refreshCompleter!.complete();
        } catch (e) {
          log('❌ Error refreshing token: $e');
          _refreshCompleter!.completeError(e);
          return handler.reject(err);
        } finally {
          _isRefreshing = false;
        }
      }

      // Wait for refresh to complete
      await _refreshCompleter!.future;
      // Retry the failed request with the new token
      return handler.resolve(await _retryRequest(err.requestOptions));
    }
    handler.next(err);
  }

  bool _isTokenExpiringSoon(String token, {int bufferInSeconds = 30}) {
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      int? exp = decodedToken['exp'];
      if (exp == null) return false;

      int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return (exp - currentTime) <= bufferInSeconds;
    } catch (e) {
      return false;
    }
  }

  Future<void> _refreshToken() async {
    String? refreshToken = tokenManager.refreshToken;

    if (refreshToken == null) {
      await tokenManager.loadTokens();
      refreshToken = tokenManager.refreshToken;
    }

    if (refreshToken == null) {
      log('🚨 No refresh token found. Logging out...');
      serviceLocator<AuthBloc>()
          .add(LogoutEvent(message: 'Your session has expired'));
      return;
    }

    for (int attempt = 0; attempt <= 5; attempt++) {
      if (serviceLocator<AuthBloc>().state is LogoutSuccess) {
        log('🚨 User has logged out. Stopping token refresh.');
        return;
      }
      try {
        log('🔄 Requesting new Refresh Token (Attempt ${attempt + 1})');
        final response = await dio.get(accessTokenPath, data: {
          'refreshToken': refreshToken,
        });

        log('🔄 Refresh token response status: ${response.statusCode}');

        final newAccessToken = response.data['accessToken'];
        await tokenManager.setAccessToken(
            accessToken: newAccessToken); // ✅ Use setTokens
        return;
      } catch (e) {
        if (attempt == 5) {
          log('🚨 Token refresh attempt ${attempt + 1} failed: $e');
          log('🚨 Final refresh attempt failed. Logging out...');
          log('🚨 Dispatching LogoutEvent...');
          serviceLocator<AuthBloc>().add(LogoutEvent(message: '$e'));
          log('✅ LogoutEvent dispatched.');
          return;
        }
        await Future.delayed(Duration(seconds: 5));
      } finally {
        _isRefreshing = false;
      }
    }
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    final newAccessToken = tokenManager.accessToken;
    if (newAccessToken == null) {
      return Response(
        requestOptions: requestOptions,
        statusCode: 401,
      );
    }
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $newAccessToken',
      },
    );
    log('🔄 Retring request...');
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
