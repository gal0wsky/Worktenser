import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/searchbar/presentation/bloc/searchbar/searchbar_bloc.dart';

class Searchbar extends StatelessWidget {
  const Searchbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          cursorColor: AppColors.callToAction,
          decoration: const InputDecoration(
            fillColor: AppColors.secondary,
            iconColor: AppColors.textSecondary,
            hintText: 'Search',
            hintStyle: TextStyle(color: AppColors.textSecondary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.secondary,
                width: 0,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.secondary,
                width: 0,
              ),
            ),
            focusColor: AppColors.callToAction,
          ),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
          onChanged: (value) => context.read<SearchbarBloc>().add(
                UpdateSearchPhrase(searchPhrase: value),
              ),
        ),
      ),
    );
  }
}
