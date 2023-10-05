import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/timeCounter/data/data_sources/counter_service_provider.dart';

part 'time_counter_event.dart';
part 'time_counter_state.dart';

class TimeCounterBloc extends Bloc<TimeCounterEvent, TimeCounterState> {
  TimeCounterBloc() : super(TimeCounterInitial()) {
    on<InitializeTimeCounter>(_onInitializeTimeCounter);
    on<StartTimeCounter>(_onStartTimeCounter);
    on<StopTimeCounter>(_onStopTimeCounter);
  }

  void _onInitializeTimeCounter(
      InitializeTimeCounter event, Emitter<TimeCounterState> emit) async {
    // FlutterBackgroundService().invoke('setProject', event.project.toJson());
    currentProject = event.project;

    emit(TimeCounterInitialized(project: event.project));
  }

  Future<void> _onStartTimeCounter(
      StartTimeCounter event, Emitter<TimeCounterState> emit) async {
    final state = this.state;

    if (state is TimeCounterWorking) return;

    if (state is TimeCounterInitialized) {
      await FlutterBackgroundService().startService();

      emit(TimeCounterWorking(project: state.project));
    }

    if (state is TimeCounterStopped) {
      await FlutterBackgroundService().startService();

      emit(TimeCounterWorking(project: state.project));
    }
  }

  void _onStopTimeCounter(
      StopTimeCounter event, Emitter<TimeCounterState> emit) async {
    final state = this.state;

    if (state is TimeCounterStopped || state is TimeCounterInitialized) return;

    if (state is TimeCounterWorking) {
      final project = state.project;
      FlutterBackgroundService().invoke('stopTimeCounter');

      emit(TimeCounterStopped(project: currentProject));
    }

    // update in Firestore
  }
}
