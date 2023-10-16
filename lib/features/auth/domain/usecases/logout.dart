import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/auth/domain/repository/auth_repository.dart';
import 'package:worktenser/features/projects/data/data_sources/local/projects_local_storage.dart';

class LogoutUseCase extends UseCase<bool, void> {
  final AuthRepository _authRepository;
  final ProjectsLocalStorage _projectsLocalStorage;

  LogoutUseCase(
      {required AuthRepository authRepository,
      required ProjectsLocalStorage projectsLocalStorage})
      : _authRepository = authRepository,
        _projectsLocalStorage = projectsLocalStorage;

  @override
  Future<bool> call({void params}) async {
    final storageCleared = await _projectsLocalStorage.clear();

    if (!storageCleared) {
      return false;
    } else {
      return _authRepository.logOut();
    }
  }
}
