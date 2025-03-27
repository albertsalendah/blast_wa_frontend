import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_blast/config/routes/route_notifier.dart';
import 'package:whatsapp_blast/features/auth/presentation/pages/login_page.dart';
import 'package:whatsapp_blast/features/auth/presentation/pages/signup_page.dart';
import 'package:whatsapp_blast/features/navigation/main_nav.dart';
import 'routes_name.dart';

final GoRouter router = GoRouter(
    initialLocation: "/${RoutesName.login}",
    refreshListenable: routeNotifier,
    errorBuilder: (context, state) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text(state.error.toString())),
          ],
        ),
      );
    },
    redirect: (context, state) {
      final isAuthenticated = routeNotifier.isAuthenticated;
      final isLoginPage = state.matchedLocation == '/login_page';
      final isSignupPage = state.matchedLocation == '/signup_page';
      if (!isAuthenticated && !isLoginPage && !isSignupPage) {
        return "/login_page";
      } else if (isAuthenticated && isLoginPage) {
        return "/nav_page";
      } else {
        return null;
      }
    },
    routes: [
      GoRoute(
          path: "/${RoutesName.login}",
          name: RoutesName.login,
          builder: (context, state) {
            return const LoginPage();
          },
          routes: const []),
      GoRoute(
        path: "/${RoutesName.signup}",
        name: RoutesName.signup,
        builder: (context, state) {
          return const SignupPage();
        },
      ),
      GoRoute(
        path: "/${RoutesName.navpage}",
        name: RoutesName.navpage,
        builder: (context, state) {
          return MainNav();
        },
      ),
    ]);

class GoRouterRefreshStream extends ChangeNotifier {
  final Stream<dynamic> _stream;
  GoRouterRefreshStream(this._stream) {
    _stream.listen((_) => notifyListeners());
  }
}
