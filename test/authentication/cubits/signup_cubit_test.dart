import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:worktenser/cubits/cubits.dart';

import '../blocs/auth_bloc_test.mocks.dart';

void main() {
  final authRepoMock = MockAuthRepository();
  late SignupCubit cubit;

  const validName = 'testUser';

  const validEmail = 'valid@email.com';
  const invalidEmail = 'invalid@email.com';

  const validPassword = 'password123';

  setUp(() => cubit = SignupCubit(authRepoMock));

  test('Create SigninCubit', () {
    final signupCubit = SignupCubit(authRepoMock);

    expect(signupCubit.state, SignupState.initial());
  });

  test('NameChanged valid', () {
    cubit.nameChanged(validName);

    expect(cubit.state.name, validName);
    expect(cubit.state.status, SignupStatus.initial);
  });

  test('EmailChanged valid', () {
    cubit.emailChanged(validEmail);

    expect(cubit.state.email, validEmail);
    expect(cubit.state.status, SignupStatus.initial);
  });

  test('PasswordChanged valid', () {
    cubit.passwordChanged(validPassword);

    expect(cubit.state.password, validPassword);
    expect(cubit.state.status, SignupStatus.initial);
  });

  test('Signup valid', () async {
    when(authRepoMock.signupWithEmailAndPassword(
            email: validEmail, password: validPassword))
        .thenAnswer((realInvocation) async => true);

    cubit.nameChanged(validName);
    cubit.emailChanged(validEmail);
    cubit.passwordChanged(validPassword);

    await cubit.signUpWithEmailAndPassword();

    expect(cubit.state.status, SignupStatus.success);
  });

  test('Signup invalid', () async {
    when(authRepoMock.signupWithEmailAndPassword(
            email: invalidEmail, password: validPassword))
        .thenAnswer((realInvocation) async => false);

    cubit.nameChanged(validName);
    cubit.emailChanged(invalidEmail);
    cubit.passwordChanged(validPassword);

    await cubit.signUpWithEmailAndPassword();

    expect(cubit.state.status, SignupStatus.error);
  });

  test('Signup exception catch', () async {
    when(authRepoMock.signupWithEmailAndPassword(
            email: validEmail, password: validPassword))
        .thenThrow(Exception());

    cubit.nameChanged(validName);
    cubit.emailChanged(validEmail);
    cubit.passwordChanged(validPassword);

    await cubit.signUpWithEmailAndPassword();

    expect(cubit.state.status, SignupStatus.error);
  });
}
