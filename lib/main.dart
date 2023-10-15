// import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/bloc_observer.dart';
import 'package:worktenser/config/routes.dart';
import 'package:worktenser/features/timeCounter/data/presentation/bloc/time_counter/time_counter_bloc.dart';
import 'package:worktenser/injection_container.dart';

import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/projects/presentation/bloc/projects/projects_bloc.dart';
import 'features/timeCounter/data/data_sources/counter_service_provider.dart';

Future main() async {
  Bloc.observer = AppBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await initializeDependiencies();

  final backgroundServiceRunning = await FlutterBackgroundService().isRunning();

  debugPrint(
      'Background Service running: ${backgroundServiceRunning ? 'yes' : 'no'}');

  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'worktenser_channel',
        channelName: 'Worktenser notifications',
        channelDescription: 'Notifications channel for Worktenser mobile app.',
      ),
    ],
    debug: true,
  );

  await AwesomeNotifications().isNotificationAllowed().then(
    (isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    },
  );

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    final inForeground = state == AppLifecycleState.resumed;

    if (inForeground) {
      final working = await FlutterBackgroundService().isRunning();

      debugPrint('\n\nBackground service working:\t${working ? 'yes' : 'no'}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => sl(),
        ),
        BlocProvider<ProjectsBloc>(
          create: (context) => sl(),
        ),
        BlocProvider<TimeCounterBloc>(
          create: (context) => sl(),
        )
      ],
      child: const AppView(),
    );
  }
}

// class App extends StatelessWidget {
//   const App({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<AuthBloc>(
//           create: (context) => sl(),
//         ),
//         BlocProvider<ProjectsBloc>(
//           create: (context) => sl(),
//         ),
//         BlocProvider<TimeCounterBloc>(
//           create: (context) => sl(),
//         )
//       ],
//       child: const AppView(),
//     );
//   }
// }

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeAsyncDependencies(),
        builder: ((context, snapshot) {
          return MaterialApp(
            title: 'Worktenser',
            home: FlowBuilder<AuthStatus>(
              state: context.select((AuthBloc bloc) => bloc.state.status),
              onGeneratePages: onGenerateAppViewPages,
            ),
          );
        }));
  }
}

Future<void> _initializeAsyncDependencies() async {
  await initializeTimeCounterService(sl());
}
