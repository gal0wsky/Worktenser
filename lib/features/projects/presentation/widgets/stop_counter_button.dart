import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/timeCounter/presentation/bloc/time_counter/time_counter_bloc.dart';

class StopCounterButton extends StatelessWidget {
  const StopCounterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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
          context.read<TimeCounterBloc>().add(StopTimeCounter());
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.stop,
              color: AppColors.textPrimary,
              size: 16,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Stop',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontSize: 18,
              ),
            ),
          ],
        ));
  }
}
