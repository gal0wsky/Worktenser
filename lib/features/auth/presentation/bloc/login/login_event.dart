part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class CredentialsLoginRequested extends LoginEvent {
  final LoginEntity loginData;

  const CredentialsLoginRequested({required this.loginData});

  @override
  List<Object> get props => [loginData];
}

class GoogleLoginRequested extends LoginEvent {}
