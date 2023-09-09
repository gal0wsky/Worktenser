import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:worktenser/domain/authentication/models/user_model.dart';
import 'package:worktenser/domain/projects/models/project_model.dart';
import 'package:worktenser/domain/projects/repositories/iprojects_repository.dart';

part 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  final IProjectsRepository _projectsRepository;

  ProjectsCubit({required IProjectsRepository projectsRepository})
      : _projectsRepository = projectsRepository,
        super(ProjectsState.initial());

  Future<void> loadProjects(User user) async {
    if (state.status == ProjectsStatus.loading) return;

    emit(state.copyWith(status: ProjectsStatus.loading));

    try {
      final projects = await _projectsRepository.loadProjects(user);

      emit(state.update(
        newStatus: ProjectsStatus.success,
        newProjects: projects,
      ));
    } catch (e) {
      emit(state.copyWith(status: ProjectsStatus.error));
      print(e);
    }
  }

  Future<void> addProject(Project project) async {
    if (state.status == ProjectsStatus.loading) return;

    emit(state.copyWith(status: ProjectsStatus.loading));

    try {
      final result = await _projectsRepository.addProject(project);

      final newStatus = result ? ProjectsStatus.reload : ProjectsStatus.error;

      List<Project> projects = [];

      for (var proj in state.projects) {
        projects.add(proj);
      }
      projects.add(project);

      emit(state.update(
        newStatus: newStatus,
        newProjects: projects,
      ));
    } catch (e) {
      emit(state.copyWith(status: ProjectsStatus.error));
      print(e);
    }
  }

  Future<void> updateProject(Project project) async {
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

        emit(state.update(
          newStatus: ProjectsStatus.success,
          newProjects: updatedProjects,
        ));
      }
    } catch (e) {
      emit(state.copyWith(status: ProjectsStatus.error));
      print(e);
    }
  }

  Future<void> deleteProject(Project project) async {
    if (state.status == ProjectsStatus.loading) return;

    emit(state.copyWith(status: ProjectsStatus.loading));

    try {
      final result = await _projectsRepository.deleteProject(project);

      if (!result) {
        emit(state.copyWith(status: ProjectsStatus.error));
      } else {
        emit(state.copyWith(
          status: ProjectsStatus.reload,
          projectsCount: state.projectsCount - 1,
        ));
      }
    } catch (e) {
      emit(state.copyWith(status: ProjectsStatus.error));
      print(e);
    }
  }
}
