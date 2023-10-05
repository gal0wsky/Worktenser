abstract class TimeCounterRepository {
  Future<void> initialize();
  Future<void> start();
  Future<void> stop();
}
