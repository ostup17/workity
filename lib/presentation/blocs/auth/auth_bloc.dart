import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/register_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../domain/usecases/login_user.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;

  AuthBloc(this.loginUser, this.registerUser) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginUser(event.email, event.password);
        emit(AuthAuthenticated(user: user));
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
        final user = await registerUser(event.email, event.password);
        emit(AuthAuthenticated(user: user));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });
  }
}

