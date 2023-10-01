import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/domain/projects/src/services/iprojects_local_storage.dart';
import 'package:worktenser/features/auth/domain/repository/auth_repository.dart';

class LogoutUseCase extends UseCase<bool, void> {
  final AuthRepository _authRepository;
  final IProjectsLocalStorage _projectsLocalStorage;

  LogoutUseCase(
      {required AuthRepository authRepository,
      required IProjectsLocalStorage projectsLocalStorage})
      : _authRepository = authRepository,
        _projectsLocalStorage = projectsLocalStorage;

  @override
  Future<bool> call({void params}) async {
    final storageCleared = await _projectsLocalStorage.clear();

    if (!storageCleared) {
      return false;
    }

    return _authRepository.logOut();
  }
}
