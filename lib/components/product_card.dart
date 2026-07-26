import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../data/mock_data.dart';
import '../styles/theme.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () {
          context.push('/product/${widget.product.id}');
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: ZentroTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isHovered ? 0.08 : 0.02),
                blurRadius: 30,
                offset: const Offset(0, 10),
              )
            ],
          ),
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ZentroTheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: AnimatedScale(
                        scale: isHovered ? 1.05 : 1.0,
                        duration: const Duration(milliseconds: 500),
                        child: Hero(
                          tag: 'product_image_${widget.product.id}',
                          child: CachedNetworkImage(
                            imageUrl: widget.product.images.first,
                            fit: BoxFit.cover,
                            memCacheWidth: 400, // Optimize memory for thumbnails
                            errorWidget: (context, url, error) =>
                                const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
                          ),
                        ),
                      ),
                    ),
                    if (widget.product.discountPercentage != null)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: ZentroTheme.emerald,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '-${widget.product.discountPercentage!.toInt()}%',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: ZentroTheme.onPrimary,
                                ),
                          ),
                        ),
                      ),
                    if (widget.product.isNew)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: ZentroTheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'NEW',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: ZentroTheme.onSurface,
                                ),
                          ),
                        ),
                      ),
                    // Wishlist button
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Consumer<WishlistProvider>(
                        builder: (context, wishlist, child) {
                          final isFavorite = wishlist.isInWishlist(widget.product.id);
                          return IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? ZentroTheme.error : ZentroTheme.onSurfaceVariant,
                            ),
                            onPressed: () {
                              wishlist.toggleFavorite(widget.product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isFavorite ? 'Removed from wishlist' : 'Added to wishlist',
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    // Add to bag button overlay
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: AnimatedOpacity(
                        opacity: isHovered ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Consumer<CartProvider>(
                          builder: (context, cart, child) {
                            return GestureDetector(
                              onTap: () {
                                cart.addItem(widget.product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${widget.product.name} added to cart'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: ZentroTheme.surfaceContainerLowest.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                    )
                                  ],
                                ),
                                child: const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: ZentroTheme.primary,
                                  size: 20,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  widget.product.name,
                  style: Theme.of(context).textTheme.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  widget.product.brand,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ZentroTheme.onSurfaceVariant,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      '\$${widget.product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: ZentroTheme.primary,
                          ),
                    ),
                    const SizedBox(width: 8),
                    if (widget.product.originalPrice != null)
                      Text(
                        '\$${widget.product.originalPrice!.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: ZentroTheme.outline,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 14,
                            ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

