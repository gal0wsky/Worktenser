import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/presentation/bloc/projects/projects_bloc.dart';

class AddProjectPage extends StatelessWidget {
  const AddProjectPage({super.key});

  static Route get route {
    return MaterialPageRoute(builder: (_) => const AddProjectPage());
  }

  static Page get page => const MaterialPage(child: AddProjectPage());

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocBuilder<ProjectsBloc, ProjectsState>(
        builder: (context, state) {
          if (state is ProjectsLoading) {
            return const CircularProgressIndicator();
          } else if (state is ProjectsError) {
            return Text(state.message);
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 120,
                ),
                TextField(
                  controller: nameController,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'project name',
                    labelStyle: TextStyle(
                      color: AppColors.textPrimary,
                    ),
                    filled: true,
                    fillColor: AppColors.secondary,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.callToAction,
                        width: 2,
                      ),
                    ),
                  ),
                  cursorColor: AppColors.callToAction,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: descriptionController,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'description',
                    labelStyle: TextStyle(
                      color: AppColors.textPrimary,
                    ),
                    filled: true,
                    fillColor: AppColors.secondary,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.callToAction,
                        width: 2,
                      ),
                    ),
                  ),
                  cursorColor: AppColors.callToAction,
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 40),
                      backgroundColor: AppColors.callToAction),
                  onPressed: () {
                    final project = ProjectEntity(
                      name: nameController.value.text,
                      description: descriptionController.value.text,
                      userId: context.read<AuthBloc>().state.user.id,
                    );

                    context
                        .read<ProjectsBloc>()
                        .add(AddProject(project: project));
                    Navigator.of(context).pop();
                  },
                  child: const Text('ADD'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
