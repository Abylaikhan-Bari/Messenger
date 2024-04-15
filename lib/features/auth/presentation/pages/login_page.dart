import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../messaging/presentation/pages/chats_page.dart';
import 'registration_page.dart';


class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define TextEditingControllers for email and password
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Email TextField
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            // Password TextField
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            // Login Button
            ElevatedButton(
              child: Text('Login'),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  // After successful login, navigate to the ChatsPage
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ChatsPage()));
                } on FirebaseAuthException catch (e) {
                  // Handle different Firebase auth errors here
                  print(e);
                }
              },
            ),
            // Redirect to Register Page
            TextButton(
              child: Text("Don't have an account? Register"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => RegistrationPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
