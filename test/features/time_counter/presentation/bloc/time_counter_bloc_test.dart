import 'dart:isolate';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worktenser/features/auth/domain/entities/user.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/save_project_on_device.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/start_counter.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/stop_counter.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/update_in_firestore.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/update_local_copy.dart';
import 'package:worktenser/features/timeCounter/presentation/bloc/time_counter/time_counter_bloc.dart';

import 'time_counter_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ReceivePort>(),
  MockSpec<SharedPreferences>(),
  MockSpec<StartProjectTimeCounterUseCase>(),
  MockSpec<StopProjectTimeCounterUseCase>(),
  MockSpec<UpdateLocalCopyUseCase>(),
  MockSpec<UpdateInFirestoreUseCase>(),
  MockSpec<SaveProjectOnDeviceUseCase>(),
])
void main() {
  final receivePortMock = MockReceivePort();
  final sharedPrefsMock = MockSharedPreferences();
  final startUseCaseMock = MockStartProjectTimeCounterUseCase();
  final stopUseCaseMock = MockStopProjectTimeCounterUseCase();
  final updateLocalCopyMock = MockUpdateLocalCopyUseCase();
  final updateInFirestoreMock = MockUpdateInFirestoreUseCase();
  final saveOnDeviceMock = MockSaveProjectOnDeviceUseCase();

  late TimeCounterBloc bloc;

  const fakeUser = UserEntity(
    id: 'veryFakeID',
    name: 'fakeUser',
    email: 'fake@email.com',
    password: 'fakePassword123',
  );

  final fakeProj1 = ProjectEntity(
    id: 'jashkldf',
    name: 'Worktenser',
    userId: fakeUser.id,
    time: 37,
    description: 'Worktenser the app',
  );

  setUp(() => bloc = TimeCounterBloc(
        receivePort: receivePortMock,
        preferences: sharedPrefsMock,
        startUseCase: startUseCaseMock,
        stopUseCase: stopUseCaseMock,
        updateLocalCopyUseCase: updateLocalCopyMock,
        updateInFirestoreUseCase: updateInFirestoreMock,
        saveProjectOnDeviceUseCase: saveOnDeviceMock,
      ));

  test('Create Bloc', () {
    final bloc = TimeCounterBloc(
      receivePort: receivePortMock,
      preferences: sharedPrefsMock,
      startUseCase: startUseCaseMock,
      stopUseCase: stopUseCaseMock,
      updateLocalCopyUseCase: updateLocalCopyMock,
      updateInFirestoreUseCase: updateInFirestoreMock,
      saveProjectOnDeviceUseCase: saveOnDeviceMock,
    );

    expect(bloc.state, TimeCounterInitial());
  });

  blocTest<TimeCounterBloc, TimeCounterState>(
    'Initialize counter test',
    build: () {
      when(saveOnDeviceMock.call(params: fakeProj1))
          .thenAnswer((realInvocation) async => true);

      return bloc;
    },
    act: (bloc) => bloc.add(InitializeTimeCounter(project: fakeProj1)),
    wait: const Duration(milliseconds: 100),
    expect: () => <TimeCounterState>[
      TimeCounterInitialized(project: fakeProj1),
    ],
  );

  blocTest<TimeCounterBloc, TimeCounterState>(
    'Initialize counter invalid test',
    build: () {
      when(saveOnDeviceMock.call(params: fakeProj1))
          .thenAnswer((realInvocation) async => false);

      return bloc;
    },
    act: (bloc) => bloc.add(InitializeTimeCounter(project: fakeProj1)),
    wait: const Duration(milliseconds: 100),
    expect: () => <TimeCounterState>[
      const TimeCounterError(message: "Couldn't set the project"),
    ],
  );

  blocTest<TimeCounterBloc, TimeCounterState>(
    'Start counter test',
    build: () {
      when(startUseCaseMock.call()).thenAnswer((realInvocation) async => true);

      bloc.emit(TimeCounterInitialized(project: fakeProj1));

      return bloc;
    },
    act: (bloc) => bloc.add(StartTimeCounter()),
    wait: const Duration(milliseconds: 100),
    expect: () => <TimeCounterState>[
      TimeCounterWorking(project: fakeProj1),
    ],
  );

  blocTest<TimeCounterBloc, TimeCounterState>(
    'Start counter error test',
    build: () {
      when(startUseCaseMock.call()).thenAnswer((realInvocation) async => false);

      bloc.emit(TimeCounterInitialized(project: fakeProj1));

      return bloc;
    },
    act: (bloc) => bloc.add(StartTimeCounter()),
    wait: const Duration(milliseconds: 100),
    expect: () => <TimeCounterState>[
      const TimeCounterError(message: "Couldn't start the counter."),
    ],
  );

  blocTest<TimeCounterBloc, TimeCounterState>(
    'Start counter already working test',
    build: () {
      when(startUseCaseMock.call()).thenAnswer((realInvocation) async => true);

      bloc.emit(TimeCounterWorking(project: fakeProj1));

      return bloc;
    },
    act: (bloc) => bloc.add(StartTimeCounter()),
    wait: const Duration(milliseconds: 100),
    expect: () => <TimeCounterState>[],
  );

  blocTest<TimeCounterBloc, TimeCounterState>(
    'Start counter from Stopped state test',
    build: () {
      when(startUseCaseMock.call()).thenAnswer((realInvocation) async => true);
      when(saveOnDeviceMock.call(params: fakeProj1))
          .thenAnswer((realInvocation) async => true);

      bloc.emit(TimeCounterStopped(project: fakeProj1));

      return bloc;
    },
    act: (bloc) => bloc.add(StartTimeCounter()),
    wait: const Duration(milliseconds: 100),
    expect: () => <TimeCounterState>[
      TimeCounterWorking(project: fakeProj1),
    ],
  );

  blocTest<TimeCounterBloc, TimeCounterState>(
    'Start counter from Stopped state - invalid test',
    build: () {
      when(startUseCaseMock.call()).thenAnswer((realInvocation) async => true);
      when(saveOnDeviceMock.call(params: fakeProj1))
          .thenAnswer((realInvocation) async => false);

      bloc.emit(TimeCounterStopped(project: fakeProj1));

      return bloc;
    },
    act: (bloc) => bloc.add(StartTimeCounter()),
    wait: const Duration(milliseconds: 100),
    expect: () => <TimeCounterState>[
      const TimeCounterError(),
    ],
  );

  blocTest<TimeCounterBloc, TimeCounterState>(
    'Start counter from Stopped state - saved but not started test',
    build: () {
      when(startUseCaseMock.call()).thenAnswer((realInvocation) async => false);
      when(saveOnDeviceMock.call(params: fakeProj1))
          .thenAnswer((realInvocation) async => true);

      bloc.emit(TimeCounterStopped(project: fakeProj1));

      return bloc;
    },
    act: (bloc) => bloc.add(StartTimeCounter()),
    wait: const Duration(milliseconds: 100),
    expect: () => <TimeCounterState>[
      const TimeCounterError(message: "Couldn't start the counter."),
    ],
  );

  blocTest<TimeCounterBloc, TimeCounterState>(
    'Stop counter - Stopped state test',
    build: () {
      bloc.emit(TimeCounterStopped(project: fakeProj1));

      return bloc;
    },
    act: (bloc) => bloc.add(StopTimeCounter()),
    wait: const Duration(milliseconds: 100),
    expect: () => <TimeCounterState>[],
  );

  blocTest<TimeCounterBloc, TimeCounterState>(
    'Stop counter - Initialized state test',
    build: () {
      bloc.emit(TimeCounterInitialized(project: fakeProj1));

      return bloc;
    },
    act: (bloc) => bloc.add(StopTimeCounter()),
    wait: const Duration(milliseconds: 100),
    expect: () => <TimeCounterState>[],
  );

  blocTest<TimeCounterBloc, TimeCounterState>(
    'Stop counter - Working state invalid test',
    build: () {
      when(stopUseCaseMock.call()).thenAnswer((realInvocation) async => false);

      bloc.emit(TimeCounterWorking(project: fakeProj1));

      return bloc;
    },
    act: (bloc) => bloc.add(StopTimeCounter()),
    wait: const Duration(milliseconds: 100),
    expect: () => <TimeCounterState>[
      const TimeCounterError(message: "Couldn't stop the counter")
    ],
  );

  blocTest<TimeCounterBloc, TimeCounterState>(
    'Stop counter - Working state saved successful test',
    build: () {
      when(stopUseCaseMock.call()).thenAnswer((realInvocation) async => true);
      when(saveOnDeviceMock.call(params: fakeProj1))
          .thenAnswer((realInvocation) async => true);

      bloc.emit(TimeCounterWorking(project: fakeProj1));

      return bloc;
    },
    act: (bloc) => bloc.add(StopTimeCounter()),
    wait: const Duration(milliseconds: 100),
    expect: () => <TimeCounterState>[
      TimeCounterStopped(project: fakeProj1),
    ],
  );

  blocTest<TimeCounterBloc, TimeCounterState>(
    'Stop counter - Working state saved invalid test',
    build: () {
      when(stopUseCaseMock.call()).thenAnswer((realInvocation) async => true);
      when(saveOnDeviceMock.call(params: fakeProj1))
          .thenAnswer((realInvocation) async => false);

      bloc.emit(TimeCounterWorking(project: fakeProj1));

      return bloc;
    },
    act: (bloc) => bloc.add(StopTimeCounter()),
    wait: const Duration(milliseconds: 100),
    expect: () => <TimeCounterState>[
      const TimeCounterError(message: "Couldn't save the project"),
    ],
  );

  blocTest<TimeCounterBloc, TimeCounterState>(
    "Update counter's project test",
    build: () {
      when(updateLocalCopyMock.call(params: fakeProj1))
          .thenAnswer((realInvocation) async => true);

      return bloc;
    },
    act: (bloc) => bloc.add(UpdateTimeCounterProject(project: fakeProj1)),
    wait: const Duration(milliseconds: 100),
    expect: () => <TimeCounterState>[
      TimeCounterWorking(project: fakeProj1),
    ],
  );

  blocTest<TimeCounterBloc, TimeCounterState>(
    "Update counter's project - saving invalid test",
    build: () {
      when(updateLocalCopyMock.call(params: fakeProj1))
          .thenAnswer((realInvocation) async => false);

      return bloc;
    },
    act: (bloc) => bloc.add(UpdateTimeCounterProject(project: fakeProj1)),
    wait: const Duration(milliseconds: 100),
    expect: () => <TimeCounterState>[
      const TimeCounterError(),
    ],
  );
}
