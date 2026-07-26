import 'package:flutter/foundation.dart';
import '../data/mock_data.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  bool isInWishlist(String productId) {
    return _items.any((item) => item.id == productId);
  }

  void toggleFavorite(Product product) {
    if (isInWishlist(product.id)) {
      _items.removeWhere((item) => item.id == product.id);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }
}
