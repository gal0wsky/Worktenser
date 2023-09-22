// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:worktenser/blocs/auth/auth_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/cubits/projects/projects_cubit.dart';
import 'package:worktenser/domain/projects/src/models/project_model.dart';
import 'package:worktenser/domain/timeCounter/timeCounter.dart';
import 'package:worktenser/pages/editProjectPage/edit_project_page.dart';

class DetailsPage extends StatefulWidget {
  final Project project;

  const DetailsPage({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Project project = widget.project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocConsumer<ProjectsCubit, ProjectsState>(
        listener: (context, state) async {
          if (state is ProjectsReload) {
            await context
                .read<ProjectsCubit>()
                .loadProjects(context.read<AuthBloc>().state.user);
          }
          if (state is ProjectsLoaded) {
            final state = context.read<ProjectsCubit>().state as ProjectsLoaded;
            setState(() {
              project =
                  state.projects.firstWhere((proj) => proj.id == project.id);
            });
          }
        },
        builder: (context, state) {
          if (state is ProjectsLoading || state is ProjectsReload) {
            return const CircularProgressIndicator();
          } else if (state is ProjectsLoadingError) {
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
                        context.read<ProjectsCubit>().deleteProject(project);
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
              ElevatedButton(
                onPressed: () async {
                  // currentCounterProject = project;
                  updateCurrentTimerProject(project);
                  await FlutterBackgroundService().startService();
                },
                child: const Text(
                  'Start',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  FlutterBackgroundService().invoke('stopTimeCounter');
                },
                child: const Text(
                  'Stop',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
