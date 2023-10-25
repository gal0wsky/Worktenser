import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:worktenser/features/auth/domain/usecases/reset_password.dart';
import 'package:worktenser/features/auth/presentation/bloc/resetPassword/reset_password_bloc.dart';

import 'reset_password_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ResetPasswordUseCase>()])
void main() {
  final useCaseMock = MockResetPasswordUseCase();

  late ResetPasswordBloc bloc;

  setUp(() => bloc = ResetPasswordBloc(resetPasswordUseCase: useCaseMock));

  test('Create ResetPasswordBloc test', () {
    final bloc = ResetPasswordBloc(resetPasswordUseCase: useCaseMock);

    expect(bloc.state, ResetPasswordInitial());
  });

  blocTest<ResetPasswordBloc, ResetPasswordState>(
    'Reset password, already submitting test',
    build: () {
      bloc.emit(ResetPasswordSubmitting());

      return bloc;
    },
    act: (bloc) => bloc.add(
      const ResetUserPassword(email: 'fake@email.com'),
    ),
    wait: const Duration(milliseconds: 100),
    expect: () => <ResetPasswordState>[],
  );

  blocTest<ResetPasswordBloc, ResetPasswordState>(
    'Reset password bloc successful test',
    build: () {
      when(useCaseMock.call(params: 'fake@email.com'))
          .thenAnswer((realInvocation) async => true);

      return bloc;
    },
    act: (bloc) => bloc.add(
      const ResetUserPassword(email: 'fake@email.com'),
    ),
    wait: const Duration(milliseconds: 100),
    expect: () => <ResetPasswordState>[
      ResetPasswordSubmitting(),
      ResetPasswordSuccess(),
    ],
  );

  blocTest<ResetPasswordBloc, ResetPasswordState>(
    'Reset password bloc invalid test',
    build: () {
      when(useCaseMock.call(params: 'fake@email.com'))
          .thenAnswer((realInvocation) async => false);

      return bloc;
    },
    act: (bloc) => bloc.add(
      const ResetUserPassword(email: 'fake@email.com'),
    ),
    wait: const Duration(milliseconds: 100),
    expect: () => <ResetPasswordState>[
      ResetPasswordSubmitting(),
      const ResetPasswordError(
          message: "Couldn't send the reset password email"),
    ],
  );
}
