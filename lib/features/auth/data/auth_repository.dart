import 'package:Messenger/features/auth/data/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserModel?> signIn(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return UserModel.fromFirebaseUser(credential.user);
    } catch (e) {
      // Handle the sign-in errors here
      print('Sign in error: $e');
      return null;
    }
  }

  Future<UserModel?> signUp(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return UserModel.fromFirebaseUser(credential.user);
    } catch (e) {
      // Handle the sign-up errors here
      print('Sign up error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      // Handle sign-out errors here
      print('Sign out error: $e');
    }
  }

  UserModel? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }
}
