import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';
import 'package:mbeybi/auth/controllers/auth.controller.dart';
import 'package:mbeybi/core/constants/colors.dart';
import 'package:mbeybi/core/utils/responsive.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.sizeFromWidth(20),
            vertical: responsive.sizeFromHeight(30),
          ),
          child: Column(
            children: [
              // Contenu principal dans un SingleChildScrollView
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: responsive.sizeFromHeight(30)),
                      // Logo
                      Center(
                        child: Image.asset(
                          'assets/icons/logo_app_mbey.png',
                          height: responsive.sizeFromHeight(120),
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: responsive.sizeFromHeight(40)),

                      // Title
                      Text(
                        textAlign: TextAlign.center,
                        'Bienvenue sur Mbeybi',
                        style: TextStyle(
                          fontSize: responsive.sizeFromWidth(24),
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: responsive.sizeFromHeight(10)),

                      // Subtitle
                      Text(
                        'Connectez-vous ou créez un compte pour continuer',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: responsive.sizeFromWidth(16),
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: responsive.sizeFromHeight(80)),

                      // Phone number input with country picker
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: responsive.sizeFromWidth(5),
                            ),
                            child: Text(
                              'Numéro de Téléphone',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: responsive.sizeFromWidth(16),
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: responsive.sizeFromHeight(10)),

                          // Row combining country picker and phone field
                          Row(
                            children: [
                              // Country Picker Button
                              Obx(
                                () => Container(
                                  height: responsive.sizeFromHeight(58),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      showCountryPicker(
                                        context: context,
                                        showPhoneCode: true,
                                        onSelect: (Country country) {
                                          authController.selectedCountry.value =
                                              country;
                                        },
                                        countryListTheme: CountryListThemeData(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          inputDecoration: InputDecoration(
                                            hintText: 'Rechercher un pays',
                                            prefixIcon: const Icon(
                                              Icons.search,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: responsive.sizeFromWidth(
                                          12,
                                        ),
                                        vertical: responsive.sizeFromHeight(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Country flag
                                          Text(
                                            authController
                                                .selectedCountry
                                                .value
                                                .flagEmoji,
                                            style: TextStyle(
                                              fontSize: responsive
                                                  .sizeFromWidth(20),
                                            ),
                                          ),
                                          SizedBox(
                                            width: responsive.sizeFromWidth(5),
                                          ),
                                          // Country code
                                          Text(
                                            '+${authController.selectedCountry.value.phoneCode}',
                                            style: TextStyle(
                                              fontSize: responsive
                                                  .sizeFromWidth(14),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: responsive.sizeFromWidth(5),
                                          ),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.grey.shade700,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: responsive.sizeFromWidth(10)),

                              // Phone number text field
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.phone,
                                  controller: authController.phoneController,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade500,
                                    ),
                                    hintText: 'Numéro de téléphone',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: responsive.sizeFromHeight(150)),

                      // Continue button
                      Obx(
                        () => ElevatedButton(
                          onPressed:
                              authController.isLoading.value
                                  ? null
                                  : () => authController.checkUserExists(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: responsive.sizeFromHeight(15),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(
                              double.infinity,
                              responsive.sizeFromHeight(50),
                            ),
                          ),
                          child:
                              authController.isLoading.value
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : Text(
                                    'Continuer',
                                    style: TextStyle(
                                      fontSize: responsive.sizeFromWidth(16),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Terms and conditions placés en bas de l'écran
              Padding(
                padding: EdgeInsets.only(bottom: responsive.sizeFromHeight(20)),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: responsive.sizeFromWidth(14),
                      color: Colors.grey[700],
                    ),
                    children: const [
                      TextSpan(text: 'En continuant, vous acceptez nos '),
                      TextSpan(
                        text: 'Conditions d\'utilisation',
                        style: TextStyle(
                          color: AppColors.thirdColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' et '),
                      TextSpan(
                        text: 'Politique de confidentialité',
                        style: TextStyle(
                          color: AppColors.thirdColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
