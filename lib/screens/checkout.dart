import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../data/mock_data.dart';
import '../styles/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _deliveryOption = 0;
  int _paymentOption = 0;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

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
          'Checkout',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontFamily: 'Montserrat',
            letterSpacing: -1,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildShippingAddress(),
                        const SizedBox(height: 24),
                        _buildDeliveryMethod(),
                        const SizedBox(height: 24),
                        _buildPaymentMethod(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 5,
                    child: Consumer<CartProvider>(
                      builder: (context, cart, child) => _buildOrderSummary(context, cart),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildShippingAddress(),
                  const SizedBox(height: 24),
                  _buildDeliveryMethod(),
                  const SizedBox(height: 24),
                  _buildPaymentMethod(),
                  const SizedBox(height: 32),
                  Consumer<CartProvider>(
                    builder: (context, cart, child) => _buildOrderSummary(context, cart),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
      ),
    );
  }

  Widget _buildShippingAddress() {
    return _buildSection(
      icon: Icons.location_on,
      title: 'Shipping Address',
      actionText: 'Change',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Elena Rodriguez'),
          const SizedBox(height: 4),
          Text(
            '123 Design Avenue, Apt 4B\nNew York, NY 10011\nUnited States',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ZentroTheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '+1 (555) 123-4567',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ZentroTheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryMethod() {
    return _buildSection(
      icon: Icons.local_shipping,
      title: 'Delivery Method',
      child: Column(
        children: [
          _buildOptionTile(
            value: 0,
            groupValue: _deliveryOption,
            onChanged: (val) => setState(() => _deliveryOption = val!),
            title: 'Standard Delivery',
            trailing: 'Free',
            subtitle: 'Estimated arrival: Oct 24 - 26',
          ),
          const SizedBox(height: 12),
          _buildOptionTile(
            value: 1,
            groupValue: _deliveryOption,
            onChanged: (val) => setState(() => _deliveryOption = val!),
            title: 'Express Delivery',
            trailing: '\$15.00',
            subtitle: 'Next day delivery (Order before 2 PM)',
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return _buildSection(
      icon: Icons.payment,
      title: 'Payment Method',
      actionText: 'Add New',
      child: Column(
        children: [
          _buildOptionTile(
            value: 0,
            groupValue: _paymentOption,
            onChanged: (val) => setState(() => _paymentOption = val!),
            titleWidget: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F36),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('VISA', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                const Text('•••• 4242', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildOptionTile(
            value: 1,
            groupValue: _paymentOption,
            onChanged: (val) => setState(() => _paymentOption = val!),
            titleWidget: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Pay', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                const Text('Apple Pay', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    String? actionText,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ZentroTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ZentroTheme.surfaceVariant.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          )
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(icon, color: ZentroTheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ZentroTheme.primary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              if (actionText != null)
                TextButton(
                  onPressed: () {},
                  child: Text(
                    actionText,
                    style: const TextStyle(
                      color: ZentroTheme.onSurfaceVariant,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 32), // Indent to align with text
            child: child,
          )
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required int value,
    required int groupValue,
    required ValueChanged<int?> onChanged,
    String? title,
    Widget? titleWidget,
    String? trailing,
    String? subtitle,
  }) {
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: ZentroTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? ZentroTheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Radio<int>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: ZentroTheme.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: titleWidget ?? Text(title ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      if (trailing != null) Text(trailing, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ZentroTheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartProvider cart) {
    final items = cart.items;
    final subtotal = cart.subtotal;
    final shipping = _deliveryOption == 0 ? 0.0 : 15.0;
    final tax = cart.taxes;
    final total = subtotal + shipping + tax;

    return Container(
      decoration: BoxDecoration(
        color: ZentroTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ZentroTheme.surfaceVariant.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          )
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Order Summary',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          ...items.map((e) => _buildSummaryItem(e)).toList(),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _buildSummaryRow('Shipping', shipping == 0 ? 'Free' : '\$${shipping.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _buildSummaryRow('Estimated Tax', '\$${tax.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: ZentroTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: ZentroTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: items.isEmpty ? null : () {
              // Add orders to OrderProvider
              context.read<OrderProvider>().placeOrder(items);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order placed successfully!')),
              );
              cart.clear(); // Clear the cart after placing order
              context.go('/');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A), // Specific dark color from design
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Place Order', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.lock, size: 16),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'By placing your order, you agree to Zentro\'s Terms of Service and Privacy Policy.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: ZentroTheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(CartItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: ZentroTheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              imageUrl: item.product.images.first,
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
                  item.product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(color: ZentroTheme.onSurfaceVariant, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ZentroTheme.onSurfaceVariant,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
