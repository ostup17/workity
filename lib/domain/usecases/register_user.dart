import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';


class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<User> call(String email, String password) async {
    final firebaseUser = await repository.registerWithEmailPassword(email, password);
    if (firebaseUser != null) {
      return User(id: firebaseUser.uid, email: firebaseUser.email!);
    } else {
      throw Exception('Registration failed: User not created');
    }
  }
}

