import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:worktenser/features/auth/domain/entities/user.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/domain/repository/projects_repository.dart';
import 'package:worktenser/features/projects/domain/usecases/add_project.dart';
import 'package:worktenser/features/projects/domain/usecases/delete_project.dart';
import 'package:worktenser/features/projects/domain/usecases/get_projects_total_time.dart';
import 'package:worktenser/features/projects/domain/usecases/load_projects.dart';
import 'package:worktenser/features/projects/domain/usecases/update_project.dart';

import 'projects_usecases_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ProjectsRepository>()])
void main() {
  final repoMock = MockProjectsRepository();

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

  final fakeProj2 = ProjectEntity(
    id: 'kaghjsdf',
    name: 'Test project',
    userId: fakeUser.id,
    time: 0,
    description: 'My test project',
  );

  test('Load projects', () async {
    when(repoMock.loadProjects(fakeUser))
        .thenAnswer((realInvocation) async => [fakeProj1, fakeProj2]);

    final useCase = LoadProjectsUsecase(projectsRepository: repoMock);

    final projects = await useCase.call(params: fakeUser);

    expect(projects, [fakeProj1, fakeProj2]);
  });

  test('Load projects empty list', () async {
    when(repoMock.loadProjects(fakeUser))
        .thenAnswer((realInvocation) async => []);

    final useCase = LoadProjectsUsecase(projectsRepository: repoMock);

    final projects = await useCase.call(params: fakeUser);

    expect(projects, []);
  });

  test('Add project', () async {
    when(repoMock.addProject(fakeProj1))
        .thenAnswer((realInvocation) async => true);

    final useCase = AddProjectUseCase(projectsRepository: repoMock);

    final result = await useCase.call(params: fakeProj1);

    expect(result, true);
  });

  test('Add project invalid', () async {
    when(repoMock.addProject(fakeProj1))
        .thenAnswer((realInvocation) async => false);

    final useCase = AddProjectUseCase(projectsRepository: repoMock);

    final result = await useCase.call(params: fakeProj1);

    expect(result, false);
  });

  test('Update project', () async {
    when(repoMock.updateProject(fakeProj1))
        .thenAnswer((realInvocation) async => true);

    final useCase = UpdateProjectUseCase(projectsRepository: repoMock);

    final result = await useCase.call(params: fakeProj1);

    expect(result, true);
  });

  test('Update project invalid', () async {
    when(repoMock.updateProject(fakeProj1))
        .thenAnswer((realInvocation) async => false);

    final useCase = UpdateProjectUseCase(projectsRepository: repoMock);

    final result = await useCase.call(params: fakeProj1);

    expect(result, false);
  });

  test('Delete project', () async {
    when(repoMock.deleteProject(fakeProj1))
        .thenAnswer((realInvocation) async => true);

    final useCase = DeleteProjectUseCase(projectsRepository: repoMock);

    final result = await useCase.call(params: fakeProj1);

    expect(result, true);
  });

  test('Delete project invalid', () async {
    when(repoMock.deleteProject(fakeProj1))
        .thenAnswer((realInvocation) async => false);

    final useCase = DeleteProjectUseCase(projectsRepository: repoMock);

    final result = await useCase.call(params: fakeProj1);

    expect(result, false);
  });

  test('Get projects total time', () async {
    when(repoMock.getProjectsTotalTime([fakeProj1, fakeProj2]))
        .thenAnswer((realInvocation) => 37);

    final useCase = GetProjectsTotalTimeUseCase(projectsRepository: repoMock);

    final result = await useCase.call(params: [fakeProj1, fakeProj2]);

    expect(result, 37);
  });
}
