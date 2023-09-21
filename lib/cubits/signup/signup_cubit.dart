import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:worktenser/domain/authentication/repositories/iauth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final IAuthRepository _authRepository;

  SignupCubit(this._authRepository) : super(SignupState.initial());

  void nameChanged(String value) {
    emit(state.copyWith(name: value, status: SignupStatus.initial));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  Future signUpWithEmailAndPassword() async {
    if (state.status == SignupStatus.submitting) return;

    emit(state.copyWith(status: SignupStatus.submitting));

    try {
      final result = await _authRepository.signupWithEmailAndPassword(
          email: state.email, password: state.password);

      if (!result) {
        emit(state.copyWith(status: SignupStatus.error));
      } else {
        emit(state.copyWith(status: SignupStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(status: SignupStatus.error));
    }
  }
}
