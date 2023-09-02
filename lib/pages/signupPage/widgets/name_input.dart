import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/cubits/signup/signup_cubit.dart';

class NameInput extends StatelessWidget {
  const NameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (name) {
            context.read<SignupCubit>().nameChanged(name);
          },
          style: const TextStyle(
            color: AppColors.textPrimary,
          ),
          decoration: const InputDecoration(
            labelText: 'name',
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
        );
      },
    );
  }
}
