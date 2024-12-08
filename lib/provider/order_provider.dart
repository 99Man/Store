import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/utils/utils.dart';
import 'package:fire/widget/list_items.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _orderPlaced = false;

  bool get orderPlaced => _orderPlaced;

  Future<void> placeOrder(
    String userId,
    List<CartItem> cartItems,
    String sellerId,
  ) async {
    try {
      final orderId = DateTime.now().microsecondsSinceEpoch.toString();
      final sellerID = cartItems.map((item) => {item.sellerId});
      final sellerRef = _firestore.collection("Orders_by_Users").doc(orderId);
      final orderRef =
          _firestore.collection("User_Ordered_Products").doc(orderId);

      double totalPrice = cartItems.fold(0.0,
          (sums, item) => sums + (double.parse(item.price) * item.quantity));
      // print('Cart Items: ${cartItems.map((item) => item.toString()).toList()}');

      await orderRef.set({
        "userId": userId,
        "orderId": orderId,
        "totalPrice": totalPrice,
        "Status": "Pending",
        // "Status": Status.pending,
        "items": cartItems
            .map((item) => {
                  "title": item.title,
                  "price": item.price,
                  "quantity": item.quantity,
                  "imgUrl": item.imgUrl,
                  "sellerId": item.sellerId,
                  "total_Product_price":
                      double.parse(item.price) * item.quantity,
                  "id": DateTime.now().microsecondsSinceEpoch.toString()
                })
            .toList(),
      });
      await sellerRef.set({
        "orderId": orderId,
        "userId": userId,
        "Status": "Pending",
        "items": cartItems
            .map((item) => {
                  "title": item.title,
                  "price": item.price,
                  "quantity": item.quantity,
                  "imgUrl": item.imgUrl,
                  "sellerId": item.sellerId,
                  "id": DateTime.now().microsecondsSinceEpoch.toString()
                })
            .toList(),
        "total_Price": totalPrice,
        "SellerId": cartItems.first.sellerId,
        "timeStamp": FieldValue.serverTimestamp(),
      });

      Utilgreen().fluttertoastmessage("Your Order is Placed");
      _orderPlaced = true;
      // final cartItem = List.unmodifiable(cartItems);
      // final modifiableList = List.from(cartItem);
      cartItems.clear();
      notifyListeners();
    } catch (e) {
      _orderPlaced = false;
      Utilred().fluttertoastmessage(
          "There is some issue placing this order.  Error :  ${e.toString()}");
      print("There is some issue placing this order ${e.toString()}");
    }
  }

  Future<void> deleteOrder(String documentId) async {
    try {
      await _firestore
          .collection("User_Ordered_Products")
          .doc(documentId)
          .delete();
      await _firestore.collection("Orders_by_Users").doc(documentId).delete();
      Utilgreen().fluttertoastmessage("Your Order is deleted");
    } catch (e) {
      Utilred()
          .fluttertoastmessage("There is some issue deleting this order : $e");
    }
  }

  void resetOrder() {
    _orderPlaced = false;
    notifyListeners();
  }
}
