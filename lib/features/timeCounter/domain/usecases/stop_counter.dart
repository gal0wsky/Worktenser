import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/timeCounter/domain/repository/time_counter_repository.dart';

class StopProjectTimeCounterUseCase extends UseCase<bool, void> {
  final TimeCounterRepository _counterRepository;

  StopProjectTimeCounterUseCase(
      {required TimeCounterRepository counterRepository})
      : _counterRepository = counterRepository;

  @override
  Future<bool> call({void params}) async {
    await _counterRepository.stop();

    final isWorking = await _counterRepository.isWorking;

    return !isWorking;
  }
}
