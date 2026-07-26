import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home.dart';
import 'screens/shop.dart';
import 'screens/product_details.dart';
import 'screens/cart.dart';
import 'screens/checkout.dart';
import 'screens/wishlist.dart';
import 'screens/orders.dart';
import 'screens/profile.dart';
import 'screens/about.dart';
import 'screens/contact.dart';
import 'screens/not_found.dart';
import 'layouts/main_layout.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const NotFoundScreen(),
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/shop',
          builder: (context, state) => ShopScreen(
            initialCategory: state.uri.queryParameters['category'],
            isNewArrivals: state.uri.queryParameters['new'] == 'true',
          ),
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: '/wishlist',
          builder: (context, state) => const WishlistScreen(),
        ),
        GoRoute(
          path: '/orders',
          builder: (context, state) => const OrdersScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const AboutScreen(),
        ),
        GoRoute(
          path: '/contact',
          builder: (context, state) => const ContactScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) => ProductDetailsScreen(
        productId: state.pathParameters['id'],
      ),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
  ],
);
