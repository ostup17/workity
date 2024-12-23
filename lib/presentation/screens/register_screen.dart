import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  UserRole? selectedRole;

  void _registerUser(BuildContext context) {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, выберите роль.')),
      );
      return;
    }

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    context.read<AuthBloc>().add(AuthRegisterEvent(
      email: email,
      password: password,
      role: selectedRole!,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            DropdownButton<UserRole>(
              value: selectedRole,
              hint: Text('Выберите роль'),
              onChanged: (role) => setState(() => selectedRole = role),
              items: [
                DropdownMenuItem(
                  value: UserRole.performer,
                  child: Text('Исполнитель'),
                ),
                DropdownMenuItem(
                  value: UserRole.customer,
                  child: Text('Заказчик'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => _registerUser(context),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
