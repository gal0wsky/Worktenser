// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/auth/presentation/bloc/login/login_bloc.dart';

class PasswordInput extends StatelessWidget {
  final TextEditingController valueController;

  const PasswordInput({
    Key? key,
    required this.valueController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          controller: valueController,
          style: const TextStyle(
            color: AppColors.textPrimary,
          ),
          decoration: const InputDecoration(
            labelText: 'Password',
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
          obscureText: true,
        );
      },
    );
  }
}
