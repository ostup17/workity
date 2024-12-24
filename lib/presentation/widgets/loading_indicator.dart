import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 150,
        height: 150,
        child: Lottie.asset(
          'assets/animations/loading.json', // Путь к файлу анимации
        ),
      ),
    );
  }
}