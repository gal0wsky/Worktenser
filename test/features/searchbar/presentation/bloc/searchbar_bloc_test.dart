import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:worktenser/features/auth/domain/entities/user.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/presentation/bloc/projects/projects_bloc.dart';
import 'package:worktenser/features/searchbar/presentation/bloc/searchbar/searchbar_bloc.dart';

import 'searchbar_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ProjectsBloc>()])
void main() {
  final projectsBlocMock = MockProjectsBloc();

  late SearchbarBloc bloc;

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
    id: 'fakeId2',
    name: 'Fake proj 2',
    userId: fakeUser.id,
    time: 0,
    description: 'Fake the app',
  );

  setUp(() => bloc = SearchbarBloc(projectsBloc: projectsBlocMock));

  test('Create SearchbarBloc test', () {
    bloc = SearchbarBloc(projectsBloc: projectsBlocMock);

    expect(bloc.state, SearchbarInitial());
    expect(bloc.state.searchPhrase, '');
    expect(bloc.state.filteredProjects, []);
  });

  blocTest<SearchbarBloc, SearchbarState>(
    'Update search phrase test',
    build: () {
      return bloc;
    },
    act: (bloc) {
      bloc.add(const UpdateSearchPhrase(searchPhrase: 'test'));
    },
    wait: const Duration(milliseconds: 100),
    expect: () => <SearchbarState>[
      const SearchPhraseUpdated(searchPhrase: 'test', filteredProjects: [])
    ],
  );

  blocTest<SearchbarBloc, SearchbarState>(
    'Search for phrase test - ProjectsInitial state',
    build: () {
      provideDummy<ProjectsState>(ProjectsInitial());

      return bloc;
    },
    act: (bloc) {
      bloc.add(SearchForPhrase());
    },
    wait: const Duration(milliseconds: 100),
    expect: () => <SearchbarState>[
      const SearchbarSearchApplied(searchPhrase: '', filteredProjects: [])
    ],
  );

  blocTest<SearchbarBloc, SearchbarState>(
    'Search for phrase test - empty phrase',
    build: () {
      provideDummy<ProjectsState>(
        ProjectsLoaded(
          projects: [fakeProj1, fakeProj2],
          projectsCount: 2,
          projectsTime: 37,
        ),
      );

      return bloc;
    },
    act: (bloc) {
      bloc.add(SearchForPhrase());
    },
    wait: const Duration(milliseconds: 100),
    expect: () => <SearchbarState>[
      SearchbarSearchApplied(
          searchPhrase: '', filteredProjects: [fakeProj1, fakeProj2])
    ],
  );

  blocTest<SearchbarBloc, SearchbarState>(
    'Search for phrase test - successful',
    build: () {
      provideDummy<ProjectsState>(
        ProjectsLoaded(
          projects: [fakeProj1, fakeProj2],
          projectsCount: 2,
          projectsTime: 37,
        ),
      );

      bloc.add(const UpdateSearchPhrase(searchPhrase: 'Work'));

      return bloc;
    },
    act: (bloc) {
      bloc.add(SearchForPhrase());
    },
    wait: const Duration(milliseconds: 100),
    expect: () => <SearchbarState>[
      const SearchPhraseUpdated(searchPhrase: 'Work', filteredProjects: []),
      SearchbarSearchApplied(
          searchPhrase: 'Work', filteredProjects: [fakeProj1])
    ],
  );
}
