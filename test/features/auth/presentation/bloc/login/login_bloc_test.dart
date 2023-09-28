import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:worktenser/features/auth/domain/entities/login.dart';
import 'package:worktenser/features/auth/domain/usecases/signin_with_credentials.dart';
import 'package:worktenser/features/auth/domain/usecases/signin_with_google.dart';
import 'package:worktenser/features/auth/presentation/bloc/login/login_bloc.dart';

import 'login_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SigninWithCredentialsUseCase>(),
  MockSpec<SigninWithGoogleUseCase>()
])
void main() {
  final signWithCredentialsUseCaseMock = MockSigninWithCredentialsUseCase();
  final signWithGoogleUseCaseMock = MockSigninWithGoogleUseCase();

  late LoginBloc bloc;

  setUp(() => bloc = LoginBloc(
      signinWithCredentialsUseCase: signWithCredentialsUseCaseMock,
      signinWithGoogleUseCase: signWithGoogleUseCaseMock));

  test('Create LoginBloc', () {
    expect(bloc.state, LoginInitial());
  });

  blocTest<LoginBloc, LoginState>(
    'Login with email & password valid',
    build: () {
      const fakeLoginData =
          LoginEntity(email: 'fake@email.com', password: 'fakePassword123');

      when(signWithCredentialsUseCaseMock.call(params: fakeLoginData))
          .thenAnswer((realInvocation) async => true);

      return bloc;
    },
    act: (bloc) => bloc.add(const CredentialsLoginRequested(
        loginData:
            LoginEntity(email: 'fake@email.com', password: 'fakePassword123'))),
    wait: const Duration(milliseconds: 100),
    expect: () => <LoginState>[LoginSubmitting(), LoginSuccessful()],
  );

  blocTest<LoginBloc, LoginState>(
    'Login with email & password invalid',
    build: () {
      const fakeLoginData =
          LoginEntity(email: 'fake@email.com', password: 'fakePassword123');

      when(signWithCredentialsUseCaseMock.call(params: fakeLoginData))
          .thenAnswer((realInvocation) async => false);

      return bloc;
    },
    act: (bloc) => bloc.add(const CredentialsLoginRequested(
        loginData:
            LoginEntity(email: 'fake@email.com', password: 'fakePassword123'))),
    wait: const Duration(milliseconds: 100),
    expect: () => <LoginState>[
      LoginSubmitting(),
      const LoginError(message: "Couldn't log in")
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'Signin with Google valid',
    build: () {
      when(signWithGoogleUseCaseMock.call())
          .thenAnswer((realInvocation) async => true);

      return bloc;
    },
    act: (bloc) => bloc.add(GoogleLoginRequested()),
    wait: const Duration(milliseconds: 100),
    expect: () => <LoginState>[LoginSubmitting(), LoginSuccessful()],
  );

  blocTest<LoginBloc, LoginState>(
    'Signin with Google invalid',
    build: () {
      when(signWithGoogleUseCaseMock.call())
          .thenAnswer((realInvocation) async => false);

      return bloc;
    },
    act: (bloc) => bloc.add(GoogleLoginRequested()),
    wait: const Duration(milliseconds: 100),
    expect: () => <LoginState>[
      LoginSubmitting(),
      const LoginError(message: "Couldn't log in")
    ],
  );
}
