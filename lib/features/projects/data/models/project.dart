import 'package:worktenser/features/projects/domain/entities/project.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    id,
    required name,
    description,
    time = 0,
    required userId,
  }) : super(
            id: id,
            name: name,
            description: description,
            time: time,
            userId: userId);

  factory ProjectModel.fromEntity(ProjectEntity entity) => ProjectModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      time: entity.time,
      userId: entity.userId);

  @override
  ProjectModel copyWith(
      {String? id,
      String? name,
      String? description,
      int? time,
      String? userId}) {
    return ProjectModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        time: time ?? this.time,
        userId: userId ?? this.userId);
  }

  factory ProjectModel.fromJson({required Map<String, dynamic> json}) =>
      ProjectModel(
          id: json['id'],
          name: json['name'],
          description: json['description'],
          time: json['time'],
          userId: json['userId']);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'time': time,
        'userId': userId
      };

  static List<Map<String, dynamic>> listToJson(List<ProjectEntity> list) {
    List<Map<String, dynamic>> jsonList = [];

    for (ProjectEntity project in list) {
      jsonList.add(ProjectModel.fromEntity(project).toJson());
    }

    return jsonList;
  }
}
