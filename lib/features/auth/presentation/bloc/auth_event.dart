part of 'auth_bloc.dart';

//Example of bloc event
@immutable
sealed class AuthEvent {}

final class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({
    required this.email,
    required this.password,
  });
}

final class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  SignUpEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

final class GetUserPhoneNumbersEvent extends AuthEvent {
  final String email;
  GetUserPhoneNumbersEvent({required this.email});
}

final class GetUserDataEvent extends AuthEvent {
  final String email;
  GetUserDataEvent({required this.email});
}

final class LogoutEvent extends AuthEvent {
  final String message;
  LogoutEvent({required this.message});
}
