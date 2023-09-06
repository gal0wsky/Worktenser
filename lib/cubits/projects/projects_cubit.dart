import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:worktenser/domain/authentication/models/user_model.dart';
import 'package:worktenser/domain/projects/models/project_model.dart';
import 'package:worktenser/domain/projects/repositories/projects_repository.dart';

part 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  final ProjectsRepository _projectsRepository;

  ProjectsCubit({required ProjectsRepository projectsRepository})
      : _projectsRepository = projectsRepository,
        super(ProjectsState.initial());

  Future loadProjects(User user) async {
    if (state.status == ProjectsStatus.loading) return;

    emit(state.copyWith(status: ProjectsStatus.loading));

    try {
      final projects = await _projectsRepository.loadProjects(user);

      emit(state.copyWith(
          projects: projects,
          projectsCount: projects.length,
          projectsTime: _countProjectsTotalTime(projects),
          status: ProjectsStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ProjectsStatus.error));
      print(e);
    }
  }

  Future addProject(Project project) async {
    if (state.status == ProjectsStatus.loading) return;

    emit(state.copyWith(status: ProjectsStatus.loading));

    try {
      final result = await _projectsRepository.addProject(project);

      final newStatus = result ? ProjectsStatus.success : ProjectsStatus.error;

      List<Project> projects = [];

      for (var proj in state.projects) {
        projects.add(proj);
      }
      projects.add(project);

      emit(state.copyWith(
        status: newStatus,
        projects: projects,
        projectsCount: projects.length,
        projectsTime: _countProjectsTotalTime(projects),
      ));
    } catch (e) {
      emit(state.copyWith(status: ProjectsStatus.error));
      print(e);
    }
  }

  Future updateProject(Project project) async {
    if (state.status == ProjectsStatus.loading) return;

    emit(state.copyWith(status: ProjectsStatus.loading));

    try {
      final result = await _projectsRepository.updateProject(project);

      if (!result) {
        emit(state.copyWith(status: ProjectsStatus.error));
      } else {
        final updatedProjects = state.projects.map((proj) {
          return proj.id == project.id ? project : proj;
        }).toList();

        emit(state.copyWith(
          status: ProjectsStatus.success,
          projects: updatedProjects,
        ));
      }
    } catch (e) {
      emit(state.copyWith(status: ProjectsStatus.error));
      print(e);
    }
  }

  Future deleteProject(Project project) async {
    if (state.status == ProjectsStatus.loading) return;

    emit(state.copyWith(status: ProjectsStatus.loading));

    try {
      final result = await _projectsRepository.deleteProject(project);

      if (!result) {
        emit(state.copyWith(status: ProjectsStatus.error));
      } else {
        List<Project> updatedProjects = [];

        for (var proj in state.projects) {
          if (proj.id != project.id) {
            updatedProjects.add(proj);
          }
        }

        emit(state.copyWith(
          status: ProjectsStatus.success,
          projects: updatedProjects,
          projectsCount: updatedProjects.length,
          projectsTime: _countProjectsTotalTime(updatedProjects),
        ));
      }
    } catch (e) {
      emit(state.copyWith(status: ProjectsStatus.error));
      print(e);
    }
  }

  int _countProjectsTotalTime(List<Project> projects) {
    int time = 0;

    for (var project in projects) {
      time += project.time;
    }

    return time;
  }
}
