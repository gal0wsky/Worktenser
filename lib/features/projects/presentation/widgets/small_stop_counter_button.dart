import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/timeCounter/presentation/bloc/time_counter/time_counter_bloc.dart';

class SmallStopCounterButton extends StatelessWidget {
  const SmallStopCounterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        FontAwesomeIcons.solidCircleStop,
        color: AppColors.callToAction,
      ),
      iconSize: 40,
      onPressed: () {
        context.read<TimeCounterBloc>().add(StopTimeCounter());
      },
    );
  }
}
