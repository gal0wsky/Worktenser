import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/blocs/auth/auth_bloc.dart';
import 'package:worktenser/config/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page get page => const MaterialPage(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to ',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Worktenser',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.callToAction,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AppLogoutRequested());
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(
                    200,
                    40,
                  ),
                  backgroundColor: AppColors.callToAction,
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
