part of 'time_counter_bloc.dart';

sealed class TimeCounterState extends Equatable {
  const TimeCounterState();

  @override
  List<Object> get props => [];
}

final class TimeCounterInitial extends TimeCounterState {}

final class TimeCounterInitialized extends TimeCounterState {
  final ProjectEntity project;

  const TimeCounterInitialized({required this.project});

  @override
  List<Object> get props => [project];
}

final class TimeCounterStopped extends TimeCounterState {
  final ProjectEntity project;

  const TimeCounterStopped({required this.project});

  @override
  List<Object> get props => [project];
}

final class TimeCounterWorking extends TimeCounterState {
  final ProjectEntity project;

  const TimeCounterWorking({required this.project});

  @override
  List<Object> get props => [project];
}

final class TimeCounterError extends TimeCounterState {
  final String message;

  const TimeCounterError({this.message = 'Something went wrong'});

  @override
  List<Object> get props => [message];
}
