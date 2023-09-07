import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:worktenser/cubits/cubits.dart';

import '../blocs/auth_bloc_test.mocks.dart';

void main() {
  final authRepoMock = MockAuthRepository();
  late LoginCubit cubit;
  const validEmail = 'valid@email.com';
  const invalidEmail = 'invalid@email.com';
  const emptyEmail = '';

  const validPassword = 'password123';
  const invalidPassword = 'invalidPassword';
  const emptyPassword = '';

  setUp(() => cubit = LoginCubit(authRepository: authRepoMock));

  test('Create LoginCubit', () {
    expect(cubit.state, LoginState.initial());
  });

  test('EmailChanged', () {
    const newEmail = 'new@email.com';

    cubit.emailChanged(newEmail);

    expect(cubit.state.email, newEmail);
    expect(cubit.state.status, LoginStatus.initial);
  });

  test('EmailChanged to empty', () {
    cubit.emailChanged(emptyEmail);

    expect(cubit.state.status, LoginStatus.error);
  });

  test('PasswordChanged', () {
    cubit.passwordChanged(validPassword);

    expect(cubit.state.password, validPassword);
    expect(cubit.state.status, LoginStatus.initial);
  });

  test('PasswordChanged to empty', () {
    cubit.passwordChanged(emptyPassword);

    expect(cubit.state.status, LoginStatus.error);
  });

  test('Login with email & password valid', () async {
    when(authRepoMock.logInWithEmailAndPassword(
            email: validEmail, password: validPassword))
        .thenAnswer((realInvocation) async => true);

    cubit.emailChanged(validEmail);
    cubit.passwordChanged(validPassword);

    await cubit.logInWithEmailAndPassword();

    expect(cubit.state.status, LoginStatus.success);
  });

  test('Login with email & password invalid', () async {
    when(authRepoMock.logInWithEmailAndPassword(
            email: invalidEmail, password: invalidPassword))
        .thenAnswer((realInvocation) async => false);

    cubit.emailChanged(invalidEmail);
    cubit.passwordChanged(invalidPassword);

    await cubit.logInWithEmailAndPassword();

    expect(cubit.state.status, LoginStatus.error);
  });

  test('Login with email & password empty input', () async {
    cubit.emailChanged(validEmail);
    cubit.passwordChanged(emptyPassword);

    await cubit.logInWithEmailAndPassword();

    expect(cubit.state.status, LoginStatus.initial);
  });

  test('Login with email & password exception catch', () async {
    when(authRepoMock.logInWithEmailAndPassword(
            email: invalidEmail, password: invalidPassword))
        .thenThrow(Exception());

    cubit.emailChanged(invalidEmail);
    cubit.passwordChanged(invalidPassword);

    await cubit.logInWithEmailAndPassword();

    expect(cubit.state.status, LoginStatus.error);
  });

  test('Signin with Google valid', () async {
    when(authRepoMock.signInWithGoogle())
        .thenAnswer((realInvocation) async => true);

    cubit.emailChanged(validEmail);
    cubit.passwordChanged(validPassword);

    await cubit.signInWithGoogle();

    expect(cubit.state.status, LoginStatus.success);
  });

  test('Signin with Google invalid', () async {
    when(authRepoMock.signInWithGoogle())
        .thenAnswer((realInvocation) async => false);

    cubit.emailChanged(invalidEmail);
    cubit.passwordChanged(invalidPassword);

    await cubit.signInWithGoogle();

    expect(cubit.state.status, LoginStatus.error);
  });

  test('Signin with Google exception catch', () async {
    when(authRepoMock.signInWithGoogle()).thenThrow(Exception());

    cubit.emailChanged(validEmail);
    cubit.passwordChanged(validPassword);

    await cubit.signInWithGoogle();

    expect(cubit.state.status, LoginStatus.error);
  });
}
