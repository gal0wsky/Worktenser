import 'package:flutter/material.dart';
import 'package:worktenser/config/colors.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: const ButtonStyle(),
      child: const Padding(
        padding: EdgeInsets.only(bottom: 94),
        child: Text(
          'Forgot password',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.callToAction,
          ),
        ),
      ),
    );
  }
}
