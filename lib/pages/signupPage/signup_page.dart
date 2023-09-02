import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/cubits/signup/signup_cubit.dart';
import 'package:worktenser/domain/authentication/repositories/auth_repository.dart';

import 'widgets/email_input.dart';
import 'widgets/name_input.dart';
import 'widgets/password_input.dart';
import 'widgets/signup_button.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  static Route get route {
    return MaterialPageRoute(builder: (_) => const SignupPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocProvider(
        create: (_) => SignupCubit(context.read<AuthRepository>()),
        child: const SignupForm(),
      ),
    );
  }
}

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.status == SignupStatus.error) {}
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Worktenser',
              style: TextStyle(
                fontSize: 40,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 120,
            ),
            NameInput(),
            SizedBox(
              height: 16,
            ),
            EmailInput(),
            SizedBox(
              height: 16,
            ),
            PasswordInput(),
            SizedBox(
              height: 50,
            ),
            SignupButton(),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
