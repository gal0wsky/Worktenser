import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';
import 'package:worktenser/features/projects/data/models/project.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/timeCounter/data/presentation/bloc/time_counter/time_counter_bloc.dart';
import 'package:worktenser/injection_container.dart';

const _notificationsChannelName = 'dev.gawlowski.worktenser/notifications';
const _notificationsChannel = MethodChannel(_notificationsChannelName);

late FlutterBackgroundService _service;

ProjectEntity currentProject =
    const ProjectModel(name: '', userId: '', time: 0);

late TimeCounterBloc _bloc;

Future<void> initializeTimeCounterService(TimeCounterBloc bloc) async {
  _bloc = bloc;

  _service = FlutterBackgroundService();
  _service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: _onStart,
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: _onStart,
        isForegroundMode: true,
        autoStart: false,
      ));
}

void updateCurrentTimerProject(ProjectEntity project) async {
  if (await _service.isRunning()) {
    _service.invoke('stopTimeCounter');
  }

  // currentCounterProject = project;

  // await _service.startService();
}

@pragma('vm:entry-point')
void _onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  service.on('setAsForeground').listen((event) {
    // if (service is AndroidServiceInstance) {
    //   service.setAsForegroundService();
    // }
  });

  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
  }

  service.on('stopTimeCounter').listen((event) async {
    await _onStop();
    service.stopSelf();
  });

  service.on('setProject').listen(
    (event) {
      final project = ProjectModel.fromJson(json: event?[0]);
      currentProject = project;
    },
  );

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    // final TimeCounterBloc bloc = sl();
    // final state = _bloc.state;

    int newTime = currentProject.time;
    newTime++;

    currentProject = currentProject.copyWith(time: newTime);

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
          title: 'Working on ${currentProject.name}',
          content:
              'Current time: ${ProjectModel.fromEntity(currentProject).printTime()}');
    }

    if (service is IOSServiceInstance) {
      await _sendIosForegroundNotification(
        title: 'Working on ${currentProject.name}',
        body:
            'Current time: ${ProjectModel.fromEntity(currentProject).printTime()}',
      );
    }

    print(
        'Current time: ${ProjectModel.fromEntity(currentProject).printTime()}\t${currentProject.time}');
  });
}

Future<void> _onStop() async {
  print(currentProject.toJson());
}

Future<void> _sendIosForegroundNotification(
    {required String title, required String body}) async {
  final args = <String, String>{
    'title': title,
    'body': body,
  };

  final result =
      await _notificationsChannel.invokeMethod('localNotification', args);
}
