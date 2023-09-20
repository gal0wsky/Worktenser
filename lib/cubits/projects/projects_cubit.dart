import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:worktenser/domain/authentication/authentication.dart';
import 'package:worktenser/domain/projects/src/models/models.dart';
import 'package:worktenser/domain/projects/src/repositories/iprojects_repository.dart';

part 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  final IProjectsRepository _projectsRepository;

  ProjectsCubit({required IProjectsRepository projectsRepository})
      : _projectsRepository = projectsRepository,
        super(ProjectsInitial());

  Future<void> loadProjects(User user) async {
    if (state is ProjectsLoading) return;

    emit(ProjectsLoading());

    try {
      final projects = await _projectsRepository.loadProjects(user);

      emit(ProjectsLoaded(
        projects: projects,
        projectsCount: projects.length,
        projectsTime: _countProjectsTotalTime(projects),
      ));
    } catch (e) {
      emit(const ProjectsLoadingError());
    }
  }

  Future<void> addProject(Project project) async {
    if (state is ProjectsLoading) return;

    emit(ProjectsLoading());

    try {
      final result = await _projectsRepository.addProject(project);

      emit(result ? ProjectsReload() : const ProjectsLoadingError());
    } catch (e) {
      emit(const ProjectsLoadingError());
    }
  }

  Future<void> updateProject(Project project) async {
    if (state is ProjectsLoading) return;

    emit(ProjectsLoading());

    try {
      final result = await _projectsRepository.updateProject(project);

      emit(
        result
            ? ProjectsReload()
            : const ProjectsLoadingError(
                message: "Couldn't update the project"),
      );
    } catch (e) {
      emit(const ProjectsLoadingError());
    }
  }

  Future<void> deleteProject(Project project) async {
    if (state is ProjectsLoading) return;

    emit(ProjectsLoading());

    try {
      final result = await _projectsRepository.deleteProject(project);

      emit(
        result
            ? ProjectsReload()
            : const ProjectsLoadingError(
                message: "Couldn't delete the project"),
      );
    } catch (e) {
      emit(const ProjectsLoadingError());
    }
  }
}

int _countProjectsTotalTime(List<Project> projects) {
  int time = 0;

  for (var project in projects) {
    time += project.time;
  }

  return time;
}
