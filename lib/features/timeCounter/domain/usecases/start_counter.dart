import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/timeCounter/domain/repository/time_counter_repository.dart';

class StartProjectTimeCounterUseCase extends UseCase<bool, void> {
  final TimeCounterRepository _counterRepository;

  StartProjectTimeCounterUseCase(
      {required TimeCounterRepository counterRepository})
      : _counterRepository = counterRepository;

  @override
  Future<bool> call({void params}) {
    return _counterRepository.start();
  }
}
