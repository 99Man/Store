import 'package:fire/utils/text.dart';
import 'package:fire/widget/list_items.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  final List<CartItem> cartItems;

  CartScreen(this.cartItems, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: text("Your Cart", 20, Colors.black, FontWeight.bold),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          var cartItem = cartItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                        child: Image.network(
                          cartItem.imgUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 22,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text("Title : " + cartItem.title, 15, Colors.black,
                              FontWeight.w700),
                          SizedBox(
                            height: 7,
                          ),
                          text("Price:  \$" + cartItem.price, 12, Colors.black,
                              FontWeight.w700)
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child:
                        IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
