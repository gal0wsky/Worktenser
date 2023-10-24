import 'dart:isolate';
import 'dart:ui';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worktenser/features/auth/data/repository/auth_repository_impl.dart';
import 'package:worktenser/features/auth/domain/usecases/logout.dart';
import 'package:worktenser/features/auth/domain/usecases/signin_with_credentials.dart';
import 'package:worktenser/features/auth/domain/usecases/signin_with_google.dart';
import 'package:worktenser/features/auth/domain/usecases/signup_with_credentials.dart';
import 'package:worktenser/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:worktenser/features/projects/data/data_sources/local/projects_local_storage.dart';
import 'package:worktenser/features/projects/data/data_sources/local/projects_local_storage_impl.dart';
import 'package:worktenser/features/projects/data/repository/projects_repository_impl.dart';
import 'package:worktenser/features/projects/domain/repository/projects_repository.dart';
import 'package:worktenser/features/projects/domain/usecases/add_project.dart';
import 'package:worktenser/features/projects/domain/usecases/get_projects_total_time.dart';
import 'package:worktenser/features/projects/domain/usecases/load_local_copy.dart';
import 'package:worktenser/features/projects/domain/usecases/load_projects.dart';
import 'package:worktenser/features/projects/presentation/bloc/project_details/project_details_bloc.dart';
import 'package:worktenser/features/searchbar/presentation/bloc/searchbar/searchbar_bloc.dart';
import 'package:worktenser/features/timeCounter/data/repository/time_counter_repository_impl.dart';
import 'package:worktenser/features/timeCounter/domain/repository/time_counter_repository.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/save_project_on_device.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/start_counter.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/update_in_firestore.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/update_local_copy.dart';
import 'package:worktenser/features/timeCounter/presentation/bloc/time_counter/time_counter_bloc.dart';

import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/auth/presentation/bloc/signup/signup_bloc.dart';
import 'features/projects/domain/usecases/delete_project.dart';
import 'features/projects/domain/usecases/update_project.dart';
import 'features/projects/presentation/bloc/projects/projects_bloc.dart';
import 'features/timeCounter/domain/usecases/stop_counter.dart';

final sl = GetIt.instance;

Future<void> initializeDependiencies() async {
  final sharedPrefs = await SharedPreferences.getInstance();

  sl.registerSingleton<ProjectsLocalStorage>(
      ProjectsLocalStorageImpl(preferences: sharedPrefs));

  sl.registerSingleton<ProjectsRepository>(ProjectsRepositoryImpl());

  _registerAuthenticationDependencies();

  _registerTimeCounterDependencies(sharedPrefs);

  _registerProjectsDependencies(sharedPrefs);

  _registerSearchbarDependencies();
}

void _registerAuthenticationDependencies() {
  // Dependencies
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());

  // Usecases
  sl.registerSingleton<SignupWithCredentialsUseCase>(
      SignupWithCredentialsUseCase(authRepository: sl()));

  sl.registerSingleton<SigninWithCredentialsUseCase>(
      SigninWithCredentialsUseCase(authRepository: sl()));

  sl.registerSingleton<SigninWithGoogleUseCase>(
      SigninWithGoogleUseCase(authRepository: sl()));

  sl.registerSingleton<LogoutUseCase>(
      LogoutUseCase(authRepository: sl(), projectsLocalStorage: sl()));

  // Blocs
  sl.registerFactory<AuthBloc>(() => AuthBloc(
        authRepository: sl(),
        logoutUseCase: sl(),
      ));

  sl.registerFactory<SignupBloc>(
      () => SignupBloc(signupWithCredentialsUseCase: sl()));

  sl.registerFactory<LoginBloc>(() => LoginBloc(
      signinWithCredentialsUseCase: sl(), signinWithGoogleUseCase: sl()));
}

void _registerProjectsDependencies(SharedPreferences preferences) {
  // Dependencies

  // Usecases
  sl.registerSingleton<LoadProjectsUsecase>(LoadProjectsUsecase(
      projectsRepository: sl(), projectsLocalStorage: sl()));

  sl.registerSingleton<AddProjectUseCase>(
      AddProjectUseCase(projectsRepository: sl(), projectsLocalStorage: sl()));

  sl.registerSingleton<UpdateProjectUseCase>(UpdateProjectUseCase(
      projectsRepository: sl(), projectsLocalStorage: sl()));

  sl.registerSingleton<DeleteProjectUseCase>(DeleteProjectUseCase(
      projectsRepository: sl(), projectsLocalStorage: sl()));

  sl.registerSingleton<GetProjectsTotalTimeUseCase>(
      GetProjectsTotalTimeUseCase(projectsRepository: sl()));

  sl.registerSingleton<LoadLocalCopyUseCase>(
      LoadLocalCopyUseCase(projectsLocalStorage: sl()));

  sl.registerSingleton<ProjectsBloc>(ProjectsBloc(
    loadProjectsUsecase: sl(),
    addProjectUseCase: sl(),
    updateProjectUseCase: sl(),
    deleteProjectUseCase: sl(),
    getProjectsTotalTimeUseCase: sl(),
    loadLocalCopyUseCase: sl(),
    timeCounterBloc: sl(),
  ));

  sl.registerSingleton<ProjectDetailsBloc>(
      ProjectDetailsBloc(timeCounterBloc: sl()));
}

void _registerTimeCounterDependencies(SharedPreferences preferences) {
  // Dependencies
  sl.registerSingleton<TimeCounterRepository>(TimeCounterRepositoryImpl());

  sl.registerSingleton<ReceivePort>(ReceivePort());

  final ReceivePort receivePort = sl();

  IsolateNameServer.removePortNameMapping('timeCounter');

  IsolateNameServer.registerPortWithName(receivePort.sendPort, 'timeCounter');

  // Usecases
  sl.registerSingleton<StartProjectTimeCounterUseCase>(
      StartProjectTimeCounterUseCase(counterRepository: sl()));

  sl.registerSingleton<StopProjectTimeCounterUseCase>(
      StopProjectTimeCounterUseCase(counterRepository: sl()));

  sl.registerSingleton<UpdateInFirestoreUseCase>(
      UpdateInFirestoreUseCase(projectsRepository: sl()));

  sl.registerSingleton<UpdateLocalCopyUseCase>(
      UpdateLocalCopyUseCase(projectsLocalStorage: sl()));

  sl.registerSingleton<SaveProjectOnDeviceUseCase>(
      SaveProjectOnDeviceUseCase(preferences: preferences));

  // Bloc
  sl.registerSingleton<TimeCounterBloc>(TimeCounterBloc(
    receivePort: sl(),
    preferences: preferences,
    startUseCase: sl(),
    stopUseCase: sl(),
    updateLocalCopyUseCase: sl(),
    updateInFirestoreUseCase: sl(),
    saveProjectOnDeviceUseCase: sl(),
  ));
}

void _registerSearchbarDependencies() {
  sl.registerFactory<SearchbarBloc>(() => SearchbarBloc(projectsBloc: sl()));
}
