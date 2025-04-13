import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';
import 'package:mbeybi/auth/screens/connexion.screen.dart';
import 'package:mbeybi/auth/screens/inscription.screen.dart';
import 'package:mbeybi/auth/screens/pincodebuilder.dart';
import 'package:mbeybi/core/constants/colors.dart';
import 'package:mbeybi/home/screens/home.dart';

class AuthController extends GetxController {
  // Controllers
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  var otpCode = ''.obs;
  var pinCode = ''.obs;
  var tempPin = ''.obs; // Pour stocker temporairement le premier PIN saisi
  var confirmPinMode = false.obs; // Pour suivre l'état de confirmation du PIN
  var pinError = ''.obs; // Pour les messages d'erreur sur le PIN
  var pinInitialized =
      false.obs; // Pour savoir si l'état du PIN a été initialisé

  // Observables
  final isLoading = false.obs;
  final isUserExist = false.obs;
  final otpSent = false.obs;
  final otpVerified = false.obs;
  final isRegistrationComplete =
      false.obs; // Pour suivre si l'inscription est complète

  var resendTimer = 60.obs;
  Timer? countdownTimer;

  void startResendCountdown() {
    resendTimer.value = 60;
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        timer.cancel();
      }
    });
  }

  // Liste des pays autorisés (codes ISO)
  // Vous pouvez modifier cette liste selon vos besoins
  final List<String> allowedCountries = ['SN'];

  // Country selection - par défaut le Sénégal (SN)
  final selectedCountry =
      Country(
        phoneCode: '221',
        countryCode: 'SN',
        e164Sc: 0,
        geographic: true,
        level: 1,
        name: 'Sénégal',
        example: '771234567',
        displayName: 'Sénégal (SN) [+221]',
        displayNameNoCountryCode: 'Sénégal (SN)',
        e164Key: '221-SN-0',
      ).obs;

  @override
  void onInit() {
    super.onInit();
    // Any initialization code
  }

  @override
  void onClose() {
    // Dispose controllers when the controller is removed from memory
    phoneController.dispose();
    otpController.dispose();
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    countdownTimer?.cancel();

    super.onClose();
  }

  // Get full phone number with country code
  String getFullPhoneNumber() {
    return '+${selectedCountry.value.phoneCode}${phoneController.text.trim()}';
  }

  // Check if user exists and navigate accordingly
  void checkUserExists() async {
    // Validate phone number
    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        backgroundColor: AppColors.thirdColor,
        colorText: Colors.white,
        'Erreur',
        'Veuillez entrer votre numéro de téléphone',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Set loading to true
    isLoading.value = true;

    try {
      // In a real app, you would check with your backend or authentication service
      // Simulating API call with Future.delayed
      await Future.delayed(const Duration(seconds: 2));

      // For demo purposes, we'll check if the phone number starts with "7" to determine if user exists
      if (phoneController.text.startsWith('7')) {
        isUserExist.value = true;
        // Navigate to connexion (login) screen for existing users
        Get.to(() => const ConnexionScreen());
      } else {
        isUserExist.value = false;
        // Navigate to inscription (registration) screen for new users
        Get.to(() => const ConnexionScreen());
      }
    } catch (e) {
      Get.snackbar(
        backgroundColor: AppColors.thirdColor,
        colorText: Colors.white,
        'Erreur',
        'Une erreur est survenue: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Send OTP for verification
  void sendOTP() async {
    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        backgroundColor: AppColors.thirdColor,
        colorText: Colors.white,
        'Erreur',
        'Veuillez entrer votre numéro de téléphone',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulate OTP sending
      await Future.delayed(const Duration(seconds: 2));
      otpSent.value = true;
      startResendCountdown();

      Get.snackbar(
        backgroundColor: AppColors.secondaryColor,
        colorText: Colors.white,
        'Succès',
        'Code OTP envoyé à ${getFullPhoneNumber()}',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        backgroundColor: AppColors.thirdColor,
        colorText: Colors.white,
        'Erreur',
        'Impossible d\'envoyer le code OTP: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Verify OTP code
  void verifyOTP() async {
    if (otpCode.value.isEmpty) {
      Get.snackbar(
        backgroundColor: AppColors.thirdColor,
        colorText: Colors.white,
        'Erreur',
        'Veuillez entrer le code OTP',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulate OTP verification
      await Future.delayed(const Duration(seconds: 2));

      // For demo purposes, we'll consider "1234" as valid OTP
      if (otpCode.value == "1234") {
        otpVerified.value = true;

        // Diriger selon que l'utilisateur existe ou non
        if (isUserExist.value) {
          // Utilisateur existant - Aller directement à l'écran de vérification PIN
          Get.snackbar(
            backgroundColor: AppColors.secondaryColor,
            colorText: Colors.white,
            'Succès',
            'Vérification réussie. Entrez votre code PIN',
            snackPosition: SnackPosition.TOP,
          );
          pinInitialized.value = false;
          Get.to(() => PinScreen(isNewUser: false));
        } else {
          // Nouvel utilisateur - Aller à l'écran d'inscription d'abord
          Get.snackbar(
            backgroundColor: AppColors.secondaryColor,
            colorText: Colors.white,
            'Succès',
            'Vérification réussie. Complétez votre inscription',
            snackPosition: SnackPosition.TOP,
          );
          isRegistrationComplete.value =
              false; // Assurer que l'inscription est marquée comme incomplète
          Get.to(() => const InscriptionScreen());
        }
      } else {
        Get.snackbar(
          backgroundColor: AppColors.thirdColor,
          colorText: Colors.white,
          'Erreur',
          'Code OTP invalide. Veuillez réessayer',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        backgroundColor: AppColors.thirdColor,
        colorText: Colors.white,
        'Erreur',
        'Erreur de vérification: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Réinitialiser l'état du PIN
  void resetPinState() {
    pinCode.value = '';
    tempPin.value = '';
    confirmPinMode.value = false;
    pinError.value = '';
  }

  // Sauvegarder le code PIN et continuer
  void savePinCode() async {
    isLoading.value = true;

    try {
      // Simuler l'enregistrement du PIN
      await Future.delayed(const Duration(seconds: 1));

      Get.snackbar(
        backgroundColor: AppColors.secondaryColor,
        colorText: Colors.white,
        'Succès',
        isUserExist.value
            ? 'Authentification réussie !'
            : 'Code PIN créé avec succès !',
        snackPosition: SnackPosition.TOP,
      );

      // Redirection finale selon le cas
      // Note: Pour un nouvel utilisateur, l'inscription est déjà faite à ce stade
      // On naviguerait vers l'écran principal dans les deux cas
      Get.offAll(() => const HomeScreen());

      // Pour la démo, on peut retourner à l'inscription ou à un écran factice
      Get.snackbar(
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.white,
        'Information',
        'Navigation vers Home',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        backgroundColor: AppColors.thirdColor,
        colorText: Colors.white,
        'Erreur',
        'Impossible de sauvegarder le code PIN: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Vérifier le PIN existant
  void verifyExistingPin() async {
    if (pinCode.value.length != 4) {
      Get.snackbar(
        backgroundColor: AppColors.thirdColor,
        colorText: Colors.white,
        'Erreur',
        'Veuillez entrer un code PIN à 4 chiffres',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simuler la vérification du PIN (dans une vraie app, vous vérifieriez avec une API/base de données)
      await Future.delayed(const Duration(seconds: 1));

      // Pour démo, considérez "1234" comme valide
      if (pinCode.value == "1234") {
        savePinCode(); // Réutiliser cette méthode pour continuer le flux
      } else {
        pinError.value = "Code PIN incorrect. Veuillez réessayer.";
        pinCode.value = '';

        // Réinitialiser l'erreur après 3 secondes
        Future.delayed(const Duration(seconds: 3), () {
          pinError.value = '';
        });
      }
    } catch (e) {
      Get.snackbar(
        backgroundColor: AppColors.thirdColor,
        colorText: Colors.white,
        'Erreur',
        'Erreur de vérification: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Register new user
  void registerUser() async {
    // Validate fields
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      Get.snackbar(
        backgroundColor: AppColors.thirdColor,
        colorText: Colors.white,
        'Erreur',
        'Veuillez remplir tous les champs',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulate registration API call
      await Future.delayed(const Duration(seconds: 2));

      // Registration successful
      Get.snackbar(
        backgroundColor: AppColors.secondaryColor,
        colorText: Colors.white,
        'Succès',
        'Inscription réussie! Créez maintenant votre code PIN',
        snackPosition: SnackPosition.TOP,
      );

      // Marquer l'inscription comme complète
      isRegistrationComplete.value = true;

      // Pour un nouvel utilisateur, aller à la création du PIN maintenant
      pinInitialized.value = false;
      Get.to(() => PinScreen(isNewUser: true));
    } catch (e) {
      Get.snackbar(
        backgroundColor: AppColors.thirdColor,
        colorText: Colors.white,
        'Erreur',
        'Erreur d\'inscription: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
