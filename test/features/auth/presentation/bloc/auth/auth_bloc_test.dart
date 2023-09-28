import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:worktenser/features/auth/domain/entities/user.dart';
import 'package:worktenser/features/auth/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:worktenser/features/auth/domain/usecases/logout.dart';
import 'package:worktenser/features/auth/presentation/bloc/auth/auth_bloc.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthRepository>(),
  MockSpec<firebase_auth.FirebaseAuth>(),
  MockSpec<LogoutUseCase>()
])
void main() {
  final authRepoMock = MockAuthRepository();
  final logoutUseCaseMock = MockLogoutUseCase();

  test('Create AuthBloc unauthenticated', () {
    when(authRepoMock.currentUser)
        .thenAnswer((realInvocation) => UserEntity.empty);

    final bloc = AuthBloc(
        authRepository: authRepoMock, logoutUseCase: logoutUseCaseMock);

    expect(bloc.state, const AuthState.unauthenticated());
  });

  test('Create AuthBloc authenticated', () {
    const fakeUser = UserEntity(id: '123');

    when(authRepoMock.currentUser).thenAnswer((realInvocation) => fakeUser);

    final bloc = AuthBloc(
        authRepository: authRepoMock, logoutUseCase: logoutUseCaseMock);

    expect(bloc.state, const AuthState.authenticated(fakeUser));
    expect(bloc.state.user, fakeUser);
  });

  test('AppUserChanged to unauthenticated test', () {
    const fakeUser = UserEntity.empty;

    when(authRepoMock.currentUser).thenAnswer((realInvocation) => fakeUser);

    final bloc = AuthBloc(
        authRepository: authRepoMock, logoutUseCase: logoutUseCaseMock);

    bloc.add(const AppUserChanged(fakeUser));

    expect(bloc.state, const AuthState.unauthenticated());
  });

  test('AppUserChanged to authenticated', () {
    const fakeUser = UserEntity(id: '123');

    when(authRepoMock.currentUser).thenAnswer((realInvocation) => fakeUser);

    final bloc = AuthBloc(
        authRepository: authRepoMock, logoutUseCase: logoutUseCaseMock);

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
