import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/auth/domain/entities/login.dart';
import 'package:worktenser/features/auth/domain/repository/auth_repository.dart';

class SigninWithCredentialsUseCase implements UserCase<bool, LoginEntity> {
  final AuthRepository _authRepository;

  SigninWithCredentialsUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<bool> call({LoginEntity? params}) {
    return _authRepository.logInWithEmailAndPassword(loginInformation: params!);
  }
}
