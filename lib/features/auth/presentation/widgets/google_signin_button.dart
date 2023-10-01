import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/features/auth/presentation/bloc/login/login_bloc.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return state is LoginSubmitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 40),
                    backgroundColor: Colors.grey.shade800),
                onPressed: () {
                  context.read<LoginBloc>().add(GoogleLoginRequested());
                },
                child: const Text('GOOGLE SIGN IN'),
              );
      },
    );
  }
}
