import 'package:fire/UI/admin_screens/addpost.dart';
import 'package:fire/UI/admin_screens/admin_screen.dart';
import 'package:fire/UI/admin_screens/show_all_post.dart';
import 'package:fire/UI/admin_screens/view_user_order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NechanavigationAdmin extends StatefulWidget {
  const NechanavigationAdmin({super.key});

  @override
  State<NechanavigationAdmin> createState() => _NechanavigationAdminState();
}

class _NechanavigationAdminState extends State<NechanavigationAdmin> {
  int currentTab = 0;
  bool isFloatingButtonTapped = false;
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const AdminScreen();
  final userId = FirebaseAuth.instance.currentUser!.uid;

  final List<Widget> screens = [
    const AdminScreen(),
    ViewUserOrders(userId: FirebaseAuth.instance.currentUser!.uid),
    MyProductScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                height: 60,
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
                          currentScreen = const AdminScreen();
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
                          currentScreen = ViewUserOrders(
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
                          currentScreen = MyProductScreen();
                          currentTab = 2;
                        });
                      },
                      child: SizedBox(
                          width: 21,
                          height: 21,
                          child: Icon(
                            Icons.person_outline_sharp,
                            color: currentTab == 2 ? Colors.white : Colors.grey,
                          )),
                    ),
                    MaterialButton(
                      // minWidth: 60,
                      onPressed: () {
                        setState(() {
                          isFloatingButtonTapped = false;
                          currentScreen = AddPost();
                          currentTab = 3;
                        });
                      },
                      child: SizedBox(
                          width: 21,
                          height: 21,
                          child: Icon(
                            Icons.add,
                            color: currentTab == 3 ? Colors.white : Colors.grey,
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
                height: 60,
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
                          currentScreen = const AdminScreen();
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
                          currentScreen = ViewUserOrders(
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
                    MaterialButton(
                      // minWidth: 60,
                      onPressed: () {
                        setState(() {
                          isFloatingButtonTapped = false;
                          currentScreen = MyProductScreen();
                          currentTab = 2;
                        });
                      },
                      child: SizedBox(
                          width: 21,
                          height: 21,
                          child: Icon(
                            Icons.person_outline_sharp,
                            color: currentTab == 2 ? Colors.white : Colors.grey,
                          )),
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
