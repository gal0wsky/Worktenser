// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worktenser/bloc_observer.dart';
import 'package:worktenser/blocs/auth/auth_bloc.dart';
import 'package:worktenser/config/routes.dart';
import 'package:worktenser/cubits/projects/projects_cubit.dart';
import 'package:worktenser/domain/authentication/authentication.dart';
import 'package:worktenser/domain/projects/projects.dart';
import 'package:worktenser/domain/timeCounter/timeCounter.dart';

Future main() async {
  Bloc.observer = AppBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authRepository = AuthRepository();
  final projectsRepository = ProjectsRepository();

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

  runApp(App(
    authRepository: authRepository,
    projectsRepository: projectsRepository,
    projectsLocalStorage: projectsLocalStorage,
  ));
}

class App extends StatelessWidget {
  final AuthRepository _authRepository;
  final ProjectsRepository _projectsRepository;
  final ProjectsLocalStorage _projectsLocalStorage;

  const App(
      {Key? key,
      required AuthRepository authRepository,
      required ProjectsRepository projectsRepository,
      required ProjectsLocalStorage projectsLocalStorage})
      : _authRepository = authRepository,
        _projectsRepository = projectsRepository,
        _projectsLocalStorage = projectsLocalStorage,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: _authRepository,
              projectsLocalStorage: _projectsLocalStorage,
            ),
          ),
          BlocProvider(
            create: (context) => ProjectsCubit(
              projectsRepository: _projectsRepository,
              projectsLocalStorage: _projectsLocalStorage,
            ),
          )
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
        future: _initializeAsyncDependencies(
            projectsCubit: context.read<ProjectsCubit>()),
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

Future<void> _initializeAsyncDependencies(
    {required ProjectsCubit projectsCubit}) async {
  await initializeTimeCounterService(projectsCubit);
}
