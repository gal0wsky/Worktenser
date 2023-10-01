import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/auth/presentation/bloc/signup/signup_bloc.dart';
import 'package:worktenser/injection_container.dart';

import '../widgets/email_input.dart';
import '../widgets/password_input.dart';
import '../widgets/signup_button.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  static Route get route {
    return MaterialPageRoute(builder: (_) => const SignupPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocProvider<SignupBloc>(
        create: (_) => sl(),
        child: SignupForm(),
      ),
    );
  }
}

class SignupForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupError) {}
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Worktenser',
              style: TextStyle(
                fontSize: 40,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 120,
            ),
            EmailInput(
              valueController: emailController,
            ),
            const SizedBox(
              height: 16,
            ),
            PasswordInput(
              valueController: passwordController,
            ),
            const SizedBox(
              height: 50,
            ),
            SignupButton(
              emailController: emailController,
              passwordController: passwordController,
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
