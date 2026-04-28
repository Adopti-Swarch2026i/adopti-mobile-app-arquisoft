import '../entities/user.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  Future<User?> getCurrentUser();
  Future<User> signInWithGoogle();
  Future<void> signOut();
  Future<String> getIdToken();
}
