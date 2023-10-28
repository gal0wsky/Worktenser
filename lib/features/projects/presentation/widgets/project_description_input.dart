import 'package:flutter/material.dart';
import 'package:worktenser/config/colors.dart';

class ProjectDescriptionInput extends StatelessWidget {
  final TextEditingController valueController;

  const ProjectDescriptionInput({super.key, required this.valueController});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 300),
      child: TextField(
        controller: valueController,
        maxLength: 1000,
        maxLines: 10,
        minLines: 1,
        style: const TextStyle(
          color: AppColors.textPrimary,
        ),
        decoration: const InputDecoration(
          labelText: 'Description',
          labelStyle: TextStyle(
            color: AppColors.textPrimary,
          ),
          helperStyle: TextStyle(
            color: AppColors.textSecondary,
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
      ),
    );
  }
}
