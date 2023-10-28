import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:worktenser/features/projects/data/models/project.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';

import 'projects_local_storage.dart';

class ProjectsLocalStorageImpl implements ProjectsLocalStorage {
  final SharedPreferences _prefs;

  static const String _key = 'worktenser.projects';

  ProjectsLocalStorageImpl({required SharedPreferences preferences})
      : _prefs = preferences;

  @override
  List<ProjectEntity> load() {
    final jsonData = _prefs.getString(_key);

    if (jsonData == null) {
      return <ProjectEntity>[];
    }

    final projects = _jsonToProjects(jsonData);

    return projects;
  }

  @override
  Future<bool> add(ProjectEntity project) async {
    List<ProjectEntity> projects = load();
    projects.add(project);

    final changesSaved = await save(projects);

    return changesSaved;
  }

  @override
  Future<bool> save(List<ProjectEntity> projects) async {
    final result = await _prefs.setString(
        _key, json.encode(ProjectModel.listToJson(projects)));

    return result;
  }

  @override
  Future<bool> update(ProjectEntity project) async {
    List<ProjectEntity> projects = load();

    projects = projects.map((proj) {
      return proj.id == project.id
          ? proj.copyWith(
              name: project.name,
              description: project.description,
              time: project.time,
            )
          : proj;
    }).toList();

    final result = await save(projects);

    return result;
  }

  @override
  Future<bool> delete(ProjectEntity project) async {
    List<ProjectEntity> projects = load();

    final updatedProjects = projects.where((proj) {
      return proj.id != project.id;
    }).toList();

    final result = await save(updatedProjects);

    return result;
  }

  @override
  Future<bool> clear() async {
    final result = await _prefs.remove(_key);

    return result;
  }

  List<ProjectEntity> _jsonToProjects(String jsonData) {
    List<ProjectEntity> projects = [];

    json
        .decode(jsonData)
        .map((projectJson) =>
            projects.add(ProjectModel.fromJson(json: projectJson)))
        .toList();

    return projects;
  }
}
