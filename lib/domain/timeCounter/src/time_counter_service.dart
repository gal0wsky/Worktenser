import 'dart:async';
import 'dart:ui';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';
import 'package:worktenser/cubits/projects/projects_cubit.dart';
import 'package:worktenser/domain/projects/projects.dart';

const _notificationsChannelName = 'dev.gawlowski.worktenser/notifications';
const _notificationsChannel = MethodChannel(_notificationsChannelName);

late ProjectsCubit _cubit;
Project currentCounterProject = const Project(
    name: 'test', userId: 'xwfX6UZDh5erVcHJt86hXBZifx62', time: 30);
late FlutterBackgroundService _service;

Future<void> initializeTimeCounterService(ProjectsCubit cubit) async {
  _cubit = cubit;

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

void updateCurrentTimerProject(Project project) async {
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
    // final proj = event?[0];
    // currentCounterProject = proj;
    if (service is AndroidServiceInstance) {
      service.setAsForegroundService();
    }
  });

  service.on('stopTimeCounter').listen((event) async {
    await _onStop();
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    int newTime = currentCounterProject.time;
    newTime++;
    currentCounterProject = currentCounterProject.copyWith(time: newTime);

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
          title: 'Working on ${currentCounterProject.name}',
          content: 'Current time: ${currentCounterProject.printTime()}');

      // await AwesomeNotifications().dismissAllNotifications();

      // await AwesomeNotifications().createNotification(
      //   content: NotificationContent(
      //     id: -1,
      //     channelKey: 'worktenser_channel',
      //     title: 'Working on ${currentCounterProject.name}',
      //     body: 'Current time: ${currentCounterProject.printTime()}',
      //   ),
      // );
    }

    if (service is IOSServiceInstance) {
      await sendIosForegroundNotification(
        title: 'Working on ${currentCounterProject.name}',
        body: 'Current time: ${currentCounterProject.printTime()}',
      );
    }

    print(
        'Current time: ${currentCounterProject.printTime()}\t${currentCounterProject.time}');
  });
}

Future<void> _onStop() async {
  // await _cubit.updateProject(currentCounterProject);
  print(currentCounterProject.toJson());
}

Future<void> sendIosForegroundNotification(
    {required String title, required String body}) async {
  final args = <String, String>{
    'title': title,
    'body': body,
  };

  final result =
      await _notificationsChannel.invokeMethod('localNotification', args);
}
