import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:worktenser/features/auth/data/models/login.dart';
import 'package:worktenser/features/auth/data/models/signup.dart';
import 'package:worktenser/features/auth/data/models/user.dart';
import 'package:worktenser/features/auth/domain/entities/login.dart';
import 'package:worktenser/features/auth/domain/entities/signup.dart';
import 'package:worktenser/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepositoryImpl(
      {firebase_auth.FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  var currentUser = UserModel.empty;

  @override
  Stream<UserModel> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? UserModel.empty : firebaseUser.toUser;
      currentUser = user;
      return user;
    });
  }

  @override
  Future<bool> signupWithEmailAndPassword(
      {required SignupEntity signupInformation}) async {
    try {
      final signupModel = SignupModel.fromEntity(signupInformation);

      await _firebaseAuth.createUserWithEmailAndPassword(
          email: signupModel.email, password: signupModel.password);
    } catch (e) {
      return false;
    }

    return true;
  }

  @override
  Future<bool> logInWithEmailAndPassword(
      {required LoginEntity loginInformation}) async {
    try {
      final loginModel = LoginModel.fromEntity(loginInformation);

      await _firebaseAuth.signInWithEmailAndPassword(
          email: loginModel.email, password: loginModel.password);
    } catch (e) {
      return false;
    }

    return true;
  }

  @override
  Future<bool> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      return false;
    }

    return true;
  }

  @override
  Future<bool> logOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut()]);
    } catch (e) {
      return false;
    }

    return true;
  }

  @override
  Future<bool> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      return false;
    }

    return true;
  }
}

extension on firebase_auth.User {
  UserModel get toUser {
    return UserModel(id: uid, email: email, name: displayName);
  }
}
