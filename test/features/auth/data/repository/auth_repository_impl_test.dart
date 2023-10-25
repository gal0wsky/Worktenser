import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:worktenser/features/auth/data/models/user.dart';
import 'package:worktenser/features/auth/data/repository/auth_repository_impl.dart';
import 'package:worktenser/features/auth/domain/entities/login.dart';
import 'package:worktenser/features/auth/domain/entities/signup.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<firebase_auth.FirebaseAuth>(),
  MockSpec<firebase_auth.UserCredential>()
])
void main() {
  final firebaseAuthMock = MockFirebaseAuth();
  final userCredentialMock = MockUserCredential();
  final googleSignInMock = MockGoogleSignIn();

  test('Create AuthRepository', () {
    final repository = AuthRepositoryImpl(firebaseAuth: firebaseAuthMock);

    expect(repository, isNotNull);
    expect(repository.currentUser, UserModel.empty);
  });

  test('Signup with email & password valid', () async {
    const email = 'valid@email.com';
    const password = 'validPassword123';

    when(firebaseAuthMock.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).thenAnswer((realInvocation) async => userCredentialMock);

    final repo = AuthRepositoryImpl(firebaseAuth: firebaseAuthMock);

    const signupEntity = SignupEntity(email: email, password: password);

    final result =
        await repo.signupWithEmailAndPassword(signupInformation: signupEntity);

    expect(result, true);
  });

  test('Signup with email & password invalid', () async {
    const email = '';
    const password = '';

    when(firebaseAuthMock.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).thenThrow(Exception());

    final repo = AuthRepositoryImpl(firebaseAuth: firebaseAuthMock);

    const signupEntity = SignupEntity(email: email, password: password);

    final result =
        await repo.signupWithEmailAndPassword(signupInformation: signupEntity);

    expect(result, false);
  });

  test('Login with email & password valid', () async {
    const email = 'valid@email.com';
    const password = 'validPassword37';

    when(firebaseAuthMock.signInWithEmailAndPassword(
            email: email, password: password))
        .thenAnswer((realInvocation) async => userCredentialMock);

    final repo = AuthRepositoryImpl(firebaseAuth: firebaseAuthMock);

    const loginEntity = LoginEntity(email: email, password: password);

    final result =
        await repo.logInWithEmailAndPassword(loginInformation: loginEntity);

    expect(result, true);
  });

  test('Login with email & password invalid', () async {
    const email = '';
    const password = '';

    when(firebaseAuthMock.signInWithEmailAndPassword(
            email: email, password: password))
        .thenThrow(Exception());

    final repo = AuthRepositoryImpl(firebaseAuth: firebaseAuthMock);

    const loginEntity = LoginEntity(email: email, password: password);

    final result =
        await repo.logInWithEmailAndPassword(loginInformation: loginEntity);

    expect(result, false);
  });

  test('Signin with Google valid', () async {
    when(firebaseAuthMock.signInWithCredential(any))
        .thenAnswer((realInvocation) async => userCredentialMock);

    final repo = AuthRepositoryImpl(
        firebaseAuth: firebaseAuthMock, googleSignIn: googleSignInMock);

    final result = await repo.signInWithGoogle();

    expect(result, true);
  });

  test('Signin with Google invalid', () async {
    when(firebaseAuthMock.signInWithCredential(any)).thenThrow(Exception());

    final repo = AuthRepositoryImpl(
        firebaseAuth: firebaseAuthMock, googleSignIn: googleSignInMock);

    final result = await repo.signInWithGoogle();

    expect(result, false);
  });

  test('Logout valid', () async {
    final repo = AuthRepositoryImpl(firebaseAuth: firebaseAuthMock);

    final result = await repo.logOut();

    expect(result, true);
  });

  test('Logout invalid', () async {
    when(firebaseAuthMock.signOut()).thenThrow(Exception());

    final repo = AuthRepositoryImpl(firebaseAuth: firebaseAuthMock);

    final result = await repo.logOut();

    expect(result, false);
  });

  test('Reset password successful test', () async {
    when(firebaseAuthMock.sendPasswordResetEmail(email: 'fake@email.com'))
        .thenAnswer((realInvocation) async => true);

    final repo = AuthRepositoryImpl(firebaseAuth: firebaseAuthMock);

    final result = await repo.resetPassword(email: 'fake@email.com');

    expect(result, true);
  });

  test('Reset password catch exception test', () async {
    when(firebaseAuthMock.sendPasswordResetEmail(email: 'fake@email.com'))
        .thenThrow(Exception());

    final repo = AuthRepositoryImpl(firebaseAuth: firebaseAuthMock);

    final result = await repo.resetPassword(email: 'fake@email.com');

    expect(result, false);
  });
}
