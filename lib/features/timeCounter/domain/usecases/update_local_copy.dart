import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/projects/data/data_sources/local/projects_local_storage.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';

class UpdateLocalCopyUseCase extends UseCase<bool, ProjectEntity> {
  final ProjectsLocalStorage _projectsLocalStorage;

  UpdateLocalCopyUseCase({required ProjectsLocalStorage projectsLocalStorage})
      : _projectsLocalStorage = projectsLocalStorage;

  @override
  Future<bool> call({ProjectEntity? params}) {
    return _projectsLocalStorage.update(params!);
  }
}
