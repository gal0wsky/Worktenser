import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:worktenser/domain/authentication/repositories/auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;

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

  Future signInWithEmailAndPassword() async {
    if (state.status == SignupStatus.submitting) return;

    emit(state.copyWith(status: SignupStatus.submitting));

    try {
      await _authRepository.signupWithEmailAndPassword(
          email: state.email, password: state.password);

      emit(state.copyWith(status: SignupStatus.success));
    } catch (_) {}
  }
}
