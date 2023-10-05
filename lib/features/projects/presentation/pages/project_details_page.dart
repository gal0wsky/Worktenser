import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/presentation/bloc/projects/projects_bloc.dart';
import 'package:worktenser/features/timeCounter/data/presentation/bloc/time_counter/time_counter_bloc.dart';

import 'edit_project_page.dart';

class DetailsPage extends StatefulWidget {
  final ProjectEntity project;

  const DetailsPage({Key? key, required this.project}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late ProjectEntity project = widget.project;
  bool skipReload = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocConsumer<ProjectsBloc, ProjectsState>(
        listener: (context, state) async {
          if (state is ProjectsReloading) {
            context
                .read<ProjectsBloc>()
                .add(LoadProjects(user: context.read<AuthBloc>().state.user));
          }
          if (state is ProjectsLoaded) {
            if (!skipReload) {
              final state =
                  context.read<ProjectsBloc>().state as ProjectsLoaded;
              setState(() {
                project =
                    state.projects.firstWhere((proj) => proj.id == project.id);
              });
            }
          }
        },
        builder: (context, state) {
          if (state is ProjectsLoading || state is ProjectsReloading) {
            return const CircularProgressIndicator();
          } else if (state is ProjectsError) {
            return Text(state.message);
          }

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 100,
                  bottom: 50,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EditProjectPage(project: project),
                          ),
                        );
                      },
                      child: const Icon(Icons.edit),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<ProjectsBloc>()
                            .add(DeleteProject(project: project));

                        setState(() {
                          skipReload = true;
                        });

                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
              Text(
                project.name,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Total time:',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    project.time.toString(),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Description:',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                project.description ?? '',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  FlutterBackgroundService()
                      .invoke('setAsForeground', <String, dynamic>{
                    'project': project,
                  });
                },
                child: const Text(
                  'Foreground',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              BlocConsumer<TimeCounterBloc, TimeCounterState>(
                listener: (context, state) {
                  if (state is TimeCounterInitial) {
                    context
                        .read<TimeCounterBloc>()
                        .add(InitializeTimeCounter(project: project));
                  }
                },
                builder: (context, state) {
                  if (state is TimeCounterInitial) {
                    context
                        .read<TimeCounterBloc>()
                        .add(InitializeTimeCounter(project: project));

                    return const CircularProgressIndicator();
                  }
                  if (state is TimeCounterWorking) {
                    return ElevatedButton(
                      onPressed: () {
                        // FlutterBackgroundService().invoke('stopTimeCounter');
                        context.read<TimeCounterBloc>().add(StopTimeCounter());
                      },
                      child: const Text(
                        'Stop',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else if (state is TimeCounterInitialized ||
                      state is TimeCounterStopped) {
                    return ElevatedButton(
                      onPressed: () async {
                        // currentCounterProject = project;
                        // updateCurrentTimerProject(project);
                        // await FlutterBackgroundService().startService();
                        context.read<TimeCounterBloc>().add(StartTimeCounter());
                      },
                      child: const Text(
                        'Start',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    return const Text('Something went wrong');
                  }
                },
              )
            ],
          );
        },
      ),
    );
  }
}
