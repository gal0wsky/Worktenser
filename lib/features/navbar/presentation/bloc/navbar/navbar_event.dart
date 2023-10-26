part of 'navbar_bloc.dart';

sealed class NavbarEvent extends Equatable {
  const NavbarEvent();

  @override
  List<Object> get props => [];
}

final class UpdatePageIndex extends NavbarEvent {
  final int pageIndex;

  const UpdatePageIndex({required this.pageIndex});

  @override
  List<Object> get props => [pageIndex];
}
