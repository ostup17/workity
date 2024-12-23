import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/user.dart' as app_user;

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<app_user.User> call(String email, String password) async {
    final firebaseUser = await repository.signIn(email, password);
    if (firebaseUser != null) {
      return app_user.User(
        id: firebaseUser.id,
        email: firebaseUser.email,
        roles: firebaseUser.roles, // Используем роли из репозитория
        activeRole: firebaseUser.activeRole, // Устанавливаем активную роль
      );
    } else {
      throw Exception('Login failed: User not found');
    }
  }
}
