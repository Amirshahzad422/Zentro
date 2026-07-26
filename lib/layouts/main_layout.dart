import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../styles/theme.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/shop')) return 1;
    if (location.startsWith('/wishlist')) return 2;
    if (location.startsWith('/orders')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0; // Default to Home
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;
    return Scaffold(
      drawer: Drawer(
        backgroundColor: ZentroTheme.surfaceContainerLowest,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: ZentroTheme.slate900,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'ZENTRO',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: ZentroTheme.onPrimary,
                          fontFamily: 'Montserrat',
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Luxury Fashion Boutique',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ZentroTheme.surfaceContainerLow,
                        ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Us'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                context.go('/about');
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_support_outlined),
              title: const Text('Contact Us'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                context.go('/contact');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ZENTRO',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontFamily: 'Montserrat',
            letterSpacing: -1,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => context.go('/cart'),
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: ZentroTheme.surfaceContainerLowest.withOpacity(0.8),
        surfaceTintColor: Colors.transparent,
      ),
      body: child,
      bottomNavigationBar: isDesktop
          ? null
          : Container(
              decoration: BoxDecoration(
                color: ZentroTheme.surfaceContainerLowest.withOpacity(0.9),
                border: const Border(
                  top: BorderSide(color: ZentroTheme.outlineVariant, width: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -10),
                    blurRadius: 30,
                  )
                ],
              ),
              child: SafeArea(
                child: _CustomSlidingNavBar(
                  selectedIndex: _calculateSelectedIndex(context),
                  onDestinationSelected: (index) {
                    switch (index) {
                      case 0: context.go('/'); break;
                      case 1: context.go('/shop'); break;
                      case 2: context.go('/wishlist'); break;
                      case 3: context.go('/orders'); break;
                      case 4: context.go('/profile'); break;
                    }
                  },
                ),
              ),
            ),
    );
  }
}

class _CustomSlidingNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _CustomSlidingNavBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / 5;
    
    return SizedBox(
      height: 80,
      child: Stack(
        children: [
          // Sliding indicator
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            left: selectedIndex * itemWidth + (itemWidth / 2) - 32, // Center pill
            top: 16,
            child: Container(
              width: 64,
              height: 32,
              decoration: BoxDecoration(
                color: ZentroTheme.secondaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          // Icons and Text
          Row(
            children: [
              _NavBarItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                isSelected: selectedIndex == 0,
                onTap: () => onDestinationSelected(0),
                width: itemWidth,
              ),
              _NavBarItem(
                icon: Icons.storefront_outlined,
                activeIcon: Icons.storefront,
                label: 'Shop',
                isSelected: selectedIndex == 1,
                onTap: () => onDestinationSelected(1),
                width: itemWidth,
              ),
              _NavBarItem(
                icon: Icons.favorite_border,
                activeIcon: Icons.favorite,
                label: 'Wishlist',
                isSelected: selectedIndex == 2,
                onTap: () => onDestinationSelected(2),
                width: itemWidth,
              ),
              _NavBarItem(
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long,
                label: 'Orders',
                isSelected: selectedIndex == 3,
                onTap: () => onDestinationSelected(3),
                width: itemWidth,
              ),
              _NavBarItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                isSelected: selectedIndex == 4,
                onTap: () => onDestinationSelected(4),
                width: itemWidth,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double width;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 2), // Adjust vertical alignment
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? ZentroTheme.onSecondaryContainer : ZentroTheme.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected ? ZentroTheme.onSurface : ZentroTheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
