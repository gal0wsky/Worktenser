import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:worktenser/features/auth/domain/usecases/reset_password.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordBloc({required ResetPasswordUseCase resetPasswordUseCase})
      : _resetPasswordUseCase = resetPasswordUseCase,
        super(ResetPasswordInitial()) {
    on<ResetUserPassword>(_onResetUserPassword);
  }

  Future<void> _onResetUserPassword(
      ResetUserPassword event, Emitter<ResetPasswordState> emit) async {
    final state = this.state;

    if (state is ResetPasswordSubmitting) return;

    emit(ResetPasswordSubmitting());

    final resetEmailSend =
        await _resetPasswordUseCase.call(params: event.email);

    if (!resetEmailSend) {
      emit(const ResetPasswordError(
          message: "Couldn't send the reset password email"));
    } else {
      emit(ResetPasswordSuccess());
    }
  }
}
