import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart' as app_user;

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class LogoutEvent extends AuthEvent {}

class AuthRegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final app_user.UserRole role;

  AuthRegisterEvent({
    required this.email,
    required this.password,
    required this.role,
  });

  @override
  List<Object?> get props => [email, password, role];
}

class SwitchRoleEvent extends AuthEvent {
  final app_user.UserRole newRole;

  SwitchRoleEvent({required this.newRole});

  @override
  List<Object?> get props => [newRole];
}
