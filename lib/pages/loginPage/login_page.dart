import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/cubits/login/login_cubit.dart';
import 'package:worktenser/domain/authentication/repositories/auth_repository.dart';

import 'widgets/email_input.dart';
import 'widgets/login_button.dart';
import 'widgets/password_input.dart';
import 'widgets/signup_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page get page => const MaterialPage(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocProvider(
        create: (_) =>
            LoginCubit(authRepository: context.read<AuthRepository>()),
        child: const Center(
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.error) {}
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
            EmailInput(),
            SizedBox(
              height: 16,
            ),
            PasswordInput(),
            SizedBox(
              height: 50,
            ),
            LoginButton(),
            SizedBox(
              height: 8,
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
