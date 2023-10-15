part of 'project_details_bloc.dart';

sealed class ProjectDetailsEvent extends Equatable {
  const ProjectDetailsEvent();

  @override
  List<Object> get props => [];
}

final class LoadProjectDetails extends ProjectDetailsEvent {
  final ProjectEntity project;

  const LoadProjectDetails({required this.project});

  @override
  List<Object> get props => [project];
}

final class UpdateProjectDetails extends ProjectDetailsEvent {
  final ProjectEntity project;

  const UpdateProjectDetails({required this.project});

  @override
  List<Object> get props => [project];
}
