import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final String? password;

  const UserEntity({required this.id, this.name, this.email, this.password});

  static const empty = UserEntity(id: '');

  bool get isNotEmpty => this != UserEntity.empty;
  bool get isEmpty => this == UserEntity.empty;

  @override
  List<Object?> get props => [id, email, password];
}
