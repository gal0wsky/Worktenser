import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:worktenser/features/auth/domain/entities/signup.dart';
import 'package:worktenser/features/auth/domain/usecases/signup_with_credentials.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupWithCredentialsUseCase _signupWithCredentialsUseCase;

  SignupBloc(
      {required SignupWithCredentialsUseCase signupWithCredentialsUseCase})
      : _signupWithCredentialsUseCase = signupWithCredentialsUseCase,
        super(SignupInitial()) {
    on<SignupRequested>(_onSignupRequested);
    on<ResetState>(_onResetBlocState);
  }

  FutureOr<void> _onSignupRequested(
      SignupRequested event, Emitter<SignupState> emit) async {
    if (state is SignupSubmitting) return;

    emit(SignupSubmitting());

    final signedUp =
        await _signupWithCredentialsUseCase.call(params: event.signupData);

    if (!signedUp) {
      emit(const SignupError(message: "Couldn't sign up"));
    } else {
      emit(SignupSuccessful());
    }
  }

  void _onResetBlocState(ResetState event, Emitter<SignupState> emit) {
    emit(SignupInitial());
  }
}
