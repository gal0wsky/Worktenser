import 'package:worktenser/features/projects/domain/entities/project.dart';

abstract class ProjectsLocalStorage {
  List<ProjectEntity> load();
  Future<bool> add(ProjectEntity project);
  Future<bool> save(List<ProjectEntity> projects);
  Future<bool> update(ProjectEntity project);
  Future<bool> delete(ProjectEntity project);
  Future<bool> clear();
}
