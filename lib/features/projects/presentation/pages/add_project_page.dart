import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:worktenser/features/navbar/presentation/bloc/navbar/navbar_bloc.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/presentation/bloc/projects/projects_bloc.dart';
import 'package:worktenser/features/projects/presentation/widgets/project_description_input.dart';
import 'package:worktenser/features/projects/presentation/widgets/project_name_input.dart';

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
      resizeToAvoidBottomInset: false,
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
                          'Add project',
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
                )),
                Align(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(300, 50),
                          backgroundColor: AppColors.callToAction,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        final project = ProjectEntity(
                          name: nameController.value.text,
                          description: descriptionController.value.text,
                          userId: context.read<AuthBloc>().state.user.id,
                        );

                        context
                            .read<ProjectsBloc>()
                            .add(AddProject(project: project));

                        context
                            .read<NavbarBloc>()
                            .add(const UpdatePageIndex(pageIndex: 0));
                      },
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
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
