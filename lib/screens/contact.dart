import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../styles/theme.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

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
          'Contact Us',
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
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Get in Touch',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: ZentroTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Have a question or need support? We\'re here to help.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: ZentroTheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: ZentroTheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ZentroTheme.surfaceVariant.withOpacity(0.5)),
                  ),
                  child: Column(
                    children: [
                      _buildContactItem(
                        context,
                        Icons.email_outlined,
                        'Email',
                        'support@zentro.com',
                      ),
                      const Divider(height: 32),
                      _buildContactItem(
                        context,
                        Icons.phone_outlined,
                        'Phone',
                        '+1 (800) 123-4567',
                      ),
                      const Divider(height: 32),
                      _buildContactItem(
                        context,
                        Icons.location_on_outlined,
                        'Address',
                        '123 Design Avenue, NY 10011',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ZentroTheme.primary,
                    foregroundColor: ZentroTheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Send us a Message', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, IconData icon, String title, String detail) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ZentroTheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: ZentroTheme.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: ZentroTheme.onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                detail,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
