import 'package:flutter/material.dart';
import 'package:mbeybi/auth/screens/onboarding.screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agriculture Onboarding',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'SF Pro Display',
      ),
      home: const OnboardingScreen(),
    );
  }
}
