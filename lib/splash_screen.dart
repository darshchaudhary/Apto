import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.black87
          ),
          child: Center(
            child: Text(
              'APTO',
              style: TextStyle(
                fontSize: 120,
                fontFamily: 'SansitaOne',
                fontWeight: FontWeight.w900,
                color: Colors.white
              ),
            ),
          ),
        ),
      ),
    );
  }
}
