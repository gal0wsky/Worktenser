import 'package:worktenser/domain/authentication/models/user_model.dart';

abstract class IAuthRepository {
  User currentUser = User.empty;
  Stream<User> get user;

  Future<bool> signupWithEmailAndPassword(
      {required String email, required String password});
  Future<bool> logInWithEmailAndPassword(
      {required String email, required String password});
  Future<bool> signInWithGoogle();
  Future<bool> logOut();
}
