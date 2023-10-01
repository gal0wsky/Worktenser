import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/auth/domain/entities/user.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/domain/repository/projects_repository.dart';

class LoadProjectsUsecase extends UseCase<List<ProjectEntity>, UserEntity> {
  final ProjectsRepository _projectsRepository;

  LoadProjectsUsecase({required ProjectsRepository projectsRepository})
      : _projectsRepository = projectsRepository;

  @override
  Future<List<ProjectEntity>> call({UserEntity? params}) {
    return _projectsRepository.loadProjects(params!);
  }
}
