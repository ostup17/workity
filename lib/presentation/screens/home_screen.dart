import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:workity/presentation/screens/auth_screen.dart';


class HomeScreen extends StatelessWidget {
 const HomeScreen({super.key});

 Future<AuthGate> _signOut() async {
  await FirebaseAuth.instance.signOut();
  return new AuthGate();
}

 @override
 Widget build(BuildContext context) {
   return Scaffold(
    body: Center(
      child: ElevatedButton(onPressed: _signOut, child: Text('SignOut'))
    ),
   );
 }
}