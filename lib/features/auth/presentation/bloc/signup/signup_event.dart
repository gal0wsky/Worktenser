part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupRequested extends SignupEvent {
  final SignupEntity signupData;

  const SignupRequested({required this.signupData});

  @override
  List<Object> get props => [signupData];
}

class ResetState extends SignupEvent {}
