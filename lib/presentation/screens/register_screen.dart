import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../../../domain/entities/user.dart' as app_user;
import '../blocs/auth/auth_state.dart';
import '../widgets/loading_indicator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  app_user.UserRole? selectedRole;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Scaffold(
              body: LoadingIndicator(),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('Register'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<app_user.UserRole>(
                    value: selectedRole,
                    items: [
                      DropdownMenuItem(
                        value: app_user.UserRole.customer,
                        child: Text('Заказчик'),
                      ),
                      DropdownMenuItem(
                        value: app_user.UserRole.performer,
                        child: Text('Исполнитель'),
                      ),
                    ],
                    onChanged: (role) {
                      setState(() {
                        selectedRole = role;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Выберите роль',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedRole == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Пожалуйста, выберите роль')),
                        );
                        return;
                      }

                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      context.read<AuthBloc>().add(
                            AuthRegisterEvent(
                              email: email,
                              password: password,
                              role: selectedRole!,
                            ),
                          );
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

