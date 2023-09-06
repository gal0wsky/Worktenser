// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String? id;
  final String name;
  final String? description;
  final int time;
  final String userId;

  const Project({
    this.id,
    required this.name,
    this.description,
    this.time = 0,
    required this.userId,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'time': time,
        'userId': userId,
      };

  static Project fromJson(Map<String, dynamic> json) => Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      time: json['time'],
      userId: json['userId']);

  @override
  List<Object?> get props => [id, name, description, time, userId];

  Project copyWith({
    String? id,
    String? name,
    String? description,
    int? time,
    String? userId,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      time: time ?? this.time,
      userId: userId ?? this.userId,
    );
  }
}
