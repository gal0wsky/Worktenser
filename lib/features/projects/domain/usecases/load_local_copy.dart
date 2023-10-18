import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/projects/data/data_sources/local/projects_local_storage.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';

class LoadLocalCopyUseCase extends UseCase<List<ProjectEntity>, void> {
  final ProjectsLocalStorage _projectsLocalStorage;

  LoadLocalCopyUseCase({required ProjectsLocalStorage projectsLocalStorage})
      : _projectsLocalStorage = projectsLocalStorage;

  @override
  Future<List<ProjectEntity>> call({void params}) async {
    final projects = _projectsLocalStorage.load();

    return projects;
  }
}
