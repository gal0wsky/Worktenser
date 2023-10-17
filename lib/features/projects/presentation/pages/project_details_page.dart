import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/projects/presentation/bloc/project_details/project_details_bloc.dart';
import 'package:worktenser/features/projects/presentation/bloc/projects/projects_bloc.dart';
import 'package:worktenser/features/timeCounter/presentation/bloc/time_counter/time_counter_bloc.dart';

import 'edit_project_page.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocBuilder<ProjectDetailsBloc, ProjectDetailsState>(
        builder: (context, state) {
          if (state is ProjectDetailsLoading) {
            return const CircularProgressIndicator();
          } else if (state is ProjectDetailsError) {
            return Text(state.message);
          }

          final detailsState = state as ProjectDetailsLoaded;

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
                            builder: (_) =>
                                EditProjectPage(project: detailsState.project),
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
                            .add(DeleteProject(project: detailsState.project));

                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
              Text(
                detailsState.project.name,
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
                    state.project.printTime(),
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
                detailsState.project.description ?? '',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                ),
              ),
              ElevatedButton(
                onPressed: () {},
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
                    context.read<TimeCounterBloc>().add(
                        InitializeTimeCounter(project: detailsState.project));
                  }
                },
                builder: (context, state) {
                  if (state is TimeCounterInitial) {
                    context.read<TimeCounterBloc>().add(
                        InitializeTimeCounter(project: detailsState.project));

                    return const CircularProgressIndicator();
                  }
                  if (state is TimeCounterWorking) {
                    return ElevatedButton(
                      onPressed: () {
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
