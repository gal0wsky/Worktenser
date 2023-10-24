import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:worktenser/features/auth/domain/entities/user.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/domain/usecases/add_project.dart';
import 'package:worktenser/features/projects/domain/usecases/delete_project.dart';
import 'package:worktenser/features/projects/domain/usecases/get_projects_total_time.dart';
import 'package:worktenser/features/projects/domain/usecases/load_local_copy.dart';
import 'package:worktenser/features/projects/domain/usecases/load_projects.dart';
import 'package:worktenser/features/projects/domain/usecases/update_project.dart';
import 'package:worktenser/features/timeCounter/presentation/bloc/time_counter/time_counter_bloc.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final LoadProjectsUsecase _loadProjectsUsecase;
  final AddProjectUseCase _addProjectUseCase;
  final UpdateProjectUseCase _updateProjectUseCase;
  final DeleteProjectUseCase _deleteProjectUseCase;
  final GetProjectsTotalTimeUseCase _getProjectsTotalTimeUseCase;
  final LoadLocalCopyUseCase _loadLocalCopyUseCase;

  final TimeCounterBloc _timeCounterBloc;
  late StreamSubscription _counterSubscription;

  ProjectsBloc(
      {required LoadProjectsUsecase loadProjectsUsecase,
      required AddProjectUseCase addProjectUseCase,
      required UpdateProjectUseCase updateProjectUseCase,
      required DeleteProjectUseCase deleteProjectUseCase,
      required GetProjectsTotalTimeUseCase getProjectsTotalTimeUseCase,
      required LoadLocalCopyUseCase loadLocalCopyUseCase,
      required TimeCounterBloc timeCounterBloc})
      : _loadProjectsUsecase = loadProjectsUsecase,
        _addProjectUseCase = addProjectUseCase,
        _updateProjectUseCase = updateProjectUseCase,
        _deleteProjectUseCase = deleteProjectUseCase,
        _getProjectsTotalTimeUseCase = getProjectsTotalTimeUseCase,
        _loadLocalCopyUseCase = loadLocalCopyUseCase,
        _timeCounterBloc = timeCounterBloc,
        super(ProjectsInitial()) {
    on<LoadProjects>(_onLoadProjects);
    on<AddProject>(_onAddProject);
    on<UpdateProject>(_onUpdateProject);
    on<DeleteProject>(_onDeleteProject);
    on<LoadLocalCopy>(_onLoadLocalCopy);

    _counterSubscription = _timeCounterBloc.stream.listen((counterState) {
      add(LoadLocalCopy());
    });
  }

  Future<void> _onLoadProjects(
      LoadProjects event, Emitter<ProjectsState> emit) async {
    final state = this.state;

    if (state is ProjectsLoading) return;

    emit(ProjectsLoading());

    final projects = await _loadProjectsUsecase.call(params: event.user);

    final projectsTotalTime =
        await _getProjectsTotalTimeUseCase.call(params: projects);

    emit(ProjectsLoaded(
        projects: projects,
        projectsCount: projects.length,
        projectsTime: projectsTotalTime));
  }

  Future<void> _onAddProject(
      AddProject event, Emitter<ProjectsState> emit) async {
    final state = this.state;

    if (state is ProjectsLoading) return;

    emit(ProjectsLoading());

    final projectAdded = await _addProjectUseCase.call(params: event.project);

    if (!projectAdded) {
      emit(const ProjectsError(message: "Couldn't add the project"));
    } else {
      emit(ProjectsReloading());
    }
  }

  Future<void> _onUpdateProject(
      UpdateProject event, Emitter<ProjectsState> emit) async {
    final state = this.state;

    if (state is ProjectsLoading) return;

    emit(ProjectsLoading());

    final projectUpdated =
        await _updateProjectUseCase.call(params: event.project);

    if (!projectUpdated) {
      emit(const ProjectsError(message: "Couldn't update the project"));
    } else {
      emit(ProjectsReloading());
    }
  }

  Future<void> _onDeleteProject(
      DeleteProject event, Emitter<ProjectsState> emit) async {
    final state = this.state;

    if (state is ProjectsLoading) return;

    emit(ProjectsLoading());

    final projectDeleted =
        await _deleteProjectUseCase.call(params: event.project);

    if (!projectDeleted) {
      emit(const ProjectsError(message: "Couldn't delete the project"));
    } else {
      emit(ProjectsReloading());
    }
  }

  Future<void> _onLoadLocalCopy(
      LoadLocalCopy event, Emitter<ProjectsState> emit) async {
    final projects = await _loadLocalCopyUseCase.call();
    final totalTime = await _getProjectsTotalTimeUseCase.call(params: projects);

    emit(ProjectsLoaded(
        projects: projects,
        projectsCount: projects.length,
        projectsTime: totalTime));
  }

  @override
  Future<void> close() {
    _counterSubscription.cancel();
    return super.close();
  }
}
