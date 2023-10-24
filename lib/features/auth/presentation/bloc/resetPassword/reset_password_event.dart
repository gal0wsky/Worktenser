part of 'reset_password_bloc.dart';

sealed class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

class ResetUserPassword extends ResetPasswordEvent {
  final String email;

  const ResetUserPassword({required this.email});

  @override
  List<Object> get props => [email];
}
