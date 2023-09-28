import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:worktenser/domain/projects/projects.dart';
import 'package:worktenser/features/auth/domain/entities/login.dart';
import 'package:worktenser/features/auth/domain/entities/signup.dart';
import 'package:worktenser/features/auth/domain/repository/auth_repository.dart';
import 'package:worktenser/features/auth/domain/usecases/logout.dart';
import 'package:worktenser/features/auth/domain/usecases/signin_with_credentials.dart';
import 'package:worktenser/features/auth/domain/usecases/signin_with_google.dart';
import 'package:worktenser/features/auth/domain/usecases/signup_with_credentials.dart';

import 'auth_usecases_test.mocks.dart';

@GenerateMocks([AuthRepository, IProjectsLocalStorage])
void main() {
  final authRepoMock = MockAuthRepository();
  final storageMock = MockIProjectsLocalStorage();

  test('Signup usecase successful test', () async {
    const fakeSignupData =
        SignupEntity(email: 'fake@email.com', password: 'fakePassword123');

    when(authRepoMock.signupWithEmailAndPassword(
            signupInformation: fakeSignupData))
        .thenAnswer((realInvocation) async => true);

    final SignupWithCredentialsUseCase useCase =
        SignupWithCredentialsUseCase(authRepository: authRepoMock);

    final result = await useCase.call(params: fakeSignupData);

    expect(result, true);
  });

  test('Signup usecase invalid test', () async {
    const fakeSignupData =
        SignupEntity(email: 'fake@email.com', password: 'fakePassword123');

    when(authRepoMock.signupWithEmailAndPassword(
            signupInformation: fakeSignupData))
        .thenAnswer((realInvocation) async => false);

    final SignupWithCredentialsUseCase useCase =
        SignupWithCredentialsUseCase(authRepository: authRepoMock);

    final result = await useCase.call(params: fakeSignupData);

    expect(result, false);
  });

  test('Login successful with email & password test', () async {
    const fakeLoginData =
        LoginEntity(email: 'fake@email.com', password: 'fakePassword123');

    when(authRepoMock.logInWithEmailAndPassword(
            loginInformation: fakeLoginData))
        .thenAnswer((realInvocation) async => true);

    final useCase = SigninWithCredentialsUseCase(authRepository: authRepoMock);

    final result = await useCase.call(params: fakeLoginData);

    expect(result, true);
  });

  test('Login invalid with email & password test', () async {
    const fakeLoginData =
        LoginEntity(email: 'fake@email.com', password: 'fakePassword123');

    when(authRepoMock.logInWithEmailAndPassword(
            loginInformation: fakeLoginData))
        .thenAnswer((realInvocation) async => false);

    final useCase = SigninWithCredentialsUseCase(authRepository: authRepoMock);

    final result = await useCase.call(params: fakeLoginData);

    expect(result, false);
  });

  test('Login successful with Google account', () async {
    when(authRepoMock.signInWithGoogle())
        .thenAnswer((realInvocation) async => true);

    final useCase = SigninWithGoogleUseCase(authRepository: authRepoMock);

    final result = await useCase.call();

    expect(result, true);
  });

  test('Login invalid with Google account', () async {
    when(authRepoMock.signInWithGoogle())
        .thenAnswer((realInvocation) async => false);

    final useCase = SigninWithGoogleUseCase(authRepository: authRepoMock);

    final result = await useCase.call();

    expect(result, false);
  });

  test('Logout usecase successful test', () async {
    when(authRepoMock.logOut()).thenAnswer((realInvocation) async => true);
    when(storageMock.clear()).thenAnswer((realInvocation) async => true);

    final LogoutUseCase useCase = LogoutUseCase(
        authRepository: authRepoMock, projectsLocalStorage: storageMock);

    final result = await useCase.call();

    expect(result, true);
  });

  test('Logout usecase invalid storage clear test', () async {
    when(authRepoMock.logOut()).thenAnswer((realInvocation) async => true);
    when(storageMock.clear()).thenAnswer((realInvocation) async => false);

    final LogoutUseCase useCase = LogoutUseCase(
        authRepository: authRepoMock, projectsLocalStorage: storageMock);

    final result = await useCase.call();

    expect(result, false);
  });

  test('Logout usecase invalid Firebase logout test', () async {
    when(authRepoMock.logOut()).thenAnswer((realInvocation) async => false);
    when(storageMock.clear()).thenAnswer((realInvocation) async => true);

    final LogoutUseCase useCase = LogoutUseCase(
        authRepository: authRepoMock, projectsLocalStorage: storageMock);

    final result = await useCase.call();

    expect(result, false);
  });
}
