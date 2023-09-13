import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:worktenser/domain/projects/projects.dart';
import 'package:worktenser/domain/timeCounter/src/itime_counter_manager.dart';

part 'time_counter_event.dart';
part 'time_counter_state.dart';

class TimeCounterBloc extends Bloc<TimeCounterEvent, TimeCounterState> {
  final ITimeCounterManager _counterManager;

  TimeCounterBloc({required ITimeCounterManager counterManager})
      : _counterManager = counterManager,
        super(TimeCounterInitial()) {
    on<StartTimeCounter>(_onStartCounter);
    on<StopTimeCounter>(_onStopCounter);
    on<ChangeCounterProject>(_onChangeProject);
  }

  FutureOr<void> _onStartCounter(
      StartTimeCounter event, Emitter<TimeCounterState> emit) {
    final state = this.state;

    if (state is TimeCounterLoaded) {}
  }

  FutureOr<void> _onStopCounter(
      StopTimeCounter event, Emitter<TimeCounterState> emit) {}

  FutureOr<void> _onChangeProject(
      ChangeCounterProject event, Emitter<TimeCounterState> emit) {}
}
