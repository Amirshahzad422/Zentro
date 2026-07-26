import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../styles/theme.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _filterStatus = 'All';

  List<OrderModel> _getFilteredOrders(List<OrderModel> allOrders) {
    if (_filterStatus == 'Active') {
      return allOrders.where((o) => o.isActive).toList();
    } else if (_filterStatus == 'Completed') {
      return allOrders.where((o) => !o.isActive).toList();
    }
    return allOrders;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;
    final allOrders = context.watch<OrderProvider>().orders;
    final filteredOrders = _getFilteredOrders(allOrders);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Orders',
                    style: isDesktop
                        ? Theme.of(context).textTheme.displaySmall
                        : Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track, manage, and reorder past purchases.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: ZentroTheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 24),
                  _buildFilterChips(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16),
            sliver: filteredOrders.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          'No $_filterStatus orders found.',
                          style: TextStyle(color: ZentroTheme.onSurfaceVariant),
                        ),
                      ),
                    ),
                  )
                : SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop ? 2 : 1,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      mainAxisExtent: 260, // Fixed height for order cards
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final order = filteredOrders[index];
                        return _buildOrderCard(
                          context: context,
                          order: order,
                        );
                      },
                      childCount: filteredOrders.length,
                    ),
                  ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 48)),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Row(
      children: [
        _buildChip('All'),
        const SizedBox(width: 8),
        _buildChip('Active'),
        const SizedBox(width: 8),
        _buildChip('Completed'),
      ],
    );
  }

  Widget _buildChip(String label) {
    final isSelected = _filterStatus == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterStatus = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? ZentroTheme.primary : ZentroTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? ZentroTheme.onPrimary : ZentroTheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showOrderDetails(BuildContext context, OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final total = order.product.price * order.quantity;
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order Summary', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Order #${order.orderId}', style: TextStyle(color: ZentroTheme.onSurfaceVariant)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: ZentroTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      imageUrl: order.product.images.first,
                      fit: BoxFit.cover,
                      memCacheWidth: 200,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Qty: ${order.quantity} • ${order.variant}', style: TextStyle(color: ZentroTheme.onSurfaceVariant, fontSize: 12)),
                      ],
                    ),
                  ),
                  Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal'),
                  Text('\$${total.toStringAsFixed(2)}'),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Shipping'),
                  Text('Free'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ZentroTheme.primary,
                    foregroundColor: ZentroTheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Close Details'),
                ),
              ),
              const SizedBox(height: 24), // Extra padding for safe area
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderCard({
    required BuildContext context,
    required OrderModel order,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ZentroTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ZentroTheme.outlineVariant.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #${order.orderId}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: ZentroTheme.onSurfaceVariant,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Placed ${order.date}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ZentroTheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: order.isActive ? ZentroTheme.secondaryContainer : ZentroTheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      order.isActive ? Icons.local_shipping : Icons.check_circle,
                      size: 16,
                      color: order.isActive ? ZentroTheme.onSecondaryContainer : ZentroTheme.onSurface,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      order.status,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: order.isActive ? ZentroTheme.onSecondaryContainer : ZentroTheme.onSurface,
                          ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: ZentroTheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(
                    imageUrl: order.product.images.first,
                    fit: BoxFit.cover,
                    memCacheWidth: 200,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        order.product.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Qty: ${order.quantity} • ${order.variant}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ZentroTheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${(order.product.price * order.quantity).toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: ZentroTheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if (!order.isActive) {
                      // Reorder logic
                      context.read<CartProvider>().addItem(order.product, quantity: 1);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${order.product.name} added to cart!'),
                          action: SnackBarAction(
                            label: 'View Cart',
                            onPressed: () => context.go('/cart'),
                          ),
                        ),
                      );
                    } else {
                      // Track logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Live tracking will be available when item is dispatched.'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: ZentroTheme.outlineVariant, width: 2),
                    foregroundColor: ZentroTheme.onSurface,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!order.isActive) ...[
                        const Icon(Icons.replay, size: 18),
                        const SizedBox(width: 4),
                        const Text('Reorder'),
                      ] else
                        const Text('Track Package'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showOrderDetails(context, order),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ZentroTheme.surfaceContainerLow,
                    foregroundColor: ZentroTheme.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('View Details'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
