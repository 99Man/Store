import 'package:fire/provider/order_provider.dart';
import 'package:fire/utils/sized.dart';
import 'package:fire/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewOrders extends StatelessWidget {
  final String userId;

  const ViewOrders({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('User_Ordered_Products')
            .where('userId',
                isEqualTo: userId) // Fetch orders for the specific user
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders found"));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderData = orders[index].data() as Map<String, dynamic>;
              final items = orderData['items'] as List<dynamic>;
              final documentId = orderData["orderId"];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text("OrderId: ${orderData["orderId"]}", 12,
                              Colors.black, FontWeight.w800),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: text(
                                            "Do you really want to delete the placed order ?",
                                            15,
                                            Colors.black,
                                            FontWeight.w600),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: text(
                                                  "No",
                                                  10,
                                                  Colors.black,
                                                  FontWeight.bold)),
                                          TextButton(
                                              onPressed: () async {
                                                OrderProvider()
                                                    .deleteOrder(documentId);
                                                Navigator.pop(context);
                                              },
                                              child: text(
                                                  "Yes",
                                                  10,
                                                  Colors.black,
                                                  FontWeight.bold))
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.delete)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      text("Status: ${orderData["Status"]}", 14, Colors.grey,
                          FontWeight.bold),
                      const SizedBox(height: 5),
                      ...items.map((item) {
                        final itemMap = item as Map<String, dynamic>;
                        return Container(
                          width: getWidth(context),
                          height: 99,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(19)),
                          child: Card(
                            elevation: 2,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    bottomLeft: Radius.circular(14),
                                  ),
                                  child: Image.network(
                                    itemMap["imgUrl"],
                                    width: 99,
                                    height: 99,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Product Title: ${itemMap["title"] ?? 'N/A'}",
                                          style: GoogleFonts.prata(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        text(
                                            "Price: ${itemMap["price"] ?? "N/A"}",
                                            12,
                                            Colors.black,
                                            FontWeight.bold),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        text("Quantity: ${itemMap["quantity"]}",
                                            12, Colors.black, FontWeight.w700)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 10),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              text("Total Price: ${orderData["totalPrice"]}",
                                  13, Colors.grey, FontWeight.bold),
                              text("Total Items: ${items.length}", 13,
                                  Colors.grey, FontWeight.bold)
                            ],
                          )),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
