import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/projects/presentation/bloc/project_details/project_details_bloc.dart';
import 'package:worktenser/features/projects/presentation/bloc/projects/projects_bloc.dart';
import 'package:worktenser/features/projects/presentation/widgets/start_counter_button.dart';
import 'package:worktenser/features/projects/presentation/widgets/stop_counter_button.dart';
import 'package:worktenser/features/projects/presentation/widgets/time_spinner.dart';
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

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 50,
                          bottom: 50,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(context).pop,
                              icon: const Icon(
                                FontAwesomeIcons.angleLeft,
                                color: AppColors.textPrimary,
                              ),
                              padding: EdgeInsets.zero,
                              iconSize: 25,
                            ),
                            PopupMenuButton(
                              icon: const Icon(
                                FontAwesomeIcons.ellipsisVertical,
                                color: AppColors.textPrimary,
                                size: 24,
                              ),
                              color: AppColors.secondary,
                              surfaceTintColor: AppColors.primary,
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                  child: GestureDetector(
                                    child: const Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => EditProjectPage(
                                            project: detailsState.project),
                                      ),
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    onTap: () {
                                      context.read<ProjectsBloc>().add(
                                            DeleteProject(
                                                project: detailsState.project),
                                          );

                                      Navigator.of(context).pop();
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        detailsState.project.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Time spent on project:',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    state.project.printTime(),
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const TimeSpinner(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      const Text(
                        'Description:',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            detailsState.project.description ?? '',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 50,
                      top: 20,
                    ),
                    child: BlocConsumer<TimeCounterBloc, TimeCounterState>(
                      listener: (context, state) {
                        if (state is TimeCounterInitial) {
                          context.read<TimeCounterBloc>().add(
                              InitializeTimeCounter(
                                  project: detailsState.project));
                        }
                      },
                      builder: (context, state) {
                        if (state is TimeCounterInitial) {
                          context.read<TimeCounterBloc>().add(
                              InitializeTimeCounter(
                                  project: detailsState.project));

                          return const CircularProgressIndicator();
                        }
                        if (state is TimeCounterWorking) {
                          return const StopCounterButton();
                        } else if (state is TimeCounterInitialized ||
                            state is TimeCounterStopped) {
                          return const StartCounterButton();
                        } else {
                          return const Text('Something went wrong');
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
