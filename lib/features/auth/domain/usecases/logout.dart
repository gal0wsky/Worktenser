import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/auth/domain/repository/auth_repository.dart';

class LogoutUseCase extends UseCase<bool, void> {
  final AuthRepository _authRepository;

  LogoutUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<bool> call({void params}) async {
    return _authRepository.logOut();
  }
}
