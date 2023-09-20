import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:worktenser/blocs/auth/auth_bloc.dart';
import 'package:worktenser/domain/projects/src/models/project_model.dart';
import 'package:worktenser/domain/projects/src/services/iprojects_local_storage.dart';

class ProjectsLocalStorage implements IProjectsLocalStorage {
  final AuthBloc _authBloc;
  final SharedPreferences _prefs;

  static const String _key = 'worktenser.projects';

  const ProjectsLocalStorage(
      {required SharedPreferences prefs, required AuthBloc authBloc})
      : _prefs = prefs,
        _authBloc = authBloc;

  @override
  List<Project> load() {
    final jsonData = _prefs.getString(_key);

    if (jsonData == null) {
      return <Project>[];
    }

    final projects = _jsonToProjects(jsonData);

    return projects;
  }

  @override
  Future<bool> save(List<Project> projects) async {
    final userId = _authBloc.state.user.id;
    final result = await _prefs.setString(userId, json.encode(projects));

    return result;
  }

  @override
  Future<bool> update(Project project) async {
    List<Project> projects = load();

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
  Future<bool> delete(Project project) async {
    List<Project> projects = load();

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

  List<Project> _jsonToProjects(String jsonData) {
    List<Project> projects = [];

    json
        .decode(jsonData)
        .map((projectJson) => projects.add(Project.fromJson(projectJson)))
        .toList();

    return projects;
  }
}
