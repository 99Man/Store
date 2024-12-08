import 'package:fire/UI/admin_screens/view_user_order.dart';
import 'package:fire/UI/user_screens/cart_screen.dart';
import 'package:fire/UI/user_screens/user_screen.dart';
import 'package:fire/UI/user_screens/view_orders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Nechanavigation extends StatefulWidget {
  const Nechanavigation({super.key});

  @override
  State<Nechanavigation> createState() => _NechanavigationState();
}

class _NechanavigationState extends State<Nechanavigation> {
  int currentTab = 0;
  bool isFloatingButtonTapped = false;
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const UserScreen();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final List<Widget> screens = [
    const UserScreen(),
    ViewUserOrders(userId: FirebaseAuth.instance.currentUser!.uid),
    CartScreen(documentId: FirebaseAuth.instance.currentUser!.uid)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      bottomNavigationBar: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: BottomAppBar(
                height: 60.0,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      // minWidth: 60,
                      onPressed: () {
                        setState(() {
                          isFloatingButtonTapped = false;
                          currentScreen = const UserScreen();
                          currentTab = 0;
                        });
                      },
                      child: SizedBox(
                        width: 21,
                        height: 21,
                        child: Image.asset(
                          'assets/icons/home.png',
                          fit: BoxFit.cover,
                          color: currentTab == 0 ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                    MaterialButton(
                      // minWidth: 60,
                      onPressed: () {
                        setState(() {
                          isFloatingButtonTapped = false;
                          currentScreen = ViewOrders(
                            userId: userId,
                          );
                          currentTab = 1;
                        });
                      },
                      child: SizedBox(
                        width: 21,
                        height: 21,
                        child: Image.asset(
                          'assets/icons/shop.png',
                          fit: BoxFit.cover,
                          color: currentTab == 1 ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                    MaterialButton(
                      // minWidth: 60,
                      onPressed: () {
                        setState(() {
                          isFloatingButtonTapped = false;
                          currentScreen = CartScreen(documentId: userId);
                          currentTab = 2;
                        });
                      },
                      child: SizedBox(
                          width: 21,
                          height: 21,
                          child: Icon(
                            Icons.shopping_cart_rounded,
                            color: currentTab == 2 ? Colors.white : Colors.grey,
                          )),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Landscape layout
            return ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              child: BottomAppBar(
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      // minWidth: 60,
                      onPressed: () {
                        setState(() {
                          isFloatingButtonTapped = false;
                          currentScreen = const UserScreen();
                          currentTab = 0;
                        });
                      },
                      child: SizedBox(
                        width: 23,
                        height: 23,
                        child: Image.asset(
                          'assets/icons/home.png',
                          color: currentTab == 0 ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                    MaterialButton(
                      // minWidth: 60,
                      onPressed: () {
                        setState(() {
                          isFloatingButtonTapped = false;
                          currentScreen = ViewOrders(
                            userId: userId,
                          );
                          currentTab = 1;
                        });
                      },
                      child: SizedBox(
                        width: 23,
                        height: 23,
                        child: Image.asset(
                          'assets/icons/shop.png',
                          color: currentTab == 1 ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
