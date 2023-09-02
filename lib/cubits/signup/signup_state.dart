// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, error }

class SignupState extends Equatable {
  final String name;
  final String email;
  final String password;
  final SignupStatus status;

  const SignupState(
      {this.name = '',
      this.email = '',
      this.password = '',
      this.status = SignupStatus.initial});

  factory SignupState.initial() {
    return const SignupState(
        email: '', password: '', status: SignupStatus.initial);
  }

  SignupState copyWith({
    String? name,
    String? email,
    String? password,
    SignupStatus? status,
  }) {
    return SignupState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [name, email, password, status];
}
