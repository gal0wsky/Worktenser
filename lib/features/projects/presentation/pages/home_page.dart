import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:worktenser/features/projects/presentation/bloc/projects/projects_bloc.dart';
import 'package:worktenser/features/projects/presentation/widgets/project_tile.dart';
import 'package:worktenser/features/searchbar/presentation/bloc/searchbar/searchbar_bloc.dart';
import 'package:worktenser/features/searchbar/presentation/widgets/searchbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route get route {
    return MaterialPageRoute(builder: (_) => const HomePage());
  }

  static Page get page => const MaterialPage(child: HomePage());

  void _loadProjectsOnBuildIfNeeded(BuildContext context) {
    final state = context.read<ProjectsBloc>().state;

    if (state is ProjectsInitial) {
      context
          .read<ProjectsBloc>()
          .add(LoadProjects(user: context.read<AuthBloc>().state.user));

      context.read<SearchbarBloc>().add(SearchForPhrase());
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadProjectsOnBuildIfNeeded(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocListener<ProjectsBloc, ProjectsState>(
        listener: (context, state) {
          if (state is ProjectsReloading) {
            context
                .read<ProjectsBloc>()
                .add(LoadProjects(user: context.read<AuthBloc>().state.user));
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: Platform.isAndroid ? 60 : 80, bottom: 20),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Projects',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Searchbar(),
                BlocConsumer<SearchbarBloc, SearchbarState>(
                    listener: (context, state) {
                  if (state is SearchPhraseUpdated) {
                    context.read<SearchbarBloc>().add(SearchForPhrase());
                  }
                }, builder: (context, state) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.filteredProjects.length,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ProjectTile(
                              project: state.filteredProjects[index]),
                        );
                      }),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
