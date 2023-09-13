part of 'time_counter_bloc.dart';

sealed class TimeCounterEvent extends Equatable {
  const TimeCounterEvent();

  @override
  List<Object> get props => [];
}

class ChangeCounterProject extends TimeCounterEvent {}

class StartTimeCounter extends TimeCounterEvent {}

class StopTimeCounter extends TimeCounterEvent {}
