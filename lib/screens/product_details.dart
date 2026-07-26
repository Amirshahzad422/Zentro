import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../data/mock_data.dart';
import '../styles/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String? productId;
  const ProductDetailsScreen({super.key, this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  String? _selectedColor;
  String? _selectedSize;
  int _currentImageIndex = 0;
  bool _isDescriptionExpanded = true;
  bool _isShippingExpanded = false;

  @override
  Widget build(BuildContext context) {
    final product = mockProducts.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => mockProducts.first,
    );
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    if (_selectedColor == null && product.colors.isNotEmpty) {
      _selectedColor = product.colors.first;
    }
    if (_selectedSize == null && product.sizes.isNotEmpty) {
      _selectedSize = product.sizes.first;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: Text(
          'ZENTRO',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontFamily: 'Montserrat',
            letterSpacing: -1,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => context.go('/cart'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: isDesktop ? 48 : 100, // Make room for mobile bottom bar
            ),
            child: Padding(
              padding: EdgeInsets.all(isDesktop ? 32 : 16),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildGallery(product)),
                        const SizedBox(width: 48),
                        Expanded(child: _buildDetails(product, true)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGallery(product),
                        const SizedBox(height: 24),
                        _buildDetails(product, false),
                      ],
                    ),
            ),
          ),
          if (!isDesktop)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildMobileBottomBar(product),
            ),
        ],
      ),
    );
  }

  Widget _buildGallery(Product product) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 4 / 5,
          child: Container(
            decoration: BoxDecoration(
              color: ZentroTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'product_image_${product.id}',
                  child: CachedNetworkImage(
                    imageUrl: product.images.isNotEmpty ? product.images[_currentImageIndex] : '',
                    fit: BoxFit.cover,
                    memCacheWidth: 800, // Higher for details hero
                  ),
                ),
                if (product.discountPercentage != null)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: ZentroTheme.emerald,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '-${product.discountPercentage!.toInt()}%',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: ZentroTheme.onPrimary,
                            ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Consumer<WishlistProvider>(
                    builder: (context, wishlist, child) {
                      final isFavorite = wishlist.isInWishlist(product.id);
                      return Container(
                        decoration: BoxDecoration(
                          color: ZentroTheme.surfaceContainerLowest.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? ZentroTheme.error : ZentroTheme.onSurface,
                          ),
                          onPressed: () {
                            wishlist.toggleFavorite(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFavorite ? 'Removed from wishlist' : 'Added to wishlist',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        if (product.images.length > 1) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: product.images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = index == _currentImageIndex;
                return GestureDetector(
                  onTap: () => setState(() => _currentImageIndex = index),
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      color: ZentroTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? ZentroTheme.primary : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      imageUrl: product.images[index],
                      fit: BoxFit.cover,
                      memCacheWidth: 200,
                    ),
                  ),
                );
              },
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildDetails(Product product, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < product.rating.floor() ? Icons.star : Icons.star_half,
                  color: ZentroTheme.amber,
                  size: 16,
                );
              }),
            ),
            const SizedBox(width: 8),
            Text(
              '(${product.reviewCount} Reviews)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ZentroTheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          product.name,
          style: isDesktop
              ? Theme.of(context).textTheme.headlineMedium
              : Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: ZentroTheme.primary,
                  ),
            ),
            const SizedBox(width: 12),
            if (product.originalPrice != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  '\$${product.originalPrice!.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: ZentroTheme.onSurfaceVariant,
                        decoration: TextDecoration.lineThrough,
                      ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),
        if (product.colors.isNotEmpty) ...[
          Text(
            'COLOR: ${_selectedColor?.toUpperCase() ?? ''}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: ZentroTheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: product.colors.map((color) {
              final isSelected = color == _selectedColor;
              // Mock color logic based on string
              Color displayColor = Colors.grey;
              if (color.toLowerCase() == 'black') displayColor = Colors.black;
              if (color.toLowerCase() == 'white') displayColor = Colors.white;
              if (color.toLowerCase() == 'navy') displayColor = Colors.indigo;
              if (color.toLowerCase() == 'tan' || color.toLowerCase() == 'camel') displayColor = const Color(0xFFC28A5C);

              return GestureDetector(
                onTap: () => setState(() => _selectedColor = color),
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: displayColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ZentroTheme.outlineVariant,
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: ZentroTheme.primary.withOpacity(0.4),
                              spreadRadius: 2,
                              blurRadius: 4,
                            )
                          ]
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
        if (product.sizes.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SIZE',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: ZentroTheme.onSurfaceVariant,
                    ),
              ),
              Text(
                'Size Guide',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: ZentroTheme.primary,
                      decoration: TextDecoration.underline,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: product.sizes.map((size) {
              final isSelected = size == _selectedSize;
              return GestureDetector(
                onTap: () => setState(() => _selectedSize = size),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? ZentroTheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? ZentroTheme.primary : ZentroTheme.outlineVariant,
                    ),
                  ),
                  child: Text(
                    size,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: isSelected ? ZentroTheme.onPrimary : ZentroTheme.onSurfaceVariant,
                        ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
        if (isDesktop) ...[
          Row(
            children: [
              _buildQuantitySelector(),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    return ElevatedButton(
                      onPressed: () {
                        cart.addItem(product, quantity: _quantity);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} added to cart'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ZentroTheme.primary,
                        foregroundColor: ZentroTheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Add to Cart'),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ZentroTheme.amber,
                    foregroundColor: ZentroTheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Buy Now'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
        const Divider(color: ZentroTheme.outlineVariant),
        _buildAccordion(
          title: 'Description',
          isExpanded: _isDescriptionExpanded,
          content: product.description,
          onTap: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
        ),
        const Divider(color: ZentroTheme.outlineVariant),
        _buildAccordion(
          title: 'Shipping & Returns',
          isExpanded: _isShippingExpanded,
          content: 'Free standard shipping on all orders over \$200. Returns accepted within 30 days of purchase in unworn condition with tags attached.',
          onTap: () => setState(() => _isShippingExpanded = !_isShippingExpanded),
        ),
        const Divider(color: ZentroTheme.outlineVariant),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      decoration: BoxDecoration(
        color: ZentroTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 20),
            color: ZentroTheme.onSurfaceVariant,
            onPressed: () {
              if (_quantity > 1) setState(() => _quantity--);
            },
          ),
          SizedBox(
            width: 32,
            child: Text(
              '$_quantity',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 20),
            color: ZentroTheme.onSurfaceVariant,
            onPressed: () {
              setState(() => _quantity++);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccordion({
    required String title,
    required bool isExpanded,
    required String content,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: ZentroTheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ZentroTheme.onSurfaceVariant,
                    height: 1.5,
                  ),
            ),
          ),
      ],
    );
  }

  Widget _buildMobileBottomBar(Product product) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ZentroTheme.surfaceContainerLowest.withOpacity(0.9),
        border: const Border(top: BorderSide(color: ZentroTheme.outlineVariant, width: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -10),
            blurRadius: 30,
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            _buildQuantitySelector(),
            const SizedBox(width: 16),
            Expanded(
              child: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  return ElevatedButton(
                    onPressed: () {
                      cart.addItem(product, quantity: _quantity);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ZentroTheme.primary,
                      foregroundColor: ZentroTheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Add to Cart'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
