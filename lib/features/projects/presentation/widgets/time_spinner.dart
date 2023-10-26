import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/projects/presentation/bloc/project_details/project_details_bloc.dart';

class TimeSpinner extends StatefulWidget {
  final double size;
  final double thickness;
  final Color color;

  const TimeSpinner({
    super.key,
    this.size = 60.0,
    this.thickness = 5.0,
    this.color = AppColors.callToAction,
  });

  @override
  State<TimeSpinner> createState() => _TimeSpinnerState();
}

class _TimeSpinnerState extends State<TimeSpinner> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: CircularProgressIndicator(
            value: 1,
            strokeWidth: widget.thickness,
            color: AppColors.secondary,
          ),
        ),
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: BlocBuilder<ProjectDetailsBloc, ProjectDetailsState>(
            builder: (context, state) {
              if (state is ProjectDetailsLoaded) {
                return CircularProgressIndicator(
                  value: (state.project.time % 60.0) / 60,
                  strokeWidth: widget.thickness,
                  color: widget.color,
                );
              }

              return CircularProgressIndicator(
                value: 0,
                strokeWidth: widget.thickness,
                color: widget.color,
              );
            },
          ),
        ),
      ],
    );
  }
}
