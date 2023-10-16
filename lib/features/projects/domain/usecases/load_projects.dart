import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/auth/domain/entities/user.dart';
import 'package:worktenser/features/projects/data/data_sources/local/projects_local_storage.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/domain/repository/projects_repository.dart';

class LoadProjectsUsecase extends UseCase<List<ProjectEntity>, UserEntity> {
  final ProjectsRepository _projectsRepository;
  final ProjectsLocalStorage _projectsLocalStorage;

  LoadProjectsUsecase(
      {required ProjectsRepository projectsRepository,
      required ProjectsLocalStorage projectsLocalStorage})
      : _projectsRepository = projectsRepository,
        _projectsLocalStorage = projectsLocalStorage;

  @override
  Future<List<ProjectEntity>> call({UserEntity? params}) async {
    final projects = await _projectsRepository.loadProjects(params!);

    final projectsSaved = await _projectsLocalStorage.save(projects);

    if (!projectsSaved) {
      return [];
    } else {
      return projects;
    }
  }
}
