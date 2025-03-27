import 'package:whatsapp_blast/core/shared/entities/dio_response.dart';
import 'package:whatsapp_blast/features/auth/domain/usecases/get_user_data.dart';
import 'package:whatsapp_blast/features/auth/domain/usecases/user_logout.dart';
import '../../domain/usecases/user_sign_in.dart';
import '../../domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final UserLogout _userLogout;
  final GetUserData _getUserData;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required UserLogout userLogout,
    required GetUserData getUserData,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _userLogout = userLogout,
        _getUserData = getUserData,
        super(AuthInitial()) {
    on<AuthEvent>(
      (event, emit) {
        emit(AuthLoading());
      },
    );
    on<SignUpEvent>(_onAuthSignUp);
    on<SignInEvent>(_onAuthSignIn);
    on<LogoutEvent>(_onLogout);
    on<GetUserDataEvent>(_onGetUserData);
  }

  void _onAuthSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    await _userSignUp(UserSignUpParams(
            name: event.name, email: event.email, password: event.password))
        .then(
      (response) {
        response.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (success) => emit(AuthSuccess(success)),
        );
      },
    );
  }

  void _onAuthSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    await _userSignIn(
            UserSignInParams(email: event.email, password: event.password))
        .then(
      (response) {
        response.fold((failure) => emit(AuthFailure(failure.message)),
            (success) {
          emit(LoginSuccess(success));
        });
      },
    );
  }

  void _onGetUserData(GetUserDataEvent event, Emitter<AuthState> emit) async {
    await _getUserData(event.email).then(
      (response) {
        response.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (success) => emit(GetUserDataSuccess(success)),
        );
      },
    );
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) {
    emit(LogoutSuccess(_userLogout(message: event.message)));
  }
}
