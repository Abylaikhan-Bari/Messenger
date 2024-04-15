import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../domain/user.dart';

class UserModel extends AppUser {
  UserModel({required String id, required String email, required String name})
      : super(id: id, email: email, name: name);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }

  factory UserModel.fromFirebaseUser(firebase_auth.User? user) {
    if (user == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'ERROR_NO_USER',
        message: 'No user found for the provided user entity',
      );
    }
    return UserModel(
        id: user.uid,
        email: user.email!,
        name: 'Default Name'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }
}
