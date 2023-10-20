import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:worktenser/features/projects/presentation/bloc/project_details/project_details_bloc.dart';
import 'package:worktenser/features/projects/presentation/bloc/projects/projects_bloc.dart';

import 'add_project_page.dart';
import 'project_details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route get route {
    return MaterialPageRoute(builder: (_) => const HomePage());
  }

  static Page get page => const MaterialPage(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 120,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to ',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Worktenser',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.callToAction,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(AppLogoutRequested());
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(
                  200,
                  40,
                ),
                backgroundColor: AppColors.callToAction,
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddProjectPage()));
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(
                  200,
                  40,
                ),
                backgroundColor: AppColors.callToAction,
              ),
              child: const Text('Add project'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ProjectsBloc>().add(
                    LoadProjects(user: context.read<AuthBloc>().state.user));
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(
                  200,
                  40,
                ),
                backgroundColor: AppColors.callToAction,
              ),
              child: const Text('Load projects'),
            ),
            BlocConsumer<ProjectsBloc, ProjectsState>(
                listener: (context, state) {
              if (state is ProjectsReloading) {
                context.read<ProjectsBloc>().add(
                    LoadProjects(user: context.read<AuthBloc>().state.user));
              }
            }, builder: (context, state) {
              if (state is ProjectsInitial) {
                context.read<ProjectsBloc>().add(
                    LoadProjects(user: context.read<AuthBloc>().state.user));
                return const CircularProgressIndicator();
              } else if (state is ProjectsError) {
                return Text(state.message);
              } else if (state is ProjectsReloading) {
                return const CircularProgressIndicator();
              } else if (state is ProjectsLoaded) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.projectsCount,
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: ListTile(
                            title: Text(
                              '${state.projects[index].name}\t${state.projects[index].printTime()}',
                              style: const TextStyle(
                                fontSize: 20,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            onTap: () {
                              context.read<ProjectDetailsBloc>().add(
                                    LoadProjectDetails(
                                      project: state.projects[index],
                                    ),
                                  );

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const DetailsPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                );
              } else {
                return const Text('Something went wrong');
              }
            }),
          ],
        ),
      ),
    );
  }
}
