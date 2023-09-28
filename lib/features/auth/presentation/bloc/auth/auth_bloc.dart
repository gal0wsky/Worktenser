import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:worktenser/features/auth/domain/entities/user.dart';
import 'package:worktenser/features/auth/domain/repository/auth_repository.dart';
import 'package:worktenser/features/auth/domain/usecases/logout.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<UserEntity>? _userSubscription;

  final LogoutUseCase _logoutUseCase;

  AuthBloc(
      {required AuthRepository authRepository,
      required LogoutUseCase logoutUseCase})
      : _authRepository = authRepository,
        _logoutUseCase = logoutUseCase,
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
    unawaited(_logoutUseCase.call());
  }

  @override
  Future close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
