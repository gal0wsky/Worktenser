import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:worktenser/features/auth/domain/entities/signup.dart';
import 'package:worktenser/features/auth/domain/usecases/signup_with_credentials.dart';
import 'package:worktenser/features/auth/presentation/bloc/signup/signup_bloc.dart';

import 'signup_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SignupWithCredentialsUseCase>()])
void main() {
  final signupUseCaseMock = MockSignupWithCredentialsUseCase();

  late SignupBloc bloc;

  setUp(
      () => bloc = SignupBloc(signupWithCredentialsUseCase: signupUseCaseMock));

  test('Create SignupBloc', () {
    expect(bloc.state, SignupInitial());
  });

  blocTest<SignupBloc, SignupState>(
    'Signup with email & password successful',
    build: () {
      const fakeSignupData =
          SignupEntity(email: 'fake@email.com', password: 'fakePassword123');

      when(signupUseCaseMock.call(params: fakeSignupData))
          .thenAnswer((realInvocation) async => true);

      return bloc;
    },
    act: (bloc) => bloc.add(const SignupRequested(
        signupData: SignupEntity(
            email: 'fake@email.com', password: 'fakePassword123'))),
    wait: const Duration(milliseconds: 100),
    expect: () => <SignupState>[SignupSubmitting(), SignupSuccessful()],
  );

  blocTest<SignupBloc, SignupState>(
    'Signup with email & password error',
    build: () {
      const fakeSignupData =
          SignupEntity(email: 'fake@email.com', password: 'fakePassword123');

      when(signupUseCaseMock.call(params: fakeSignupData))
          .thenAnswer((realInvocation) async => false);

      return bloc;
    },
    act: (bloc) => bloc.add(const SignupRequested(
        signupData: SignupEntity(
            email: 'fake@email.com', password: 'fakePassword123'))),
    wait: const Duration(milliseconds: 100),
    expect: () => <SignupState>[
      SignupSubmitting(),
      const SignupError(message: "Couldn't sign up")
    ],
  );
}
