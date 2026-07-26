import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../styles/theme.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 120,
                color: ZentroTheme.onSurfaceVariant.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
              Text(
                '404',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: ZentroTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Page Not Found',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: ZentroTheme.onSurface,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'The page you are looking for might have been removed, had its name changed, or is temporarily unavailable.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: ZentroTheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go('/'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ZentroTheme.primary,
                  foregroundColor: ZentroTheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.home, size: 20),
                    SizedBox(width: 8),
                    Text('Back to Home', style: TextStyle(fontWeight: FontWeight.bold)),
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
