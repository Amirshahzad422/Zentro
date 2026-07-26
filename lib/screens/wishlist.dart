import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import '../styles/theme.dart';
import '../components/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Scaffold(
      body: Consumer<WishlistProvider>(
        builder: (context, wishlist, child) {
          final wishlistItems = wishlist.items;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Wishlist',
                        style: isDesktop
                            ? Theme.of(context).textTheme.displaySmall
                            : Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${wishlistItems.length} items saved',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: ZentroTheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              if (wishlistItems.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Text('Your wishlist is empty.'),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop ? 4 : (MediaQuery.of(context).size.width >= 768 ? 3 : 2),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ProductCard(product: wishlistItems[index]),
                      childCount: wishlistItems.length,
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 48)),
            ],
          );
        },
      ),
    );
  }
}

