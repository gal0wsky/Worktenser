import 'dart:async';
import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/save_project_on_device.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/start_counter.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/stop_counter.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/update_in_firestore.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/update_local_copy.dart';

part 'time_counter_event.dart';
part 'time_counter_state.dart';

class TimeCounterBloc extends Bloc<TimeCounterEvent, TimeCounterState> {
  final ReceivePort _receivePort;
  final StartProjectTimeCounterUseCase _startUseCase;
  final StopProjectTimeCounterUseCase _stopUseCase;
  final UpdateLocalCopyUseCase _updateLocalCopyUseCase;
  final UpdateInFirestoreUseCase _updateInFirestoreUseCase;
  final SaveProjectOnDeviceUseCase _saveProjectOnDeviceUseCase;

  TimeCounterBloc({
    required ReceivePort receivePort,
    required SharedPreferences preferences,
    required StartProjectTimeCounterUseCase startUseCase,
    required StopProjectTimeCounterUseCase stopUseCase,
    required UpdateLocalCopyUseCase updateLocalCopyUseCase,
    required UpdateInFirestoreUseCase updateInFirestoreUseCase,
    required SaveProjectOnDeviceUseCase saveProjectOnDeviceUseCase,
  })  : _receivePort = receivePort,
        _startUseCase = startUseCase,
        _stopUseCase = stopUseCase,
        _updateLocalCopyUseCase = updateLocalCopyUseCase,
        _updateInFirestoreUseCase = updateInFirestoreUseCase,
        _saveProjectOnDeviceUseCase = saveProjectOnDeviceUseCase,
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
    final projectSaved =
        await _saveProjectOnDeviceUseCase.call(params: event.project);

    if (!projectSaved) {
      emit(const TimeCounterError(message: "Couldn't set the project"));
    } else {
      emit(TimeCounterInitialized(project: event.project));
    }
  }

  Future<void> _onStartTimeCounter(
      StartTimeCounter event, Emitter<TimeCounterState> emit) async {
    final state = this.state;

    if (state is TimeCounterWorking) return;

    if (state is TimeCounterInitialized) {
      final counterStarted = await _startUseCase.call();

      if (!counterStarted) {
        emit(const TimeCounterError(message: "Couldn't start the counter."));
      } else {
        emit(TimeCounterWorking(project: state.project!));
      }
    }

    if (state is TimeCounterStopped) {
      final projectSaved =
          await _saveProjectOnDeviceUseCase.call(params: state.project!);

      if (projectSaved) {
        final counterStarted = await _startUseCase.call();

        if (!counterStarted) {
          emit(const TimeCounterError(message: "Couldn't start the counter."));
        } else {
          emit(TimeCounterWorking(project: state.project!));
        }
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
      final counterStopped = await _stopUseCase.call();

      if (!counterStopped) {
        emit(const TimeCounterError(message: "Couldn't stop the counter"));
      } else {
        final projectSaved =
            await _saveProjectOnDeviceUseCase.call(params: state.project!);

        if (!projectSaved) {
          emit(const TimeCounterError(message: "Couldn't save the project"));
        } else {
          emit(TimeCounterStopped(project: state.project!));
          _updateInFirestoreUseCase.call(params: state.project!);
        }
      }
    }
  }

  Future<void> _onUpdateTimeCounterProject(
      UpdateTimeCounterProject event, Emitter<TimeCounterState> emit) async {
    if (event.project.userId.isNotEmpty) {
      final updatedLocally =
          await _updateLocalCopyUseCase.call(params: event.project);

      if (!updatedLocally) {
        emit(const TimeCounterError());
      } else {
        emit(TimeCounterWorking(project: event.project));
      }
    }
  }
}
