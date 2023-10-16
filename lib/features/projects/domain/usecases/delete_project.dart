import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/projects/data/data_sources/local/projects_local_storage.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/domain/repository/projects_repository.dart';

class DeleteProjectUseCase extends UseCase<bool, ProjectEntity> {
  final ProjectsRepository _projectsRepository;
  final ProjectsLocalStorage _projectsLocalStorage;

  DeleteProjectUseCase(
      {required ProjectsRepository projectsRepository,
      required ProjectsLocalStorage projectsLocalStorage})
      : _projectsRepository = projectsRepository,
        _projectsLocalStorage = projectsLocalStorage;

  @override
  Future<bool> call({ProjectEntity? params}) async {
    final project = params!;

    final deletedLocally = await _projectsLocalStorage.delete(project);

    if (!deletedLocally) {
      return false;
    } else {
      final deletedFromFirestore =
          await _projectsRepository.deleteProject(project);

      return deletedFromFirestore;
    }
  }
}
