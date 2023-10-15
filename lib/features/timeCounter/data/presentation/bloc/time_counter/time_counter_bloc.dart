import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/injection_container.dart';

part 'time_counter_event.dart';
part 'time_counter_state.dart';

class TimeCounterBloc extends Bloc<TimeCounterEvent, TimeCounterState> {
  final SharedPreferences _prefs;
  final ReceivePort _receivePort = sl();

  TimeCounterBloc({required SharedPreferences preferences})
      : _prefs = preferences,
        super(TimeCounterInitial()) {
    on<InitializeTimeCounter>(_onInitializeTimeCounter);
    on<StartTimeCounter>(_onStartTimeCounter);
    on<StopTimeCounter>(_onStopTimeCounter);
    on<UpdateTimeCounterProject>(_onUpdateTimeCounterProject);

    _receivePort.listen((updatedProject) {
      // debugPrint('New project time: ${updatedProject}');
      add(UpdateTimeCounterProject(
          project: ProjectEntity.fromJson(updatedProject)));
    });
  }

  void _onInitializeTimeCounter(
      InitializeTimeCounter event, Emitter<TimeCounterState> emit) async {
    final projectSaved = await _prefs.setString(
        'timeCounterProject', json.encode(event.project.toJson()));

    if (projectSaved) {
      emit(TimeCounterInitialized(project: event.project));
    } else {
      emit(const TimeCounterError(message: "Couldn't set the project"));
    }
  }

  Future<void> _onStartTimeCounter(
      StartTimeCounter event, Emitter<TimeCounterState> emit) async {
    final state = this.state;

    if (state is TimeCounterWorking) return;

    if (state is TimeCounterInitialized) {
      await FlutterBackgroundService().startService();

      emit(TimeCounterWorking(project: state.project!));
    }

    if (state is TimeCounterStopped) {
      final projectSaved = await _prefs.setString(
          'timeCounterProject', json.encode(state.project!.toJson()));

      if (projectSaved) {
        await FlutterBackgroundService().startService();

        emit(TimeCounterWorking(project: state.project!));
      } else {
        emit(const TimeCounterError());
      }
    }
  }

  Future<void> _onStopTimeCounter(
      StopTimeCounter event, Emitter<TimeCounterState> emit) async {
    final state = this.state;

    if (state is TimeCounterStopped || state is TimeCounterInitialized) return;

    if (state is TimeCounterWorking) {
      FlutterBackgroundService().invoke('stopTimeCounter');

      final projectSaved = await _prefs.setString(
          'timeCounterProject', json.encode(state.project!.toJson()));

      if (projectSaved) {
        emit(TimeCounterStopped(project: state.project!));
      } else {
        emit(const TimeCounterError(message: "Couldn't save the project"));
      }
    }

    // update in Firestore
  }

  void _onUpdateTimeCounterProject(
      UpdateTimeCounterProject event, Emitter<TimeCounterState> emit) {
    if (event.project.userId.isNotEmpty) {
      final state = this.state;

      if (state is TimeCounterWorking) {
        emit(TimeCounterWorking(project: event.project));
      }
    }
  }
}
