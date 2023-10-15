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

  factory ProjectEntity.fromJson(Map<String, dynamic> json) => ProjectEntity(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        time: json['time'],
        userId: json['userId'],
      );

  String printTime() {
    int time = this.time;

    final hours = time ~/ 3600;
    time = (time % 3600).toInt();
    final minutes = time ~/ 60;
    final seconds = time % 60;

    final formattedTime =
        _formatTime(hours: hours, minutes: minutes, seconds: seconds);

    return formattedTime;
  }

  String _formatTime(
      {required int hours, required int minutes, required int seconds}) {
    final hoursStr = hours.toString().padLeft(2, '0');
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = seconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  @override
  List<Object?> get props => [id, name, description, time, userId];
}
