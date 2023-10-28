import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/timeCounter/domain/repository/time_counter_repository.dart';

class SaveProjectOnDeviceUseCase extends UseCase<bool, ProjectEntity> {
  final TimeCounterRepository _counterRepository;

  SaveProjectOnDeviceUseCase({required TimeCounterRepository counterRepository})
      : _counterRepository = counterRepository;

  @override
  Future<bool> call({ProjectEntity? params}) {
    return _counterRepository.saveProjectOnDevice(params!);
  }
}
