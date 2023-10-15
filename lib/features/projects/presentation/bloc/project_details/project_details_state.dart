part of 'project_details_bloc.dart';

sealed class ProjectDetailsState extends Equatable {
  const ProjectDetailsState();

  @override
  List<Object> get props => [];
}

final class ProjectDetailsLoading extends ProjectDetailsState {}

final class ProjectDetailsLoaded extends ProjectDetailsState {
  final ProjectEntity project;

  const ProjectDetailsLoaded({required this.project});

  @override
  List<Object> get props => [project];
}

final class ProjectDetailsError extends ProjectDetailsState {
  final String message;

  const ProjectDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}
