import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../messaging/presentation/pages/chats_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String _name = '';

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: _email.trim(),
          password: _password.trim(),
        );
        User? firebaseUser = userCredential.user;

        if (firebaseUser != null) {
          // Add user document to Firestore
          await _firestore.collection('users').doc(firebaseUser.uid).set({
            'email': firebaseUser.email,
            'name': _name, // You'll need to add a field to capture the user's name
            // Add other user details as necessary
          });
        }

        // Navigate to chats page after successful registration and Firestore document creation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChatsPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              onSaved: (value) => _name = value!, // Add this line
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) => value != null && !value.contains('@') ? 'Enter a valid email' : null,
              onSaved: (value) => _email = value ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) => value != null && value.length < 6 ? 'Password must be at least 6 characters' : null,
              onSaved: (value) => _password = value ?? '',
            ),
            ElevatedButton(style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                  }
                  return null; // Use the component's default.
                },
              ),
            ),

              onPressed: _register,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
