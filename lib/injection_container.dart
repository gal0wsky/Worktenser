import 'package:get_it/get_it.dart';
import 'package:worktenser/features/auth/data/repository/auth_repository_impl.dart';
import 'package:worktenser/features/auth/domain/usecases/logout.dart';
import 'package:worktenser/features/auth/domain/usecases/signin_with_credentials.dart';
import 'package:worktenser/features/auth/domain/usecases/signin_with_google.dart';
import 'package:worktenser/features/auth/domain/usecases/signup_with_credentials.dart';
import 'package:worktenser/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:worktenser/features/projects/data/repository/projects_repository_impl.dart';
import 'package:worktenser/features/projects/domain/repository/projects_repository.dart';
import 'package:worktenser/features/projects/domain/usecases/add_project.dart';
import 'package:worktenser/features/projects/domain/usecases/get_projects_total_time.dart';
import 'package:worktenser/features/projects/domain/usecases/load_projects.dart';
import 'package:worktenser/features/timeCounter/data/presentation/bloc/time_counter/time_counter_bloc.dart';
import 'package:worktenser/features/timeCounter/data/repository/time_counter_repository_impl.dart';
import 'package:worktenser/features/timeCounter/domain/repository/time_counter_repository.dart';
import 'package:worktenser/features/timeCounter/domain/usecases/start_counter.dart';

import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/auth/presentation/bloc/signup/signup_bloc.dart';
import 'features/projects/domain/usecases/delete_project.dart';
import 'features/projects/domain/usecases/update_project.dart';
import 'features/projects/presentation/bloc/projects/projects_bloc.dart';
import 'features/timeCounter/domain/usecases/stop_counter.dart';

final sl = GetIt.instance;

Future<void> initializeDependiencies() async {
  _registerAuthenticationDependencies();

  _registerProjectsDependencies();

  _registerTimeCounterDependencies();
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

  sl.registerSingleton<LogoutUseCase>(LogoutUseCase(authRepository: sl()));

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

void _registerProjectsDependencies() {
  // Dependencies
  sl.registerSingleton<ProjectsRepository>(ProjectsRepositoryImpl());

  // Usecases
  sl.registerSingleton<LoadProjectsUsecase>(
      LoadProjectsUsecase(projectsRepository: sl()));

  sl.registerSingleton<AddProjectUseCase>(
      AddProjectUseCase(projectsRepository: sl()));

  sl.registerSingleton<UpdateProjectUseCase>(
      UpdateProjectUseCase(projectsRepository: sl()));

  sl.registerSingleton<DeleteProjectUseCase>(
      DeleteProjectUseCase(projectsRepository: sl()));

  sl.registerSingleton<GetProjectsTotalTimeUseCase>(
      GetProjectsTotalTimeUseCase(projectsRepository: sl()));

  sl.registerFactory<ProjectsBloc>(() => ProjectsBloc(
        loadProjectsUsecase: sl(),
        addProjectUseCase: sl(),
        updateProjectUseCase: sl(),
        deleteProjectUseCase: sl(),
        getProjectsTotalTimeUseCase: sl(),
      ));
}

void _registerTimeCounterDependencies() {
  // Dependencies
  sl.registerSingleton<TimeCounterRepository>(TimeCounterRepositoryImpl());

  // Usecases
  sl.registerSingleton<StartProjectTimeCounterUseCase>(
      StartProjectTimeCounterUseCase());

  sl.registerSingleton<StopProjectTimeCounterUseCase>(
      StopProjectTimeCounterUseCase());

  // Bloc
  sl.registerFactory<TimeCounterBloc>(() => TimeCounterBloc());
}
