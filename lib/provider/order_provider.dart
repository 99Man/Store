import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  bool _orderPlaced = false;

  bool get orderPlaced => _orderPlaced;

  void placeOrder() {
    _orderPlaced = true;
    notifyListeners();
  }

  void resetOrder() {
    _orderPlaced = false;
    notifyListeners();
  }
}
