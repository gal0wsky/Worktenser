abstract class TimeCounterRepository {
  Future<bool> start();
  Future<void> stop();
  Future<bool> get isWorking;
}
