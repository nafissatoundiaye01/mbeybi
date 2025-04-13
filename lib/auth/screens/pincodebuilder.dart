import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbeybi/auth/controllers/auth.controller.dart';
import 'package:mbeybi/core/constants/colors.dart';
import 'package:mbeybi/core/utils/responsive.dart';

class Pincodebuilder extends StatelessWidget {
  const Pincodebuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.sizeFromWidth(20),
              vertical: responsive.sizeFromHeight(10),
            ),
            child: Obx(() {
              return _buildOtpInputField(responsive, authController);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpInputField(
    Responsive responsive,
    AuthController authController,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: responsive.sizeFromWidth(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: responsive.sizeFromHeight(30)),

          Text(
            'Code Pin',
            style: TextStyle(
              fontSize: responsive.sizeFromWidth(20),
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: responsive.sizeFromHeight(10)),
          Text(
            'Entrez votre code pin pour continuer',
            style: TextStyle(
              fontSize: responsive.sizeFromWidth(14),
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: responsive.sizeFromHeight(100)),
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
                      index < authController.pinCode.value.length
                          ? AppColors.secondaryColor
                          : Colors.grey[300],
                ),
              ),
            ),
          ),
          SizedBox(height: responsive.sizeFromHeight(50)),
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
                  if (authController.pinCode.value.length < 4) {
                    authController.pinCode.value += '$i';
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
                if (authController.pinCode.value.length < 4) {
                  authController.pinCode.value += '0';
                }
              }),

              _buildKeyboardButton(
                responsive,
                '',
                () {
                  if (authController.pinCode.value.isNotEmpty) {
                    authController.pinCode.value = authController
                        .otpController
                        .text
                        .substring(0, authController.pinCode.value.length - 1);
                  }
                },
                isIcon: true,
                icon: Icons.backspace_outlined,
              ),
            ],
          ),

          SizedBox(height: responsive.sizeFromHeight(20)),

          // OTP dots display
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
