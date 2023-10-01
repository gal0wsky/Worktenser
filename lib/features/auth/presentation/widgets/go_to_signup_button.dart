import 'package:flutter/material.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/pages/signupPage/signup_page.dart';

class GoToSignupButton extends StatelessWidget {
  const GoToSignupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade800,
        fixedSize: const Size(200, 40),
      ),
      onPressed: () => Navigator.of(context).push<void>(SignupPage.route),
      child: const Text(
        'CREATE ACCOUNT',
        style: TextStyle(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
