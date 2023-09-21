import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:worktenser/blocs/auth/auth_bloc.dart';
import 'package:worktenser/domain/authentication/models/user_model.dart';
import 'package:worktenser/domain/authentication/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../projects/cubits/projects_cubit_test.mocks.dart';
import 'auth_bloc_test.mocks.dart';

@GenerateNiceMocks(
    [MockSpec<AuthRepository>(), MockSpec<firebase_auth.FirebaseAuth>()])
void main() {
  final authRepoMock = MockAuthRepository();
  final localStorageMock = MockIProjectsLocalStorage();

  test('Create AuthBloc unauthenticated', () {
    when(authRepoMock.currentUser).thenAnswer((realInvocation) => User.empty);

    final bloc = AuthBloc(
        authRepository: authRepoMock, projectsLocalStorage: localStorageMock);

    expect(bloc.state, const AuthState.unauthenticated());
  });

  test('Create AuthBloc authenticated', () {
    const fakeUser = User(id: '123');

    when(authRepoMock.currentUser).thenAnswer((realInvocation) => fakeUser);

    final bloc = AuthBloc(
        authRepository: authRepoMock, projectsLocalStorage: localStorageMock);

    expect(bloc.state, const AuthState.authenticated(fakeUser));
    expect(bloc.state.user, fakeUser);
  });

  test('AppUserChanged to unauthenticated test', () {
    const fakeUser = User.empty;

    when(authRepoMock.currentUser).thenAnswer((realInvocation) => fakeUser);

    final bloc = AuthBloc(
        authRepository: authRepoMock, projectsLocalStorage: localStorageMock);

    bloc.add(const AppUserChanged(fakeUser));

    expect(bloc.state, const AuthState.unauthenticated());
  });

  test('AppUserChanged to authenticated', () {
    const fakeUser = User(id: '123');

    when(authRepoMock.currentUser).thenAnswer((realInvocation) => fakeUser);

    final bloc = AuthBloc(
        authRepository: authRepoMock, projectsLocalStorage: localStorageMock);

    bloc.add(const AppUserChanged(fakeUser));

    expect(bloc.state, const AuthState.authenticated(fakeUser));
    expect(bloc.state.user, fakeUser);
  });

  // test('AppLogoutRequested test', () {
  //   const fakeUser = User(id: 'id');

  //   when(authRepoMock.currentUser).thenAnswer((realInvocation) => fakeUser);
  //   when(authRepoMock.logOut()).thenAnswer((realInvocation) async => true);
  //   when(authRepoMock.user)
  //       .thenAnswer((realInvocation) => Stream<User>.value(User.empty));

  //   final bloc = AuthBloc(authRepository: authRepoMock, projectsLocalStorage: localStorageMock);

  //   // expect(bloc.state, const AuthState.authenticated(fakeUser));

  //   // when(authRepoMock.user)
  //   // .thenAnswer((realInvocation) => Stream<User>.value(User.empty));

  //   bloc.add(AppLogoutRequested());

  //   // expect(bloc.state.user, User.empty);
  //   expect(bloc.state, const AuthState.unauthenticated());
  // });
}
