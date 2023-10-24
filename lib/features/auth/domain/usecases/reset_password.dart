import 'package:worktenser/core/usecase/usecase.dart';
import 'package:worktenser/features/auth/domain/repository/auth_repository.dart';

class ResetPasswordUseCase extends UseCase<bool, String> {
  final AuthRepository _authRepository;

  ResetPasswordUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<bool> call({String? params}) {
    return _authRepository.resetPassword(email: params!);
  }
}
