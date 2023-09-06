import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/blocs/auth/auth_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/cubits/projects/projects_cubit.dart';
import 'package:worktenser/pages/addProjectPage/add_project_page.dart';
import 'package:worktenser/pages/projectDetailsPge/project_details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                context
                    .read<ProjectsCubit>()
                    .loadProjects(context.read<AuthBloc>().state.user);
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
            BlocConsumer<ProjectsCubit, ProjectsState>(
                listener: (context, state) {
              if (state.status == ProjectsStatus.reload) {
                context
                    .read<ProjectsCubit>()
                    .loadProjects(context.read<AuthBloc>().state.user);
              }
            }, builder: (context, state) {
              if (state.status == ProjectsStatus.initial) {
                context.read<ProjectsCubit>().loadProjects(
                      context.read<AuthBloc>().state.user,
                    );
                return const CircularProgressIndicator();
              } else if (state.status == ProjectsStatus.error) {
                return const Text('Something went wrong');
              } else if (state.status == ProjectsStatus.reload) {
                return const CircularProgressIndicator();
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount:
                        context.read<ProjectsCubit>().state.projectsCount,
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: ListTile(
                            title: Text(
                              context
                                  .read<ProjectsCubit>()
                                  .state
                                  .projects[index]
                                  .name,
                              style: const TextStyle(
                                fontSize: 20,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => DetailsPage(
                                      project: context
                                          .read<ProjectsCubit>()
                                          .state
                                          .projects[index]),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
