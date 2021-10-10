import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/screens/home_screen.dart';
import 'package:phoneauth/screens/login_screen.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: LoginScreen(),



    );
  }
}

class Intializer extends StatefulWidget {
  @override
  _IntializerState createState() => _IntializerState();
}

class _IntializerState extends State<Intializer> {

      late FirebaseAuth auth;
       late User user;
       bool isLoading = true;


      @override
      void initState(){
        super.initState();
        auth=FirebaseAuth.instance;
        user=auth.currentUser!;
        isLoading=false;
      }
  Widget build(BuildContext context) {
    return isLoading ?Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ) : user==null ? LoginScreen() : HomeScreen();
  }
}
