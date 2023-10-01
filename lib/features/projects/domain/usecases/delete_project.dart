import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/domain/repository/projects_repository.dart';

class DeleteProjectUseCase extends UseCase<bool, ProjectEntity> {
  final ProjectsRepository _projectsRepository;

  DeleteProjectUseCase({required ProjectsRepository projectsRepository})
      : _projectsRepository = projectsRepository;

  @override
  Future<bool> call({ProjectEntity? params}) {
    return _projectsRepository.deleteProject(params!);
  }
}
