import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/blocs/auth/auth_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/cubits/projects/projects_cubit.dart';
import 'package:worktenser/domain/projects/models/project_model.dart';

class EditProjectPage extends StatelessWidget {
  final Project project;

  const EditProjectPage({super.key, required this.project});

  // static Page get page => const MaterialPage(child: EditProjectPage());

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocBuilder<ProjectsCubit, ProjectsState>(
        builder: (context, state) {
          if (state.status == ProjectsStatus.loading) {
            return const CircularProgressIndicator();
          } else if (state.status == ProjectsStatus.error) {
            return const Text('Something went wrong!');
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
                  decoration: InputDecoration(
                    labelText: 'project name',
                    labelStyle: const TextStyle(
                      color: AppColors.textPrimary,
                    ),
                    hintText: project.name,
                    filled: true,
                    fillColor: AppColors.secondary,
                    focusedBorder: const UnderlineInputBorder(
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
                  decoration: InputDecoration(
                    labelText: project.description,
                    labelStyle: const TextStyle(
                      color: AppColors.textPrimary,
                    ),
                    filled: true,
                    fillColor: AppColors.secondary,
                    focusedBorder: const UnderlineInputBorder(
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
                    final updatedProject = Project(
                      id: project.id,
                      name: nameController.value.text,
                      description: descriptionController.value.text,
                      userId: context.read<AuthBloc>().state.user.id,
                    );

                    context.read<ProjectsCubit>().addProject(updatedProject);
                    Navigator.of(context).pop();
                  },
                  child: const Text('SAVE'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
