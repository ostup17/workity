import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'app_state.dart';
import 'home_screen.dart';
import 'login.dart';
import 'registration.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Вход пользователя
  Future<User?> signInWithEmailPassword(String email, String password) async {
  try {
    final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Проверяем, действительно ли userCredential.user - это объект User
    if (userCredential.user is User) {
      return userCredential.user as User;
    } else {
      throw Exception('Неизвестный тип данных: ${userCredential.user.runtimeType}');
    }
  } on FirebaseAuthException catch (e) {
    debugPrint('FirebaseAuthException: ${e.code}, ${e.message}');
    throw FirebaseAuthException(code: e.code, message: e.message);
  } catch (e) {
    debugPrint('Неизвестная ошибка: $e');
    throw Exception('Неизвестная ошибка: $e');
  }
}


  // Регистрация пользователя
  Future<User?> registerWithEmailPassword(String email, String password) async {
  try {
    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

  // Получить текущего пользователя
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Выход из системы
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false, // Удаляем все предыдущие маршруты из стека
    );
  }
}



class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return const HomeScreen(); // Пользователь авторизован
        } else {
          return const LoginScreen(); // Пользователь не авторизован
        }
      },
    );
  }
}

