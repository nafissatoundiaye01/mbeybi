import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbeybi/auth/screens/login.screen.dart';
import 'package:mbeybi/core/constants/colors.dart';
import 'package:mbeybi/core/utils/responsive.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Achetez Local, Soutenez Nos Agriculteurs",
      "description":
          "Trouvez des produits frais directement auprès des agriculteurs sénégalais. Commandez en quelques clics !",
    },
    {
      "title": "Livraison Rapide et Sécurisée",
      "description":
          "Recevez vos produits à domicile ou en point de retrait, toujours frais et de qualité.",
    },
    {
      "title": "Commerce Équitable et Accessible",
      "description":
          "Achetez à prix juste et participez au développement de l'agriculture locale.",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Initialiser Responsive pour l'utiliser dans tout le widget
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Stack(
        children: [
          // Image de fond responsive
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding.png',
              fit: BoxFit.cover,
            ),
          ),

          // Conteneur principal centré
          Positioned(
            bottom: responsive.sizeFromHeight(20),
            left: responsive.width! * 0.05,
            right: responsive.width! * 0.05,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: responsive.sizeFromHeight(
                    Responsive.isMobile(context) ? 30 : 50,
                  ),
                ),
                child: SizedBox(
                  width: responsive.width! * 0.9,
                  height: responsive.sizeFromHeight(
                    Responsive.isMobile(context)
                        ? 320
                        : Responsive.isTablet(context)
                        ? 360
                        : 400,
                  ),
                  child: PageView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      return _buildContentBox(
                        context,
                        title: _onboardingData[index]["title"]!,
                        description: _onboardingData[index]["description"]!,
                        isLastPage: index == _onboardingData.length - 1,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBox(
    BuildContext context, {
    required String title,
    required String description,
    bool isLastPage = false,
  }) {
    final responsive = Responsive(context);

    // Adapter les tailles de texte en fonction du dispositif
    final titleFontSize =
        Responsive.isMobile(context)
            ? responsive.sizeFromWidth(22)
            : Responsive.isTablet(context)
            ? responsive.sizeFromWidth(25)
            : responsive.sizeFromWidth(28);

    final descriptionFontSize =
        Responsive.isMobile(context)
            ? responsive.sizeFromWidth(14)
            : Responsive.isTablet(context)
            ? responsive.sizeFromWidth(15)
            : responsive.sizeFromWidth(16);

    // Adapter les paddings en fonction du dispositif
    final containerPadding =
        Responsive.isMobile(context)
            ? responsive.sizeFromWidth(15)
            : responsive.sizeFromWidth(20);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: responsive.sizeFromWidth(5)),
      padding: EdgeInsets.all(containerPadding),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 175, 190, 120),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: responsive.sizeFromHeight(
              Responsive.isMobile(context)
                  ? 60
                  : Responsive.isTablet(context)
                  ? 100
                  : 140,
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: responsive.sizeFromHeight(10)),
          SizedBox(
            height: responsive.sizeFromHeight(
              Responsive.isMobile(context)
                  ? 80
                  : Responsive.isTablet(context)
                  ? 120
                  : 160,
            ),
            child: Text(
              description,
              style: TextStyle(
                fontSize: descriptionFontSize,
                color: Colors.white,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: responsive.sizeFromHeight(20)),

          // Pagination Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_onboardingData.length, (index) {
              return Container(
                width: responsive.sizeFromWidth(20),
                height: responsive.sizeFromHeight(7),
                margin: EdgeInsets.only(right: responsive.sizeFromWidth(5)),
                decoration: BoxDecoration(
                  color:
                      index == _currentPage
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }),
          ),

          const Spacer(),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isLastPage)
                SizedBox(
                  width: responsive.sizeFromWidth(310),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TextButton(
                        onPressed: () {
                          _pageController.animateToPage(
                            2,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.bounceIn,
                          );
                        },
                        child: Text(
                          "Passer",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: responsive.sizeFromWidth(
                              Responsive.isMobile(context) ? 14 : 16,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              "Suivant",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: responsive.sizeFromWidth(
                                  Responsive.isMobile(context) ? 14 : 16,
                                ),
                              ),
                            ),
                            SizedBox(width: responsive.sizeFromWidth(5)),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: responsive.sizeFromWidth(16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (isLastPage)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(LoginScreen());
                    },
                    child: Container(
                      width: responsive.sizeFromHeight(80),
                      height: responsive.sizeFromHeight(80),
                      child: CustomPaint(
                        painter: GradientBorderPainter(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.primaryColor,
                            ],
                          ),
                          strokeWidth: 2,
                        ),
                        child: Center(
                          child: Container(
                            width: responsive.sizeFromWidth(40),
                            height: responsive.sizeFromHeight(40),
                            decoration: BoxDecoration(
                              color: const Color(0xE540342B),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: responsive.sizeFromWidth(18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class GradientBorderPainter extends CustomPainter {
  final Gradient gradient;
  final double strokeWidth;

  GradientBorderPainter({required this.gradient, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint =
        Paint()
          ..shader = gradient.createShader(rect)
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
