import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:worktenser/features/auth/domain/entities/login.dart';
import 'package:worktenser/features/auth/domain/usecases/signin_with_credentials.dart';
import 'package:worktenser/features/auth/domain/usecases/signin_with_google.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SigninWithCredentialsUseCase _signinWithCredentialsUseCase;
  final SigninWithGoogleUseCase _signinWithGoogleUseCase;

  LoginBloc(
      {required SigninWithCredentialsUseCase signinWithCredentialsUseCase,
      required SigninWithGoogleUseCase signinWithGoogleUseCase})
      : _signinWithCredentialsUseCase = signinWithCredentialsUseCase,
        _signinWithGoogleUseCase = signinWithGoogleUseCase,
        super(LoginInitial()) {
    on<CredentialsLoginRequested>(_onCredentialsLoginRequested);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
  }

  Future<void> _onCredentialsLoginRequested(
      CredentialsLoginRequested event, Emitter<LoginState> emit) async {
    if (state is LoginSubmitting) return;

    emit(LoginSubmitting());

    final loggedIn =
        await _signinWithCredentialsUseCase.call(params: event.loginData);

    if (!loggedIn) {
      emit(const LoginError(message: "Couldn't log in"));
    } else {
      emit(LoginSuccessful());
    }
  }

  FutureOr<void> _onGoogleLoginRequested(
      GoogleLoginRequested event, Emitter<LoginState> emit) async {
    if (state is LoginSubmitting) return;

    emit(LoginSubmitting());

    final loggedIn = await _signinWithGoogleUseCase.call();

    if (!loggedIn) {
      emit(const LoginError(message: "Couldn't log in"));
    } else {
      emit(LoginSuccessful());
    }
  }
}
