import 'package:worktenser/features/auth/domain/entities/login.dart';

class LoginModel extends LoginEntity {
  const LoginModel({required String email, required String password})
      : super(email: email, password: password);

  factory LoginModel.initial() => const LoginModel(email: '', password: '');

  factory LoginModel.fromEntity(LoginEntity entity) =>
      LoginModel(email: entity.email, password: entity.password);
}
