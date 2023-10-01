part of 'projects_bloc.dart';

sealed class ProjectsState extends Equatable {
  const ProjectsState();

  @override
  List<Object> get props => [];
}

final class ProjectsInitial extends ProjectsState {}

final class ProjectsLoading extends ProjectsState {}

class ProjectsLoaded extends ProjectsState {
  final List<ProjectEntity> projects;
  final int projectsCount;
  final int projectsTime;

  const ProjectsLoaded({
    this.projects = const <ProjectEntity>[],
    this.projectsCount = 0,
    this.projectsTime = 0,
  });

  @override
  List<Object> get props => [projects, projectsCount, projectsTime];
}

class ProjectsError extends ProjectsState {
  final String message;

  const ProjectsError({this.message = 'Something went wrong.'});

  @override
  List<Object> get props => [message];
}

final class ProjectsReloading extends ProjectsState {}
