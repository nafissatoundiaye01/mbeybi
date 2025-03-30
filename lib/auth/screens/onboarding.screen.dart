import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
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

          Positioned(
            bottom: Responsive.isMobile(context) ? 30 : 50,
            left: 20,
            right: 20,
            child: SizedBox(
              height: Responsive.isMobile(context) ? 320 : 400,
              child: PageView.builder(
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

    return Container(
      margin: EdgeInsets.symmetric(horizontal: responsive.sizeFromWidth(5)),
      padding: EdgeInsets.all(responsive.sizeFromWidth(20)),
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
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.isMobile(context) ? 22 : 28,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: Responsive.isMobile(context) ? 14 : 16,
              color: Colors.white,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // Pagination Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_onboardingData.length, (index) {
              return Container(
                width: index == _currentPage ? 20 : 7,
                height: 7,
                margin: const EdgeInsets.only(right: 5),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  // Skip logic
                },
                child: const Text(
                  "Passer",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              isLastPage
                  ? Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xE540342B),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 18,
                    ),
                  )
                  : ElevatedButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.grey[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.isMobile(context) ? 16 : 24,
                        vertical: Responsive.isMobile(context) ? 10 : 14,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          "Suivant",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
