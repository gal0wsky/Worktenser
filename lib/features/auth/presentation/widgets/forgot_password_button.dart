import 'package:flutter/material.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/auth/presentation/pages/reset_password_page.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(ResetPasswordPage.route);
      },
      style: const ButtonStyle(),
      child: const Text(
        'Forgot password',
        style: TextStyle(
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
