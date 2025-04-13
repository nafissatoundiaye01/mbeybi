import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbeybi/auth/controllers/auth.controller.dart';
import 'package:mbeybi/core/constants/colors.dart';
import 'package:mbeybi/core/utils/responsive.dart';

class PinScreen extends StatelessWidget {
  final bool isNewUser;

  const PinScreen({Key? key, required this.isNewUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final responsive = Responsive(context);

    // Réinitialiser l'état du PIN si c'est un nouvel utilisateur
    if (isNewUser && !authController.pinInitialized.value) {
      authController.resetPinState();
      authController.pinInitialized.value = true;
    }

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
              child: Obx(() {
                return _buildPinUI(responsive, authController);
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinUI(Responsive responsive, AuthController authController) {
    // Déterminer le titre et la description en fonction du mode
    String title;
    String description;

    if (isNewUser) {
      if (authController.confirmPinMode.value) {
        title = 'Confirmer Code PIN';
        description = 'Confirmez votre code PIN pour sécuriser votre compte';
      } else {
        title = 'Créer Code PIN';
        description = 'Veuillez créer un code PIN pour sécuriser votre compte';
      }
    } else {
      title = 'Code PIN';
      description = 'Entrez votre code PIN pour continuer';
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: responsive.sizeFromWidth(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: responsive.sizeFromHeight(30)),

          Text(
            title,
            style: TextStyle(
              fontSize: responsive.sizeFromWidth(20),
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: responsive.sizeFromHeight(10)),
          Text(
            description,
            style: TextStyle(
              fontSize: responsive.sizeFromWidth(14),
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: responsive.sizeFromHeight(100)),

          // PIN dots display
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

          // PIN numeric keyboard UI
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
                    _checkPinCompletion(authController);
                  }
                }),

              // Special keys (empty, 0, delete)
              _buildKeyboardButton(
                responsive,
                '',
                () {
                  // Empty button
                },
                isIcon: true,
                icon: null,
              ),

              _buildKeyboardButton(responsive, '0', () {
                if (authController.pinCode.value.length < 4) {
                  authController.pinCode.value += '0';
                  _checkPinCompletion(authController);
                }
              }),

              _buildKeyboardButton(
                responsive,
                '',
                () {
                  if (authController.pinCode.value.isNotEmpty) {
                    authController.pinCode.value = authController.pinCode.value
                        .substring(0, authController.pinCode.value.length - 1);
                  }
                },
                isIcon: true,
                icon: Icons.backspace_outlined,
              ),
            ],
          ),

          SizedBox(height: responsive.sizeFromHeight(20)),

          // Error message
          if (authController.pinError.value.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: responsive.sizeFromHeight(10),
              ),
              child: Center(
                child: Text(
                  authController.pinError.value,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: responsive.sizeFromWidth(14),
                  ),
                ),
              ),
            ),

          // Option pour mot de passe oublié (uniquement pour utilisateurs existants)
          if (!isNewUser)
            Center(
              child: TextButton(
                onPressed: () {
                  // Logique pour réinitialiser le code PIN
                  Get.snackbar(
                    backgroundColor: AppColors.primaryColor,
                    colorText: Colors.white,
                    'Information',
                    'La réinitialisation du code PIN sera disponible prochainement',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: Text(
                  'Code PIN oublié ?',
                  style: TextStyle(
                    color: AppColors.thirdColor,
                    fontSize: responsive.sizeFromWidth(14),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _checkPinCompletion(AuthController authController) {
    // Si le PIN a 4 chiffres
    if (authController.pinCode.value.length == 4) {
      if (isNewUser) {
        // Flux pour nouvel utilisateur
        if (!authController.confirmPinMode.value) {
          // Premier PIN saisi, passer en mode confirmation
          authController.tempPin.value = authController.pinCode.value;
          authController.pinCode.value = '';
          authController.confirmPinMode.value = true;
        } else {
          // Vérifier si les deux PINs correspondent
          if (authController.tempPin.value == authController.pinCode.value) {
            // PINs correspondent, sauvegarder et continuer
            authController.savePinCode();
          } else {
            // PINs ne correspondent pas, afficher une erreur
            authController.pinError.value =
                "Les codes PIN ne correspondent pas. Veuillez réessayer.";
            authController.confirmPinMode.value = false;
            authController.pinCode.value = '';
            // Réinitialiser l'erreur après 3 secondes
            Future.delayed(const Duration(seconds: 3), () {
              authController.pinError.value = '';
            });
          }
        }
      } else {
        // Flux pour utilisateur existant - vérifier le PIN
        authController.verifyExistingPin();
      }
    }
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
