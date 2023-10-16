import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/projects/data/data_sources/local/projects_local_storage.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/domain/repository/projects_repository.dart';

class UpdateProjectUseCase extends UseCase<bool, ProjectEntity> {
  final ProjectsRepository _projectsRepository;
  final ProjectsLocalStorage _projectsLocalStorage;

  UpdateProjectUseCase(
      {required ProjectsRepository projectsRepository,
      required ProjectsLocalStorage projectsLocalStorage})
      : _projectsRepository = projectsRepository,
        _projectsLocalStorage = projectsLocalStorage;

  @override
  Future<bool> call({ProjectEntity? params}) async {
    final project = params!;

    final updatedLocally = await _projectsLocalStorage.update(project);

    if (!updatedLocally) {
      return false;
    } else {
      final updatedInFirestore =
          await _projectsRepository.updateProject(project);

      return updatedInFirestore;
    }
  }
}
