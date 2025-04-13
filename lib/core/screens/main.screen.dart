import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbeybi/core/controllers/navigation.controller.dart';
import 'package:mbeybi/core/screens/bottomnavbar.dart';
import 'package:mbeybi/home/screens/home.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialiser le contrôleur de navigation
    final navigationController = Get.put(NavigationController());

    // Liste des écrans à afficher pour chaque onglet
    final screens = [
      const HomeScreen(),
      // Écran de panier (à créer)
      const Scaffold(body: Center(child: Text('Écran Panier - À venir'))),
      // Écran de favoris (à créer)
      const Scaffold(body: Center(child: Text('Écran Favoris - À venir'))),
      // Écran de profil (à créer)
      const Scaffold(body: Center(child: Text('Écran Profil - À venir'))),
    ];

    return Obx(() {
      return Scaffold(
        body: screens[navigationController.currentIndex.value],
        bottomNavigationBar: BottomNavBar(
          currentIndex: navigationController.currentIndex.value,
          onTap: navigationController.changeTab,
        ),
      );
    });
  }
}
