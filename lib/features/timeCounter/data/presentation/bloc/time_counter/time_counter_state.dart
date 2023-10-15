part of 'time_counter_bloc.dart';

sealed class TimeCounterState extends Equatable {
  final ProjectEntity? project;
  // final Isolate? isolate;

  const TimeCounterState({this.project});

  @override
  List<Object?> get props => [project];
}

final class TimeCounterInitial extends TimeCounterState {}

final class TimeCounterInitialized extends TimeCounterState {
  const TimeCounterInitialized({required ProjectEntity project})
      : super(project: project);
}

final class TimeCounterStopped extends TimeCounterState {
  const TimeCounterStopped({required ProjectEntity project})
      : super(project: project);
}

final class TimeCounterWorking extends TimeCounterState {
  const TimeCounterWorking({required ProjectEntity project})
      : super(project: project);
}

final class TimeCounterError extends TimeCounterState {
  final String message;

  const TimeCounterError({this.message = 'Something went wrong'});

  @override
  List<Object> get props => [message];
}
