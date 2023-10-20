import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:worktenser/features/auth/presentation/bloc/signup/signup_bloc.dart';
import 'package:worktenser/features/auth/presentation/pages/signup_page.dart';
import 'package:worktenser/features/auth/presentation/widgets/email_input.dart';
import 'package:worktenser/features/auth/presentation/widgets/forgot_password_button.dart';
import 'package:worktenser/features/auth/presentation/widgets/google_signin_button.dart';
import 'package:worktenser/features/auth/presentation/widgets/login_button.dart';
import 'package:worktenser/features/auth/presentation/widgets/password_input.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route get route {
    return MaterialPageRoute(builder: (_) => const LoginPage());
  }

  static Page get page => const MaterialPage(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primary,
      body: Center(
        child: LoginForm(),
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
      listener: (ctx, state) {
        if (state is LoginError) {}

        if (state is LoginSuccessful) {
          // context.flow<Page>().update((state) => HomePage.page);
          // Navigator.of(context).pushReplacement(HomePage.route);
        }
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
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 100),
                        child: Text(
                          'Worktenser',
                          style: TextStyle(
                            fontSize: 40,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      EmailInput(
                        valueController: emailController,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      PasswordInput(valueController: passwordController),
                      const SizedBox(
                        height: 100,
                      ),
                      LoginButton(
                        emailController: emailController,
                        passwordController: passwordController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const GoogleSignInButton(),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      const ForgotPasswordButton(),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 84,
                        ),
                        child: TextButton(
                          onPressed: () {
                            context.read<SignupBloc>().add(ResetState());

                            emailController.clear();
                            passwordController.clear();

                            Navigator.of(context).push<void>(SignupPage.route);
                          },
                          style: const ButtonStyle(),
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
