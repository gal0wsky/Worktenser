import 'package:worktenser/features/auth/domain/entities/user.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';

abstract class ProjectsRepository {
  Future<List<ProjectEntity>> loadProjects(UserEntity user);
  Future<bool> addProject(ProjectEntity project);
  Future<bool> updateProject(ProjectEntity project);
  Future<bool> deleteProject(ProjectEntity project);
  int getProjectsTotalTime(List<ProjectEntity> projects);
}
