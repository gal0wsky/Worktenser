// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worktenser/bloc_observer.dart';
// import 'package:worktenser/blocs/auth/auth_bloc.dart';
import 'package:worktenser/config/routes.dart';
import 'package:worktenser/cubits/projects/projects_cubit.dart';
import 'package:worktenser/domain/projects/projects.dart';
import 'package:worktenser/domain/timeCounter/timeCounter.dart';
import 'package:worktenser/injection_container.dart';

import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/projects/presentation/bloc/projects/projects_bloc.dart';

Future main() async {
  Bloc.observer = AppBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await initializeDependiencies();

  final sharedPreferences = await SharedPreferences.getInstance();

  final projectsLocalStorage = ProjectsLocalStorage(prefs: sharedPreferences);

  await projectsLocalStorage.save([
    const Project(
        id: 'fakeId1',
        name: 'fakeProj1',
        description: 'This is fake test project #1',
        userId: 'fakeUserId'),
    const Project(
        id: 'fakeId2',
        name: 'fakeProj2',
        description: 'This is fake test project #2',
        userId: 'fakeUserId'),
  ]);

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
    // return RepositoryProvider.value(
    //   value: _authRepository,
    //   child: MultiBlocProvider(
    //     providers: [
    //       BlocProvider(
    //         create: (context) => BlocProvider.of<AuthBloc>(context),
    //       ),
    //       BlocProvider(
    //         create: (context) => ProjectsCubit(
    //           projectsRepository: _projectsRepository,
    //           projectsLocalStorage: _projectsLocalStorage,
    //         ),
    //       )
    //     ],
    //     child: const AppView(),
    //   ),
    // );

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

// Future<void> _initializeAsyncDependencies(
//     {required ProjectsCubit projectsCubit}) async {
//   await initializeTimeCounterService(projectsCubit);
// }
