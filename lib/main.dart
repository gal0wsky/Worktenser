// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:worktenser/bloc_observer.dart';
import 'package:worktenser/blocs/auth/auth_bloc.dart';
import 'package:worktenser/config/routes.dart';
import 'package:worktenser/cubits/projects/projects_cubit.dart';
import 'package:worktenser/domain/authentication/repositories/auth_repository.dart';
import 'package:worktenser/domain/projects/repositories/projects_repository.dart';
import 'package:worktenser/domain/timeCounter/timeCounter.dart';

Future main() async {
  Bloc.observer = AppBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authRepository = AuthRepository();
  final projectsRepository = ProjectsRepository();

  // await Permission.notification.isDenied.then(
  //   (value) {
  //     if (!value) {
  //       Permission.notification.request();
  //     }
  //   },
  // );

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

  runApp(App(
    authRepository: authRepository,
    projectsRepository: projectsRepository,
  ));
}

class App extends StatelessWidget {
  final AuthRepository _authRepository;
  final ProjectsRepository _projectsRepository;

  const App(
      {Key? key,
      required AuthRepository authRepository,
      required ProjectsRepository projectsRepository})
      : _authRepository = authRepository,
        _projectsRepository = projectsRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => AuthBloc(authRepository: _authRepository)),
          BlocProvider(
              create: (context) =>
                  ProjectsCubit(projectsRepository: _projectsRepository))
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeTimeCounterService(context.read<ProjectsCubit>()),
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
