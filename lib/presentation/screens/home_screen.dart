import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        body: Center(child: Text('Welcome to Home Screen!')),
      ),
    );
  }
}
