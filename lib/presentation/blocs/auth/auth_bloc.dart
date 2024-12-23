import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../domain/usecases/login_user.dart';
import '../../../domain/usecases/register_user.dart';
import '../../../domain/entities/user.dart' as app_user;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  app_user.User? get currentUser => state is AuthAuthenticated ? (state as AuthAuthenticated).user : null;

  final LoginUser loginUser;
  final RegisterUser registerUser;

  AuthBloc(this.loginUser, this.registerUser) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final firebaseUser = await loginUser(event.email, event.password);
        if (firebaseUser != null) {
          emit(AuthAuthenticated(user: firebaseUser));
        } else {
          throw Exception('User not found');
        }
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthUnauthenticated());
    });

    on<AuthRegisterEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final firebaseUser = await registerUser(event.email, event.password, event.role);
        if (firebaseUser != null) {
          emit(AuthAuthenticated(user: firebaseUser));
        } else {
          throw Exception('Registration failed: User not created');
        }
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<SwitchRoleEvent>((event, emit) async {
      try {
        final currentUser = this.currentUser!;
        await registerUser.repository.updateActiveRole(currentUser.id, event.newRole);
        final updatedUser = app_user.User(
          id: currentUser.id,
          email: currentUser.email,
          roles: currentUser.roles,
          activeRole: event.newRole,
        );
        emit(AuthAuthenticated(user: updatedUser));
      } catch (e) {
        emit(AuthError(message: 'Не удалось сменить роль: ${e.toString()}'));
      }
    });
  }
}
