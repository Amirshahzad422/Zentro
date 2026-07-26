import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../styles/theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

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
          'About Us',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontFamily: 'Montserrat',
            letterSpacing: -1,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'ZENTRO',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: ZentroTheme.primary,
                        letterSpacing: -2,
                      ),
                ),
                const SizedBox(height: 24),
                Text(
                  'We believe in minimalism, quality, and design. Zentro was founded with a simple mission: to bring curated, premium products to those who appreciate the finer details.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: ZentroTheme.onSurfaceVariant,
                        height: 1.6,
                      ),
                ),
                const SizedBox(height: 48),
                Row(
                  children: [
                    Expanded(
                      child: _buildValueCard(
                        context,
                        Icons.diamond_outlined,
                        'Premium Quality',
                        'Sourced from the best artisans worldwide.',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildValueCard(
                        context,
                        Icons.eco_outlined,
                        'Sustainable',
                        'Ethically made with minimal environmental impact.',
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValueCard(BuildContext context, IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ZentroTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ZentroTheme.surfaceVariant.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: ZentroTheme.primary),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ZentroTheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
