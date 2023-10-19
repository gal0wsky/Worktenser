import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:worktenser/features/auth/presentation/widgets/email_input.dart';
import 'package:worktenser/features/auth/presentation/widgets/forgot_password_button.dart';
import 'package:worktenser/features/auth/presentation/widgets/google_signin_button.dart';
import 'package:worktenser/features/auth/presentation/widgets/login_button.dart';
import 'package:worktenser/features/auth/presentation/widgets/password_input.dart';
import 'package:worktenser/injection_container.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page get page => const MaterialPage(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primary,
      body: BlocProvider<LoginBloc>(
        create: (context) => sl(),
        child: Center(
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginError) {}
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginError) {
            return const Text('Something went wrong!');
          }
          if (state is LoginSubmitting) {
            return const CircularProgressIndicator();
          }
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
                      PasswordInput(valueController: passwordController),
                      const SizedBox(
                        height: 50,
                      ),
                      LoginButton(
                        emailController: emailController,
                        passwordController: passwordController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const GoogleSignInButton(),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: ForgotPasswordButton(),
                ),
                // const Text(
                //   'Worktenser',
                //   style: TextStyle(
                //     fontSize: 40,
                //     color: AppColors.textPrimary,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // const SizedBox(
                //   height: 120,
                // ),
                // EmailInput(
                //   valueController: emailController,
                // ),
                // const SizedBox(
                //   height: 16,
                // ),
                // PasswordInput(valueController: passwordController),
                // const SizedBox(
                //   height: 50,
                // ),
                // LoginButton(
                //   emailController: emailController,
                //   passwordController: passwordController,
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                // const GoogleSignInButton(),
                // const SizedBox(
                //   height: 8,
                // ),
                // const ForgotPasswordButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}
