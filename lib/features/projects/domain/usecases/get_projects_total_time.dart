import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/domain/repository/projects_repository.dart';

class GetProjectsTotalTimeUseCase extends UseCase<int, List<ProjectEntity>> {
  final ProjectsRepository _projectsRepository;

  GetProjectsTotalTimeUseCase({required ProjectsRepository projectsRepository})
      : _projectsRepository = projectsRepository;

  @override
  Future<int> call({List<ProjectEntity>? params}) async {
    return _projectsRepository.getProjectsTotalTime(params!);
  }
}
