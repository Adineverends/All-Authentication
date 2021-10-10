import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  final auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Homescreen",style: TextStyle(fontSize: 60),),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await auth.signOut();
          Navigator.pushReplacement(context,MaterialPageRoute(builder:(context) => LoginScreen() ));
        },
        child: Icon(Icons.logout),
      ),
    );
  }
}
