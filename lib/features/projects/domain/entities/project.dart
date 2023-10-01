import 'package:equatable/equatable.dart';

class ProjectEntity extends Equatable {
  final String? id;
  final String name;
  final String? description;
  final int time;
  final String userId;

  const ProjectEntity({
    this.id,
    required this.name,
    this.description,
    this.time = 0,
    required this.userId,
  });

  ProjectEntity copyWith({
    String? id,
    String? name,
    String? description,
    int? time,
    String? userId,
  }) {
    return ProjectEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      time: time ?? this.time,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'time': time,
        'userId': userId
      };

  @override
  List<Object?> get props => [id, name, description, time, userId];
}
