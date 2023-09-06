// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:worktenser/domain/projects/models/project_model.dart';
// import 'package:worktenser/domain/projects/repositories/projects_repository.dart';

// part 'projects_event.dart';
// part 'projects_state.dart';

// class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
//   final ProjectsRepository _projectsRepository;

//   ProjectsBloc({required ProjectsRepository projectsRepository})
//       : _projectsRepository = projectsRepository,
//         super(ProjectsLoading()) {
//     on<LoadProjects>(_onLoadProjects);
//     // on<UpdateProjects>(_onUpdateProjects);
//     on<AddProject>(_onAddProject);
//     on<EditProject>(_onEditProject);
//     on<DeleteProject>(_onDeleteProject);
//   }

//   void _onLoadProjects(LoadProjects event, Emitter<ProjectsState> emit) {}

//   // void _onUpdateProjects(UpdateProjects event, Emitter<ProjectsState> emit) {}

//   void _onAddProject(AddProject event, Emitter<ProjectsState> emit) {}

//   void _onEditProject(EditProject event, Emitter<ProjectsState> emit) {}

//   void _onDeleteProject(DeleteProject event, Emitter<ProjectsState> emit) {}
// }
