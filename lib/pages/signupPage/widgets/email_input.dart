import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/cubits/signup/signup_cubit.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (email) {
            context.read<SignupCubit>().emailChanged(email);
          },
          style: const TextStyle(
            color: AppColors.textPrimary,
          ),
          decoration: const InputDecoration(
            labelText: 'email',
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
