part of 'projects_bloc.dart';

sealed class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object> get props => [];
}

final class LoadProjects extends ProjectsEvent {
  final UserEntity user;

  const LoadProjects({required this.user});

  @override
  List<Object> get props => [user];
}

final class AddProject extends ProjectsEvent {
  final ProjectEntity project;

  const AddProject({required this.project});

  @override
  List<Object> get props => [project];
}

final class UpdateProject extends ProjectsEvent {
  final ProjectEntity project;

  const UpdateProject({required this.project});

  @override
  List<Object> get props => [project];
}

final class DeleteProject extends ProjectsEvent {
  final ProjectEntity project;

  const DeleteProject({required this.project});

  @override
  List<Object> get props => [project];
}

final class ReloadProjects extends ProjectsEvent {}
