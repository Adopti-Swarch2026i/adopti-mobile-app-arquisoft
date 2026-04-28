import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository _repository;

  const SignInWithGoogle(this._repository);

  Future<User> call() => _repository.signInWithGoogle();
}
