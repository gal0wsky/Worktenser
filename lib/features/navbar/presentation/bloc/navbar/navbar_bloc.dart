import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:worktenser/features/projects/presentation/pages/add_project_page.dart';
import 'package:worktenser/features/projects/presentation/pages/home_page.dart';

part 'navbar_event.dart';
part 'navbar_state.dart';

class NavbarBloc extends Bloc<NavbarEvent, NavbarState> {
  NavbarBloc() : super(const NavbarState(pageIndex: 0)) {
    on<UpdatePageIndex>(_onUpdatePageIndex);
  }

  void _onUpdatePageIndex(UpdatePageIndex event, Emitter<NavbarState> emit) {
    emit(NavbarState(pageIndex: event.pageIndex, pages: state.pages));
  }
}
