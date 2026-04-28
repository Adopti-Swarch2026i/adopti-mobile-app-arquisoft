import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Stream<User?> get authStateChanges => _dataSource.authStateChanges;

  @override
  Future<User?> getCurrentUser() => _dataSource.getCurrentUser();

  @override
  Future<User> signInWithGoogle() => _dataSource.signInWithGoogle();

  @override
  Future<void> signOut() => _dataSource.signOut();

  @override
  Future<String> getIdToken() async {
    final token = await _dataSource.getIdToken();
    if (token == null) {
      throw Exception('No authenticated user');
    }
    return token;
  }
}
