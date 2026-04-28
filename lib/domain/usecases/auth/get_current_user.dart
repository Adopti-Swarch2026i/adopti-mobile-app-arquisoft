import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository _repository;

  const GetCurrentUser(this._repository);

  Future<User?> call() => _repository.getCurrentUser();
}
