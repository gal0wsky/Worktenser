import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:worktenser/domain/authentication/authentication.dart';
import 'package:worktenser/domain/projects/projects.dart';

part 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  final IProjectsRepository _projectsRepository;
  final IProjectsLocalStorage _localStorage;

  ProjectsCubit(
      {required IProjectsRepository projectsRepository,
      required IProjectsLocalStorage projectsLocalStorage})
      : _projectsRepository = projectsRepository,
        _localStorage = projectsLocalStorage,
        super(ProjectsInitial());

  Future<void> loadProjects(User user) async {
    if (state is ProjectsLoading) return;

    emit(ProjectsLoading());

    try {
      final projects = await _projectsRepository.loadProjects(user);

      final savedLocally = await _localStorage.save(projects);

      if (!savedLocally) {
        emit(const ProjectsLoadingError(
            message: "Couldn't create local backup of projects"));
      } else {
        emit(ProjectsLoaded(
          projects: projects,
          projectsCount: projects.length,
          projectsTime: _countProjectsTotalTime(projects),
        ));
      }
    } catch (e) {
      emit(const ProjectsLoadingError());
    }
  }

  Future<void> addProject(Project project) async {
    if (state is ProjectsLoading) return;

    emit(ProjectsLoading());

    try {
      final addedToFirestore = await _projectsRepository.addProject(project);

      if (!addedToFirestore) {
        emit(const ProjectsLoadingError(message: "Couldn't add the project"));
      } else {
        final localProjects = _localStorage.load();
        final addedToLocalCopy =
            await _localStorage.save(localProjects..add(project));

        emit(addedToLocalCopy
            ? ProjectsReload()
            : const ProjectsLoadingError(message: "Couldn't add the project"));
      }
    } catch (e) {
      emit(
        const ProjectsLoadingError(message: "Couldn't add the project"),
      );
    }
  }

  Future<void> updateProject(Project project) async {
    if (state is ProjectsLoading) return;

    emit(ProjectsLoading());

    try {
      final updatedInFirestore =
          await _projectsRepository.updateProject(project);

      if (!updatedInFirestore) {
        emit(
          const ProjectsLoadingError(message: "Couldn't update the project"),
        );
      } else {
        final updatedLocally = await _localStorage.update(project);

        emit(
          updatedLocally
              ? ProjectsReload()
              : const ProjectsLoadingError(
                  message: "Couldn't update the project"),
        );
      }
    } catch (e) {
      emit(const ProjectsLoadingError());
    }
  }

  Future<void> deleteProject(Project project) async {
    if (state is ProjectsLoading) return;

    emit(ProjectsLoading());

    try {
      final deletedFromFirestore =
          await _projectsRepository.deleteProject(project);

      if (!deletedFromFirestore) {
        emit(
          const ProjectsLoadingError(message: "Couldn't delete the project"),
        );
      } else {
        final deletedFromLocalBackup = await _localStorage.delete(project);

        emit(
          deletedFromLocalBackup
              ? ProjectsReload()
              : const ProjectsLoadingError(
                  message: "Couldn't delete the project"),
        );
      }
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
