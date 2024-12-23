import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart' as app_user;

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<app_user.User?> signIn(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();
    final roles = List<String>.from(userDoc['roles'] ?? []);
    final activeRole = userDoc['activeRole'] == 'performer'
        ? app_user.UserRole.performer
        : app_user.UserRole.customer;
    return app_user.User(
      id: userCredential.user!.uid,
      email: userCredential.user!.email!,
      roles: roles.map((role) => role == 'performer' ? app_user.UserRole.performer : app_user.UserRole.customer).toList(),
      activeRole: activeRole,
    );
  }

  Future<app_user.User?> registerWithEmailPassword(String email, String password, app_user.UserRole role) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final roleString = role == app_user.UserRole.performer ? 'performer' : 'customer';
    await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
      'roles': [roleString],
      'activeRole': roleString,
    });
    return app_user.User(
      id: userCredential.user!.uid,
      email: userCredential.user!.email!,
      roles: [role],
      activeRole: role,
    );
  }

  Future<void> updateActiveRole(String userId, app_user.UserRole role) async {
    final roleString = role == app_user.UserRole.performer ? 'performer' : 'customer';
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'activeRole': roleString,
    });
  }
}
