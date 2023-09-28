import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/auth/domain/entities/signup.dart';
import 'package:worktenser/features/auth/domain/repository/auth_repository.dart';

class SignupWithCredentialsUseCase implements UserCase<bool, SignupEntity> {
  final AuthRepository _authRepository;

  SignupWithCredentialsUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<bool> call({SignupEntity? params}) {
    return _authRepository.signupWithEmailAndPassword(
        signupInformation: params!);
  }
}
