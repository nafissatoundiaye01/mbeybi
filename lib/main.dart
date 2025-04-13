import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbeybi/auth/controllers/auth.controller.dart';
import 'package:mbeybi/auth/screens/onboarding.screen.dart';
import 'package:mbeybi/core/screens/main.screen.dart';

void main() {
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mbeybi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'SF Pro Display',
      ),
      // Pour tester directement l'écran d'accueil, remplacer OnboardingScreen par MainScreen
      // En production, vous voudriez vérifier si l'utilisateur est connecté pour décider
      // quel écran afficher en premier
      home: const OnboardingScreen(),
      // Définir les routes pour faciliter la navigation
      getPages: [
        GetPage(name: '/onboarding', page: () => const OnboardingScreen()),
        GetPage(name: '/main', page: () => const MainScreen()),
      ],
    );
  }
}
