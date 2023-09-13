import 'package:worktenser/cubits/projects/projects_cubit.dart';

abstract class ITimeCounterManager {
  Future<bool> get isRunning;

  Future<void> initialize(ProjectsCubit cubit);
  void startCounter();
  void stopCounter();
}
