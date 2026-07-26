import 'package:flutter/foundation.dart';
import '../data/mock_data.dart';
import 'cart_provider.dart';

class OrderModel {
  final String orderId;
  final String date;
  final String status;
  final bool isActive;
  final Product product;
  final int quantity;
  final String variant;

  OrderModel({
    required this.orderId,
    required this.date,
    required this.status,
    required this.isActive,
    required this.product,
    required this.quantity,
    required this.variant,
  });
}

class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [
    OrderModel(
      orderId: 'ZNT-8892',
      date: 'Oct 24, 2024',
      status: 'On the way',
      isActive: true,
      product: mockProducts[4],
      quantity: 2,
      variant: 'Matte Stone',
    ),
    OrderModel(
      orderId: 'ZNT-8104',
      date: 'Sep 12, 2024',
      status: 'Delivered',
      isActive: false,
      product: mockProducts[0],
      quantity: 1,
      variant: 'Standard',
    ),
    OrderModel(
      orderId: 'ZNT-7922',
      date: 'Aug 05, 2024',
      status: 'Delivered',
      isActive: false,
      product: mockProducts[2],
      quantity: 1,
      variant: 'Silver/Black',
    ),
  ];

  List<OrderModel> get orders => List.unmodifiable(_orders);

  void placeOrder(List<CartItem> cartItems) {
    if (cartItems.isEmpty) return;

    final now = DateTime.now();
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final String date = '${months[now.month - 1]} ${now.day.toString().padLeft(2, '0')}, ${now.year}';
    final String orderId = 'ZNT-${1000 + now.millisecond}'; // Simple random ID

    // Create an order entry for each cart item
    for (var item in cartItems) {
      _orders.insert(
        0,
        OrderModel(
          orderId: orderId,
          date: date,
          status: 'Processing',
          isActive: true,
          product: item.product,
          quantity: item.quantity,
          variant: 'Standard', // Could be extended in cart
        ),
      );
    }
    notifyListeners();
  }
}
