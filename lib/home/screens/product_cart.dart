import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbeybi/core/constants/colors.dart';
import 'package:mbeybi/core/models/product.dart';
import 'package:mbeybi/core/utils/responsive.dart';
import 'package:mbeybi/home/controllers/product.controller.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isHorizontal;
  final VoidCallback? onTap;

  const ProductCard({
    Key? key,
    required this.product,
    this.isHorizontal = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final productController = Get.find<ProductController>();

    return GestureDetector(
      onTap:
          onTap ??
          () {
            // Navigation vers la page de détail du produit
            // Get.to(() => ProductDetailsScreen(product: product));
          },
      child: Container(
        width:
            isHorizontal
                ? responsive.sizeFromWidth(160)
                : responsive.sizeFromWidth(120),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: EdgeInsets.all(responsive.sizeFromWidth(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du produit
            Expanded(
              child: Stack(
                children: [
                  // Image du produit
                  Center(
                    child: Image.asset(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Indicateur de réduction
                  if (product.oldPrice != null)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.sizeFromWidth(6),
                          vertical: responsive.sizeFromHeight(2),
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.thirdColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          "-${product.getDiscountPercentage()!.toInt()}%",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.sizeFromWidth(10),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Bouton favori
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Obx(() {
                      // Trouver le produit actuel dans la liste pour obtenir son état à jour
                      final currentProduct = productController.allProducts
                          .firstWhere(
                            (p) => p.id == product.id,
                            orElse: () => product,
                          );

                      return IconButton(
                        icon: Icon(
                          currentProduct.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              currentProduct.isFavorite
                                  ? Colors.red
                                  : Colors.grey,
                          size: responsive.sizeFromWidth(20),
                        ),
                        onPressed:
                            () => productController.toggleFavorite(product.id),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Informations du produit
            SizedBox(height: responsive.sizeFromHeight(8)),

            // Nom du produit
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: responsive.sizeFromWidth(12),
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: responsive.sizeFromHeight(4)),

            // Prix
            Row(
              children: [
                Text(
                  "${product.price.toInt()} FCFA",
                  style: TextStyle(
                    fontSize: responsive.sizeFromWidth(14),
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                if (product.oldPrice != null) ...[
                  SizedBox(width: responsive.sizeFromWidth(4)),
                  Text(
                    "${product.oldPrice!.toInt()} FCFA",
                    style: TextStyle(
                      fontSize: responsive.sizeFromWidth(10),
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),

            SizedBox(height: responsive.sizeFromHeight(4)),

            // Évaluation
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: responsive.sizeFromWidth(14),
                ),
                SizedBox(width: responsive.sizeFromWidth(2)),
                Text(
                  product.rating.toString(),
                  style: TextStyle(
                    fontSize: responsive.sizeFromWidth(10),
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: responsive.sizeFromWidth(4)),
                Text(
                  "(${product.ratingCount})",
                  style: TextStyle(
                    fontSize: responsive.sizeFromWidth(10),
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
