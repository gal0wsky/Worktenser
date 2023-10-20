import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/auth/presentation/bloc/signup/signup_bloc.dart';

import '../widgets/email_input.dart';
import '../widgets/password_input.dart';
import '../widgets/signup_button.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  static Route get route {
    return MaterialPageRoute(builder: (_) => const SignupPage());
  }

  static Page get page => const MaterialPage(child: SignupPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primary,
      body: SignupForm(),
    );
  }
}

class SignupForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignupState>(listener: (context, state) {
      if (state is SignupError) {}
    }, builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Create account',
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
                  (() {
                    if (state is SignupError) {
                      FocusManager.instance.primaryFocus?.unfocus();

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 50,
                            ),
                            child: Text(
                              state.message,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox(
                        height: 90,
                      );
                    }
                  }()),
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
          ],
        ),
      );
    });
  }
}
