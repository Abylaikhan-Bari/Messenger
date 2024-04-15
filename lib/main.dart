import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'features/messaging/presentation/pages/chats_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/registration_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messenger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // Checking the auth state - is the user logged in or not
            User? user = snapshot.data as User?;
            if (user == null) {
              return LoginPage(); // Redirect to login page if user is not logged in
            }
            return ChatsPage(); // Redirect to chat page if user is logged in
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(), // Show a loading spinner while checking auth state
              ),
            );
          }
        },
      ),
    );
  }
}
