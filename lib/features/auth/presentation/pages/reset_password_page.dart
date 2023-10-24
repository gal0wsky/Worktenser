import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/auth/presentation/bloc/resetPassword/reset_password_bloc.dart';
import 'package:worktenser/features/auth/presentation/widgets/email_input.dart';

class ResetPasswordPage extends StatelessWidget {
  final emailController = TextEditingController();

  ResetPasswordPage({super.key});

  static Route get route {
    return MaterialPageRoute(builder: (_) => ResetPasswordPage());
  }

  static Page get page => MaterialPage(child: ResetPasswordPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.secondary,
              ),
            );
          }

          if (state is ResetPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Reset password email has been sent.'),
                backgroundColor: AppColors.secondary,
              ),
            );

            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 100),
                      child: Text(
                        'Reset your password',
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
                      height: 100,
                    ),
                    (() {
                      if (state is ResetPasswordSubmitting) {
                        return const CircularProgressIndicator();
                      } else {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.callToAction,
                            fixedSize: const Size(300, 50),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Reset password'),
                          onPressed: () {
                            context.read<ResetPasswordBloc>().add(
                                ResetUserPassword(
                                    email: emailController.value.text));
                          },
                        );
                      }
                    }()),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
