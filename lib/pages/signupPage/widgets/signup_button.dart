import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/cubits/signup/signup_cubit.dart';

class SignupButton extends StatelessWidget {
  const SignupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == SignupStatus.submitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 40),
                    backgroundColor: AppColors.callToAction),
                onPressed: () {
                  context.read<SignupCubit>().signUpWithEmailAndPassword();
                },
                child: const Text('SIGN UP'),
              );
      },
    );
  }
}
