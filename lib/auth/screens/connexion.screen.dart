import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbeybi/auth/controllers/auth.controller.dart';
import 'package:mbeybi/core/constants/colors.dart';
import 'package:mbeybi/core/utils/responsive.dart';

class ConnexionScreen extends StatelessWidget {
  const ConnexionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Connexion',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: responsive.sizeFromWidth(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.sizeFromWidth(20),
              vertical: responsive.sizeFromHeight(10),
            ),
            child: Obx(() {
              // Show OTP verification UI if OTP has been sent
              if (authController.otpSent.value) {
                return _buildOtpVerificationUI(responsive, authController);
              } else {
                // Show initial connection UI
                return _buildInitialConnectionUI(responsive, authController);
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialConnectionUI(
    Responsive responsive,
    AuthController authController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: responsive.sizeFromHeight(20)),
        Text(
          'Entrez votre code pour vous connecter',
          style: TextStyle(
            fontSize: responsive.sizeFromWidth(16),
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: responsive.sizeFromHeight(40)),

        // Phone number display
        Container(
          padding: EdgeInsets.all(responsive.sizeFromWidth(15)),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.phone, color: AppColors.secondaryColor),
              SizedBox(width: responsive.sizeFromWidth(10)),
              Text(
                authController.phoneController.text,
                style: TextStyle(
                  fontSize: responsive.sizeFromWidth(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Modifier',
                  style: TextStyle(
                    color: AppColors.thirdColor,
                    fontSize: responsive.sizeFromWidth(14),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: responsive.sizeFromHeight(30)),

        // Send OTP button
        ElevatedButton(
          onPressed:
              authController.isLoading.value
                  ? null
                  : () => authController.sendOTP(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryColor,
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
                    'Recevoir le code OTP',
                    style: TextStyle(
                      fontSize: responsive.sizeFromWidth(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        ),
        SizedBox(height: responsive.sizeFromHeight(30)),
      ],
    );
  }

  Widget _buildOtpVerificationUI(
    Responsive responsive,
    AuthController authController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: responsive.sizeFromHeight(20)),
        Text(
          'Vérification du code OTP',
          style: TextStyle(
            fontSize: responsive.sizeFromWidth(20),
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(height: responsive.sizeFromHeight(10)),
        Text(
          'Un code de vérification a été envoyé au ${authController.phoneController.text}',
          style: TextStyle(
            fontSize: responsive.sizeFromWidth(14),
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: responsive.sizeFromHeight(40)),

        // OTP Input
        _buildOtpInputField(responsive, authController),
        SizedBox(height: responsive.sizeFromHeight(20)),

        // Resend code option
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Vous n\'avez pas reçu le code ? ',
              style: TextStyle(
                fontSize: responsive.sizeFromWidth(14),
                color: Colors.grey[700],
              ),
            ),
            TextButton(
              onPressed: () => authController.sendOTP(),
              child: Text(
                'Renvoyer',
                style: TextStyle(
                  color: AppColors.thirdColor,
                  fontSize: responsive.sizeFromWidth(14),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.sizeFromHeight(30)),

        // Verify OTP button
        ElevatedButton(
          onPressed:
              authController.isLoading.value
                  ? null
                  : () => authController.verifyOTP(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryColor,
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
                    'Vérifier',
                    style: TextStyle(
                      fontSize: responsive.sizeFromWidth(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        ),
      ],
    );
  }

  Widget _buildOtpInputField(
    Responsive responsive,
    AuthController authController,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: responsive.sizeFromWidth(10)),
      child: Column(
        children: [
          // OTP numeric keyboard UI
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            childAspectRatio: 1.5,
            mainAxisSpacing: responsive.sizeFromHeight(15),
            crossAxisSpacing: responsive.sizeFromWidth(15),
            padding: EdgeInsets.all(responsive.sizeFromWidth(10)),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // Numeric keys 1-9
              for (int i = 1; i <= 9; i++)
                _buildKeyboardButton(responsive, '$i', () {
                  if (authController.otpController.text.length < 4) {
                    authController.otpController.text += '$i';
                  }
                }),

              // Special keys (clear, 0, delete)
              _buildKeyboardButton(
                responsive,
                '',
                () {
                  // Empty button or another function
                },
                isIcon: true,
                icon: null,
              ),

              _buildKeyboardButton(responsive, '0', () {
                if (authController.otpController.text.length < 4) {
                  authController.otpController.text += '0';
                }
              }),

              _buildKeyboardButton(
                responsive,
                '',
                () {
                  if (authController.otpController.text.isNotEmpty) {
                    authController.otpController.text = authController
                        .otpController
                        .text
                        .substring(
                          0,
                          authController.otpController.text.length - 1,
                        );
                  }
                },
                isIcon: true,
                icon: Icons.backspace_outlined,
              ),
            ],
          ),

          SizedBox(height: responsive.sizeFromHeight(20)),

          // OTP dots display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (index) => Container(
                margin: EdgeInsets.symmetric(
                  horizontal: responsive.sizeFromWidth(5),
                ),
                width: responsive.sizeFromWidth(15),
                height: responsive.sizeFromHeight(15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      index < authController.otpController.text.length
                          ? AppColors.secondaryColor
                          : Colors.grey[300],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardButton(
    Responsive responsive,
    String text,
    Function() onTap, {
    bool isIcon = false,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child:
            isIcon
                ? (icon != null
                    ? Icon(icon, size: responsive.sizeFromWidth(20))
                    : const SizedBox())
                : Text(
                  text,
                  style: TextStyle(
                    fontSize: responsive.sizeFromWidth(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }
}
