import 'package:fire/widget/list_items.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => List.from(_cartItems);

  void addItem(CartItem item) {
    final index = _cartItems.indexWhere((cartItem) => cartItem.id == item.id);

    if (index >= 0) {
      _cartItems[index].quantity += item.quantity;
    } else {
      final newitem = CartItem(
          title: item.title,
          price: item.price,
          imgUrl: item.imgUrl,
          sellerId: item.sellerId,
          id: item.id);
      _cartItems.add(newitem);
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
