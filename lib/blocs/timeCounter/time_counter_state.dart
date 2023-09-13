part of 'time_counter_bloc.dart';

sealed class TimeCounterState extends Equatable {
  const TimeCounterState();

  @override
  List<Object> get props => [];
}

final class TimeCounterInitial extends TimeCounterState {}

class TimeCounterLoaded extends TimeCounterState {
  final Project project;

  const TimeCounterLoaded({required this.project});

  @override
  List<Object> get props => [project];
}

class TimeCounterError extends TimeCounterState {
  final String message;

  const TimeCounterError({this.message = 'Something went wrong.'});

  @override
  List<Object> get props => [message];
}
