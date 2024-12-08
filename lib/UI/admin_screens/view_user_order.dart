import 'package:fire/notification/notification.dart';
import 'package:fire/notification/push_notifications.dart';
import 'package:fire/provider/cart_provider.dart';
import 'package:fire/utils/sized.dart';
import 'package:fire/utils/text.dart';
import 'package:fire/utils/utils.dart';
import 'package:fire/utils/variable.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewUserOrders extends StatefulWidget {
  final String userId;

  ViewUserOrders({super.key, required this.userId});

  @override
  State<ViewUserOrders> createState() => _ViewUserOrdersState();
}

class _ViewUserOrdersState extends State<ViewUserOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: text('User Orders', 20, Colors.black, FontWeight.bold),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Orders_by_Users')
            .where("SellerId", isEqualTo: widget.userId)
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
            padding: const EdgeInsets.all(16.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderData = orders[index].data() as Map<String, dynamic>;
              final items = orderData['items'] as List<dynamic>;
              final orderId = orders[index].id;
              final usertoken = orderData["userId"].toString();
              dynamic currentStatus = orderData['Status'] ?? 'Pending';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Card(
                  color: Colors.white,
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
                                child: DropdownButton<String>(
                                  value: currentStatus,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  items: ['Pending', 'Departure', 'Arrived']
                                      .map((String status) {
                                    return DropdownMenuItem<String>(
                                      value: status,
                                      child: Text(status),
                                    );
                                  }).toList(),
                                  onChanged: (newStatus) async {
                                    String? sellerToken =
                                        await NotificationRequest()
                                            .getSellerField(usertoken);

                                    if (sellerToken != null &&
                                        sellerToken.isNotEmpty) {
                                      EasyLoading.show();
                                      await PushNotifications.getPushNotificaitons(
                                          senderId: devicetoken!,
                                          receiverId: sellerToken,
                                          title: "Status",
                                          body:
                                              "Status has been changed by the Seller",
                                          data: {"screen": "status"});

                                      if (newStatus != null) {
                                        FirebaseFirestore.instance
                                            .collection('Orders_by_Users')
                                            .doc(orderId)
                                            .update({'Status': newStatus});
                                        FirebaseFirestore.instance
                                            .collection("User_Ordered_Products")
                                            .doc(orderId)
                                            .update({"Status": newStatus});
                                      }
                                      EasyLoading.dismiss();
                                      Utilgreen().fluttertoastmessage(
                                          "Status has been updated");
                                    } else {
                                      Utilred().fluttertoastmessage(
                                          "Seller token is empty ");
                                    }
                                    currentStatus =
                                        orderData["Status"] ?? "Pending";
                                    return currentStatus;
                                  },
                                )),
                          ],
                        ),
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
                                          text("Price: ${itemMap["price"]}", 12,
                                              Colors.black, FontWeight.bold),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          text(
                                              "Quantity: ${itemMap["quantity"]}",
                                              12,
                                              Colors.black,
                                              FontWeight.w700)
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
                          child: Text(
                            "Total Items: ${items.length}",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
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
