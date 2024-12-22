import '../entities/user.dart';
import '../../data/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<User> call(String email, String password) async {
    final firebaseUser = await repository.signIn(email, password);
    if (firebaseUser != null) {
      return User(id: firebaseUser.uid, email: firebaseUser.email!);
    } else {
      throw Exception('User not found');
    }
  }
}