part of 'time_counter_bloc.dart';

sealed class TimeCounterEvent extends Equatable {
  const TimeCounterEvent();

  @override
  List<Object> get props => [];
}

final class InitializeTimeCounter extends TimeCounterEvent {
  final ProjectEntity project;

  const InitializeTimeCounter({required this.project});

  @override
  List<Object> get props => [project];
}

final class StartTimeCounter extends TimeCounterEvent {}

final class StopTimeCounter extends TimeCounterEvent {}

final class UpdateTimeCounterProject extends TimeCounterEvent {
  final ProjectEntity project;

  const UpdateTimeCounterProject({required this.project});

  @override
  List<Object> get props => [project];
}
