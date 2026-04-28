import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../domain/entities/user.dart';

class FirebaseAuthDataSource {
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges =>
      _auth.authStateChanges().map(_mapFirebaseUser);

  Future<User?> getCurrentUser() async {
    return _mapFirebaseUser(_auth.currentUser);
  }

  Future<User> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign in cancelled');
    }

    final googleAuth = await googleUser.authentication;
    final credential = firebase.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCred = await _auth.signInWithCredential(credential);
    final user = _mapFirebaseUser(userCred.user);
    if (user == null) {
      throw Exception('Failed to get user after sign in');
    }
    return user;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<String?> getIdToken() async {
    return _auth.currentUser?.getIdToken();
  }

  User? _mapFirebaseUser(firebase.User? fbUser) {
    if (fbUser == null) return null;
    return User(
      id: fbUser.uid,
      email: fbUser.email ?? '',
      displayName: fbUser.displayName ?? '',
      photoURL: fbUser.photoURL,
      phone: fbUser.phoneNumber,
    );
  }
}
