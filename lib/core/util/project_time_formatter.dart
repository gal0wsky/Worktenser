import 'package:worktenser/features/projects/domain/entities/project.dart';

String printProjectTime(ProjectEntity project) {
  int time = project.time;

  final hours = time ~/ 3600;
  time = (time % 3600).toInt();
  final minutes = time ~/ 60;
  final seconds = time % 60;

  final formattedTime =
      _formatProjectTime(hours: hours, minutes: minutes, seconds: seconds);

  return formattedTime;
}

String _formatProjectTime(
    {required int hours, required int minutes, required int seconds}) {
  final hoursStr = hours.toString().padLeft(2, '0');
  final minutesStr = minutes.toString().padLeft(2, '0');
  final secondsStr = seconds.toString().padLeft(2, '0');

  return '$hoursStr:$minutesStr:$secondsStr';
}

String printTotalProjectsTime(int time) {
  final hours = time ~/ 3600;
  time = (time % 3600).toInt();
  final minutes = time ~/ 60;
  final seconds = time % 60;

  final formattedTime =
      _formatProjectTime(hours: hours, minutes: minutes, seconds: seconds);

  return formattedTime;
}
