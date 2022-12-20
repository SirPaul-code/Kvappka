import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kvappka/LoginScreen.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;


Future<void> main() async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bloodTypeController = TextEditingController();
  final _locationController = TextEditingController();

  static const bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  static const cities = ['Bratislava', 'Košice', 'Prešov', 'Nitra', 'Banská Bystrica', 'Trnava', 'Trenčín', 'Žilina', 'Martin'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            SizedBox(height: 15.0),

            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
              ),
            ),
            SizedBox(height: 15.0),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 15.0),
        DropdownButtonFormField(
          decoration: InputDecoration(labelText: 'Blood type',),
          items: bloodTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type, textAlign: TextAlign.center,),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              _bloodTypeController.text = value;
            }
          },

        ),
            SizedBox(height: 15.0),

        DropdownButtonFormField(
        decoration: InputDecoration(            labelText: 'Location'),
        items: cities.map((city) {
        return DropdownMenuItem(
        value: city,
        child: Text(city, textAlign: TextAlign.center),
        );
        }).toList(),
          onChanged: (value) {
            if (value != null) {
              _locationController.text = value;
            }
          },

        ),
            SizedBox(height: 15.0),

            ElevatedButton(
        onPressed: () {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        firestore.collection('donors').add({
        'name': _nameController.text,
        'email': _emailController.text,
        'blood_type': _bloodTypeController.text,
        'location': _locationController.text,
        });
        },
        child: Text('Submit', textAlign: TextAlign.center),
        ),
          SizedBox(height:15.0),
            ElevatedButton(
              onPressed: () async {
                // Sign out
                try {
                  await _auth.signOut();
                } catch (error) {
                  print(error);
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: Text('Log Out'),
            ),
        ],
    ),
    );
  }
}
