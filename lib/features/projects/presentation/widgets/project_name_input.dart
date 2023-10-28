import 'package:flutter/material.dart';
import 'package:worktenser/config/colors.dart';

class ProjectNameInput extends StatelessWidget {
  final TextEditingController valueController;

  const ProjectNameInput({super.key, required this.valueController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: valueController,
      style: const TextStyle(
        color: AppColors.textPrimary,
      ),
      decoration: const InputDecoration(
        labelText: 'Project name',
        labelStyle: TextStyle(
          color: AppColors.textPrimary,
        ),
        filled: false,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.secondary,
            width: 3,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.callToAction,
            width: 2,
          ),
        ),
      ),
      cursorColor: AppColors.callToAction,
    );
  }
}
