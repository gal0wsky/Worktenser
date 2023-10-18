import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:worktenser/features/timeCounter/domain/repository/time_counter_repository.dart';

class TimeCounterRepositoryImpl implements TimeCounterRepository {
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
}
