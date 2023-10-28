import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/presentation/bloc/project_details/project_details_bloc.dart';
import 'package:worktenser/features/projects/presentation/bloc/projects/projects_bloc.dart';
import 'package:worktenser/features/projects/presentation/widgets/project_description_input.dart';
import 'package:worktenser/features/projects/presentation/widgets/project_name_input.dart';

class EditProjectPage extends StatelessWidget {
  final ProjectEntity project;

  const EditProjectPage({super.key, required this.project});

  // static Page get page => const MaterialPage(child: EditProjectPage());

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.primary,
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<ProjectDetailsBloc, ProjectDetailsState>(
        builder: (context, state) {
          if (state is ProjectDetailsLoading) {
            return const CircularProgressIndicator();
          } else if (state is ProjectDetailsError) {
            return Text(state.message);
          } else if (state is ProjectDetailsLoaded) {
            nameController.value = TextEditingValue(text: project.name);
            descriptionController.value =
                TextEditingValue(text: project.description ?? '');

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 120,
                        ),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit project',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        ProjectNameInput(valueController: nameController),
                        const SizedBox(
                          height: 60,
                        ),
                        ProjectDescriptionInput(
                            valueController: descriptionController),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(300, 50),
                          backgroundColor: AppColors.callToAction,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          final updatedProject = ProjectEntity(
                            id: project.id,
                            name: nameController.value.text,
                            description: descriptionController.value.text,
                            userId: context.read<AuthBloc>().state.user.id,
                          );

                          context
                              .read<ProjectsBloc>()
                              .add(UpdateProject(project: updatedProject));
                          Navigator.of(context).pop();
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return const SizedBox(
            height: 1,
          );
        },
      ),
    );
  }
}
