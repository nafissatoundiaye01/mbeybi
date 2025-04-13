import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbeybi/core/constants/colors.dart';
import 'package:mbeybi/core/utils/responsive.dart';
import 'package:mbeybi/home/controllers/product.controller.dart';
import 'package:mbeybi/home/screens/product_cart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController());
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => productController.fetchProducts(),
          child: Obx(() {
            if (productController.isLoading.value &&
                productController.allProducts.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (productController.hasError.value &&
                productController.allProducts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Une erreur est survenue: ${productController.errorMessage.value}',
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => productController.fetchProducts(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              );
            }

            // Décider quel contenu afficher en fonction de l'état de recherche
            Widget content;

            if (productController.searchQuery.isNotEmpty) {
              content = _buildSearchResults(productController, responsive);
            } else {
              content = _buildHomeContent(productController, responsive);
            }

            return CustomScrollView(
              slivers: [
                // En-tête avec barre de recherche
                SliverToBoxAdapter(
                  child: _buildHeader(context, productController, responsive),
                ),

                // Contenu principal (soit les résultats de recherche, soit le contenu d'accueil)
                SliverToBoxAdapter(child: content),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ProductController controller,
    Responsive responsive,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.sizeFromWidth(16),
        vertical: responsive.sizeFromHeight(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              Image.asset(
                'assets/icons/logo_app_mbey.png',
                height: responsive.sizeFromHeight(32),
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: responsive.sizeFromHeight(32),
                    width: responsive.sizeFromWidth(100),
                    color: Colors.grey[200],
                    child: const Center(child: Text('Logo')),
                  );
                },
              ),

              // Icône de notification
              Badge(
                backgroundColor: AppColors.thirdColor,
                isLabelVisible: true,
                offset: const Offset(-3, 3),
                label: const Text(
                  '2',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // Naviguer vers les notifications
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Message de bienvenue
          Text(
            'Bonjour Nathianiel,',
            style: TextStyle(
              fontSize: responsive.sizeFromWidth(16),
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),

          Text(
            'Que recherchez-vous aujourd\'hui ?',
            style: TextStyle(
              fontSize: responsive.sizeFromWidth(14),
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 16),

          // Barre de recherche
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: controller.searchProducts,
                    decoration: InputDecoration(
                      hintText: 'Rechercher...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: responsive.sizeFromHeight(12),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mic, color: AppColors.primaryColor),
                  onPressed: () {
                    // Activer la recherche vocale
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.tune, color: AppColors.primaryColor),
                  onPressed: () {
                    // Ouvrir les filtres
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(
    ProductController controller,
    Responsive responsive,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section "Prix en baisse"
        _buildSection(
          title: 'Prix en baisse',
          subtitle: 'Voir tout',
          onSubtitleTap: () {
            // Naviguer vers la liste complète des produits en solde
          },
          responsive: responsive,
        ),

        // Liste horizontale des produits en solde
        SizedBox(
          height: responsive.sizeFromHeight(
            210,
          ), // Ajustez selon la taille souhaitée
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: responsive.sizeFromWidth(16),
            ),
            itemCount: controller.onSaleProducts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: responsive.sizeFromWidth(12)),
                child: ProductCard(
                  product: controller.onSaleProducts[index],
                  isHorizontal: true,
                ),
              );
            },
          ),
        ),

        SizedBox(height: responsive.sizeFromHeight(24)),

        // Section "Les plus populaires"
        _buildSection(
          title: 'Les plus populaires',
          subtitle: 'Voir tout',
          onSubtitleTap: () {
            // Naviguer vers la liste complète des produits populaires
          },
          responsive: responsive,
        ),

        // Grille des produits populaires
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: responsive.sizeFromWidth(16),
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: responsive.sizeFromWidth(12),
            mainAxisSpacing: responsive.sizeFromHeight(12),
          ),
          itemCount: controller.popularProducts.length,
          itemBuilder: (context, index) {
            return ProductCard(product: controller.popularProducts[index]);
          },
        ),

        SizedBox(height: responsive.sizeFromHeight(16)),
      ],
    );
  }

  Widget _buildSearchResults(
    ProductController controller,
    Responsive responsive,
  ) {
    if (controller.filteredProducts.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(responsive.sizeFromWidth(20)),
          child: Column(
            children: [
              SizedBox(height: responsive.sizeFromHeight(40)),
              Icon(
                Icons.search_off,
                size: responsive.sizeFromWidth(48),
                color: Colors.grey,
              ),
              SizedBox(height: responsive.sizeFromHeight(16)),
              Text(
                'Aucun produit trouvé pour "${controller.searchQuery.value}"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: responsive.sizeFromWidth(16),
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.sizeFromWidth(16),
            vertical: responsive.sizeFromHeight(8),
          ),
          child: Text(
            '${controller.filteredProducts.length} résultats trouvés',
            style: TextStyle(
              fontSize: responsive.sizeFromWidth(14),
              color: Colors.grey[600],
            ),
          ),
        ),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: responsive.sizeFromWidth(16),
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: responsive.sizeFromWidth(12),
            mainAxisSpacing: responsive.sizeFromHeight(12),
          ),
          itemCount: controller.filteredProducts.length,
          itemBuilder: (context, index) {
            return ProductCard(product: controller.filteredProducts[index]);
          },
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required VoidCallback onSubtitleTap,
    required Responsive responsive,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.sizeFromWidth(16),
        vertical: responsive.sizeFromHeight(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: responsive.sizeFromWidth(16),
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          GestureDetector(
            onTap: onSubtitleTap,
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: responsive.sizeFromWidth(12),
                color: AppColors.thirdColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
