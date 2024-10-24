import 'dart:convert';
import 'package:fire/model/postmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<Documents>? _products;
  bool _isLoading = false;
  String? _error;

  List<Documents>? get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http
          .get(Uri.parse('YOUR_API_URL')); 

      if (response.statusCode == 200) {
        final data = product_data.fromJson(json.decode(response.body));
        _products = data.documents;
      } else {
        _error = 'Failed to load products';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
