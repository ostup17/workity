import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user.dart' as app_user;
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/loading_indicator.dart';
import 'performer_screens/create_service_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final user = state.user;
          return PopScope(
            onPopInvokedWithResult: (didPop, result) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                // Закрыть приложение или добавить логику выхода
                print("Exiting app");
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text('Home'),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Привет ${user.activeRole == app_user.UserRole.performer ? 'Исполнитель' : 'Заказчик'}!'),
                  if (user.activeRole == app_user.UserRole.performer)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: BlocProvider.of<AuthBloc>(context),
                              child: CreateServiceScreen(),
                            ),
                          ),
                        );
                      },
                      child: Text('Создать услугу'),
                    ),
                  SwitchListTile(
                    title: Text('Переключить роль'),
                    value: user.activeRole == app_user.UserRole.performer,
                    onChanged: (value) {
                      final newRole = value
                          ? app_user.UserRole.performer
                          : app_user.UserRole.customer;
                      context.read<AuthBloc>().add(SwitchRoleEvent(newRole: newRole));
                    },
                  ),
                ],
              ),
            ),
          );
        } else if (state is AuthLoading) {
          return Scaffold(
            body: const LoadingIndicator(),
          );
        } else {
          return const LoadingIndicator();
        }
      },
    );
  }
}