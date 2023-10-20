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
                  final signupData = SignupEntity(
                      email: emailController.value.text,
                      password: passwordController.value.text);

                  FocusManager.instance.primaryFocus?.unfocus();

                  context
                      .read<SignupBloc>()
                      .add(SignupRequested(signupData: signupData));
                },
                child: const Text('Sign up'),
              );
      },
    );
  }
}
