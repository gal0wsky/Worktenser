import 'package:worktenser/domain/authentication/models/user_model.dart';
import 'package:worktenser/domain/projects/src/models/project_model.dart';

abstract class IProjectsRepository {
  Future<List<Project>> loadProjects(User user);
  Future<bool> addProject(Project project);
  Future<bool> updateProject(Project project);
  Future<bool> deleteProject(Project project);
}
