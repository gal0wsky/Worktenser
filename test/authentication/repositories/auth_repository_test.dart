import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:mockito/mockito.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:worktenser/domain/authentication/models/user_model.dart';
import 'package:worktenser/domain/authentication/repositories/auth_repository.dart';
import 'auth_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<firebase_auth.FirebaseAuth>(),
  MockSpec<firebase_auth.UserCredential>()
])
void main() {
  final firebaseAuthMock = MockFirebaseAuth();
  final userCredentialMock = MockUserCredential();
  final googleSignInMock = MockGoogleSignIn();

  test('Create AuthRepository', () {
    final repository = AuthRepository(firebaseAuth: firebaseAuthMock);

    expect(repository, isNotNull);
    expect(repository.currentUser, User.empty);
  });

  test('Signup with email & password valid', () async {
    const email = 'valid@email.com';
    const password = 'validPassword123';

    when(firebaseAuthMock.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).thenAnswer((realInvocation) async => userCredentialMock);

    final repo = AuthRepository(firebaseAuth: firebaseAuthMock);

    final result =
        await repo.signupWithEmailAndPassword(email: email, password: password);

    expect(result, true);
  });

  test('Signup with email & password invalid', () async {
    const email = '';
    const password = '';

    when(firebaseAuthMock.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).thenThrow(Exception());

    final repo = AuthRepository(firebaseAuth: firebaseAuthMock);

    final result =
        await repo.signupWithEmailAndPassword(email: email, password: password);

    expect(result, false);
  });

  test('Login with email & password valid', () async {
    const email = 'valid@email.com';
    const password = 'validPassword37';

    when(firebaseAuthMock.signInWithEmailAndPassword(
            email: email, password: password))
        .thenAnswer((realInvocation) async => userCredentialMock);

    final repo = AuthRepository(firebaseAuth: firebaseAuthMock);

    final result =
        await repo.logInWithEmailAndPassword(email: email, password: password);

    expect(result, true);
  });

  test('Login with email & password invalid', () async {
    const email = '';
    const password = '';

    when(firebaseAuthMock.signInWithEmailAndPassword(
            email: email, password: password))
        .thenThrow(Exception());

    final repo = AuthRepository(firebaseAuth: firebaseAuthMock);

    final result =
        await repo.logInWithEmailAndPassword(email: email, password: password);

    expect(result, false);
  });

  test('Signin with Google valid', () async {
    when(firebaseAuthMock.signInWithCredential(any))
        .thenAnswer((realInvocation) async => userCredentialMock);

    final repo = AuthRepository(
        firebaseAuth: firebaseAuthMock, googleSignIn: googleSignInMock);

    final result = await repo.signInWithGoogle();

    expect(result, true);
  });

  test('Signin with Google invalid', () async {
    when(firebaseAuthMock.signInWithCredential(any)).thenThrow(Exception());

    final repo = AuthRepository(
        firebaseAuth: firebaseAuthMock, googleSignIn: googleSignInMock);

    final result = await repo.signInWithGoogle();

    expect(result, false);
  });

  test('Logout valid', () async {
    final repo = AuthRepository(firebaseAuth: firebaseAuthMock);

    final result = await repo.logOut();

    expect(result, true);
  });

  test('Logout invalid', () async {
    when(firebaseAuthMock.signOut()).thenThrow(Exception());

    final repo = AuthRepository(firebaseAuth: firebaseAuthMock);

    final result = await repo.logOut();

    expect(result, false);
  });
}
