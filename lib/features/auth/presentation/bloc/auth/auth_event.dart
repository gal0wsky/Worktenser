part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppLogoutRequested extends AuthEvent {}

class AppUserChanged extends AuthEvent {
  final UserEntity user;

  const AppUserChanged(this.user);

  @override
  List<Object> get props => [user];
}
