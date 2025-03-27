part of 'auth_bloc.dart';

//Example of bloc state
@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final DioResponse response;
  const AuthSuccess(this.response);
}

final class LoginSuccess extends AuthState {
  final DioResponse response;
  const LoginSuccess(this.response);
}

final class GetUserDataSuccess extends AuthState {
  final DioResponse response;
  const GetUserDataSuccess(this.response);
}

final class LogoutSuccess extends AuthState {
  final DioResponse response;
  const LogoutSuccess(this.response);
}

final class AuthFailure extends AuthState {
  final String message;
  const AuthFailure([this.message = 'An unexpected error occured']);
}
