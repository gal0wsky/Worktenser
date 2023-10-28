part of 'navbar_bloc.dart';

class NavbarState extends Equatable {
  final int pageIndex;
  final List<Widget> pages;

  const NavbarState(
      {this.pageIndex = 0,
      this.pages = const [HomePage(), AddProjectPage(), ProfilePage()]});

  @override
  List<Object> get props => [pageIndex, pages];
}
