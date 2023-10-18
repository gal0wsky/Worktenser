import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:worktenser/features/auth/domain/entities/user.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/domain/usecases/add_project.dart';
import 'package:worktenser/features/projects/domain/usecases/delete_project.dart';
import 'package:worktenser/features/projects/domain/usecases/get_projects_total_time.dart';
import 'package:worktenser/features/projects/domain/usecases/load_local_copy.dart';
import 'package:worktenser/features/projects/domain/usecases/load_projects.dart';
import 'package:worktenser/features/projects/domain/usecases/update_project.dart';
import 'package:worktenser/features/projects/presentation/bloc/projects/projects_bloc.dart';
import 'package:worktenser/features/timeCounter/presentation/bloc/time_counter/time_counter_bloc.dart';

import 'projects_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LoadProjectsUsecase>(),
  MockSpec<AddProjectUseCase>(),
  MockSpec<UpdateProjectUseCase>(),
  MockSpec<DeleteProjectUseCase>(),
  MockSpec<GetProjectsTotalTimeUseCase>(),
  MockSpec<LoadLocalCopyUseCase>(),
  MockSpec<TimeCounterBloc>(),
])
void main() {
  final loadUseCaseMock = MockLoadProjectsUsecase();
  final addUseCaseMock = MockAddProjectUseCase();
  final updateUseCaseMock = MockUpdateProjectUseCase();
  final deleteUseCaseMock = MockDeleteProjectUseCase();
  final getTotalTimeUseCaseMock = MockGetProjectsTotalTimeUseCase();
  final loadLocalCopyUseCaseMock = MockLoadLocalCopyUseCase();
  final timeCounterMock = MockTimeCounterBloc();

  late ProjectsBloc bloc;

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

  setUp(() => bloc = ProjectsBloc(
        loadProjectsUsecase: loadUseCaseMock,
        addProjectUseCase: addUseCaseMock,
        updateProjectUseCase: updateUseCaseMock,
        deleteProjectUseCase: deleteUseCaseMock,
        getProjectsTotalTimeUseCase: getTotalTimeUseCaseMock,
        loadLocalCopyUseCase: loadLocalCopyUseCaseMock,
        timeCounterBloc: timeCounterMock,
      ));

  test('Create bloc', () {
    final projectsBloc = ProjectsBloc(
      loadProjectsUsecase: loadUseCaseMock,
      addProjectUseCase: addUseCaseMock,
      updateProjectUseCase: updateUseCaseMock,
      deleteProjectUseCase: deleteUseCaseMock,
      getProjectsTotalTimeUseCase: getTotalTimeUseCaseMock,
      loadLocalCopyUseCase: loadLocalCopyUseCaseMock,
      timeCounterBloc: timeCounterMock,
    );

    expect(projectsBloc.state, ProjectsInitial());
  });

  blocTest<ProjectsBloc, ProjectsState>(
    'Load projects',
    build: () {
      when(loadUseCaseMock.call(params: fakeUser))
          .thenAnswer((realInvocation) async => [fakeProj1, fakeProj2]);

      when(getTotalTimeUseCaseMock.call(params: [fakeProj1, fakeProj2]))
          .thenAnswer((realInvocation) async => 37);

      return bloc;
    },
    act: (bloc) => bloc.add(const LoadProjects(user: fakeUser)),
    wait: const Duration(milliseconds: 100),
    expect: () => <ProjectsState>[
      ProjectsLoading(),
      ProjectsLoaded(
          projects: [fakeProj1, fakeProj2], projectsCount: 2, projectsTime: 37)
    ],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'Load empty list of projects',
    build: () {
      when(loadUseCaseMock.call(params: fakeUser))
          .thenAnswer((realInvocation) async => []);

      return bloc;
    },
    act: (bloc) => bloc.add(const LoadProjects(user: fakeUser)),
    wait: const Duration(milliseconds: 100),
    expect: () => <ProjectsState>[
      ProjectsLoading(),
      const ProjectsLoaded(projects: [], projectsCount: 0, projectsTime: 0)
    ],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'Add project',
    build: () {
      when(addUseCaseMock.call(params: fakeProj1))
          .thenAnswer((realInvocation) async => true);

      when(getTotalTimeUseCaseMock.call(params: [fakeProj1]))
          .thenAnswer((realInvocation) async => 37);

      return bloc;
    },
    act: (bloc) => bloc.add(AddProject(project: fakeProj1)),
    wait: const Duration(milliseconds: 100),
    expect: () => <ProjectsState>[ProjectsLoading(), ProjectsReloading()],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'Add project error',
    build: () {
      when(addUseCaseMock.call(params: fakeProj1))
          .thenAnswer((realInvocation) async => false);

      return bloc;
    },
    act: (bloc) => bloc.add(AddProject(project: fakeProj1)),
    wait: const Duration(milliseconds: 100),
    expect: () => <ProjectsState>[
      ProjectsLoading(),
      const ProjectsError(message: "Couldn't add the project")
    ],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'Update project',
    build: () {
      when(updateUseCaseMock.call(params: fakeProj1))
          .thenAnswer((realInvocation) async => true);

      return bloc;
    },
    act: (bloc) => bloc.add(UpdateProject(project: fakeProj1)),
    wait: const Duration(milliseconds: 100),
    expect: () => <ProjectsState>[ProjectsLoading(), ProjectsReloading()],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'Update project error',
    build: () {
      when(updateUseCaseMock.call(params: fakeProj1))
          .thenAnswer((realInvocation) async => false);

      return bloc;
    },
    act: (bloc) => bloc.add(UpdateProject(project: fakeProj1)),
    wait: const Duration(milliseconds: 100),
    expect: () => <ProjectsState>[
      ProjectsLoading(),
      const ProjectsError(message: "Couldn't update the project")
    ],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'Delete project',
    build: () {
      when(deleteUseCaseMock.call(params: fakeProj1))
          .thenAnswer((realInvocation) async => true);

      return bloc;
    },
    act: (bloc) => bloc.add(DeleteProject(project: fakeProj1)),
    wait: const Duration(milliseconds: 100),
    expect: () => <ProjectsState>[ProjectsLoading(), ProjectsReloading()],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'Delete project error',
    build: () {
      when(deleteUseCaseMock.call(params: fakeProj1))
          .thenAnswer((realInvocation) async => false);

      return bloc;
    },
    act: (bloc) => bloc.add(DeleteProject(project: fakeProj1)),
    wait: const Duration(milliseconds: 100),
    expect: () => <ProjectsState>[
      ProjectsLoading(),
      const ProjectsError(message: "Couldn't delete the project")
    ],
  );
}
