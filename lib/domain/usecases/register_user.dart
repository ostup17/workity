import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/user.dart' as app_user;

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<app_user.User> call(String email, String password, app_user.UserRole role) async {
    final firebaseUser = await repository.registerWithEmailPassword(email, password, role);
    if (firebaseUser != null) {
      return app_user.User(
        id: firebaseUser.id,
        email: firebaseUser.email,
        roles: [role],
        activeRole: role,
      );
    } else {
      throw Exception('Registration failed: User not created');
    }
  }
}
