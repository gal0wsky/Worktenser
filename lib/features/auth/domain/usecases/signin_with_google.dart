import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/auth/domain/repository/auth_repository.dart';

class SigninWithGoogleUseCase implements UseCase<bool, void> {
  final AuthRepository _authRepository;

  SigninWithGoogleUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<bool> call({void params}) {
    return _authRepository.signInWithGoogle();
  }
}
