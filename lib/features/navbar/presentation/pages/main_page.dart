import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/navbar/presentation/bloc/navbar/navbar_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static Route get route {
    return MaterialPageRoute(builder: (_) => const MainPage());
  }

  static Page get page => const MaterialPage(child: MainPage());

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavbarBloc, NavbarState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.secondary,
          body: state.pages.elementAt(state.pageIndex),
          bottomNavigationBar: GNav(
            selectedIndex: context.read<NavbarBloc>().state.pageIndex,
            activeColor: AppColors.callToAction,
            backgroundColor: AppColors.secondary,
            color: AppColors.textSecondary,
            padding: EdgeInsets.only(
              left: 50,
              right: 50,
              bottom: Platform.isAndroid ? 15 : 30,
              top: Platform.isAndroid ? 10 : 20,
            ),
            iconSize: 25,
            tabs: const [
              GButton(icon: FontAwesomeIcons.solidRectangleList),
              GButton(icon: FontAwesomeIcons.solidSquarePlus),
              GButton(icon: FontAwesomeIcons.solidUser),
            ],
            onTabChange: (index) {
              context.read<NavbarBloc>().add(UpdatePageIndex(pageIndex: index));
            },
          ),
        );
      },
    );
  }
}
