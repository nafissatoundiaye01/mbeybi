import 'package:get/get.dart';
import 'package:mbeybi/core/models/product.dart';

class ProductController extends GetxController {
  // Observable lists pour différentes catégories de produits
  final RxList<Product> allProducts = <Product>[].obs;
  final RxList<Product> onSaleProducts = <Product>[].obs;
  final RxList<Product> popularProducts = <Product>[].obs;

  // Observable pour les produits filtrés lors de la recherche
  final RxList<Product> filteredProducts = <Product>[].obs;

  // Observable pour la recherche
  final RxString searchQuery = ''.obs;

  // États de chargement et d'erreur
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // Fonction pour charger les produits (simulation d'une API)
  Future<void> fetchProducts() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      // Simuler un délai réseau
      await Future.delayed(const Duration(seconds: 1));

      // Données fictives - dans une vraie application, ces données viendraient d'une API
      List<Product> products = [
        Product(
          id: '1',
          name: 'Pommes rouges',
          price: 900,
          oldPrice: 1200,
          imageUrl: 'assets/images/products/pommes.jpg',
          category: 'Fruits',
          rating: 4.5,
          ratingCount: 120,
          isOnSale: true,
        ),
        Product(
          id: '2',
          name: 'Oranges fraiches',
          price: 800,
          oldPrice: 1000,
          imageUrl: 'assets/images/products/pommes.jpg',
          category: 'Fruits',
          rating: 4.2,
          ratingCount: 85,
          isOnSale: true,
        ),
        Product(
          id: '3',
          name: 'Poulet de chair',
          price: 3500,
          imageUrl: 'assets/images/products/pommes.jpg',
          category: 'Viandes',
          rating: 4.8,
          ratingCount: 200,
        ),
        Product(
          id: '4',
          name: 'Riz parfumé',
          price: 12000,
          imageUrl: 'assets/images/products/pommes.jpg',
          category: 'Céréales',
          rating: 4.6,
          ratingCount: 320,
        ),
        Product(
          id: '5',
          name: 'Tomates fraîches',
          price: 750,
          oldPrice: 900,
          imageUrl: 'assets/images/products/pommes.jpg',
          category: 'Légumes',
          rating: 4.3,
          ratingCount: 95,
          isOnSale: true,
        ),
        Product(
          id: '6',
          name: 'Oignons rouges',
          price: 600,
          imageUrl: 'assets/images/products/pommes.jpg',
          category: 'Légumes',
          rating: 4.1,
          ratingCount: 75,
        ),
      ];

      // Mettre à jour les listes observables
      allProducts.value = products;

      // Filtrer les produits en solde
      onSaleProducts.value = products.where((p) => p.isOnSale).toList();

      // Trier par rating pour obtenir les produits populaires
      List<Product> popular = List.from(products);
      popular.sort((a, b) => b.rating.compareTo(a.rating));
      popularProducts.value =
          popular.take(4).toList(); // Prendre les 4 plus populaires
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Fonction pour rechercher des produits
  void searchProducts(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredProducts.clear();
      return;
    }

    // Filtrer les produits selon le texte de recherche
    filteredProducts.value =
        allProducts.where((product) {
          final nameMatches = product.name.toLowerCase().contains(
            query.toLowerCase(),
          );
          final categoryMatches = product.category.toLowerCase().contains(
            query.toLowerCase(),
          );
          return nameMatches || categoryMatches;
        }).toList();
  }

  // Fonction pour basculer l'état favori d'un produit
  void toggleFavorite(String productId) {
    final index = allProducts.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final product = allProducts[index];
      final updatedProduct = product.copyWith(isFavorite: !product.isFavorite);

      // Mettre à jour le produit dans toutes les listes
      allProducts[index] = updatedProduct;

      // Mettre à jour les autres listes si nécessaire
      _updateProductInList(onSaleProducts, updatedProduct);
      _updateProductInList(popularProducts, updatedProduct);
      _updateProductInList(filteredProducts, updatedProduct);
    }
  }

  // Fonction utilitaire pour mettre à jour un produit dans une liste donnée
  void _updateProductInList(RxList<Product> list, Product updatedProduct) {
    final index = list.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      list[index] = updatedProduct;
    }
  }
}
