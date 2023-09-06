// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'projects_cubit.dart';

enum ProjectsStatus { initial, loading, success, error, reload }

class ProjectsState extends Equatable {
  final List<Project> projects;
  final int projectsCount;
  final int projectsTime;
  final ProjectsStatus status;

  const ProjectsState({
    required this.projects,
    required this.projectsCount,
    required this.projectsTime,
    required this.status,
  });

  factory ProjectsState.initial() {
    return const ProjectsState(
      projects: [],
      projectsCount: 0,
      projectsTime: 0,
      status: ProjectsStatus.initial,
    );
  }

  @override
  List<Object> get props => [projects, projectsCount, projectsCount];

  ProjectsState copyWith({
    List<Project>? projects,
    int? projectsCount,
    int? projectsTime,
    ProjectsStatus status = ProjectsStatus.initial,
  }) {
    return ProjectsState(
      projects: projects ?? this.projects,
      projectsCount: projectsCount ?? this.projectsCount,
      projectsTime: projectsTime ?? this.projectsTime,
      status: status,
    );
  }
}
