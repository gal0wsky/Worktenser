import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/projects/data/data_sources/local/projects_local_storage.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/domain/repository/projects_repository.dart';

class AddProjectUseCase extends UseCase<bool, ProjectEntity> {
  final ProjectsRepository _projectsRepository;
  final ProjectsLocalStorage _projectsLocalStorage;

  AddProjectUseCase(
      {required ProjectsRepository projectsRepository,
      required ProjectsLocalStorage projectsLocalStorage})
      : _projectsRepository = projectsRepository,
        _projectsLocalStorage = projectsLocalStorage;

  @override
  Future<bool> call({ProjectEntity? params}) async {
    final project = params!;

    final projectSavedLocally = await _projectsLocalStorage.add(project);

    if (!projectSavedLocally) {
      return false;
    } else {
      final projectAdded = await _projectsRepository.addProject(project);

      return projectAdded;
    }
  }
}
