import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:worktenser/features/projects/data/data_sources/local/projects_local_storage.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/domain/repository/projects_repository.dart';
import 'package:worktenser/features/timeCounter/domain/repository/time_counter_repository.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/save_project_on_device.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/start_counter.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/stop_counter.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/update_in_firestore.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/update_local_copy.dart';

import 'time_counter_usecases_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ProjectsRepository>(),
  MockSpec<TimeCounterRepository>(),
  MockSpec<ProjectsLocalStorage>(),
])
void main() {
  final projectsRepoMock = MockProjectsRepository();
  final counterRepoMock = MockTimeCounterRepository();
  final localStorageMock = MockProjectsLocalStorage();

  const fakeProj =
      ProjectEntity(id: 'fakeID', name: 'fakeProj1', userId: 'fakeUserID');

  test('Start counter test', () async {
    when(counterRepoMock.start()).thenAnswer((realInvocation) async => true);

    final useCase =
        StartProjectTimeCounterUseCase(counterRepository: counterRepoMock);

    final result = await useCase.call();

    expect(result, true);
  });

  test('Start counter error test', () async {
    when(counterRepoMock.start()).thenAnswer((realInvocation) async => false);

    final useCase =
        StartProjectTimeCounterUseCase(counterRepository: counterRepoMock);

    final result = await useCase.call();

    expect(result, false);
  });

  test('Stop counter test', () async {
    when(counterRepoMock.isWorking).thenAnswer((realInvocation) async => false);

    final useCase =
        StopProjectTimeCounterUseCase(counterRepository: counterRepoMock);

    final result = await useCase.call();

    expect(result, true);
  });

  test('Stop counter invalid test', () async {
    when(counterRepoMock.isWorking).thenAnswer((realInvocation) async => true);

    final useCase =
        StopProjectTimeCounterUseCase(counterRepository: counterRepoMock);

    final result = await useCase.call();

    expect(result, false);
  });

  test('Save on device usecase test', () async {
    when(counterRepoMock.saveProjectOnDevice(fakeProj))
        .thenAnswer((realInvocation) async => true);

    final useCase =
        SaveProjectOnDeviceUseCase(counterRepository: counterRepoMock);

    final result = await useCase.call(params: fakeProj);

    expect(result, true);
  });

  test('Save on device usecase invalid test', () async {
    when(counterRepoMock.saveProjectOnDevice(fakeProj))
        .thenAnswer((realInvocation) async => false);

    final useCase =
        SaveProjectOnDeviceUseCase(counterRepository: counterRepoMock);

    final result = await useCase.call(params: fakeProj);

    expect(result, false);
  });

  test('Update local copy usecase test', () async {
    when(localStorageMock.update(fakeProj))
        .thenAnswer((realInvocation) async => true);

    final useCase =
        UpdateLocalCopyUseCase(projectsLocalStorage: localStorageMock);

    final result = await useCase.call(params: fakeProj);

    expect(result, true);
  });

  test('Update local copy usecase invalid test', () async {
    when(localStorageMock.update(any))
        .thenAnswer((realInvocation) async => false);

    final useCase =
        UpdateLocalCopyUseCase(projectsLocalStorage: localStorageMock);

    final result = await useCase.call(params: fakeProj);

    expect(result, false);
  });

  test('Update in Firestore usecase test', () async {
    when(projectsRepoMock.updateProject(fakeProj))
        .thenAnswer((realInvocation) async => true);

    final useCase =
        UpdateInFirestoreUseCase(projectsRepository: projectsRepoMock);

    final result = await useCase.call(params: fakeProj);

    expect(result, true);
  });

  test('Update in Firestore usecase invalid test', () async {
    when(projectsRepoMock.updateProject(any))
        .thenAnswer((realInvocation) async => false);

    final useCase =
        UpdateInFirestoreUseCase(projectsRepository: projectsRepoMock);

    final result = await useCase.call(params: fakeProj);

    expect(result, false);
  });
}
