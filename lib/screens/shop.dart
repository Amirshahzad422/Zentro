import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../data/mock_data.dart';
import '../styles/theme.dart';
import '../components/product_card.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShopScreen extends StatefulWidget {
  final String? initialCategory;
  final bool isNewArrivals;
  
  const ShopScreen({
    super.key,
    this.initialCategory,
    this.isNewArrivals = false,
  });

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool isGridView = true;
  String _searchQuery = '';
  late String _selectedCategory;
  String? _selectedBrand;
  String? _selectedPriceRange;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'All Categories';
  }

  List<Product> get _filteredProducts {
    return mockProducts.where((Product p) {
      if (widget.isNewArrivals && !p.isNew) {
        return false;
      }
      
      final bool matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                                 p.brand.toLowerCase().contains(_searchQuery.toLowerCase());
      final bool matchesCategory = _selectedCategory == 'All Categories' || 
                                   p.category == _selectedCategory ||
                                   (_selectedCategory == 'Men' && (p.gender == 'Men' || p.gender == 'Unisex')) ||
                                   (_selectedCategory == 'Women' && (p.gender == 'Women' || p.gender == 'Unisex'));
      
      final bool matchesBrand = _selectedBrand == null || p.brand == _selectedBrand;
      
      bool matchesPrice = true;
      if (_selectedPriceRange != null) {
        if (_selectedPriceRange == 'Under \$100' && p.price >= 100) matchesPrice = false;
        else if (_selectedPriceRange == '\$100 - \$200' && (p.price < 100 || p.price > 200)) matchesPrice = false;
        else if (_selectedPriceRange == 'Over \$200' && p.price <= 200) matchesPrice = false;
      }
      
      if (matchesSearch && matchesCategory && matchesBrand && matchesPrice) {
        return true;
      } else {
        return false;
      }
    }).toList();
  }

  void _showBrandModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        final brands = ['All Brands', 'Zentro', 'Wool Blend', 'Pure Cotton', 'Italian Leather', 'Leather & Suede', 'Pure Silk'];
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Text('Filter by Brand', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: brands.length,
                      itemBuilder: (context, index) {
                        final brand = brands[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                          title: Text(brand),
                          trailing: (_selectedBrand == brand || (_selectedBrand == null && brand == 'All Brands'))
                              ? Icon(Icons.check, color: ZentroTheme.primary)
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedBrand = brand == 'All Brands' ? null : brand;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showPriceModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        final prices = ['All Prices', 'Under \$100', '\$100 - \$200', 'Over \$200'];
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          maxChildSize: 0.6,
          expand: false,
          builder: (_, controller) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Text('Filter by Price', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: prices.length,
                      itemBuilder: (context, index) {
                        final price = prices[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                          title: Text(price),
                          trailing: (_selectedPriceRange == price || (_selectedPriceRange == null && price == 'All Prices'))
                              ? Icon(Icons.check, color: ZentroTheme.primary)
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedPriceRange = price == 'All Prices' ? null : price;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16, vertical: 24),
              child: Column(
                children: [
                  _SearchBar(
                    onChanged: (val) => setState(() => _searchQuery = val),
                  ),
                  const SizedBox(height: 16),
                  _FilterChips(
                    selectedCategory: _selectedCategory,
                    onSelected: (val) => setState(() => _selectedCategory = val),
                    selectedBrand: _selectedBrand,
                    selectedPriceRange: _selectedPriceRange,
                    onBrandTap: _showBrandModal,
                    onPriceTap: _showPriceModal,
                  ),
                  const SizedBox(height: 16),
                  _ResultsHeader(
                    count: _filteredProducts.length,
                    isGridView: isGridView,
                    onToggleView: (val) => setState(() => isGridView = val),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16),
            sliver: isGridView
                ? SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop ? (MediaQuery.of(context).size.width >= 1024 ? 4 : 3) : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ProductCard(product: _filteredProducts[index]),
                      childCount: _filteredProducts.length,
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _ProductListCard(product: _filteredProducts[index]),
                      childCount: _filteredProducts.length,
                    ),
                  ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 48)),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  
  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: ZentroTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.search, color: ZentroTheme.onSurfaceVariant),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      hintText: 'Search boutique...',
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ZentroTheme.onSurfaceVariant.withOpacity(0.7),
                          ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: ZentroTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ZentroTheme.outlineVariant.withOpacity(0.3)),
          ),
          child: IconButton(
            icon: const Icon(Icons.tune),
            color: ZentroTheme.onSurface,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class _FilterChips extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelected;
  final String? selectedBrand;
  final String? selectedPriceRange;
  final VoidCallback onBrandTap;
  final VoidCallback onPriceTap;

  const _FilterChips({
    required this.selectedCategory,
    required this.onSelected,
    this.selectedBrand,
    this.selectedPriceRange,
    required this.onBrandTap,
    required this.onPriceTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(
            label: 'All Categories',
            isSelected: selectedCategory == 'All Categories',
            onTap: () => onSelected('All Categories'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Women',
            isSelected: selectedCategory == 'Women',
            onTap: () => onSelected('Women'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Men',
            isSelected: selectedCategory == 'Men',
            onTap: () => onSelected('Men'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Shoes',
            isSelected: selectedCategory == 'Shoes',
            onTap: () => onSelected('Shoes'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Accessories',
            isSelected: selectedCategory == 'Accessories',
            onTap: () => onSelected('Accessories'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: selectedBrand ?? 'Brand',
            isSelected: selectedBrand != null,
            hasDropdown: true,
            onTap: onBrandTap,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: selectedPriceRange ?? 'Price',
            isSelected: selectedPriceRange != null,
            hasDropdown: true,
            onTap: onPriceTap,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool hasDropdown;
  final VoidCallback? onTap;

  const _FilterChip({
    required this.label,
    this.isSelected = false,
    this.hasDropdown = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? ZentroTheme.primary : ZentroTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
          border: isSelected ? null : Border.all(color: ZentroTheme.outlineVariant.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected ? ZentroTheme.onPrimary : ZentroTheme.onSurface,
                  ),
            ),
            if (hasDropdown) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                size: 16,
                color: isSelected ? ZentroTheme.onPrimary : ZentroTheme.onSurface,
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  final int count;
  final bool isGridView;
  final ValueChanged<bool> onToggleView;

  const _ResultsHeader({required this.count, required this.isGridView, required this.onToggleView});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$count Results',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: ZentroTheme.onSurfaceVariant),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.grid_view, color: isGridView ? ZentroTheme.primary : ZentroTheme.onSurfaceVariant),
              onPressed: () => onToggleView(true),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 20,
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.view_list, color: !isGridView ? ZentroTheme.primary : ZentroTheme.onSurfaceVariant),
              onPressed: () => onToggleView(false),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 20,
            ),
          ],
        )
      ],
    );
  }
}

class _ProductListCard extends StatelessWidget {
  final Product product;
  const _ProductListCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: ZentroTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 30,
              offset: const Offset(0, 10),
            )
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 120,
              decoration: BoxDecoration(
                color: ZentroTheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: product.images.first,
                fit: BoxFit.cover,
                memCacheWidth: 200,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.brand,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ZentroTheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: ZentroTheme.primary,
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                context.read<CartProvider>().addItem(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} added to cart'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.add_circle),
              color: ZentroTheme.primary,
              iconSize: 32,
            )
          ],
        ),
      ),
    );
  }
}

