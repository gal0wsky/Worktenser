import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/auth/domain/entities/login.dart';
import 'package:worktenser/features/auth/presentation/bloc/login/login_bloc.dart';

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginButton(
      {super.key,
      required this.emailController,
      required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return state is LoginSubmitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 50),
                  backgroundColor: AppColors.callToAction,
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  final loginData = LoginEntity(
                      email: emailController.value.text,
                      password: passwordController.value.text);

                  FocusManager.instance.primaryFocus?.unfocus();

                  context
                      .read<LoginBloc>()
                      .add(CredentialsLoginRequested(loginData: loginData));
                },
                child: const Text(
                  'Sign in',
                ),
              );
      },
    );
  }
}
