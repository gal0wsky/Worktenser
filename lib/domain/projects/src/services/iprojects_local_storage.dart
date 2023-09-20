import 'package:worktenser/domain/projects/src/models/project_model.dart';

abstract class IProjectsLocalStorage {
  List<Project> load();
  Future<bool> save(List<Project> projects);
  Future<bool> update(Project project);
  Future<bool> delete(Project project);
  Future<bool> clear();
}
