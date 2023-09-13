import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:worktenser/cubits/projects/projects_cubit.dart';
import 'package:worktenser/domain/timeCounter/timeCounter.dart';

class TimeCounterManager implements ITimeCounterManager {
  @override
  Future<bool> get isRunning async =>
      await FlutterBackgroundService().isRunning();

  @override
  Future<void> initialize(ProjectsCubit cubit) async {
    await initializeTimeCounterService(cubit);
  }

  @override
  void startCounter() {
    FlutterBackgroundService().startService();
  }

  @override
  void stopCounter() {
    FlutterBackgroundService().invoke('stopTimeCounter');
  }
}
