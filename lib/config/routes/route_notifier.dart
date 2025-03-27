import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:whatsapp_blast/core/di/init_dependencies.dart';
import 'package:whatsapp_blast/core/network/token_manager.dart';

class RouteNotifier extends ChangeNotifier {
  bool _isAuthenticated = false;

  RouteNotifier() {
    loadAuthState();
  }

  bool get isAuthenticated => _isAuthenticated;

  void loadAuthState() {
    final tokenManager = serviceLocator<TokenManager>();
    final accessToken = tokenManager.accessToken;
    final refreshToken = tokenManager.refreshToken;
    bool isExpired = true;
    if (accessToken != null && !JwtDecoder.isExpired(accessToken)) {
      isExpired = false;
    } else if (refreshToken != null && !JwtDecoder.isExpired(refreshToken)) {
      isExpired = false;
    }
    _isAuthenticated = !isExpired;
    notifyListeners();
  }
}

final routeNotifier = RouteNotifier();
