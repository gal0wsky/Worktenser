import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/domain/repository/projects_repository.dart';

class UpdateInFirestoreUseCase extends UseCase<bool, ProjectEntity> {
  final ProjectsRepository _projectsRepository;

  UpdateInFirestoreUseCase({required ProjectsRepository projectsRepository})
      : _projectsRepository = projectsRepository;

  @override
  Future<bool> call({ProjectEntity? params}) {
    return _projectsRepository.updateProject(params!);
  }
}
