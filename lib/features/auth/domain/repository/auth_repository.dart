import 'package:worktenser/features/auth/domain/entities/login.dart';
import 'package:worktenser/features/auth/domain/entities/signup.dart';
import 'package:worktenser/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  UserEntity currentUser = UserEntity.empty;
  Stream<UserEntity> get user;

  Future<bool> signupWithEmailAndPassword(
      {required SignupEntity signupInformation});
  Future<bool> logInWithEmailAndPassword(
      {required LoginEntity loginInformation});
  Future<bool> signInWithGoogle();
  Future<bool> logOut();
}
