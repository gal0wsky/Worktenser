import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:worktenser/cubits/projects/projects_cubit.dart';
import 'package:worktenser/domain/authentication/models/user_model.dart';
import 'package:worktenser/domain/projects/projects.dart';

import 'projects_cubit_test.mocks.dart';

@GenerateNiceMocks(
    [MockSpec<IProjectsRepository>(), MockSpec<IProjectsLocalStorage>()])
void main() {
  late ProjectsCubit cubit;

  final repoMock = MockIProjectsRepository();
  final localStorageMock = MockIProjectsLocalStorage();

  const fakeUser = User(id: '123');

  final fakeProj1 = Project(
    id: 'jashkldf',
    name: 'Worktenser',
    userId: fakeUser.id,
    time: 37,
    description: 'Worktenser the app',
  );

  final fakeProj2 = Project(
    id: 'kaghjsdf',
    name: 'Test project',
    userId: fakeUser.id,
    time: 0,
    description: 'My test project',
  );

  setUp(() => cubit = ProjectsCubit(
      projectsRepository: repoMock, projectsLocalStorage: localStorageMock));

  tearDown(() => cubit.close());

  test('Create cubit', () {
    final projectsCubit = ProjectsCubit(
        projectsRepository: repoMock, projectsLocalStorage: localStorageMock);

    expect(projectsCubit.state, ProjectsInitial());
  });

  test('Load projects valid', () async {
    when(repoMock.loadProjects(fakeUser))
        .thenAnswer((realInvocation) async => [fakeProj1, fakeProj2]);

    when(localStorageMock.save(any)).thenAnswer((realInvocation) async => true);

    await cubit.loadProjects(fakeUser);

    expect(
        cubit.state,
        ProjectsLoaded(
            projects: [fakeProj1, fakeProj2],
            projectsCount: 2,
            projectsTime: 37));
  });

  test('Load projects catch error', () async {
    when(repoMock.loadProjects(fakeUser)).thenThrow(Exception());

    await cubit.loadProjects(fakeUser);

    expect(cubit.state, const ProjectsLoadingError());
  });

  test('Load projects active loading', () async {
    cubit.emit(ProjectsLoading());

    await cubit.loadProjects(fakeUser);

    expect(cubit.state, ProjectsLoading());
  });

  test('Add project valid', () async {
    when(repoMock.addProject(fakeProj1))
        .thenAnswer((realInvocation) async => true);

    when(localStorageMock.save(any)).thenAnswer((realInvocation) async => true);

    await cubit.addProject(fakeProj1);

    expect(cubit.state, ProjectsReload());
  });

  test('Add project catch error', () async {
    when(repoMock.addProject(fakeProj1)).thenThrow(Exception());

    await cubit.addProject(fakeProj1);

    expect(cubit.state,
        const ProjectsLoadingError(message: "Couldn't add the project"));
  });

  test('Add project active loading', () async {
    cubit.emit(ProjectsLoading());

    await cubit.addProject(fakeProj1);

    expect(cubit.state, ProjectsLoading());
  });

  test('Update project valid', () async {
    when(repoMock.updateProject(fakeProj1))
        .thenAnswer((realInvocation) async => true);

    when(localStorageMock.update(any))
        .thenAnswer((realInvocation) async => true);

    await cubit.updateProject(fakeProj1);

    expect(cubit.state, ProjectsReload());
  });

  test('Update project invalid', () async {
    when(repoMock.updateProject(fakeProj1))
        .thenAnswer((realInvocation) async => false);

    when(localStorageMock.update(any))
        .thenAnswer((realInvocation) async => false);

    await cubit.updateProject(fakeProj1);

    expect(cubit.state,
        const ProjectsLoadingError(message: "Couldn't update the project"));
  });

  test('Update project active loading', () async {
    cubit.emit(ProjectsLoading());

    await cubit.updateProject(fakeProj1);

    expect(cubit.state, ProjectsLoading());
  });

  test('Delete project', () async {
    when(repoMock.deleteProject(fakeProj1))
        .thenAnswer((realInvocation) async => true);

    when(localStorageMock.delete(any))
        .thenAnswer((realInvocation) async => true);

    await cubit.deleteProject(fakeProj1);

    expect(cubit.state, ProjectsReload());
  });

  test('Delete project invalid', () async {
    when(repoMock.deleteProject(fakeProj1))
        .thenAnswer((realInvocation) async => false);

    when(localStorageMock.delete(any))
        .thenAnswer((realInvocation) async => false);

    await cubit.deleteProject(fakeProj1);

    expect(cubit.state,
        const ProjectsLoadingError(message: "Couldn't delete the project"));
  });

  test('Delete project active loading', () async {
    cubit.emit(ProjectsLoading());

    await cubit.deleteProject(fakeProj1);

    expect(cubit.state, ProjectsLoading());
  });
}
