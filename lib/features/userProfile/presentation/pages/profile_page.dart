import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/core/util/project_time_formatter.dart';
import 'package:worktenser/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:worktenser/features/projects/presentation/bloc/projects/projects_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(children: [
          Expanded(
            child: Column(children: [
              const SizedBox(
                height: 120,
              ),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: AppColors.textPrimary),
                  ),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: ((context, state) {
                  return Text(
                    state.user.email!,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ),
              const SizedBox(
                height: 80,
              ),
              BlocBuilder<ProjectsBloc, ProjectsState>(
                builder: ((context, state) {
                  if (state is ProjectsLoaded) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 37),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                state.projects.length.toString(),
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              const Text(
                                'projects',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                printTotalProjectsTime(state.projectsTime),
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              const Text(
                                'total time',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }

                  return const SizedBox(
                    height: 1,
                  );
                }),
              ),
            ]),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: OutlinedButton(
                  onPressed: () =>
                      context.read<AuthBloc>().add(AppLogoutRequested()),
                  style: OutlinedButton.styleFrom(
                    fixedSize: const Size(
                      200,
                      40,
                    ),
                    foregroundColor: AppColors.textPrimary,
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Colors.red, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.rightFromBracket,
                        size: 14,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Sign out',
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  )),
            ),
          ),
        ]),
      ),
    );
  }
}
