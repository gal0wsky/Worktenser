part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginSubmitting extends LoginState {}

final class LoginSuccessful extends LoginState {}

final class LoginError extends LoginState {
  final String message;

  const LoginError({this.message = 'Something went wrong.'});

  @override
  List<Object> get props => [message];
}
