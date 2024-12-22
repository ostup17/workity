import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workity/firebase_options.dart';
import 'presentation/screens/auth_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
 );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Маркетплейс услуг',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: AuthGate(),  // Переход на экран авторизации
    );
  }
}
