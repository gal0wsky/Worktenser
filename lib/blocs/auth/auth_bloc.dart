import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:worktenser/domain/authentication/models/user_model.dart';
import 'package:worktenser/domain/authentication/repositories/iauth_repository.dart';
import 'package:worktenser/domain/projects/projects.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _authRepository;
  final IProjectsLocalStorage _projectsLocalStorage;
  StreamSubscription<User>? _userSubscription;

  AuthBloc(
      {required IAuthRepository authRepository,
      required IProjectsLocalStorage projectsLocalStorage})
      : _authRepository = authRepository,
        _projectsLocalStorage = projectsLocalStorage,
        super(authRepository.currentUser.isNotEmpty
            ? AuthState.authenticated(authRepository.currentUser)
            : const AuthState.unauthenticated()) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);

    _userSubscription = _authRepository.user.listen(
      (user) => add(AppUserChanged(user)),
    );
  }

  void _onUserChanged(AppUserChanged event, Emitter<AuthState> emit) {
    emit(event.user.isNotEmpty
        ? AuthState.authenticated(event.user)
        : const AuthState.unauthenticated());
  }

  FutureOr<void> _onLogoutRequested(
      AppLogoutRequested event, Emitter<AuthState> emit) async {
    await _projectsLocalStorage.clear();
    unawaited(_authRepository.logOut());
  }

  @override
  Future close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
