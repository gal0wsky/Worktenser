import 'package:equatable/equatable.dart';

class SignupEntity extends Equatable {
  final String email;
  final String password;

  const SignupEntity({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
