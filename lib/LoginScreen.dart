import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kvappka/main.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

final googleSignIn = GoogleSignIn(
  scopes: ['email'],
  clientId: '731928927455-521d18etvd48d5h6ausdltfqa5m5duok.apps.googleusercontent.com',
);
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              onChanged: (value) {
                _emailController.text = value;
              },
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              onChanged: (value) {
                _passwordController.text = value;
              },
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Sign in with email and password
                try {
                  final user = await _auth.signInWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                  print('Logged in as: ${user.user?.email}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                } catch (error) {
                  print(error);
                }


              },
              child: Text('Login'),
            ),

            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                // Sign in with Google
                try {
                  final googleAccount = await googleSignIn.signIn();
                  final googleAuth = await googleAccount?.authentication;
                  final credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth?.accessToken,
                    idToken: googleAuth?.idToken,
                  );
                  final user = (await _auth.signInWithCredential(credential)).user;
                  print('Logged in as: ${user?.displayName}');
                } catch (error) {
                  print(error);
                }
              },
              child: Text('Google Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
