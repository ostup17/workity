import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    final UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Этот email уже используется.');
      } else if (e.code == 'weak-password') {
        throw Exception('Пароль слишком слабый.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Некорректный формат email.');
      } else {
        throw Exception('Ошибка регистрации: ${e.message}');
      }
    }
  }

}


