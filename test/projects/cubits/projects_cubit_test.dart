import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:worktenser/cubits/projects/projects_cubit.dart';
import 'package:worktenser/domain/authentication/models/user_model.dart';
import 'package:worktenser/domain/projects/models/project_model.dart';
import 'package:worktenser/domain/projects/repositories/projects_repository.dart';

import 'projects_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ProjectsRepository>()])
void main() {
  late ProjectsCubit cubit;

  final repoMock = MockProjectsRepository();

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

  setUp(() => cubit = ProjectsCubit(projectsRepository: repoMock));

  test('Create cubit', () {
    final projectsCubit = ProjectsCubit(projectsRepository: repoMock);

    expect(projectsCubit.state, ProjectsState.initial());
  });

  test('Load projects valid', () async {
    when(repoMock.loadProjects(fakeUser))
        .thenAnswer((realInvocation) async => [fakeProj1, fakeProj2]);

    await cubit.loadProjects(fakeUser);

    expect(cubit.state.status, ProjectsStatus.success);
    expect(cubit.state.projects, isNotEmpty);
    expect(cubit.state.projects.length, 2);
  });

  test('Load projects catch error', () async {
    when(repoMock.loadProjects(fakeUser)).thenThrow(Exception());

    await cubit.loadProjects(fakeUser);

    expect(cubit.state.status, ProjectsStatus.error);
  });
}
