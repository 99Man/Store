import 'package:fire/UI/user_screens/user_info.dart';
import 'package:fire/notification/notification.dart';
import 'package:fire/notification/push_notifications.dart';
import 'package:fire/provider/cart_provider.dart';
import 'package:fire/provider/order_provider.dart';
import 'package:fire/utils/text.dart';
import 'package:fire/utils/utils.dart';
import 'package:fire/utils/variable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  String documentId;
  CartScreen({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    // final orderId = FirebaseFirestore.instance.collection("")
    // final sellertoken = FirebaseFirestore.instance.collection("Posts").where(documentId, isEqualTo: "userId").snapshots;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: text("Your Cart", 20, Colors.black, FontWeight.bold),
      ),
      body: cartProvider.cartItems.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      var cartItem = cartProvider.cartItems[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 5),
                        child: Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        bottomRight: Radius.circular(12)),
                                    child: Image.network(
                                      cartItem.imgUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 170,
                                        child: Text(
                                          "Title : ${cartItem.title}",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      text("Price:  \$ ${cartItem.price}", 12,
                                          Colors.black, FontWeight.w700),
                                      const SizedBox(height: 7),
                                      Text(
                                        "Quantity: ${cartItem.quantity}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      // Container(
                                      //   width: 130,
                                      //   child: Text(
                                      //     "SellerId : ${cartItem.sellerId}",
                                      //     style: const TextStyle(
                                      //         fontSize: 15,
                                      //         fontWeight: FontWeight.w700,
                                      //         color: Colors.black),
                                      //     maxLines: 2,
                                      //     overflow: TextOverflow.ellipsis,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Delete Post"),
                                        content: const Text(
                                            "Are you sure you want to delete this post?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("No"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              cartProvider.removeItem(cartItem);
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Yes"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.delete),
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                    onPressed: () async {
                      String sellerId = cartProvider.cartItems.first.sellerId!;
                      String? sellerToken = await NotificationRequest().getSellerField(sellerId);
                      Utilgreen()
                          .fluttertoastmessage("Seller Name: $sellerToken");

                      if (sellerToken != null) {
                        orderProvider.placeOrder(
                          FirebaseAuth.instance.currentUser!.uid,
                          cartProvider.cartItems,
                          sellerId,
                        );

                        if (orderProvider.orderPlaced) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Order Placed"),
                                content: Text(
                                    "Your order has been successfully placed"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      cartProvider.clearCart();
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        EasyLoading.show();
                        await PushNotifications.getPushNotificaitons(
                            senderId: devicetoken,
                            receiverId: sellerToken,
                            title: "A new order is placed",
                            body: "Check your order screen",
                            data: {"screen": "cart"});

                        EasyLoading.dismiss();
                      } else {
                        Utilred().fluttertoastmessage(
                            "Failed to retrieve seller Id token");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      elevation: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_cart,
                          size: 30,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        text("Place Order", 18, Colors.black, FontWeight.bold),
                      ],
                    ),
                  ),
                        // child: Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     const Icon(
                        //       Icons.shopping_bag,
                        //       size: 30,
                        //       color: Colors.black,
                        //     ),
                        //     SizedBox(
                        //       width: 12,
                        //     ),
                        //     text("Place Order", 18, Colors.black,
                        //         FontWeight.bold)
                        //   ],
                        // )
                        ),
                const SizedBox(height: 75),
              ],
            ),
    );
  }
}




// ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const PersonalInfo()));
//                         },
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 10),
//                           elevation: 15,
//                         ),