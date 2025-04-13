import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';
import 'package:mbeybi/auth/screens/connexion.screen.dart';
import 'package:mbeybi/auth/screens/inscription.screen.dart';
import 'package:mbeybi/auth/screens/pincodebuilder.dart';
import 'package:mbeybi/core/constants/colors.dart';

class AuthController extends GetxController {
  // Controllers
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  var otpCode = ''.obs;
  var pinCode = ''.obs;
  // Observables
  final isLoading = false.obs;
  final isUserExist = false.obs;
  final otpSent = false.obs;
  final otpVerified = false.obs;

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
    if (otpCode.trim().isEmpty) {
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

        // If existing user, navigate to home or complete login
        if (isUserExist.value) {
          // Here you would typically sign in the user and navigate to home
          Get.snackbar(
            backgroundColor: AppColors.secondaryColor,
            colorText: Colors.white,
            'Succès',
            'Connexion réussie',
            snackPosition: SnackPosition.TOP,
          );
          Get.offAll(() => const Pincodebuilder());
        } else {
          // For new user, complete registration process
          Get.snackbar(
            backgroundColor: AppColors.secondaryColor,
            colorText: Colors.white,
            'Succès',
            'Vérification réussie. Complétez votre inscription',
            snackPosition: SnackPosition.TOP,
          );
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
        'Inscription réussie! Bienvenue sur Mbeybi',
        snackPosition: SnackPosition.TOP,
      );

      // Navigate to home or onboarding
      Get.offAll(() => const Pincodebuilder());
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
