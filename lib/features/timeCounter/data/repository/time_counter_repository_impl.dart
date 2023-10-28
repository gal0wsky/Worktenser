import 'dart:convert';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worktenser/features/projects/data/models/project.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/timeCounter/domain/repository/time_counter_repository.dart';

class TimeCounterRepositoryImpl implements TimeCounterRepository {
  final SharedPreferences _preferences;
  final String _key = 'timeCounterProject';

  TimeCounterRepositoryImpl({required SharedPreferences preferences})
      : _preferences = preferences;

  @override
  Future<bool> start() async {
    return FlutterBackgroundService().startService();
  }

  @override
  Future<void> stop() async {
    FlutterBackgroundService().invoke('stopTimeCounter');
  }

  @override
  Future<bool> get isWorking => FlutterBackgroundService().isRunning();

  @override
  Future<bool> saveProjectOnDevice(ProjectEntity project) async {
    final projectModel = ProjectModel.fromEntity(project);

    return _preferences.setString(_key, json.encode(projectModel.toJson()));
  }
}
