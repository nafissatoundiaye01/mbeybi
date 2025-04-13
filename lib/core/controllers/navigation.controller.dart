import 'package:get/get.dart';

class NavigationController extends GetxController {
  // Index de l'onglet actuel
  final RxInt currentIndex = 0.obs;

  // Méthode pour changer d'onglet
  void changeTab(int index) {
    currentIndex.value = index;
  }
}
