import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../styles/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkMode = false;

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: ZentroTheme.outline)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackbar('Logged out successfully (Demo)');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ZentroTheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16, vertical: 24),
        child: Column(
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 32),
            _buildNavigationList(context),
            const SizedBox(height: 16),
            _buildSettingsList(context),
            const SizedBox(height: 32),
            _buildLogoutButton(context),
            const SizedBox(height: 24),
            _buildVersionInfo(context),
            const SizedBox(height: 48), // Padding for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ZentroTheme.surfaceContainerLow, width: 4),
                image: const DecorationImage(
                  image: CachedNetworkImageProvider(
                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: ZentroTheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  color: ZentroTheme.onPrimary,
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  onPressed: () => _showSnackbar('Edit profile picture tapped'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Eleanor Vance',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: ZentroTheme.onSurface,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'eleanor.vance@example.com',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ZentroTheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _buildNavigationList(BuildContext context) {
    return _buildListContainer([
      _buildListTile(context, Icons.person_outline, 'Account Settings', () => _showSnackbar('Navigating to Account Settings...')),
      _buildListTile(context, Icons.location_on_outlined, 'My Addresses', () => _showSnackbar('Navigating to Addresses...')),
      _buildListTile(context, Icons.credit_card_outlined, 'Payment Methods', () => _showSnackbar('Navigating to Payment Methods...')),
    ]);
  }

  Widget _buildSettingsList(BuildContext context) {
    return _buildListContainer([
      _buildSwitchTile(context, Icons.dark_mode_outlined, 'Dark Mode', _isDarkMode),
      _buildListTile(context, Icons.shield_outlined, 'Privacy Policy', () => context.go('/about')),
      _buildListTile(context, Icons.help_outline, 'Help Center', () => context.go('/contact')),
    ]);
  }

  Widget _buildListContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: ZentroTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: ZentroTheme.surfaceVariant.withOpacity(0.5),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ZentroTheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: ZentroTheme.onSurfaceVariant, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: ZentroTheme.onSurface,
                    ),
              ),
            ),
            const Icon(Icons.chevron_right, color: ZentroTheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(BuildContext context, IconData icon, String title, bool value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ZentroTheme.surfaceVariant.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ZentroTheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: ZentroTheme.onSurfaceVariant, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: ZentroTheme.onSurface,
                  ),
            ),
          ),
          Switch(
            value: value,
            onChanged: (val) {
              setState(() {
                _isDarkMode = val;
              });
              if (val) {
                _showSnackbar('Dark Mode is coming in v3.0!');
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) setState(() => _isDarkMode = false);
                });
              }
            },
            activeColor: ZentroTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: _showLogoutDialog,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: ZentroTheme.error),
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ZentroTheme.error,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionInfo(BuildContext context) {
    return Text(
      'Zentro App v2.4.1',
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: ZentroTheme.outline,
          ),
    );
  }
}
