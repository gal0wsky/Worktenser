import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';

class SaveProjectOnDeviceUseCase extends UseCase<bool, ProjectEntity> {
  final SharedPreferences _preferences;
  final String _key = 'timeCounterProject';

  SaveProjectOnDeviceUseCase({required SharedPreferences preferences})
      : _preferences = preferences;

  @override
  Future<bool> call({ProjectEntity? params}) {
    return _preferences.setString(_key, json.encode(params!.toJson()));
  }
}
