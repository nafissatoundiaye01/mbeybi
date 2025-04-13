import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbeybi/auth/controllers/auth.controller.dart';
import 'package:mbeybi/core/constants/colors.dart';
import 'package:mbeybi/core/utils/responsive.dart';

class InscriptionScreen extends StatelessWidget {
  const InscriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: PopScope(
          canPop: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.sizeFromWidth(20),
                vertical: responsive.sizeFromHeight(10),
              ),
              child: _buildRegistrationForm(responsive, authController),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationForm(
    Responsive responsive,
    AuthController authController,
  ) {
    return SizedBox(
      height: responsive.height! - responsive.sizeFromHeight(140),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: responsive.sizeFromHeight(30)),

              Text(
                'Inscription',
                style: TextStyle(
                  fontSize: responsive.sizeFromWidth(25),
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),

              SizedBox(height: responsive.sizeFromHeight(15)),
              Text(
                'Veuillez renseigner les informations suivantes pour finaliser votre inscription',
                style: TextStyle(
                  fontSize: responsive.sizeFromWidth(14),
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: responsive.sizeFromHeight(55)),

              // Champs de formulaire
              TextField(
                controller: authController.nameController,
                decoration: InputDecoration(
                  hintText: 'Entrez vos prénom et nom',
                  prefixIcon: const Icon(
                    Icons.person,
                    color: AppColors.primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: responsive.sizeFromHeight(20)),

              TextField(
                controller: authController.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Entrez votre adresse email',
                  prefixIcon: const Icon(
                    Icons.email,
                    color: AppColors.primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: responsive.sizeFromHeight(20)),

              TextField(
                controller: authController.addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Entrez votre adresse complète',
                  prefixIcon: const Icon(
                    Icons.location_on,
                    color: AppColors.primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),

          ElevatedButton(
            onPressed:
                authController.isLoading.value
                    ? null
                    : () => authController.registerUser(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: responsive.sizeFromHeight(15),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size(double.infinity, responsive.sizeFromHeight(50)),
            ),
            child:
                authController.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                      'Terminer l\'inscription',
                      style: TextStyle(
                        fontSize: responsive.sizeFromWidth(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
