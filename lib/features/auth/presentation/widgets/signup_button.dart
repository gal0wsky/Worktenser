import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/auth/domain/entities/signup.dart';
import 'package:worktenser/features/auth/presentation/bloc/signup/signup_bloc.dart';

class SignupButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignupButton(
      {super.key,
      required this.emailController,
      required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return state is SignupSubmitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 40),
                    backgroundColor: AppColors.callToAction),
                onPressed: () {
                  final signupData = SignupEntity(
                      email: emailController.value.text,
                      password: passwordController.value.text);

                  context
                      .read<SignupBloc>()
                      .add(SignupRequested(signupData: signupData));
                },
                child: const Text('SIGN UP'),
              );
      },
    );
  }
}
