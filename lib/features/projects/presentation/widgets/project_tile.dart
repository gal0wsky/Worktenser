import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/core/util/project_time_formatter.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/presentation/bloc/project_details/project_details_bloc.dart';
import 'package:worktenser/features/projects/presentation/pages/project_details_page.dart';
import 'package:worktenser/features/timeCounter/presentation/bloc/time_counter/time_counter_bloc.dart';

import 'small_start_counter_button.dart';
import 'small_stop_counter_button.dart';

class ProjectTile extends StatelessWidget {
  final ProjectEntity project;

  const ProjectTile({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 300,
        height: 140,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    printProjectTime(project),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  BlocBuilder<TimeCounterBloc, TimeCounterState>(
                      builder: (context, state) {
                    if (state is TimeCounterInitialized ||
                        state is TimeCounterStopped) {}

                    if (state is TimeCounterWorking) {
                      if (state.project!.id == project.id) {
                        return const SmallStopCounterButton();
                      }
                    }
                    return const SmallStartCounterButton();
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        context
            .read<ProjectDetailsBloc>()
            .add(LoadProjectDetails(project: project));

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailsPage(),
          ),
        );
      },
    );
  }
}
