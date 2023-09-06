// part of 'projects_bloc.dart';

// enum ProjectsStatus { initial, loading, success, error }

// sealed class ProjectsState extends Equatable {
//   const ProjectsState();

//   @override
//   List<Object> get props => [];
// }

// final class ProjectsLoading extends ProjectsState {}

// final class ProjectsLoaded extends ProjectsState {
//   final List<Project> projects;
//   final int projectsCount;
//   final int projectsTime;
//   final ProjectsStatus status;

//   const ProjectsLoaded({
//     required this.projects,
//     required this.projectsCount,
//     required this.projectsTime,
//     required this.status,
//   });

//   @override
//   List<Object> get props => [projects, projectsCount, projectsCount];
// }
