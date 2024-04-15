// data/user_model.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../domain/user.dart';

class UserModel extends AppUser {
  UserModel({required String id, required String email}) : super(id: id, email: email);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
    );
  }

  factory UserModel.fromFirebaseUser(firebase_auth.User? user) {
    if (user == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'ERROR_NO_USER',
        message: 'No user found for the provided user entity',
      );
    }
    // Assuming email is not null for the authenticated Firebase user
    return UserModel(id: user.uid, email: user.email!);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
    };
  }
}
