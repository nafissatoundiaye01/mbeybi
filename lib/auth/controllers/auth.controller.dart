import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';
import 'package:mbeybi/auth/screens/connexion.screen.dart';
import 'package:mbeybi/auth/screens/inscription.screen.dart';

class AuthController extends GetxController {
  // Controllers
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  // Observables
  final isLoading = false.obs;
  final isUserExist = false.obs;
  final otpSent = false.obs;
  final otpVerified = false.obs;

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
        'Erreur',
        'Veuillez entrer votre numéro de téléphone',
        snackPosition: SnackPosition.BOTTOM,
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
        Get.to(() => const InscriptionScreen());
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Send OTP for verification
  void sendOTP() async {
    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez entrer votre numéro de téléphone',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulate OTP sending
      await Future.delayed(const Duration(seconds: 2));
      otpSent.value = true;

      Get.snackbar(
        'Succès',
        'Code OTP envoyé à ${getFullPhoneNumber()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible d\'envoyer le code OTP: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Verify OTP code
  void verifyOTP() async {
    if (otpController.text.trim().isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez entrer le code OTP',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulate OTP verification
      await Future.delayed(const Duration(seconds: 2));

      // For demo purposes, we'll consider "1234" as valid OTP
      if (otpController.text == "1234") {
        otpVerified.value = true;

        // If existing user, navigate to home or complete login
        if (isUserExist.value) {
          // Here you would typically sign in the user and navigate to home
          Get.snackbar(
            'Succès',
            'Connexion réussie',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          // For new user, complete registration process
          Get.snackbar(
            'Succès',
            'Vérification réussie. Complétez votre inscription',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          'Erreur',
          'Code OTP invalide. Veuillez réessayer',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur de vérification: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
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
        'Erreur',
        'Veuillez remplir tous les champs',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulate registration API call
      await Future.delayed(const Duration(seconds: 2));

      // Registration successful
      Get.snackbar(
        'Succès',
        'Inscription réussie! Bienvenue sur Mbeybi',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate to home or onboarding
      // Get.offAll(() => const HomeScreen());
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur d\'inscription: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
