import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worktenser/core/util/project_time_formatter.dart';
import 'package:worktenser/features/projects/data/models/project.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/timeCounter/presentation/bloc/time_counter/time_counter_bloc.dart';

const _notificationsChannelName = 'dev.gawlowski.worktenser/notifications';
const _notificationsChannel = MethodChannel(_notificationsChannelName);

late FlutterBackgroundService _service;

Future<void> initializeTimeCounterService(TimeCounterBloc bloc) async {
  _service = FlutterBackgroundService();
  _service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: _onStart,
        onBackground: _onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: _onStart,
        isForegroundMode: true,
        autoStart: false,
      ));
}

@pragma('vm:entry-point')
Future<bool> _onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void _onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  service.on('setAsForeground').listen((event) {
    if (service is AndroidServiceInstance) {
      service.setAsForegroundService();
    }
  });

  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
  }

  service.on('stopTimeCounter').listen((event) async {
    await _onStop();
    service.stopSelf();
  });

  ProjectEntity? project = await _loadProject();

  if (project != null) {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      int newTime = project!.time;
      newTime++;

      project = project!.copyWith(time: newTime);

      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: 'Working on ${project!.name}',
          content:
              'Current time: ${printProjectTime(ProjectModel.fromEntity(project!))}',
        );
      }

      // if (service is IOSServiceInstance) {
      //   await _sendIosForegroundNotification(
      //     title: 'Working on ${project!.name}',
      //     body:
      //         'Current time: ${printProjectTime(ProjectModel.fromEntity(project!))}',
      //   );
      // }

      final sendPort = IsolateNameServer.lookupPortByName('timeCounter');

      final projectModel = ProjectModel.fromEntity(project!);

      sendPort?.send(projectModel.toJson());
    });
  }
}

Future<void> _onStop() async {}

Future<void> _sendIosForegroundNotification(
    {required String title, required String body}) async {
  final args = <String, String>{
    'title': title,
    'body': body,
  };

  await _notificationsChannel.invokeMethod('localNotification', args);
}

@pragma('vm:entry-point')
void runCustomIsolate(Map<String, dynamic> json) {
  ProjectEntity project = ProjectModel.fromJson(json: json);

  Timer.periodic(const Duration(seconds: 1), (timer) {
    int newTime = project.time;
    newTime++;

    project = project.copyWith(time: newTime);

    final sendPort = IsolateNameServer.lookupPortByName('timeCounter');

    final projectModel = ProjectModel.fromEntity(project);

    sendPort?.send(projectModel.toJson());

    debugPrint(
        'Current project:\t ${ProjectModel.fromEntity(project).toJson()}');
  });
}

Future<ProjectEntity?> _loadProject() async {
  final prefs = await SharedPreferences.getInstance();

  final jsonString = prefs.getString('timeCounterProject');

  if (jsonString == null) {
    return null;
  } else {
    final projectJson = json.decode(jsonString);
    final project = ProjectModel.fromJson(json: projectJson);

    return project;
  }
}
