import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worktenser/features/navbar/presentation/bloc/navbar/navbar_bloc.dart';

void main() {
  late NavbarBloc bloc;

  test('Create NavbarBloc test', () {
    final navbarBloc = NavbarBloc();

    expect(navbarBloc.state.pageIndex, 0);
  });

  blocTest<NavbarBloc, NavbarState>(
    'Update Navbar page index test',
    build: () {
      bloc = NavbarBloc();

      return bloc;
    },
    act: (bloc) => bloc.add(
      const UpdatePageIndex(pageIndex: 1),
    ),
    wait: const Duration(milliseconds: 100),
    expect: () => <NavbarState>[
      const NavbarState(pageIndex: 1),
    ],
  );
}
