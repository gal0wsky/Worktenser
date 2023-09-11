// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'projects_cubit.dart';

sealed class ProjectsState extends Equatable {
  const ProjectsState();

  @override
  List<Object> get props => [];
}

final class ProjectsInitial extends ProjectsState {}

class ProjectsLoading extends ProjectsState {}

class ProjectsLoaded extends ProjectsState {
  final List<Project> projects;
  final int projectsCount;
  final int projectsTime;

  const ProjectsLoaded(
      {this.projects = const <Project>[],
      this.projectsCount = 0,
      this.projectsTime = 0});

  @override
  List<Object> get props => [projects, projectsCount, projectsTime];
}

class ProjectsLoadingError extends ProjectsState {
  final String message;

  const ProjectsLoadingError({this.message = 'Something went wrong.'});

  @override
  List<Object> get props => [message];
}

class ProjectsReload extends ProjectsState {}
