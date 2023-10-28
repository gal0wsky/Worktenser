import 'package:worktenser/features/projects/domain/entities/project.dart';

abstract class TimeCounterRepository {
  Future<bool> start();
  Future<void> stop();
  Future<bool> get isWorking;
  Future<bool> saveProjectOnDevice(ProjectEntity project);
}
