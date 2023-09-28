import 'package:worktenser/features/auth/domain/entities/signup.dart';

class SignupModel extends SignupEntity {
  const SignupModel({required String email, required String password})
      : super(email: email, password: password);

  factory SignupModel.initial() => const SignupModel(email: '', password: '');

  factory SignupModel.fromEntity(SignupEntity entity) =>
      SignupModel(email: entity.email, password: entity.password);
}
