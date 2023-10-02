// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/bloc_observer.dart';
import 'package:worktenser/config/routes.dart';
import 'package:worktenser/injection_container.dart';

import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/projects/presentation/bloc/projects/projects_bloc.dart';

Future main() async {
  Bloc.observer = AppBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await initializeDependiencies();

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

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => sl(),
        ),
        BlocProvider<ProjectsBloc>(
          create: (context) => sl(),
        )
      ],
      child: const AppView(),
    );
  }
}

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

Future<void> _initializeAsyncDependencies() async {}
