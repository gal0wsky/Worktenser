import 'package:worktenser/features/auth/domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel(
      {required String id, String? name, String? email, String? password})
      : super(
          id: '',
          name: name,
          email: email,
          password: password,
        );

  static const empty = UserModel(id: '');

  @override
  bool get isEmpty => this == UserModel.empty;

  @override
  bool get isNotEmpty => this != UserModel.empty;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
      );

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        name: entity.name,
        email: entity.email,
        password: entity.password,
      );
}
