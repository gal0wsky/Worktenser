import 'package:flutter/material.dart';
import 'package:worktenser/blocs/auth/auth_bloc.dart';
import 'package:worktenser/pages/homePage/home_page.dart';
import 'package:worktenser/pages/loginPage/login_page.dart';

List<Page> onGenerateAppViewPages(AuthStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AuthStatus.authenticated:
      return [HomePage.page];
    case AuthStatus.unauthenticated:
      return [LoginPage.page];
  }
}
