import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/mock_data.dart';
import '../styles/theme.dart';
import '../components/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            _HeroCarousel(),
            SizedBox(height: 48),
            _CategoriesScroll(),
            SizedBox(height: 48),
            _FeaturedProducts(),
            SizedBox(height: 48),
            _WhyChooseUs(),
            SizedBox(height: 48),
            _Footer(),
          ],
        ),
      ),
    );
  }
}

class _HeroCarousel extends StatefulWidget {
  const _HeroCarousel();

  @override
  State<_HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<_HeroCarousel> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> slides = [
    {
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuD2LQDoT0CHCCjdkQxdI85aUhlpTc_Z0ytpyaOkRm4VGA3ECTASvo1oOCiIoEh-OFAz_u-H2QToTB7GqJf7dIqLUSf3vaXntLzdvCEYHcAxrO2eQgB-pyU94O0nleDC_2mV64YhuvO_OyUvdhM4yNht4zbtvMImpxcPf_BiJyxPLF1ZOxPMqvHdnMXpLLuTk6-w9zD2ulhXv5MlltNsqe9nEHh0C_2cz86MlPfx1eb1dIQRoP2hcVbqfwj8AaIF3M_g1qIGH1mLVLw',
      'title': 'New Arrivals',
      'subtitle': 'Discover the latest in sophisticated minimalism for the modern professional.',
      'button': 'Shop Now',
    },
    {
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCH6PxpbI7qp3MXOKm4unODwJczhaTz2wCaTnF3Rkb66OmJAzkldPMVF4EUBqLSnwy2t_wgeWcvQl5BitKgMAmceyAVoeGqtHnvv6Q6y7JtB20b_Ce_l2g4zqkH4tSlmwwTMYX_x-62SX5_hTDTHVc3vZ59dmUJmqxJJTS3fZ6WBmYaHOsttP8ibBmrHnVWeCmK-aMXYMVQzN7GB22Nngo0U6ZzIXQAvXlIL0QDFUZzOg2__6SmTNbOjgYdSCowcCx6QapAphmX-AA',
      'title': 'Essential Accessories',
      'subtitle': 'Elevate your daily carry with our curated selection of premium leather goods.',
      'button': 'Explore',
    }
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < slides.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_controller.hasClients) {
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_controller.hasClients && _currentPage < slides.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else if (_controller.hasClients) {
      _controller.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _prevPage() {
    if (_controller.hasClients && _currentPage > 0) {
      _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else if (_controller.hasClients) {
      _controller.animateToPage(slides.length - 1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 530px mobile, 707px desktop
    final isDesktop = MediaQuery.of(context).size.width >= 768;
    return SizedBox(
      height: isDesktop ? 707 : 530,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemCount: slides.length,
            itemBuilder: (context, index) {
              final slide = slides[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: slide['image']!,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          ZentroTheme.tertiary.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: isDesktop ? 32 : 16,
                    left: isDesktop ? 32 : 16,
                    right: isDesktop ? null : 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          slide['title']!,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: isDesktop ? 400 : null,
                          child: Text(
                            slide['subtitle']!,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: ZentroTheme.surfaceContainerLow,
                                ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            if (slide['title'] == 'New Arrivals') {
                              context.go('/shop?new=true');
                            } else {
                              context.go('/shop?category=Accessories');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ZentroTheme.slate900,
                            foregroundColor: ZentroTheme.onPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            slide['button']!,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: ZentroTheme.onPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Row(
              children: [
                _CarouselButton(icon: Icons.chevron_left, onTap: _prevPage),
                const SizedBox(width: 8),
                _CarouselButton(icon: Icons.chevron_right, onTap: _nextPage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CarouselButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CarouselButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: ZentroTheme.surfaceContainerLow.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: ZentroTheme.primary),
      ),
    );
  }
}

class _CategoriesScroll extends StatelessWidget {
  const _CategoriesScroll();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shop by Category',
            style: isDesktop
                ? Theme.of(context).textTheme.headlineMedium
                : Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: isDesktop ? 240 : 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: mockCategories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final cat = mockCategories[index];
                return GestureDetector(
                  onTap: () => context.go('/shop?category=${Uri.encodeComponent(cat.name)}'),
                  child: SizedBox(
                    width: isDesktop ? 192 : 128,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ZentroTheme.surfaceContainerLow,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: CachedNetworkImage(
                              imageUrl: cat.imageUrl,
                              fit: BoxFit.cover,
                              memCacheWidth: 200,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cat.name,
                          style: Theme.of(context).textTheme.labelLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedProducts extends StatelessWidget {
  const _FeaturedProducts();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;
    // Featured is first 4 products
    final products = mockProducts.take(4).toList();
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Featured Selection',
                style: isDesktop
                    ? Theme.of(context).textTheme.headlineMedium
                    : Theme.of(context).textTheme.titleLarge,
              ),
              if (isDesktop)
                TextButton(
                  onPressed: () => context.go('/shop'),
                  child: Text(
                    'View All',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: ZentroTheme.secondary,
                        ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: isDesktop ? 4 : 2, // show 4 on desktop, 2 on mobile (as per HTML logic)
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 4 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          ),
          if (!isDesktop)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: OutlinedButton(
                onPressed: () => context.go('/shop'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: ZentroTheme.slate300, width: 1.5),
                  backgroundColor: ZentroTheme.surfaceContainerLow,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'View All Products',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: ZentroTheme.slate900,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WhyChooseUs extends StatelessWidget {
  const _WhyChooseUs();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16),
      child: Column(
        children: [
          Text(
            'The Zentro Promise',
            style: isDesktop
                ? Theme.of(context).textTheme.headlineMedium
                : Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (isDesktop)
            Row(
              children: [
                Expanded(child: _FeatureCard(icon: Icons.local_shipping, title: 'Express Delivery', desc: 'Complimentary worldwide shipping on orders over \$200.')),
                const SizedBox(width: 16),
                Expanded(child: _FeatureCard(icon: Icons.verified, title: 'Curated Quality', desc: 'Every piece is rigorously inspected for craftsmanship and timeless design.', isAmber: true)),
                const SizedBox(width: 16),
                Expanded(child: _FeatureCard(icon: Icons.sync, title: 'Easy Returns', desc: '30-day seamless return policy for your complete satisfaction.')),
              ],
            )
          else
            Column(
              children: [
                _FeatureCard(icon: Icons.local_shipping, title: 'Express Delivery', desc: 'Complimentary worldwide shipping on orders over \$200.'),
                const SizedBox(height: 16),
                _FeatureCard(icon: Icons.verified, title: 'Curated Quality', desc: 'Every piece is rigorously inspected for craftsmanship and timeless design.', isAmber: true),
                const SizedBox(height: 16),
                _FeatureCard(icon: Icons.sync, title: 'Easy Returns', desc: '30-day seamless return policy for your complete satisfaction.'),
              ],
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ZentroTheme.slate900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.diamond, color: ZentroTheme.amber, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  'Zentro Exclusive',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: ZentroTheme.onPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Join our inner circle for early access to limited collections, private sales, and personalized styling services.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ZentroTheme.surfaceContainerLow),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ZentroTheme.surfaceContainerLowest,
                    foregroundColor: ZentroTheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  ),
                  child: const Text('Join Now'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final bool isAmber;

  const _FeatureCard({required this.icon, required this.title, required this.desc, this.isAmber = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ZentroTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ZentroTheme.surfaceContainerHighest),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isAmber ? ZentroTheme.amber.withOpacity(0.2) : ZentroTheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isAmber ? ZentroTheme.slate900 : ZentroTheme.primary, size: 32),
          ),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Text(desc, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ZentroTheme.onSurfaceVariant), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;
    if (!isDesktop) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: ZentroTheme.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ZENTRO', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text('Curating modern luxury for the discerning individual.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ZentroTheme.onSurfaceVariant)),
                ],
              ),
              Row(
                children: [
                  _FooterLink('About Us'),
                  const SizedBox(width: 32),
                  _FooterLink('Shipping Policy'),
                  const SizedBox(width: 32),
                  _FooterLink('Returns'),
                  const SizedBox(width: 32),
                  _FooterLink('Contact'),
                  const SizedBox(width: 32),
                  _FooterLink('Privacy'),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: ZentroTheme.outlineVariant),
          const SizedBox(height: 24),
          Center(
            child: Text('© 2026 ZENTRO Boutique. All rights reserved.', style: Theme.of(context).textTheme.bodyMedium),
          )
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  const _FooterLink(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ZentroTheme.onSurfaceVariant),
    );
  }
}
