import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/timeCounter/data/presentation/bloc/time_counter/time_counter_bloc.dart';

part 'project_details_event.dart';
part 'project_details_state.dart';

class ProjectDetailsBloc
    extends Bloc<ProjectDetailsEvent, ProjectDetailsState> {
  final TimeCounterBloc _timeCounterBloc;
  late StreamSubscription _counterSubscription;

  ProjectDetailsBloc({required TimeCounterBloc timeCounterBloc})
      : _timeCounterBloc = timeCounterBloc,
        super(ProjectDetailsLoading()) {
    on<LoadProjectDetails>(_onLoadProjectDetails);
    on<UpdateProjectDetails>(_onUpdateProjectDetails);

    _counterSubscription = _timeCounterBloc.stream.listen((state) {
      final updatedProject = state.project;

      if (updatedProject != null) {
        add(UpdateProjectDetails(project: updatedProject));
      }
    });
  }

  Future<void> _onLoadProjectDetails(
      LoadProjectDetails event, Emitter<ProjectDetailsState> emit) async {
    emit(ProjectDetailsLoaded(project: event.project));
  }

  Future<void> _onUpdateProjectDetails(
      UpdateProjectDetails event, Emitter<ProjectDetailsState> emit) async {
    final state = this.state;

    if (state is ProjectDetailsLoading) return;

    emit(ProjectDetailsLoaded(project: event.project));
  }

  @override
  Future<void> close() async {
    await _counterSubscription.cancel();
    return super.close();
  }
}
