import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:worktenser/config/colors.dart';
import 'package:worktenser/features/projects/presentation/pages/add_project_page.dart';
import 'package:worktenser/features/projects/presentation/pages/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static Route get route {
    return MaterialPageRoute(builder: (_) => const MainPage());
  }

  static Page get page => const MaterialPage(child: MainPage());

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _pageIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    AddProjectPage(),
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: _pages.elementAt(_pageIndex),
      bottomNavigationBar: GNav(
        selectedIndex: 0,
        activeColor: AppColors.callToAction,
        backgroundColor: AppColors.secondary,
        color: AppColors.textSecondary,
        padding: const EdgeInsets.only(
          left: 50,
          right: 50,
          bottom: 15,
          top: 10,
        ),
        iconSize: 25,
        tabs: const [
          GButton(icon: FontAwesomeIcons.solidRectangleList),
          GButton(icon: FontAwesomeIcons.solidSquarePlus),
          GButton(icon: FontAwesomeIcons.solidUser),
        ],
        onTabChange: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }
}
